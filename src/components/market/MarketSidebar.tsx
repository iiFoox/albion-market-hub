import type { SidebarGroupId } from '../../types';

type Props = {
  sidebarGroup: SidebarGroupId;
  onSidebarGroup: (g: SidebarGroupId) => void;
  tierFilter: string;
  onTierFilter: (t: string) => void;
  quality: number;
  onQuality: (q: number) => void;
  currentTab?: 'market' | 'crafting' | 'blackmarket';
};

const NAV: { id: SidebarGroupId; icon: string; label: string }[] = [
  { id: 'all', icon: '✨', label: 'Todos os Itens' },
  { id: 'raw', icon: '🪨', label: 'Recursos Brutos' },
  { id: 'refined', icon: '⚙️', label: 'Recursos Refinados' },
  { id: 'weapon', icon: '⚔️', label: 'Armas' },
  { id: 'armor', icon: '🛡️', label: 'Armaduras' },
  { id: 'offhand', icon: '🗡️', label: 'Off-Hand' },
  { id: 'food', icon: '🍖', label: 'Comida' },
  { id: 'potion', icon: '🧪', label: 'Poções' },
  { id: 'mount', icon: '🐎', label: 'Montarias' },
  { id: 'bag', icon: '🎒', label: 'Mochilas & Capas' },
];

const TIERS = ['all', '4', '5', '6', '7', '8'] as const;

const QUALITY_CHIPS: { q: number; label: string }[] = [
  { q: 1, label: 'Normal' },
  { q: 2, label: 'Bom' },
  { q: 3, label: 'Notável' },
  { q: 4, label: 'Exc.' },
  { q: 5, label: 'Obr.' },
];

export function MarketSidebar({
  sidebarGroup,
  onSidebarGroup,
  tierFilter,
  onTierFilter,
  quality,
  onQuality,
  currentTab,
}: Props) {
  const visibleNav = NAV.filter(row => {
    if (currentTab === 'crafting') {
      if (row.id === 'raw' || row.id === 'mount') return false;
    }
    return true;
  });

  return (
    <aside className="sidebar" aria-label="Categorias e filtros">
      <div className="sidebar-title">Categorias</div>

      {visibleNav.map((row) => (
        <button
          key={row.id}
          type="button"
          className={`sidebar-item ${sidebarGroup === row.id ? 'active' : ''}`}
          onClick={() => onSidebarGroup(row.id)}
        >
          <span className="sidebar-icon" aria-hidden>
            {row.icon}
          </span>
          {row.label}
        </button>
      ))}

      <div className="sidebar-section">
        <div className="sidebar-section-header">⚙️ Filtros</div>

        <div className="filter-group">
          <span className="filter-label">Tier</span>
          <div className="filter-chips" role="group" aria-label="Filtrar tier">
            <button
              type="button"
              className={`filter-chip ${tierFilter === 'all' ? 'active' : ''}`}
              onClick={() => onTierFilter('all')}
            >
              Todos
            </button>
            {TIERS.filter((t) => t !== 'all').map((t) => (
              <button
                key={t}
                type="button"
                className={`filter-chip ${tierFilter === t ? 'active' : ''}`}
                onClick={() => onTierFilter(t)}
              >
                T{t}
              </button>
            ))}
          </div>
        </div>

        <div className="filter-group">
          <span className="filter-label">Qualidade (mercado)</span>
          <div className="filter-chips" role="group" aria-label="Qualidade do item">
            {QUALITY_CHIPS.map(({ q, label }) => (
              <button
                key={q}
                type="button"
                className={`filter-chip ${quality === q ? 'active' : ''}`}
                onClick={() => onQuality(q)}
              >
                {label}
              </button>
            ))}
          </div>
        </div>
      </div>
    </aside>
  );
}
