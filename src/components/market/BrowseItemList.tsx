import { useMemo } from 'react';
import type { AlbionItemMini } from '../../types';

type Props = {
  items: AlbionItemMini[];
  onPickItem: (item: AlbionItemMini) => void;
};

// Limit visible rows for performance without needing react-window
const MAX_VISIBLE = 400;

export function BrowseItemList({ items, onPickItem }: Props) {
  const visible = useMemo(() => items.slice(0, MAX_VISIBLE), [items]);

  if (items.length === 0) {
    return (
      <div className="browse-empty">
        Nenhum item com estes filtros. Troque categoria, tier ou limpe a busca.
      </div>
    );
  }

  return (
    <div
      className="browse-list-wrap"
      style={{
        overflowY: 'auto',
        maxHeight: '520px',
        width: '100%',
        display: 'flex',
        flexDirection: 'column',
        gap: '6px',
        paddingRight: '4px',
      }}
    >
      {visible.map((item) => (
        <button
          key={item.id}
          type="button"
          className="browse-row glow-hover"
          onClick={() => onPickItem(item)}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '16px',
            textAlign: 'left',
            width: '100%',
            padding: '10px 16px',
            background: 'var(--bg-secondary)',
            border: '1px solid var(--border)',
            borderRadius: '8px',
            cursor: 'pointer',
            flexShrink: 0,
            contentVisibility: 'auto',
            containIntrinsicSize: '0 56px',
          } as React.CSSProperties}
        >
          <img
            src={`https://render.albiononline.com/v1/item/${item.id}.png?size=40`}
            alt=""
            style={{ width: '40px', height: '40px', objectFit: 'contain', flexShrink: 0 }}
            onError={(e) => { (e.target as HTMLImageElement).style.visibility = 'hidden'; }}
            loading="lazy"
          />
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center', overflow: 'hidden' }}>
            <span
              className="browse-row__name"
              style={{ fontSize: '15px', fontWeight: 600, color: 'var(--text-primary)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}
            >
              {item.name}
            </span>
            <span className="browse-row__meta" style={{ fontSize: '12px', color: 'var(--text-muted)' }}>
              T{item.tier || '?'} · {item.category.split('—')[0]?.trim()}
            </span>
          </div>
          <code
            className="browse-row__id"
            style={{ marginLeft: 'auto', flexShrink: 0, fontFamily: 'var(--font-mono)', fontSize: '11px', color: 'var(--gold-dim)', background: 'rgba(0,0,0,0.3)', padding: '3px 8px', borderRadius: '4px' }}
          >
            {item.id}
          </code>
        </button>
      ))}
      {items.length > MAX_VISIBLE && (
        <div style={{ textAlign: 'center', padding: '12px', color: 'var(--text-muted)', fontSize: '12px', fontStyle: 'italic' }}>
          Mostrando {MAX_VISIBLE} de {items.length} itens. Refine a busca ou use os filtros para ver mais.
        </div>
      )}
    </div>
  );
}
