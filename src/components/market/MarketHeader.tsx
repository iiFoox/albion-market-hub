import { type ReactNode } from 'react';
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
  isSidebarOpen?: boolean;
  apiStatusBadge?: ReactNode;
};

const REGION_ORDER: RegionKey[] = ['americas', 'europe', 'asia'];
const REGION_LABEL: Record<RegionKey, string> = {
  americas: '🌎 América',
  europe: '🌍 Europa',
  asia: '🌏 Ásia',
};

const TAB_ICONS: Record<string, string> = {
  market: '📊',
  crafting: '⚒️',
  blackmarket: '🦇',
};

const TAB_LABELS: Record<string, string> = {
  market: 'Mercado',
  crafting: 'Crafting',
  blackmarket: 'Mercado Negro',
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
  isSidebarOpen,
  apiStatusBadge,
}: Props) {
  const showDropdown = search.trim().length >= 1;

  return (
    <>
      <header className="app-header">
        {/* ── Mobile: hamburguer (esquerda) + logo (centro) ── */}
        <div className="mobile-topbar">
          <button
            className="menu-toggle"
            onClick={onToggleSidebar}
            aria-label={isSidebarOpen ? 'Fechar filtros' : 'Abrir filtros'}
            aria-expanded={isSidebarOpen}
          >
            {isSidebarOpen ? '✕' : '☰'}
          </button>

          <div className="mobile-logo">
            <svg viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg" style={{ width: 22, height: 22 }}>
              <path d="M18 2L22 10L32 11.5L25 18.5L26.5 28.5L18 24L9.5 28.5L11 18.5L4 11.5L14 10L18 2Z" fill="#c9a84c" stroke="#8a6f2e" strokeWidth="1" />
              <circle cx="18" cy="17" r="4" fill="#0a0800" stroke="#c9a84c" strokeWidth="1.5" />
            </svg>
            <span className="mobile-logo-text">
              Albion<span style={{ color: 'var(--gold)' }}>Market</span>
            </span>
          </div>

          {/* Espaçador para centrar o logo */}
          <div style={{ width: 40 }} />
        </div>

        {/* ── Desktop: tabs ── */}
        <div className="main-tabs desktop-only" role="tablist">
          {Object.keys(TAB_LABELS).map((tab) => (
            <button
              key={tab}
              role="tab"
              aria-selected={currentTab === tab}
              className={`main-tab ${currentTab === tab ? 'active' : ''}`}
              onClick={() => onTabChange(tab)}
            >
              {TAB_LABELS[tab]}
            </button>
          ))}
        </div>

        {/* ── Search ── */}
        <div className="search-bar-container">
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
                    style={{ display: 'flex', alignItems: 'center', gap: '8px', textAlign: 'left' }}
                  >
                    <img
                      src={`https://render.albiononline.com/v1/item/${item.id}.png?size=32`}
                      alt=""
                      className="result-icon"
                      style={{ width: 32, height: 32, objectFit: 'contain', flexShrink: 0 }}
                      onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
                    />
                    <div className="result-info" style={{ flex: 1 }}>
                      <div className="result-name">{item.name}</div>
                      <div className="result-category">{item.category} · T{item.tier || '?'}</div>
                    </div>
                    <div className="result-id" style={{ marginLeft: 'auto', flexShrink: 0 }}>{item.name} · T{item.tier || '?'}</div>
                  </button>
                ))
              )}
            </div>
          </div>
        </div>

        {/* ── Região + Gold ── */}
        <div className="header-actions">
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

          {/* API Status Badge */}
          {apiStatusBadge}

          <div className="gold-ticker" title="Preço do ouro (prata por 1 ouro)">
            <span className="gold-ticker-icon" aria-hidden>🥇</span>
            <div className="gold-ticker-info">
              <div className="gold-ticker-label">Gold</div>
              <div className="gold-ticker-price">
                {gold != null ? formatPrice(gold) : '—'}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* ── Mobile Bottom Nav ── */}
      <nav className="mobile-bottom-nav" role="tablist" aria-label="Navegação">
        {Object.keys(TAB_LABELS).map((tab) => (
          <button
            key={tab}
            role="tab"
            aria-selected={currentTab === tab}
            className={`mobile-bottom-tab ${currentTab === tab ? 'active' : ''}`}
            onClick={() => onTabChange(tab)}
          >
            <span className="mobile-bottom-tab-icon">{TAB_ICONS[tab]}</span>
            <span className="mobile-bottom-tab-label">{TAB_LABELS[tab]}</span>
          </button>
        ))}
      </nav>
    </>
  );
}

function formatPrice(n: number): string {
  return n.toLocaleString('pt-BR');
}
