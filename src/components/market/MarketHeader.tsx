import type { AlbionItemMini, RegionKey } from '../../types';

type Props = {
  region: RegionKey;
  onRegionChange: (r: RegionKey) => void;
  search: string;
  onSearchChange: (v: string) => void;
  results: AlbionItemMini[];
  onPickItem: (item: AlbionItemMini) => void;
  gold: number | null;
  currentTab: string;
  onTabChange: (tab: string) => void;
  onToggleSidebar: () => void;
};

const REGION_ORDER: RegionKey[] = ['americas', 'europe', 'asia'];
const REGION_LABEL: Record<RegionKey, string> = {
  americas: '🌎 América',
  europe: '🌍 Europa',
  asia: '🌏 Ásia',
};

export function MarketHeader({
  region,
  onRegionChange,
  search,
  onSearchChange,
  results,
  onPickItem,
  gold,
  currentTab,
  onTabChange,
  onToggleSidebar,
  isSidebarOpen // Adicionar este prop se possível ou gerenciar no componente
}: Props & { isSidebarOpen?: boolean }) {
  const showDropdown = search.trim().length >= 1;

  return (
    <header className="app-header" style={{ padding: 'min(24px, 4vw)' }}>
      {/* Mobile Top Bar */}
      <div style={{ alignItems: 'center', gap: '16px', width: '100%', marginBottom: '12px', borderBottom: '1px solid var(--border)', paddingBottom: '12px' }} className="menu-toggle">
        <button 
          className="menu-toggle" 
          onClick={onToggleSidebar}
          aria-label={isSidebarOpen ? "Fechar filtros" : "Abrir filtros"}
          aria-expanded={isSidebarOpen}
        >
          {isSidebarOpen ? '✕' : '☰'}
        </button>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
           <svg viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg" style={{ width: '24px', height: '24px' }}>
             <path d="M18 2L22 10L32 11.5L25 18.5L26.5 28.5L18 24L9.5 28.5L11 18.5L4 11.5L14 10L18 2Z" fill="#c9a84c" stroke="#8a6f2e" strokeWidth="1" />
             <circle cx="18" cy="17" r="4" fill="#0a0800" stroke="#c9a84c" strokeWidth="1.5" />
           </svg>
           <h1 style={{ fontSize: '16px', margin: 0, fontWeight: 800, letterSpacing: '0.5px', color: 'var(--text-primary)' }}>
             Albion<span style={{color: 'var(--gold)'}}>Market</span>
           </h1>
        </div>
      </div>

      {/* Main Tabs (Moved to left) */}
      <div className="main-tabs" role="tablist">
        <button 
          role="tab" 
          aria-selected={currentTab === 'market'} 
          className={`main-tab ${currentTab === 'market' ? 'active' : ''}`} 
          onClick={() => onTabChange('market')}
        >
          Mercado
        </button>
        <button 
          role="tab" 
          aria-selected={currentTab === 'crafting'} 
          className={`main-tab ${currentTab === 'crafting' ? 'active' : ''}`} 
          onClick={() => onTabChange('crafting')}
        >
          Crafting
        </button>
        <button 
          role="tab" 
          aria-selected={currentTab === 'blackmarket'} 
          className={`main-tab ${currentTab === 'blackmarket' ? 'active' : ''}`} 
          onClick={() => onTabChange('blackmarket')}
        >
          Mercado Negro
        </button>
      </div>

      {/* Search Bar (Centered) */}
      <div className="search-bar-container" style={{ flex: 1, display: 'flex', justifyContent: 'center' }}>
        <div className="search-wrapper">
          <span className="search-icon" aria-hidden>🔍</span>
          <input
            type="search"
            className="search-input"
            placeholder="Buscar..."
            value={search}
            onChange={(e) => onSearchChange(e.target.value)}
            autoComplete="off"
            aria-label="Buscar itens"
            aria-expanded={showDropdown}
            aria-controls="search-dropdown"
          />
          <div
            id="search-dropdown"
            className={`search-results-dropdown ${showDropdown ? 'visible' : ''}`}
            role="listbox"
          >
            {results.length === 0 ? (
              <div className="no-data">Nenhum item encontrado</div>
            ) : (
              results.map((item) => (
                <button
                  key={item.id}
                  type="button"
                  role="option"
                  className="search-result-item"
                  onClick={() => onPickItem(item)}
                >
                  <img 
                    src={`https://render.albiononline.com/v1/item/${item.id}.png?size=32`} 
                    alt="" 
                    className="result-icon"
                    style={{ width: '32px', height: '32px', objectFit: 'contain', flexShrink: 0 }}
                    onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
                  />
                  <div className="result-info" style={{ flex: 1 }}>
                    <div className="result-name">{item.name}</div>
                    <div className="result-category">
                      {item.category} · T{item.tier || '?'}
                    </div>
                  </div>
                  <div className="result-id" style={{ marginLeft: 'auto', flexShrink: 0 }}>{item.id}</div>
                </button>
              ))
            )}
          </div>
        </div>
      </div>

      {/* Servers and Gold */}
      <div className="header-actions" style={{ display: 'flex', alignItems: 'center', gap: '16px', flexWrap: 'wrap', justifyContent: 'center' }}>
        <div className="server-tabs" role="tablist" aria-label="Região">
          {REGION_ORDER.map((r) => (
            <button
              key={r}
              type="button"
              role="tab"
              aria-selected={region === r}
              className={`server-tab ${region === r ? 'active' : ''}`}
              onClick={() => onRegionChange(r)}
              title={r.toUpperCase()}
            >
              {REGION_LABEL[r]}
            </button>
          ))}
        </div>

        <div className="gold-ticker" title="Preço do ouro (prata por 1 ouro)">
          <span className="gold-ticker-icon" aria-hidden>🥇</span>
          <div className="gold-ticker-info">
            <div className="gold-ticker-label">Gold</div>
            <div className="gold-ticker-price">
              {gold != null ? `${formatPrice(gold)}` : '—'}
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}

function formatPrice(n: number): string {
  return n.toLocaleString('pt-BR');
}
