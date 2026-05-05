import type { ItemSidebarGroup, SidebarGroupId } from '../types';

export function inferTier(id: string): number {
  const base = id.replace(/@[0-9]+$/, '');
  const m = /^T(\d)/i.exec(base);
  return m ? parseInt(m[1], 10) : 0;
}

/** Encantamento numérico no ID (`@1` …) ou 0. */
export function parseEnchantLevel(id: string): number {
  const m = /@([0-9]+)$/.exec(id);
  return m ? parseInt(m[1], 10) : 0;
}

export function stripEnchant(id: string): string {
  return id.replace(/@[0-9]+$/, '');
}

export function inferSidebarGroup(id: string, category: string): ItemSidebarGroup {
  const u = stripEnchant(id).toUpperCase();

  if (/^T\d+_(METALBAR|PLANKS|CLOTH|LEATHER|STONEBLOCK)/.test(u)) return 'refined';
  if (/^T\d+_(ORE|WOOD|FIBER|HIDE|ROCK)/.test(u)) return 'raw';

  if (u.includes('POTION') || u.includes('POISON')) return 'potion';

  if (
    category === 'Comida & poções' ||
    /MEAL|STEW|SANDWICH|SOUP|ROAST|PIE|BREAD|OMELETTE|ALCO|WINE|_FOOD|T\d+_MEAT|T\d+_FISH/.test(u)
  ) {
    if (!u.includes('POTION') && !u.includes('POISON')) return 'food';
  }

  if (category.startsWith('Armas')) return 'weapon';
  if (category.startsWith('Off-hand')) return 'offhand';
  if (category === 'Montarias' || /MOUNT|STAG|OX|HORSE|SWIFT/.test(u)) return 'mount';
  if (category === 'Bolsas' || category === 'Capas') return 'bag';

  // Split armor into three categories
  if (category === 'Armaduras — Capuz / Elmo') return 'helmet';
  if (category === 'Armaduras — Peito') return 'chest';
  if (category === 'Armaduras — Botas') return 'boots';
  // Fallback for any remaining armor category
  if (category.startsWith('Armaduras')) return 'chest';

  return 'other';
}

export function emojiForSidebarGroup(g: SidebarGroupId | ItemSidebarGroup): string {
  const map: Record<string, string> = {
    all: '✨',
    raw: '🪨',
    refined: '⚙️',
    weapon: '⚔️',
    helmet: '⛑️',
    chest: '🛡️',
    boots: '👢',
    offhand: '🗡️',
    food: '🍖',
    potion: '🧪',
    mount: '🐎',
    bag: '🎒',
    other: '📦',
  };
  return map[g] ?? '📦';
}
