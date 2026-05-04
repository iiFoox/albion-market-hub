export type RegionKey = 'europe' | 'americas' | 'asia';

/** Filtros da barra lateral (HTML de referência) */
export type SidebarGroupId =
  | 'all'
  | 'raw'
  | 'refined'
  | 'weapon'
  | 'armor'
  | 'offhand'
  | 'food'
  | 'potion'
  | 'mount'
  | 'bag';

export type ItemSidebarGroup = Exclude<SidebarGroupId, 'all'> | 'other';

export type AlbionItemMini = {
  id: string;
  name: string;
  category: string;
  sidebarGroup: ItemSidebarGroup;
  tier: number;
};

export type MarketPriceRow = {
  item_id: string;
  city: string;
  quality: number;
  sell_price_min: number;
  sell_price_max: number;
  sell_price_min_date: string;
  sell_price_max_date: string;
  buy_price_min: number;
  buy_price_max: number;
  buy_price_min_date: string;
  buy_price_max_date: string;
};

export type GoldTick = {
  price: number;
  timestamp: string;
};

export type ChartLocationRow = {
  location: string;
  item_id: string;
  quality: number;
  data: {
    timestamps: string[];
    prices_avg: number[];
    item_count?: number[];
  };
};
