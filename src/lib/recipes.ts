export type RecipeIngredient = {
  id: string;
  count: number;
};

export type Recipe = {
  itemId: string;
  ingredients: RecipeIngredient[];
  craftingFeeFactor?: number;
  journals?: string[];
};

// ─────────────────────────────────────────────────────────────────────────────
// Human-readable names for ingredient IDs (PT-BR)
// ─────────────────────────────────────────────────────────────────────────────
const INGREDIENT_NAME_MAP: Record<string, string> = {
  // Madeira bruta
  T1_WOOD: 'Tronco T1', T2_WOOD: 'Tronco T2', T3_WOOD: 'Tronco T3',
  T4_WOOD: 'Tronco T4', T5_WOOD: 'Tronco T5', T6_WOOD: 'Tronco T6',
  T7_WOOD: 'Tronco T7', T8_WOOD: 'Tronco T8',
  // Tábuas
  T1_PLANKS: 'Tábua T1', T2_PLANKS: 'Tábua T2', T3_PLANKS: 'Tábua T3',
  T4_PLANKS: 'Tábua T4', T5_PLANKS: 'Tábua T5', T6_PLANKS: 'Tábua T6',
  T7_PLANKS: 'Tábua T7', T8_PLANKS: 'Tábua T8',
  // Minério
  T1_ORE: 'Minério T1', T2_ORE: 'Minério T2', T3_ORE: 'Minério T3',
  T4_ORE: 'Minério T4', T5_ORE: 'Minério T5', T6_ORE: 'Minério T6',
  T7_ORE: 'Minério T7', T8_ORE: 'Minério T8',
  // Barras de Metal
  T1_METALBAR: 'Barra de Metal T1', T2_METALBAR: 'Barra de Metal T2', T3_METALBAR: 'Barra de Metal T3',
  T4_METALBAR: 'Barra de Metal T4', T5_METALBAR: 'Barra de Metal T5', T6_METALBAR: 'Barra de Metal T6',
  T7_METALBAR: 'Barra de Metal T7', T8_METALBAR: 'Barra de Metal T8',
  // Fibra
  T1_FIBER: 'Fibra T1', T2_FIBER: 'Fibra T2', T3_FIBER: 'Fibra T3',
  T4_FIBER: 'Fibra T4', T5_FIBER: 'Fibra T5', T6_FIBER: 'Fibra T6',
  T7_FIBER: 'Fibra T7', T8_FIBER: 'Fibra T8',
  // Tecido
  T1_CLOTH: 'Tecido T1', T2_CLOTH: 'Tecido T2', T3_CLOTH: 'Tecido T3',
  T4_CLOTH: 'Tecido T4', T5_CLOTH: 'Tecido T5', T6_CLOTH: 'Tecido T6',
  T7_CLOTH: 'Tecido T7', T8_CLOTH: 'Tecido T8',
  // Couro bruto (Hide)
  T1_HIDE: 'Pele Bruta T1', T2_HIDE: 'Pele Bruta T2', T3_HIDE: 'Pele Bruta T3',
  T4_HIDE: 'Pele Bruta T4', T5_HIDE: 'Pele Bruta T5', T6_HIDE: 'Pele Bruta T6',
  T7_HIDE: 'Pele Bruta T7', T8_HIDE: 'Pele Bruta T8',
  // Couro refinado
  T1_LEATHER: 'Couro T1', T2_LEATHER: 'Couro T2', T3_LEATHER: 'Couro T3',
  T4_LEATHER: 'Couro T4', T5_LEATHER: 'Couro T5', T6_LEATHER: 'Couro T6',
  T7_LEATHER: 'Couro T7', T8_LEATHER: 'Couro T8',
  // Pedra
  T1_ROCK: 'Pedra T1', T2_ROCK: 'Pedra T2', T3_ROCK: 'Pedra T3',
  T4_ROCK: 'Pedra T4', T5_ROCK: 'Pedra T5', T6_ROCK: 'Pedra T6',
  T7_ROCK: 'Pedra T7', T8_ROCK: 'Pedra T8',
  // Blocos de Pedra
  T1_STONEBLOCK: 'Bloco de Pedra T1', T2_STONEBLOCK: 'Bloco de Pedra T2', T3_STONEBLOCK: 'Bloco de Pedra T3',
  T4_STONEBLOCK: 'Bloco de Pedra T4', T5_STONEBLOCK: 'Bloco de Pedra T5', T6_STONEBLOCK: 'Bloco de Pedra T6',
  T7_STONEBLOCK: 'Bloco de Pedra T7', T8_STONEBLOCK: 'Bloco de Pedra T8',
  // Plantações
  T1_CARROT: 'Cenoura', T2_BEAN: 'Feijão', T3_WHEAT: 'Trigo',
  T4_TURNIP: 'Nabo', T5_CABBAGE: 'Repolho', T6_POTATO: 'Batata',
  T7_CORN: 'Milho', T8_PUMPKIN: 'Abóbora',
  // Ervas
  T2_AGARIC: 'Agárico-arcano', T3_COMFREY: 'Confrei-claro', T4_BURDOCK: 'Bardana-crespa',
  T5_TEASEL: 'Cardo-dragão', T6_FOXGLOVE: 'Dedaleira-tímida', T7_MULLEIN: 'Verbasco-de-fogo',
  T8_YARROW: 'Mil-folhas',
  // Carnes e Ovos
  T3_EGG: 'Ovo de Galinha', T3_MEAT: 'Carne de Galinha', T4_MEAT: 'Carne de Cabra',
  T5_MEAT: 'Carne de Ganso', T6_MEAT: 'Carne de Carneiro', T7_MEAT: 'Carne de Porco',
  T8_MEAT: 'Carne de Vaca',
  T4_MILK: 'Leite de Cabra', T6_MILK: 'Leite de Ovelha', T8_MILK: 'Leite de Vaca',
};

