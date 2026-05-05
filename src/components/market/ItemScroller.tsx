import { useMemo } from 'react';
import type { AlbionItemMini } from '../../types';

type Props = {
  items: AlbionItemMini[];
  onPickItem: (item: AlbionItemMini) => void;
  speed?: number; // pixels per second
  iconsOnly?: boolean; // show only icons, no labels
};

/**
 * ItemScroller — faixa horizontal animada de itens que passam como roleta.
 * Duplica o array para loop infinito via CSS animation.
 */
export function ItemScroller({ items, onPickItem, speed = 40, iconsOnly = false }: Props) {
  // Pega até 30 itens aleatórios para a roleta
  const sample = useMemo(() => {
    const shuffled = [...items].sort(() => Math.random() - 0.5);
    return shuffled.slice(0, 30);
  }, [items]);

  if (sample.length === 0) return null;

  // Duplica para loop contínuo
  const loopItems = [...sample, ...sample];

  const animationDuration = (sample.length * 120) / speed;

  return (
    <div className={`item-scroller-wrapper ${iconsOnly ? 'icons-only' : ''}`}>
      <div className="item-scroller-track" style={{ animationDuration: `${animationDuration}s` }}>
        {loopItems.map((item, i) => (
          <button
            key={`${item.id}-${i}`}
            className="item-scroller-chip"
            onClick={() => onPickItem(item)}
            title={item.name}
          >
            <img
              src={`https://render.albiononline.com/v1/item/${item.id}.png?size=32`}
              alt=""
              className="item-scroller-icon"
              loading="lazy"
              onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
            />
            {!iconsOnly && <span className="item-scroller-label">{item.name}</span>}
          </button>
        ))}
      </div>
    </div>
  );
}
