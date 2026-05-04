import type { ChartLocationRow, GoldTick, MarketPriceRow, RegionKey } from '../types';
import { API_HOST, MARKET_CITIES, QUALITIES } from '../config';

const MAX_URL = 3800;

function sleep(ms: number) {
  return new Promise((r) => setTimeout(r, ms));
}

function encodeItemPathSegment(ids: string[]): string {
  return ids.map((id) => encodeURIComponent(id)).join(',');
}

export function estimateChunkSize(sampleId: string, qualitiesCommaList: string): number {
  const base =
    80 +
    MARKET_CITIES.join(',').length +
    30 +
    qualitiesCommaList.length +
    sampleId.length * 3;
  const room = Math.max(800, MAX_URL - base);
  const per = Math.max(sampleId.length + 1, 12);
  return Math.max(8, Math.floor(room / per));
}

interface PriceCacheEntry {
  timestamp: number;
  rows: MarketPriceRow[];
}

const priceCache: Record<string, PriceCacheEntry> = {};
const CACHE_TTL_MS = 5 * 60 * 1000; // 5 minutes

function getCacheKey(region: string, itemId: string, qualities: string) {
  return `${region}|${itemId}|${qualities}`;
}

export async function fetchMarketPrices(
  region: RegionKey,
  itemIds: string[],
  signal?: AbortSignal,
  options?: { qualities?: readonly number[] },
): Promise<MarketPriceRow[]> {
  if (itemIds.length === 0) return [];
  const host = API_HOST[region];
  const locations = [...MARKET_CITIES].join(',');
  const qualArr = options?.qualities ?? [...QUALITIES];
  const qualities = qualArr.join(',');
  const out: MarketPriceRow[] = [];
  const idsToFetch: string[] = [];

  const now = Date.now();

  // Check cache for each item
  for (const id of itemIds) {
    const key = getCacheKey(region, id, qualities);
    const cached = priceCache[key];
    if (cached && now - cached.timestamp < CACHE_TTL_MS) {
      out.push(...cached.rows);
    } else {
      idsToFetch.push(id);
    }
  }

  if (idsToFetch.length === 0) {
    return out; // All served from cache
  }

  const sample = idsToFetch.reduce((a, b) => (a.length >= b.length ? a : b), idsToFetch[0]);
  const chunkSize = estimateChunkSize(sample, qualities);

  for (let i = 0; i < idsToFetch.length; i += chunkSize) {
    if (signal?.aborted) throw new DOMException('Aborted', 'AbortError');
    const chunk = idsToFetch.slice(i, i + chunkSize);
    const pathIds = encodeItemPathSegment(chunk);
    const url = `${host}/api/v2/stats/prices/${pathIds}.json?locations=${encodeURIComponent(locations)}&qualities=${encodeURIComponent(qualities)}`;

    const res = await fetch(url, { signal });
    if (!res.ok) {
      if (res.status === 404) {
        out.push(...[]);
        continue;
      }
      console.error(`API Error ${res.status}: ${res.statusText}`);
      continue; // Skip chunk on error instead of crashing
    }
    const rows = (await res.json()) as MarketPriceRow[];
    out.push(...rows);

    // Group rows by item_id to store in cache
    const byItem = rows.reduce((acc, row) => {
      if (!acc[row.item_id]) acc[row.item_id] = [];
      acc[row.item_id].push(row);
      return acc;
    }, {} as Record<string, MarketPriceRow[]>);

    // Cache the results
    for (const id of chunk) {
      const key = getCacheKey(region, id, qualities);
      priceCache[key] = {
        timestamp: now,
        rows: byItem[id] || [], // If no rows returned, cache empty array to prevent refetching
      };
    }

    if (i + chunkSize < idsToFetch.length) await sleep(400);
  }

  return out;
}

export async function fetchGoldPrice(region: RegionKey, signal?: AbortSignal): Promise<number | null> {
  const url = `${API_HOST[region]}/api/v2/stats/gold.json?count=1`;
  const res = await fetch(url, { signal });
  if (!res.ok) return null;
  const data = (await res.json()) as Array<{ price?: number }>;
  const row = data[0];
  return typeof row?.price === 'number' ? row.price : null;
}

export async function fetchGoldHistory(
  region: RegionKey,
  count: number,
  signal?: AbortSignal,
): Promise<GoldTick[]> {
  const url = `${API_HOST[region]}/api/v2/stats/gold.json?count=${count}`;
  const res = await fetch(url, { signal });
  if (!res.ok) return [];
  return (await res.json()) as GoldTick[];
}

/** Histórico para gráficos (preço médio por período). */
export async function fetchChartsHistory(
  region: RegionKey,
  itemId: string,
  signal?: AbortSignal,
  opts?: { timeScale?: number },
): Promise<ChartLocationRow[]> {
  const host = API_HOST[region];
  const locations = [...MARKET_CITIES].join(',');
  const ts = opts?.timeScale ?? 24;
  const path = encodeURIComponent(itemId);
  const url = `${host}/api/v2/stats/charts/${path}.json?locations=${encodeURIComponent(locations)}&time-scale=${ts}`;

  const res = await fetch(url, { signal });
  if (!res.ok) return [];
  return (await res.json()) as ChartLocationRow[];
}