/**
 * Returns a human-readable name for an ingredient ID.
 * Falls back to catalogName (if provided) or the raw ID.
 */
export function getIngredientName(id: string, catalogName?: string): string {
  // Strip enchant suffix for lookup
  const baseId = id.includes('@') ? id.split('@')[0] : id;
  const enchant = id.includes('@') ? `+${id.split('@')[1]}` : '';
  const mapped = INGREDIENT_NAME_MAP[baseId];
  if (mapped) return enchant ? `${mapped} ${enchant}` : mapped;
  if (catalogName) return catalogName;
  return id;
}

// ─────────────────────────────────────────────────────────────────────────────
// Refining recipes (exact)
// ─────────────────────────────────────────────────────────────────────────────
const BASIC_REFINING: Recipe[] = [
  // Madeira → Tábuas
  { itemId: 'T4_PLANKS', ingredients: [{ id: 'T4_WOOD', count: 2 }, { id: 'T3_PLANKS', count: 1 }] },
  { itemId: 'T5_PLANKS', ingredients: [{ id: 'T5_WOOD', count: 3 }, { id: 'T4_PLANKS', count: 1 }] },
  { itemId: 'T6_PLANKS', ingredients: [{ id: 'T6_WOOD', count: 4 }, { id: 'T5_PLANKS', count: 1 }] },
  { itemId: 'T7_PLANKS', ingredients: [{ id: 'T7_WOOD', count: 5 }, { id: 'T6_PLANKS', count: 1 }] },
  { itemId: 'T8_PLANKS', ingredients: [{ id: 'T8_WOOD', count: 5 }, { id: 'T7_PLANKS', count: 1 }] },
  // Minério → Barras
  { itemId: 'T4_METALBAR', ingredients: [{ id: 'T4_ORE', count: 2 }, { id: 'T3_METALBAR', count: 1 }] },
  { itemId: 'T5_METALBAR', ingredients: [{ id: 'T5_ORE', count: 3 }, { id: 'T4_METALBAR', count: 1 }] },
  { itemId: 'T6_METALBAR', ingredients: [{ id: 'T6_ORE', count: 4 }, { id: 'T5_METALBAR', count: 1 }] },
  { itemId: 'T7_METALBAR', ingredients: [{ id: 'T7_ORE', count: 5 }, { id: 'T6_METALBAR', count: 1 }] },
  { itemId: 'T8_METALBAR', ingredients: [{ id: 'T8_ORE', count: 5 }, { id: 'T7_METALBAR', count: 1 }] },
  // Fibra → Tecido
  { itemId: 'T4_CLOTH', ingredients: [{ id: 'T4_FIBER', count: 2 }, { id: 'T3_CLOTH', count: 1 }] },
  { itemId: 'T5_CLOTH', ingredients: [{ id: 'T5_FIBER', count: 3 }, { id: 'T4_CLOTH', count: 1 }] },
  { itemId: 'T6_CLOTH', ingredients: [{ id: 'T6_FIBER', count: 4 }, { id: 'T5_CLOTH', count: 1 }] },
  { itemId: 'T7_CLOTH', ingredients: [{ id: 'T7_FIBER', count: 5 }, { id: 'T6_CLOTH', count: 1 }] },
  { itemId: 'T8_CLOTH', ingredients: [{ id: 'T8_FIBER', count: 5 }, { id: 'T7_CLOTH', count: 1 }] },
  // Pele → Couro
  { itemId: 'T4_LEATHER', ingredients: [{ id: 'T4_HIDE', count: 2 }, { id: 'T3_LEATHER', count: 1 }] },
  { itemId: 'T5_LEATHER', ingredients: [{ id: 'T5_HIDE', count: 3 }, { id: 'T4_LEATHER', count: 1 }] },
  { itemId: 'T6_LEATHER', ingredients: [{ id: 'T6_HIDE', count: 4 }, { id: 'T5_LEATHER', count: 1 }] },
  { itemId: 'T7_LEATHER', ingredients: [{ id: 'T7_HIDE', count: 5 }, { id: 'T6_LEATHER', count: 1 }] },
  { itemId: 'T8_LEATHER', ingredients: [{ id: 'T8_HIDE', count: 5 }, { id: 'T7_LEATHER', count: 1 }] },
  // Pedra → Blocos
  { itemId: 'T4_STONEBLOCK', ingredients: [{ id: 'T4_ROCK', count: 2 }, { id: 'T3_STONEBLOCK', count: 1 }] },
  { itemId: 'T5_STONEBLOCK', ingredients: [{ id: 'T5_ROCK', count: 3 }, { id: 'T4_STONEBLOCK', count: 1 }] },
  { itemId: 'T6_STONEBLOCK', ingredients: [{ id: 'T6_ROCK', count: 4 }, { id: 'T5_STONEBLOCK', count: 1 }] },
  { itemId: 'T7_STONEBLOCK', ingredients: [{ id: 'T7_ROCK', count: 5 }, { id: 'T6_STONEBLOCK', count: 1 }] },
  { itemId: 'T8_STONEBLOCK', ingredients: [{ id: 'T8_ROCK', count: 5 }, { id: 'T7_STONEBLOCK', count: 1 }] },
];

