import { useEffect, useMemo, useState } from 'react';
import { MARKET_CITIES, CITY_COLORS } from '../config';
import { fetchMarketPrices } from './marketApi';
import { getRecipe } from './recipes';
import { stripEnchant } from './sidebarGroup';
import type { AlbionItemMini, MarketPriceRow, RegionKey } from '../types';

export const CRAFTING_CITIES = MARKET_CITIES.filter(c => c !== 'Black Market');

export const RRR = {
  noFocus: 0.152,
  focus: 0.435,
  cityNoFocus: 0.367,
  cityFocus: 0.539,
};

export interface CraftCalcResult {
  breakdown: Array<{ id: string; count: number; price: number; cost: number; sourceCity: string; allCityPrices: Array<{ city: string; price: number }> }>;
  totalRawCost: number;
  returnDiscount: number;
  feeCost: number;
  netCost: number;
  targetPrice: number;
  sellRevenue: number;
  profit: number;
  margin: number;
  rrr: number;
}

export interface CityCalc {
  city: string;
  color: string;
  result: CraftCalcResult | null;
}

export function getBestCityForIngredient(id: string, allPrices: MarketPriceRow[]) {
  let best: { city: string; price: number } | null = null;
  for (const city of CRAFTING_CITIES) {
    const row = allPrices.find(p => p.item_id === id && p.city === city);
    const price = row?.sell_price_min ?? 0;
    if (price > 0 && (!best || price < best.price)) best = { city, price };
  }
  return best;
}

export function getAllCityPricesForIngredient(id: string, allPrices: MarketPriceRow[]) {
  return CRAFTING_CITIES.map(city => {
    const row = allPrices.find(p => p.item_id === id && p.city === city);
    return { city, price: row?.sell_price_min ?? 0 };
  });
}

export function calcForCity(
  recipe: ReturnType<typeof getRecipe>,
  allPrices: MarketPriceRow[],
  city: string,
  useFocus: boolean,
  cityBonus: boolean,
  stationFee: number,
  resolvedItemId: string,
  useBestCity: boolean,
  quality: number
): CraftCalcResult | null {
  if (!recipe) return null;

  let totalRawCost = 0;
  const breakdown = recipe.ingredients.map(ing => {
    let price = 0;
    let sourceCity = city;
    if (useBestCity) {
      const best = getBestCityForIngredient(ing.id, allPrices);
      price = best?.price ?? 0;
      sourceCity = best?.city ?? city;
    } else {
      const row = allPrices.find(p => p.item_id === ing.id && p.city === city)
               || allPrices.find(p => p.item_id === ing.id);
      price = row?.sell_price_min ?? 0;
    }
    const cost = price * ing.count;
    totalRawCost += cost;
    const allCityPrices = getAllCityPricesForIngredient(ing.id, allPrices);
    return { ...ing, price, cost, sourceCity, allCityPrices };
  });

  const rrrRate = cityBonus
    ? (useFocus ? RRR.cityFocus : RRR.cityNoFocus)
    : (useFocus ? RRR.focus : RRR.noFocus);

  const returnDiscount = totalRawCost * rrrRate;
  const feeCost = (stationFee / 10000) * totalRawCost;
  const netCost = totalRawCost - returnDiscount + feeCost;

  const targetRow = allPrices.find(p => p.item_id === resolvedItemId && p.city === city && p.quality === quality)
                 || allPrices.find(p => p.item_id === resolvedItemId && p.city === city)
                 || allPrices.find(p => p.item_id === resolvedItemId);
  const targetPrice = targetRow?.sell_price_min ?? 0;
  const TAX = 0.065;
  const sellRevenue = targetPrice * (1 - TAX);
  const profit = sellRevenue - netCost;
  const margin = netCost > 0 ? (profit / netCost) * 100 : 0;

  return { breakdown, totalRawCost, returnDiscount, feeCost, netCost, targetPrice, sellRevenue, profit, margin, rrr: rrrRate };
}

export function useCraftingCalc(item: AlbionItemMini, region: RegionKey, enchantLevel: number, resolvedItemId: string) {
  const baseId = stripEnchant(item.id);
  const recipe = useMemo(() => getRecipe(baseId, enchantLevel), [baseId, enchantLevel]);

  const [allPrices, setAllPrices] = useState<MarketPriceRow[]>([]);
  const [loading, setLoading] = useState(false);

  const ingredientIds = recipe ? recipe.ingredients.map(i => i.id).join(',') : '';

  useEffect(() => {
    if (!recipe || !ingredientIds) return;
    const idsToFetch = [...recipe.ingredients.map(i => i.id), resolvedItemId];
    let active = true;
    setLoading(true);
    fetchMarketPrices(region, idsToFetch)
      .then(data => { if (active) setAllPrices(data); })
      .catch(() => { if (active) setAllPrices([]); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [ingredientIds, region, resolvedItemId]);

  return { recipe, allPrices, loading };
}

export { CITY_COLORS };
