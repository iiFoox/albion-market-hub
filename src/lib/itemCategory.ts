/**
 * Agrupa itens por família a partir do UniqueName (mesmo esquema do jogo / dumps).
 */
export function categorizeItem(uniqueName: string): string {
  const u = uniqueName.toUpperCase();

  if (u.includes('UNIQUE') && u.includes('ARTEFACT')) return 'Artefatos — únicos';
  if (u.startsWith('UNIQUE')) return 'Itens únicos';

  // Recursos brutos & refinados
  if (/^T[1-8]_(WOOD|ROCK|ORE|HIDE|FIBER|SILVER|ARTEFACT)/.test(u) || u.includes('_LEVEL'))
    return 'Recursos & materiais';

  if (
    u.includes('RUNE') ||
    u.includes('SOUL') ||
    u.includes('RELIC') ||
    u.includes('AVALONIAN')
  )
    return 'Runas, almas & fragmentos';

  // Ferramentas & gathering
  if (u.includes('_TOOL') || u.includes('_PICK') || u.includes('_AXE') || u.includes('FISHING'))
    return 'Ferramentas & gathering';

  // Consumíveis
  if (
    u.includes('POTION') ||
    u.includes('POISON') ||
    u.includes('BAGGINS') ||
    u.includes('MEAL') ||
    u.includes('STEW') ||
    u.includes('SANDWICH') ||
    u.includes('SOUP') ||
    u.includes('ROAST') ||
    u.includes('PIE') ||
    u.includes('OMELETTE') ||
    u.includes('SALAD') ||
    u.includes('MEAT') ||
    u.includes('_FISH') ||
    u.includes('ALCO') ||
    u.includes('WINE') ||
    u.includes('BREAD')
  )
    return 'Comida & poções';

  // Montarias & pets
  if (u.includes('MOUNT') || u.includes('STAG') || u.includes('HORSE') || u.includes('OX') || u.includes('SWIFT'))
    return 'Montarias';

  // Armaduras ( por tipo )
  if (u.includes('HEAD_CLOTH') || u.includes('HEAD_LEATHER') || u.includes('HEAD_PLATE'))
    return 'Armaduras — Capuz / Elmo';
  if (u.includes('ARMOR_CLOTH') || u.includes('ARMOR_LEATHER') || u.includes('ARMOR_PLATE'))
    return 'Armaduras — Peito';
  if (u.includes('SHOES_CLOTH') || u.includes('SHOES_LEATHER') || u.includes('SHOES_PLATE'))
    return 'Armaduras — Botas';

  if (u.includes('BAG')) return 'Bolsas';
  if (u.includes('CAPE')) return 'Capas';

  // Armas — ordem do mais específico ao genérico
  if (u.includes('DAGGER')) return 'Armas — Adagas';
  if (u.includes('CLAYMORE') || u.includes('MAIN_SWORD') || u.includes('2H_SWORD') || u.includes('DUALSWORDS'))
    return 'Armas — Espadas';
  if (u.includes('SPEAR') || u.includes('GLAIVE') || u.includes('HALBERD')) return 'Armas — Lanças & glaives';
  if (u.includes('MAIN_AXE') || u.includes('2H_AXE')) return 'Armas — Machados';
  if (u.includes('MAIN_HAMMER') || u.includes('2H_HAMMER') || u.includes('POLEHAMMER'))
    return 'Armas — Martelos';
  if (u.includes('MAIN_MACE') || u.includes('2H_MACE')) return 'Armas — Maças';
  if (u.includes('MAIN_CURSED') || u.includes('2H_CURSED')) return 'Armas — Cajados amaldiçoados';
  if (u.includes('MAIN_FIRE') || u.includes('2H_FIRE')) return 'Armas — Cajados de fogo';
  if (u.includes('MAIN_FROST') || u.includes('2H_FROST')) return 'Armas — Cajados de gelo';
  if (u.includes('MAIN_ARCANE') || u.includes('2H_ARCANE')) return 'Armas — Cajados arcanos';
  if (u.includes('MAIN_HOLY') || u.includes('2H_HOLY')) return 'Armas — Cajados sagrados';
  if (u.includes('MAIN_NATURE') || u.includes('2H_NATURE')) return 'Armas — Cajados da natureza';
  if (u.includes('MAIN_ENERGY') || u.includes('2H_ENERGY')) return 'Armas — Cajados de energia';
  if (u.includes('MAIN_QUARTERSTAFF') || u.includes('2H_COMBATSTAFF') || u.includes('MAIN_ROCK'))
    return 'Armas — Cajados de quartzo / combate';
  if (u.includes('MAIN_SHAPESHIFTER')) return 'Armas — Metamorfo';
  if (u.includes('MAIN_CROSSBOW') || u.includes('2H_CROSSBOW')) return 'Armas — Bestas';
  if (u.includes('2H_BOW') || u.includes('MAIN_BOW')) return 'Armas — Arcos';

  if (u.includes('OFF_SHIELD')) return 'Off-hand — Escudos';
  if (u.includes('OFF_BOOK') || u.includes('OFF_ORB') || u.includes('OFF_TORCH') || u.includes('OFF_MACE'))
    return 'Off-hand — Livros / orbes / tochas';

  if (u.includes('TOME') || u.includes('SKILLBOOK')) return 'Livros & tomos';

  return 'Outros';
}

export function extractEnchantLabel(itemId: string): string | null {
  const at = itemId.indexOf('@');
  if (at === -1) return null;
  const level = itemId.slice(at + 1);
  if (!level) return null;
  return `.${level}`;
}