const ALL_RECIPES = [...BASIC_REFINING];

// ─────────────────────────────────────────────────────────────────────────────
// Keyword patterns that indicate a craftable weapon/armor/consumable
// An item MUST match one of these to get a heuristic recipe
// ─────────────────────────────────────────────────────────────────────────────
const WEAPON_ARMOR_PATTERNS = [
  '_2H_', '_MAIN_', '_OFF_',
  '_ARMOR_', '_HEAD_', '_SHOES_',
  '_CAPE', '_BAG',
  '_POTION_', '_MEAL_'
];

function isCraftableByHeuristic(id: string): boolean {
  return WEAPON_ARMOR_PATTERNS.some(p => id.includes(p));
}

/**
 * Returns the recipe for an item given its base ID and enchant level.
 * Returns null if no recipe can be determined.
 */
export function getRecipe(baseId: string, enchantLevel: number): Recipe | null {
  // 1. Check exact static recipes first
  let recipe = ALL_RECIPES.find((r) => r.itemId === baseId);

  // 2. Heuristic only for items that match weapon/armor patterns
  if (!recipe && isCraftableByHeuristic(baseId)) {
    const match = baseId.match(/^T(\d+)_/);
    if (match) {
      const tier = match[1];
      const is2H = baseId.includes('_2H_');
      const isMain = baseId.includes('_MAIN_');
      const isArmor = baseId.includes('_ARMOR_');
      const isHead = baseId.includes('_HEAD_');
      const isShoes = baseId.includes('_SHOES_');
      const isOff = baseId.includes('_OFF_');
      const isCape = baseId.includes('_CAPE');
      const isBag = baseId.includes('_BAG');

      let primary = '';
      let secondary = '';
      let pCount = 0;
      let sCount = 0;
      const ingredients: RecipeIngredient[] = [];

      // Consumables logic
      if (baseId.includes('_POTION_')) {
        // T2_POTION_HEAL -> T2_AGARIC (approx)
        const isHeal = baseId.includes('HEAL');
        const herbLevel = Math.max(2, Math.min(8, parseInt(tier, 10)));
        const herbTypes = ['', '', 'AGARIC', 'COMFREY', 'BURDOCK', 'TEASEL', 'FOXGLOVE', 'MULLEIN', 'YARROW'];
        
        ingredients.push({ id: `T${herbLevel}_${herbTypes[herbLevel]}`, count: isHeal ? 24 : 12 });
        if (herbLevel >= 4) {
          ingredients.push({ id: 'T3_EGG', count: 6 });
        }
      } else if (baseId.includes('_MEAL_')) {
        const isStew = baseId.includes('STEW');
        const isOmelette = baseId.includes('OMELETTE');
        const isPie = baseId.includes('PIE');
        
        const cropMap = ['', 'CARROT', 'BEAN', 'WHEAT', 'TURNIP', 'CABBAGE', 'POTATO', 'CORN', 'PUMPKIN'];
        const foodTier = parseInt(tier, 10);
        
        if (isStew) {
          // Meat + Crop
          ingredients.push({ id: `T${foodTier}_MEAT`, count: 18 });
          ingredients.push({ id: `T${Math.max(1, foodTier - 2)}_${cropMap[Math.max(1, foodTier - 2)]}`, count: 9 });
        } else if (isOmelette) {
          // Meat + Crop + Egg
          ingredients.push({ id: `T${foodTier}_MEAT`, count: 18 });
          ingredients.push({ id: `T${foodTier}_${cropMap[foodTier]}`, count: 9 });
          ingredients.push({ id: 'T3_EGG', count: 18 });
        } else if (isPie) {
          // Meat + Crop + Milk
          ingredients.push({ id: `T${foodTier}_MEAT`, count: 18 });
          ingredients.push({ id: `T${Math.max(1, foodTier - 2)}_${cropMap[Math.max(1, foodTier - 2)]}`, count: 9 });
          if (foodTier >= 4) ingredients.push({ id: `T${Math.min(8, foodTier + 2)}_MILK`, count: 18 });
        } else {
          // Generic Meal
          ingredients.push({ id: `T${foodTier}_${cropMap[foodTier]}`, count: 18 });
        }
      } else {
        // Material by weapon/armor type
        if (baseId.includes('PLATE')) { primary = 'METALBAR'; }
        else if (baseId.includes('LEATHER')) { primary = 'LEATHER'; }
        else if (baseId.includes('CLOTH')) { primary = 'CLOTH'; }
        else if (baseId.includes('SWORD') || baseId.includes('AXE') || baseId.includes('MACE') || baseId.includes('KNUCKLE')) { primary = 'METALBAR'; secondary = 'LEATHER'; }
        else if (baseId.includes('BOW') || baseId.includes('CROSSBOW')) { primary = 'PLANKS'; secondary = 'METALBAR'; }
        else if (baseId.includes('STAFF') || baseId.includes('MAGIC') || baseId.includes('TOME') || baseId.includes('ORB')) { primary = 'PLANKS'; secondary = 'CLOTH'; }
        else if (baseId.includes('DAGGER') || baseId.includes('SPEAR')) { primary = 'METALBAR'; secondary = 'PLANKS'; }
        else if (baseId.includes('HAMMER') || baseId.includes('MACE')) { primary = 'METALBAR'; secondary = 'CLOTH'; }
        else if (isCape) { primary = 'CLOTH'; secondary = 'LEATHER'; }
        else if (isBag) { primary = 'LEATHER'; }
        else { primary = 'METALBAR'; } // generic weapon fallback

        // Quantity by slot
        if (is2H) {
          pCount = 20; sCount = 12;
          if (baseId.includes('_2H_BOW')) { pCount = 32; sCount = 0; }
        } else if (isMain) { pCount = 16; sCount = 8; }
        else if (isArmor) { pCount = 16; }
        else if (isHead || isShoes || isOff) { pCount = 8; }
        else if (isCape) { pCount = 8; sCount = 4; }
        else if (isBag) { pCount = 8; }
        else { pCount = 16; }
      }

      if (pCount > 0) ingredients.push({ id: `T${tier}_${primary}`, count: pCount });
      if (sCount > 0 && secondary) ingredients.push({ id: `T${tier}_${secondary}`, count: sCount });

      if (ingredients.length > 0) {
        recipe = { itemId: baseId, ingredients };
      }
    }
  }

  if (!recipe) return null;
  if (enchantLevel === 0) return recipe;

  // Apply enchant level to ingredient IDs
  const enchantedIngredients = recipe.ingredients.map((ing) => {
    const isTiered = /^T[4-8]_/.test(ing.id);
    return isTiered ? { id: `${ing.id}@${enchantLevel}`, count: ing.count } : ing;
  });

  return { ...recipe, ingredients: enchantedIngredients };
}
