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
  onTabChange
}: Props) {
  const showDropdown = search.trim().length >= 1;

  return (
    <header style={{ 
      padding: '24px 32px', 
      background: 'var(--bg-card)', 
      backdropFilter: 'blur(20px)',
      borderBottom: '1px solid var(--border)',
      display: 'flex',
      alignItems: 'center',
      gap: '32px'
    }}>
      {/* Main Tabs (Moved to left) */}
      <div className="main-tabs" role="tablist" style={{ 
        margin: 0, 
        display: 'flex', 
        gap: '8px', 
        background: 'transparent',
        padding: 0
      }}>
        <button 
          role="tab" 
          aria-selected={currentTab === 'market'} 
          className={`main-tab ${currentTab === 'market' ? 'active' : ''}`} 
          onClick={() => onTabChange('market')}
          style={{ padding: '8px 24px', borderRadius: '30px' }}
        >
          Mercado
        </button>
        <button 
          role="tab" 
          aria-selected={currentTab === 'crafting'} 
          className={`main-tab ${currentTab === 'crafting' ? 'active' : ''}`} 
          onClick={() => onTabChange('crafting')}
          style={{ padding: '8px 24px', borderRadius: '30px' }}
        >
          Crafting
        </button>
        <button 
          role="tab" 
          aria-selected={currentTab === 'blackmarket'} 
          className={`main-tab ${currentTab === 'blackmarket' ? 'active' : ''}`} 
          onClick={() => onTabChange('blackmarket')}
          style={{ padding: '8px 24px', borderRadius: '30px' }}
        >
          Mercado Negro
        </button>
      </div>

      {/* Search Bar (Centered) */}
      <div style={{ flex: 1, display: 'flex', justifyContent: 'center' }}>
        <div className="search-wrapper" style={{ width: '100%', maxWidth: '400px' }}>
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
                  style={{ display: 'flex', alignItems: 'center', gap: '8px', textAlign: 'left' }}
                >
                  <img 
                    src={`https://render.albiononline.com/v1/item/${item.id}.png?size=32`} 
                    alt="" 
                    style={{ width: '32px', height: '32px', objectFit: 'contain', flexShrink: 0 }}
                    onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
                  />
                  <div style={{ flex: 1 }}>
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
      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        <div className="server-tabs" role="tablist" aria-label="Região" style={{ background: 'var(--bg-secondary)', padding: '4px', borderRadius: '8px' }}>
          {REGION_ORDER.map((r) => (
            <button
              key={r}
              type="button"
              role="tab"
              aria-selected={region === r}
              className={`server-tab ${region === r ? 'active' : ''}`}
              onClick={() => onRegionChange(r)}
              style={{ padding: '6px 12px', fontSize: '14px' }}
              title={r.toUpperCase()}
            >
              {REGION_LABEL[r]}
            </button>
          ))}
        </div>

        <div className="gold-ticker" title="Preço do ouro (prata por 1 ouro)" style={{ marginLeft: '8px' }}>
          <span className="gold-ticker-icon" aria-hidden>🥇</span>
          <div>
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
