import type { RegionKey } from './types';

export const API_HOST: Record<RegionKey, string> = {
  europe: 'https://europe.albion-online-data.com',
  americas: 'https://west.albion-online-data.com',
  asia: 'https://east.albion-online-data.com',
};

/** Cidades com mercado de jogador (API Albion Online Data) */
export const MARKET_CITIES = [
  'Bridgewatch',
  'Caerleon',
  'Fort Sterling',
  'Lymhurst',
  'Martlock',
  'Thetford',
  'Brecilien',
  'Black Market',
] as const;

export const QUALITIES = [1, 2, 3, 4, 5] as const;

export const ITEMS_JSON_URL =
  'https://raw.githubusercontent.com/ao-data/ao-bin-dumps/master/formatted/items.json';

export const QUALITY_LABELS_PT: Record<number, string> = {
  1: 'Normal',
  2: 'Bom',
  3: 'Notável',
  4: 'Excelente',
  5: 'Obra-prima',
};

/** Cor por cidade (UI — referência HTML) */
export const CITY_COLORS: Record<string, string> = {
  Bridgewatch: '#f5a623',
  Caerleon: '#c94c4c',
  'Fort Sterling': '#e8e4d8',
  Lymhurst: '#4caf7d',
  Martlock: '#4c7ac9',
  Thetford: '#8c4cc9',
  Brecilien: '#00bcd4',
  'Black Market': '#555555',
};

/** Atalhos na tela inicial (IDs estáveis no dump) */
export const QUICK_ITEM_IDS = [
  'T6_WOOD',
  'T6_ORE',
  'T6_METALBAR',
  'T4_BAG',
  'T6_MAIN_SWORD',
  'T6_2H_BOW',
  'T6_ARMOR_PLATE_SET1',
  'T6_CAPE',
];
