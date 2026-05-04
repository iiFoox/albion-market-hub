import { useCallback, useEffect, useMemo, useState } from 'react';
import { useLocalStorage } from './lib/useLocalStorage';
import { QUICK_ITEM_IDS } from './config';
import {
  clearCatalogCache,
  fetchAndBuildCatalog,
  loadCachedCatalog,
} from './lib/catalogLoader';
import { fetchGoldPrice, fetchMarketPrices } from './lib/marketApi';
import { parseEnchantLevel, stripEnchant } from './lib/sidebarGroup';
import { getRecipe } from './lib/recipes';
import { GoldPanel } from './components/market/GoldPanel';
import { ItemWorkspace } from './components/market/ItemWorkspace';
import { MarketHeader } from './components/market/MarketHeader';
import { MarketSidebar } from './components/market/MarketSidebar';
import { BrowseItemList } from './components/market/BrowseItemList';
import { WelcomePanel } from './components/market/WelcomePanel';
import { CraftingWorkspace } from './components/market/CraftingWorkspace';
import { BlackMarketWorkspace } from './components/market/BlackMarketWorkspace';
import type { AlbionItemMini, MarketPriceRow, RegionKey, SidebarGroupId } from './types';
import './market-layout.css';

export default function App() {
  const [currentTab, setCurrentTab] = useLocalStorage<'market' | 'crafting' | 'blackmarket'>('amh-tab', 'market');
  const [region, setRegion] = useLocalStorage<RegionKey>('amh-region', 'americas');
  const [catalog, setCatalog] = useState<AlbionItemMini[] | null>(null);
  const [downloadPct, setDownloadPct] = useState(0);
  const [processPct, setProcessPct] = useState(0);
  const [catalogError, setCatalogError] = useState<string | null>(null);
  const [loadingCatalog, setLoadingCatalog] = useState(true);

  const [sidebarGroup, setSidebarGroup] = useLocalStorage<SidebarGroupId>('amh-sidebar', 'all');
  const [tierFilter, setTierFilter] = useLocalStorage<string>('amh-tier', 'all');
  const [quality, setQuality] = useLocalStorage<number>('amh-quality', 1);
  const [search, setSearch] = useState('');

  const [selected, setSelected] = useState<AlbionItemMini | null>(null);
  const [enchantLevel, setEnchantLevel] = useState(0);

  const [prices, setPrices] = useState<MarketPriceRow[]>([]);
  const [loadingPrices, setLoadingPrices] = useState(false);
  const [priceError, setPriceError] = useState<string | null>(null);

  const [gold, setGold] = useState<number | null>(null);

  const resolvedItemId = useMemo(() => {
    if (!selected) return null;
    const base = stripEnchant(selected.id);
    if (enchantLevel <= 0) return base;
    return `${base}@${enchantLevel}`;
  }, [selected, enchantLevel]);

  const loadCatalog = useCallback(async (forceRemote: boolean) => {
    setCatalogError(null);
    setLoadingCatalog(true);
    setDownloadPct(0);
    setProcessPct(0);
    const ac = new AbortController();
    try {
      if (!forceRemote) {
        const cached = await loadCachedCatalog();
        if (cached) {
          setCatalog(cached);
          setLoadingCatalog(false);
          return;
        }
      } else {
        await clearCatalogCache();
      }
      const built = await fetchAndBuildCatalog(setDownloadPct, setProcessPct, ac.signal);
      setCatalog(built);
    } catch (e) {
      if ((e as Error).name === 'AbortError') return;
      setCatalogError((e as Error).message || 'Erro ao carregar itens');
    } finally {
      setLoadingCatalog(false);
    }
  }, []);

  useEffect(() => {
    loadCatalog(false);
  }, [loadCatalog]);

  useEffect(() => {
    const ac = new AbortController();
    fetchGoldPrice(region, ac.signal).then(setGold).catch(() => setGold(null));
    const id = window.setInterval(() => {
      fetchGoldPrice(region, ac.signal).then(setGold).catch(() => {});
    }, 120_000);
    return () => {
      ac.abort();
      window.clearInterval(id);
    };
  }, [region]);

  const normalizeText = (text: string) => 
    text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();

  /** Itens que passam por categoria, tier e texto da busca (se houver). */
  const filteredItems = useMemo(() => {
    if (!catalog) return [];
    
    const searchTokens = normalizeText(search.trim()).split(/\s+/).filter(Boolean);

    return catalog.filter((it) => {
      if (sidebarGroup !== 'all' && it.sidebarGroup !== sidebarGroup) return false;
      if (tierFilter !== 'all' && String(it.tier) !== tierFilter) return false;
      
      if (searchTokens.length > 0) {
        const itemText = normalizeText(`${it.name} ${it.id} ${it.category} tier ${it.tier} t${it.tier}`);
        const matchesAllTokens = searchTokens.every((token) => itemText.includes(token));
        if (!matchesAllTokens) return false;
      }
      
      return true;
    });
  }, [catalog, search, sidebarGroup, tierFilter]);

  /** Itens craftáveis: apenas os que têm receita gerada pela heurística */
  const craftableItems = useMemo(() => {
    return filteredItems.filter((it) => {
      const base = stripEnchant(it.id);
      return getRecipe(base, 0) !== null;
    });
  }, [filteredItems]);

  /** Dropdown do header: só quando há texto na busca. */
  const searchResults = useMemo(() => {
    if (search.trim().length < 1) return [];
    return filteredItems.slice(0, 15);
  }, [filteredItems, search]);

  const quickItems = useMemo(() => {
    if (!catalog || filteredItems.length === 0) return [];
    const idSet = new Set(filteredItems.map((i) => i.id));
    const fromPreset: AlbionItemMini[] = [];
    for (const id of QUICK_ITEM_IDS) {
      const found = catalog.find((i) => i.id === id);
      if (found && idSet.has(id)) fromPreset.push(found);
    }
    if (fromPreset.length >= 4) return fromPreset.slice(0, 12);
    return filteredItems.slice(0, 12);
  }, [catalog, filteredItems]);

  const fetchPrices = useCallback(async (isBackground = false) => {
    if (!resolvedItemId) {
      setPrices([]);
      return;
    }
    if (!isBackground) {
      setLoadingPrices(true);
    }
    setPriceError(null);
    try {
      // Abort controller might be complex to manage with background updates, omitting for simplicity
      const data = await fetchMarketPrices(region, [resolvedItemId], undefined, { qualities: [quality] });
      setPrices(data);
    } catch (e: any) {
      if (e.name === 'AbortError') return;
      setPriceError(e.message || 'Falha ao buscar preços');
      if (!isBackground) setPrices([]);
    } finally {
      setLoadingPrices(false);
    }
  }, [resolvedItemId, region, quality]);

  useEffect(() => {
    fetchPrices(false);
    const intervalId = window.setInterval(() => {
      fetchPrices(true);
    }, 30_000);
    return () => window.clearInterval(intervalId);
  }, [fetchPrices]);

  const pickItem = useCallback((item: AlbionItemMini) => {
    setSelected(item);
    setEnchantLevel(parseEnchantLevel(item.id));
    setSearch('');
  }, []);

  const switchTier = useCallback((newTier: number) => {
    if (!selected || !catalog) return;
    const baseId = selected.id.split('@')[0];
    const match = baseId.match(/^T(\d+)/);
    if (!match) return;
    const currentTier = parseInt(match[1], 10);
    if (currentTier === newTier) return;
    
    const newBaseId = baseId.replace(/^T\d+/, `T${newTier}`);
    const found = catalog.find(i => i.id.split('@')[0] === newBaseId);
    if (found) {
      setSelected(found);
    }
  }, [selected, catalog]);

  return (
    <div className="app-container">
      <aside className="app-sidebar-area">
        <div style={{ padding: '32px 24px', display: 'flex', alignItems: 'center', gap: '12px' }}>
           <svg viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg" style={{ width: '32px', height: '32px' }}>
             <path d="M18 2L22 10L32 11.5L25 18.5L26.5 28.5L18 24L9.5 28.5L11 18.5L4 11.5L14 10L18 2Z" fill="#c9a84c" stroke="#8a6f2e" strokeWidth="1" />
             <path d="M18 6L21 13L28.5 14L23 19.5L24.5 27L18 23.5L11.5 27L13 19.5L7.5 14L15 13L18 6Z" fill="#f0cc6e" opacity="0.3" />
             <circle cx="18" cy="17" r="4" fill="#0a0800" stroke="#c9a84c" strokeWidth="1.5" />
           </svg>
           <h1 style={{ fontSize: '20px', margin: 0, fontWeight: 800, letterSpacing: '1px', color: 'var(--text-primary)', whiteSpace: 'nowrap' }}>
             Albion<span style={{color: 'var(--gold)'}}>Market</span>
           </h1>
        </div>
        <div style={{ padding: '0 24px' }}>
          <MarketSidebar
            currentTab={currentTab}
            sidebarGroup={sidebarGroup}
            onSidebarGroup={(g) => {
              setSidebarGroup(g);
              setSelected(null);
            }}
            tierFilter={tierFilter}
            onTierFilter={(t) => {
              setTierFilter(t);
              setSelected(null);
            }}
            quality={quality}
            onQuality={setQuality}
          />
        </div>
      </aside>

      <main className="app-main-area">
        <MarketHeader
          region={region}
          onRegionChange={setRegion}
          search={search}
          onSearchChange={setSearch}
          results={searchResults}
          onPickItem={pickItem}
          gold={gold}
          currentTab={currentTab}
          onTabChange={setCurrentTab as any}
        />

        <div style={{ padding: '32px', flex: 1, overflowY: 'auto' }}>
          {loadingCatalog && (
            <div className="catalog-load-banner glass-panel" role="status" style={{ marginBottom: '24px' }}>
              <div className="catalog-load-track">
                <div
                  className="catalog-load-fill"
                  style={{ width: `${Math.max(downloadPct, processPct)}%` }}
                />
              </div>
              <p>
                {downloadPct < 100
                  ? `Baixando catálogo… ${downloadPct}%`
                  : `Processando… ${processPct}%`}
              </p>
            </div>
          )}

          {catalogError && (
            <div className="catalog-error-banner glass-panel" role="alert" style={{ marginBottom: '24px' }}>
              {catalogError}{' '}
              <button type="button" className="link-btn" onClick={() => loadCatalog(true)}>
                Tentar novamente
              </button>
            </div>
          )}
          {!selected && currentTab === 'market' && (
            <div className="browse-section" style={{ display: 'flex', flexDirection: 'column', gap: '24px', maxWidth: '1200px', margin: '0 auto', width: '100%', marginBottom: '60px' }}>
              <WelcomePanel
                quickItems={quickItems}
                onPickItem={pickItem}
                sidebarGroup={sidebarGroup}
                filteredCount={filteredItems.length}
              />
              <div className="browse-panel glass-panel" style={{ padding: '24px', borderRadius: '16px' }}>
                <h3 style={{ margin: '0 0 24px 0', fontSize: '14px', textTransform: 'uppercase', letterSpacing: '2px', color: 'var(--gold)' }}>Lista de itens</h3>
                <BrowseItemList key="market-list" items={filteredItems} onPickItem={pickItem} />
              </div>
            </div>
          )}

          {!selected && currentTab === 'crafting' && (
            <div className="browse-section" style={{ display: 'flex', flexDirection: 'column', gap: '24px', maxWidth: '1200px', margin: '0 auto', width: '100%', marginBottom: '60px' }}>
              <div className="welcome-state glass-panel fade-in" style={{ padding: '32px 40px', borderRadius: '16px' }}>
                <div style={{ display: 'flex', alignItems: 'flex-start', gap: '24px', flexWrap: 'wrap' }}>
                  <div style={{ flex: 1 }}>
                    <span style={{ fontSize: '36px', display: 'block', marginBottom: '12px' }}>⚒️</span>
                    <h2 className="welcome-title" style={{ fontSize: '22px', margin: '0 0 8px 0' }}>Laboratório de Crafting</h2>
                    <p className="welcome-sub" style={{ color: 'var(--text-muted)', margin: 0 }}>
                      Selecione um item craftável para abrir a <strong>Calculadora de Produção</strong> com análise de custo, retorno e lucro por cidade.
                    </p>
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', minWidth: '240px' }}>
                    <div style={{ fontSize: '11px', color: 'var(--text-muted)', letterSpacing: '1px', textTransform: 'uppercase', marginBottom: '4px' }}>Categorias suportadas</div>
                    {[
                      { icon: '⚙️', label: 'Recursos Refinados' },
                      { icon: '⚔️', label: 'Armas' },
                      { icon: '🛡️', label: 'Armaduras & Off-Hand' },
                      { icon: '🎒', label: 'Mochilas & Capas' },
                      { icon: '🧪', label: 'Poções' },
                      { icon: '🍖', label: 'Comida' },
                    ].map(cat => (
                      <div key={cat.label} style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '13px' }}>
                        <span>{cat.icon}</span>
                        <span style={{ color: 'var(--text-primary)' }}>{cat.label}</span>
                        <span style={{ marginLeft: 'auto', background: '#4caf7d22', color: '#4caf7d', fontSize: '10px', padding: '1px 6px', borderRadius: '4px', border: '1px solid #4caf7d44', fontWeight: 700 }}>✓</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
              <div className="browse-panel glass-panel" style={{ padding: '24px', borderRadius: '16px' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '20px' }}>
                  <h3 style={{ margin: 0, fontSize: '14px', textTransform: 'uppercase', letterSpacing: '2px', color: 'var(--gold)' }}>
                    Itens Craftáveis
                  </h3>
                  <span style={{ background: 'var(--gold)', color: '#000', fontSize: '11px', fontWeight: 800, padding: '2px 8px', borderRadius: '10px' }}>
                    {craftableItems.length}
                  </span>
                  {(sidebarGroup === 'mount') && (
                    <span style={{ background: '#f5a62322', color: '#f5a623', fontSize: '12px', padding: '2px 10px', borderRadius: '6px', border: '1px solid #f5a62344' }}>
                      🚧 Receitas desta categoria ainda não implementadas
                    </span>
                  )}
                </div>
                <BrowseItemList items={craftableItems} onPickItem={pickItem} />
              </div>
            </div>
          )}

          {!selected && currentTab === 'blackmarket' && (
            <BlackMarketWorkspace 
              items={craftableItems} 
              region={region} 
              quality={quality} 
              enchantLevel={enchantLevel} 
            />
          )}

          {selected && resolvedItemId && currentTab === 'market' && (
            <ItemWorkspace
              item={selected}
              region={region}
              enchantLevel={enchantLevel}
              onEnchantLevel={setEnchantLevel}
              quality={quality}
              onQuality={setQuality}
              resolvedItemId={resolvedItemId}
              prices={prices}
              loadingPrices={loadingPrices}
              priceError={priceError}
              onRefresh={() => fetchPrices(true)}
              onClose={() => setSelected(null)}
              onSwitchTier={switchTier}
            />
          )}

          {selected && resolvedItemId && currentTab === 'crafting' && (
            <CraftingWorkspace
              item={selected}
              region={region}
              enchantLevel={enchantLevel}
              onEnchantLevel={setEnchantLevel}
              quality={quality}
              onQuality={setQuality}
              resolvedItemId={resolvedItemId}
              onClose={() => setSelected(null)}
              onSwitchTier={switchTier}
            />
          )}

          <GoldPanel region={region} />
          <footer className="site-footer" style={{ marginTop: '40px', padding: '20px 0', borderTop: '1px solid var(--border)', textAlign: 'center', opacity: 0.5 }}>
            <p style={{ margin: 0 }}>
              Dados de mercado:{' '}
              <a href="https://www.albion-online-data.com/" target="_blank" rel="noreferrer" style={{ color: 'var(--gold)' }}>
                Albion Online Data
              </a>
              . Catálogo:{' '}
              <a href="https://github.com/ao-data/ao-bin-dumps" target="_blank" rel="noreferrer" style={{ color: 'var(--gold)' }}>
                ao-bin-dumps
              </a>
              .
            </p>
          </footer>
        </div>
      </main>
    </div>
  );
}
