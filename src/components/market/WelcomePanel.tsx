import type { AlbionItemMini, SidebarGroupId } from '../../types';

const SIDEBAR_HINT: Record<SidebarGroupId, string> = {
  all:     'Todos os itens do catálogo.',
  helmet:  'Capacetes, capuzes e elmos de todas as linhas.',
  chest:   'Peitorais e armaduras de corpo de todas as linhas.',
  boots:   'Botas e sapatos de todas as linhas.',
  bag:     'Mochilas e capas.',
  weapon:  'Armas de todas as linhas.',
  offhand: 'Escudos, livros, orbes…',
  food:    'Comidas e ingredientes.',
  potion:  'Poções e venenos.',
  mount:   'Montarias.',
  raw:     'Recursos brutos (minério, madeira, fibra…).',
  refined: 'Barras, pranchas, tecido, couro, pedra.',
};

type Props = {
  quickItems: AlbionItemMini[];
  onPickItem: (item: AlbionItemMini) => void;
  sidebarGroup: SidebarGroupId;
  filteredCount: number;
};

export function WelcomePanel({ sidebarGroup, filteredCount }: Props) {
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
    </div>
  );
}
