import { useMemo, useState, useEffect } from 'react';
import type { AlbionItemMini } from '../../types';

type Props = {
  items: AlbionItemMini[];
  onPickItem: (item: AlbionItemMini) => void;
};

// Desktop: cap at 400 for performance. Mobile: start at 10, expand to all.
const DESKTOP_MAX = 400;
const MOBILE_INITIAL = 10;

function useIsMobile() {
  const [mobile, setMobile] = useState(() => window.innerWidth < 900);
  useEffect(() => {
    const handler = () => setMobile(window.innerWidth < 900);
    window.addEventListener('resize', handler, { passive: true });
    return () => window.removeEventListener('resize', handler);
  }, []);
  return mobile;
}

export function BrowseItemList({ items, onPickItem }: Props) {
  const isMobile = useIsMobile();
  const [showAll, setShowAll] = useState(false);

  // Reset "show all" when items change (e.g. filter/search changes)
  useEffect(() => { setShowAll(false); }, [items]);

  const visible = useMemo(() => {
    if (isMobile && !showAll) return items.slice(0, MOBILE_INITIAL);
    return items.slice(0, DESKTOP_MAX);
  }, [items, isMobile, showAll]);

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
        overflowY: isMobile ? 'visible' : 'auto',
        maxHeight: isMobile ? 'none' : '520px',
        width: '100%',
        display: 'flex',
        flexDirection: 'column',
        gap: '6px',
        paddingRight: isMobile ? 0 : '4px',
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

      {/* Mobile: show more button */}
      {isMobile && !showAll && items.length > MOBILE_INITIAL && (
        <button
          type="button"
          onClick={() => setShowAll(true)}
          style={{
            marginTop: '8px',
            width: '100%',
            padding: '12px',
            background: 'transparent',
            border: '1px dashed var(--gold-dim)',
            borderRadius: '8px',
            color: 'var(--gold)',
            fontWeight: 700,
            fontSize: '14px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px',
          }}
        >
          <span>📋</span>
          Mostrar mais ({items.length - MOBILE_INITIAL} restantes)
        </button>
      )}

      {/* Desktop: overflow notice */}
      {!isMobile && items.length > DESKTOP_MAX && (
        <div style={{ textAlign: 'center', padding: '12px', color: 'var(--text-muted)', fontSize: '12px', fontStyle: 'italic' }}>
          Mostrando {DESKTOP_MAX} de {items.length} itens. Refine a busca ou use os filtros para ver mais.
        </div>
      )}
    </div>
  );
}
