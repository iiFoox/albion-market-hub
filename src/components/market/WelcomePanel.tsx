import type { AlbionItemMini, SidebarGroupId } from '../../types';

const SIDEBAR_HINT: Record<SidebarGroupId, string> = {
  all: 'Todos os itens do catálogo.',
  raw: 'Recursos brutos (minério, madeira, fibra…).',
  refined: 'Barras, pranchas, tecido, couro, pedra.',
  weapon: 'Armas de todas as linhas.',
  armor: 'Peças de armadura (capuz, peito, botas).',
  offhand: 'Escudos, livros, orbes…',
  food: 'Comidas e ingredientes.',
  potion: 'Poções e venenos.',
  mount: 'Montarias.',
  bag: 'Mochilas e capas.',
};

type Props = {
  quickItems: AlbionItemMini[];
  onPickItem: (item: AlbionItemMini) => void;
  sidebarGroup: SidebarGroupId;
  filteredCount: number;
};

export function WelcomePanel({ quickItems, onPickItem, sidebarGroup, filteredCount }: Props) {
  return (
    <div className="welcome-state fade-in welcome-state--compact">
      <span className="welcome-icon" aria-hidden>
        ⚔️
      </span>
      <div className="welcome-title">Albion Online Market</div>
      <div className="welcome-sub">
        {SIDEBAR_HINT[sidebarGroup]} Use a busca para refinar.{' '}
        <strong className="welcome-count">{filteredCount.toLocaleString('pt-BR')} itens</strong> visíveis com os filtros atuais.
      </div>
      <div className="welcome-hint">✨ Atalhos abaixo da lista — clique num item para ver preços</div>
      <div className="quick-items">
        {quickItems.map((item) => (
          <button key={item.id} type="button" className="quick-item-btn" onClick={() => onPickItem(item)} style={{ display: 'inline-flex', alignItems: 'center', gap: '8px' }}>
            <img 
              src={`https://render.albiononline.com/v1/item/${item.id}.png?size=32`} 
              alt="" 
              style={{ width: '32px', height: '32px', objectFit: 'contain' }}
              onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
            />
            <span>{item.name}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
