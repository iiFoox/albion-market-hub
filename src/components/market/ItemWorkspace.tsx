import { useMemo, useState, useEffect } from 'react';
import { CITY_COLORS, MARKET_CITIES, QUALITY_LABELS_PT } from '../../config';
import { formatPrice, formatRelativeTime, freshnessClass } from '../../lib/formatPrice';
import { inferTier, stripEnchant } from '../../lib/sidebarGroup';
import type { AlbionItemMini, MarketPriceRow, RegionKey } from '../../types';
import { PriceHistoryBlock } from './PriceHistoryBlock';
import { FlipPanel } from './FlipPanel';

type Props = {
  item: AlbionItemMini;
  region: RegionKey;
  enchantLevel: number;
  onEnchantLevel: (n: number) => void;
  quality: number;
  onQuality: (q: number) => void;
  resolvedItemId: string;
  prices: MarketPriceRow[];
  loadingPrices: boolean;
  priceError: string | null;
  onRefresh?: () => void;
  onClose?: () => void;
  onSwitchTier?: (t: number) => void;
};

const TIER_HEX = ['#555', '#5c8a3a', '#3a6e8a', '#8a7a3a', '#c94c4c', '#8c4cc9', '#4c7ac9', '#c9a84c'];
const ENCHANT_LABELS = ['Normal', '+1', '+2', '+3', '+4'];

function categoryLabel(cat: string): string {
  if (cat.startsWith('Armas')) return 'Arma';
  if (cat.startsWith('Armaduras')) return 'Armadura';
  if (cat.startsWith('Off-hand')) return 'Off-hand';
  if (cat.includes('Comida')) return 'Consumível';
  return cat.split('—')[0]?.trim() ?? cat;
}

function useIsMobile() {
  const [mobile, setMobile] = useState(() => window.innerWidth < 900);
  useEffect(() => {
    const handler = () => setMobile(window.innerWidth < 900);
    window.addEventListener('resize', handler, { passive: true });
    return () => window.removeEventListener('resize', handler);
  }, []);
  return mobile;
}

export function ItemWorkspace({
  item,
  region,
  enchantLevel,
  onEnchantLevel,
  quality,
  onQuality,
  resolvedItemId,
  prices,
  loadingPrices,
  priceError,
  onRefresh,
  onClose,
  onSwitchTier,
}: Props) {
  const isMobile = useIsMobile();
  const baseId = stripEnchant(item.id);
  const tier = inferTier(baseId);
  const tierColor = TIER_HEX[Math.min(Math.max(tier - 1, 0), 7)];

  const byCity = useMemo(() => {
    const m = new Map<string, MarketPriceRow>();
    for (const r of prices) {
      m.set(r.city, r);
    }
    return m;
  }, [prices]);

  const stats = useMemo(() => {
    let minSell = Infinity;
    let maxBuy = 0;
    for (const r of prices) {
      if (r.sell_price_min > 0 && r.sell_price_min < minSell) minSell = r.sell_price_min;
      if (r.buy_price_max > maxBuy) maxBuy = r.buy_price_max;
    }
    const spread =
      minSell < Infinity && maxBuy > 0 ? Math.abs(minSell - maxBuy) : null;

    let bestFlip = 0;
    for (const c1 of MARKET_CITIES) {
      for (const c2 of MARKET_CITIES) {
        if (c1 === c2) continue;
        const buy = byCity.get(c1)?.buy_price_max ?? 0;
        const sell = byCity.get(c2)?.sell_price_min ?? 0;
        if (buy > 0 && sell > buy) {
          const net = sell * 0.935 - buy;
          if (net > bestFlip) bestFlip = net;
        }
      }
    }

    return {
      minSell: minSell < Infinity ? minSell : null,
      maxBuy: maxBuy > 0 ? maxBuy : null,
      spread,
      bestFlip: bestFlip > 0 ? Math.round(bestFlip) : null,
    };
  }, [prices, byCity]);

  return (
    <div id="itemView" className="item-workspace fade-in-up" style={{ marginBottom: '60px', padding: isMobile ? '12px' : '0' }}>
      {onClose && (
        <button
          type="button"
          onClick={onClose}
          style={{
            background: 'none',
            border: 'none',
            color: 'var(--text-muted)',
            cursor: 'pointer',
            padding: '8px 0',
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            fontSize: '12px',
            marginBottom: '16px',
            textTransform: 'uppercase',
            letterSpacing: '0.1em',
            fontWeight: 700,
          }}
        >
          &larr; Voltar
        </button>
      )}

      {/* Hero Header */}
      <div className="item-header-responsive" style={{
        display: 'flex',
        flexDirection: isMobile ? 'column' : 'row',
        gap: isMobile ? '20px' : '32px',
        alignItems: isMobile ? 'center' : 'flex-start',
        marginBottom: isMobile ? '30px' : '40px',
        position: 'relative',
        textAlign: isMobile ? 'center' : 'left'
      }}>
        {/* Glow behind image */}
        <div style={{
          position: 'absolute',
          top: isMobile ? '60px' : '50%',
          left: isMobile ? '50%' : '60px',
          width: '120px',
          height: '120px',
          background: tierColor,
          filter: 'blur(80px)',
          WebkitFilter: 'blur(80px)',
          opacity: 0.4,
          transform: 'translate(-50%, -50%)',
          zIndex: 0,
          pointerEvents: 'none'
        }} />

        <div style={{ position: 'relative', zIndex: 1 }}>
          <img 
            src={`https://render.albiononline.com/v1/item/${resolvedItemId}.png?quality=${quality}`}
            alt={item.name}
            className="item-icon-box-large"
            style={{ width: isMobile ? '100px' : '120px', height: isMobile ? '100px' : '120px', objectFit: 'contain', filter: `drop-shadow(0 0 20px ${tierColor}80)` }}
            onError={(e) => {
              (e.target as HTMLImageElement).style.display = 'none';
            }}
          />
        </div>

        <div className="item-header-info" style={{ flex: 1, zIndex: 1, display: 'flex', flexDirection: 'column', width: isMobile ? '100%' : 'auto' }}>
          <div className="item-meta-responsive" style={{ display: 'flex', gap: '8px', marginBottom: '8px', flexWrap: 'wrap', justifyContent: isMobile ? 'center' : 'flex-start' }}>
            <span style={{ 
              background: `${tierColor}20`, 
              color: tierColor, 
              border: `1px solid ${tierColor}40`,
              padding: '4px 10px',
              borderRadius: '4px',
              fontSize: '11px',
              fontWeight: 800,
              letterSpacing: '1px'
            }}>TIER {tier || '?'}</span>
            <span style={{
              background: 'var(--bg-secondary)',
              color: 'var(--text-muted)',
              padding: '4px 10px',
              borderRadius: '4px',
              fontSize: '11px',
              fontWeight: 600,
              textTransform: 'uppercase'
            }}>{categoryLabel(item.category)}</span>
            <span style={{
              color: 'var(--text-faded)',
              padding: '4px 0',
              fontSize: '11px',
              fontFamily: 'var(--font-mono)'
            }}>{resolvedItemId}</span>
          </div>

          <h2 className="item-title-responsive" style={{ 
            fontSize: isMobile ? '28px' : '48px', 
            margin: '0 0 20px 0', 
            fontFamily: 'var(--font-heading)',
            fontWeight: 800,
            lineHeight: 1.1,
            letterSpacing: '-1px'
          }}>
            {item.name} <span style={{ color: 'var(--gold)' }}>{enchantLevel > 0 ? `.${enchantLevel}` : ''}</span>
          </h2>

          <div style={{ display: 'flex', gap: '12px', flexWrap: 'wrap', justifyContent: isMobile ? 'center' : 'flex-start' }}>
            {/* Tier Selector */}
            {onSwitchTier && tier > 0 && (
              <div 
                style={{ display: 'flex', gap: '2px', background: 'var(--bg-card)', padding: '3px', borderRadius: '10px', border: '1px solid var(--border)', flexWrap: 'nowrap' }}
                role="group"
                aria-label="Selecionar Tier"
              >
                {[4, 5, 6, 7, 8].map(t => (
                  <button
                    key={t}
                    type="button"
                    onClick={() => onSwitchTier(t)}
                    style={{
                      background: tier === t ? 'var(--text-primary)' : 'transparent',
                      color: tier === t ? 'var(--bg-primary)' : 'var(--text-muted)',
                      padding: isMobile ? '6px 10px' : '6px 12px',
                      borderRadius: '7px',
                      cursor: 'pointer',
                      fontWeight: 800,
                      fontSize: '13px',
                      border: 'none',
                      transition: 'all 0.2s'
                    }}
                  >
                    T{t}
                  </button>
                ))}
              </div>
            )}

            {/* Enchant Selector */}
            <div 
              style={{ display: 'flex', gap: '2px', background: 'var(--bg-card)', padding: '3px', borderRadius: '10px', border: '1px solid var(--border)', flexWrap: 'nowrap' }}
              role="group"
              aria-label="Selecionar Encantamento"
            >
              {ENCHANT_LABELS.map((lbl, idx) => (
                <button
                  key={idx}
                  type="button"
                  onClick={() => onEnchantLevel(idx)}
                  style={{
                    background: enchantLevel === idx ? 'var(--gold)' : 'transparent',
                    color: enchantLevel === idx ? 'var(--bg-primary)' : 'var(--text-muted)',
                    padding: isMobile ? '6px 10px' : '6px 16px',
                    borderRadius: '7px',
                    cursor: 'pointer',
                    fontWeight: 800,
                    fontSize: '13px',
                    border: 'none',
                    transition: 'all 0.2s'
                  }}
                >
                  {isMobile ? `.${idx}` : lbl}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Brutalist Stats */}
      <div className="responsive-grid-stats" style={{ display: 'grid', gridTemplateColumns: isMobile ? '1fr 1fr' : 'repeat(auto-fit, minmax(200px, 1fr))', gap: isMobile ? '12px' : '20px', marginBottom: '30px' }}>
        <div className="glass-panel" style={{ padding: isMobile ? '16px' : '24px', borderRadius: '16px' }}>
          <div style={{ fontSize: '10px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginBottom: '6px' }}>Venda Mín.</div>
          <div style={{ fontSize: isMobile ? '20px' : '32px', fontFamily: 'var(--font-mono)', fontWeight: 800, color: 'var(--gold-light)' }}>
            {stats.minSell ? formatPrice(stats.minSell) : '—'}
          </div>
        </div>
        <div className="glass-panel" style={{ padding: isMobile ? '16px' : '24px', borderRadius: '16px' }}>
          <div style={{ fontSize: '10px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginBottom: '6px' }}>Compra Máx.</div>
          <div style={{ fontSize: isMobile ? '20px' : '32px', fontFamily: 'var(--font-mono)', fontWeight: 800, color: 'var(--green-light)' }}>
            {stats.maxBuy ? formatPrice(stats.maxBuy) : '—'}
          </div>
        </div>
        <div className="glass-panel" style={{ padding: isMobile ? '16px' : '24px', borderRadius: '16px' }}>
          <div style={{ fontSize: '10px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginBottom: '6px' }}>Spread</div>
          <div style={{ fontSize: isMobile ? '20px' : '32px', fontFamily: 'var(--font-mono)', fontWeight: 800, color: 'var(--text-primary)' }}>
            {stats.spread ? formatPrice(stats.spread) : '—'}
          </div>
        </div>
        <div className="glass-panel" style={{ padding: isMobile ? '16px' : '24px', borderRadius: '16px', border: '1px solid var(--gold-dim)' }}>
          <div style={{ fontSize: '10px', color: 'var(--gold)', textTransform: 'uppercase', letterSpacing: '1px', marginBottom: '6px' }}>Melhor Flip</div>
          <div style={{ fontSize: isMobile ? '20px' : '32px', fontFamily: 'var(--font-mono)', fontWeight: 800, color: 'var(--gold)' }}>
            {stats.bestFlip ? `+${formatPrice(stats.bestFlip)}` : '—'}
          </div>
        </div>
      </div>

      {loadingPrices && <div style={{ color: 'var(--gold)', marginBottom: '20px', fontFamily: 'var(--font-mono)', fontSize: '12px' }}>[ PROCESSANDO DADOS... ]</div>}
      {priceError && <div style={{ color: 'var(--red)', marginBottom: '20px', fontFamily: 'var(--font-mono)', fontSize: '12px' }}>[ ERRO: {priceError} ]</div>}

      <div className="price-section fade-in">
        <div className="section-header" style={{ flexDirection: isMobile ? 'column' : 'row', alignItems: isMobile ? 'flex-start' : 'center', gap: isMobile ? '12px' : '0' }}>
          <div className="section-title">
            💹 Preços por cidade
            {onRefresh && (
              <button
                type="button"
                onClick={onRefresh}
                className="refresh-btn"
                style={{
                  marginLeft: '12px',
                  background: 'none',
                  border: '1px solid #444',
                  color: '#ccc',
                  padding: '4px 8px',
                  borderRadius: '4px',
                  cursor: 'pointer',
                  fontSize: '11px',
                }}
              >
                🔄
              </button>
            )}
          </div>
          <div className="section-actions" style={{ width: isMobile ? '100%' : 'auto' }}>
            <select
              id="quality-select-main"
              className="quality-select"
              value={quality}
              onChange={(e) => onQuality(Number(e.target.value))}
              style={{
                backgroundColor: 'var(--bg-secondary)',
                color: 'var(--text-primary)',
                border: '1px solid var(--border)',
                borderRadius: '8px',
                padding: '8px 12px',
                fontWeight: 600,
                fontSize: '13px',
                cursor: 'pointer',
                width: isMobile ? '100%' : 'auto'
              }}
            >
              {[1, 2, 3, 4, 5].map((q) => (
                <option key={q} value={q} style={{ background: 'var(--bg-secondary)', color: 'var(--text-primary)' }}>
                  {QUALITY_LABELS_PT[q] ?? `Q${q}`}
                </option>
              ))}
            </select>
          </div>
        </div>

        <div id="priceTableContainer" className="price-table-container">
          {loadingPrices && (
            <div className="loading-state">
              <div className="spinner" />
              <div>Buscando preços…</div>
            </div>
          )}
          {priceError && (
            <div className="no-data" role="alert">
              {priceError}
            </div>
          )}
          {!loadingPrices && !priceError && prices.length === 0 && (
            <div className="no-data">Sem dados de mercado.</div>
          )}
          {!loadingPrices && !priceError && prices.length > 0 && (
            <>
              {isMobile ? (
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                  {MARKET_CITIES.map((city) => {
                    const row = byCity.get(city);
                    const sell = row?.sell_price_min;
                    const updated = row?.sell_price_min_date || row?.buy_price_max_date;
                    const bestSell = stats.minSell != null && sell === stats.minSell && sell > 0;

                    return (
                      <div key={city} style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--border)', borderRadius: '10px', padding: '12px', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '8px', alignItems: 'center' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                          <div style={{ width: '6px', height: '6px', borderRadius: '50%', background: CITY_COLORS[city] ?? '#888', flexShrink: 0 }} />
                          <span style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-primary)' }}>{city}</span>
                        </div>
                        <div style={{ textAlign: 'center' }}>
                          <div style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', marginBottom: '2px' }}>Venda</div>
                          {sell != null && sell > 0 ? (
                            <div style={{ fontSize: '13px', fontWeight: 700, color: bestSell ? 'var(--gold)' : 'var(--gold-dim)', fontFamily: 'monospace' }}>
                              {formatPrice(sell)}
                            </div>
                          ) : <span style={{ fontSize: '11px', color: 'var(--text-faded)' }}>—</span>}
                        </div>
                        <div style={{ textAlign: 'right' }}>
                          <div style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', marginBottom: '2px' }}>Atualizado</div>
                          <span className={`updated-cell ${freshnessClass(updated)}`} style={{ fontSize: '10px' }}>
                            {formatRelativeTime(updated)}
                          </span>
                        </div>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <table className="price-table">
                  <thead>
                    <tr>
                      <th>Cidade</th>
                      <th>Menor venda</th>
                      <th>Maior compra</th>
                      <th>Atualizado</th>
                    </tr>
                  </thead>
                  <tbody>
                    {MARKET_CITIES.map((city) => {
                      const row = byCity.get(city);
                      const sell = row?.sell_price_min;
                      const buy = row?.buy_price_max;
                      const updated = row?.sell_price_min_date || row?.buy_price_max_date;
                      const bestSell = stats.minSell != null && sell === stats.minSell && sell > 0;
                      const bestBuy = stats.maxBuy != null && buy === stats.maxBuy && buy > 0;

                      return (
                        <tr key={city}>
                          <td>
                            <div className="city-cell">
                              <div
                                className="city-dot"
                                style={{
                                  background: CITY_COLORS[city] ?? '#888',
                                  boxShadow: `0 0 6px ${CITY_COLORS[city] ?? '#888'}`,
                                }}
                              />
                              <span className="city-name">{city}</span>
                            </div>
                          </td>
                          <td>
                            {sell != null && sell > 0 ? (
                              <>
                                <span className="price-sell">{formatPrice(sell)}</span>
                                {bestSell ? <span className="best-badge best-sell">melhor</span> : null}
                              </>
                            ) : (
                              <span className="price-na">sem dados</span>
                            )}
                          </td>
                          <td>
                            {buy != null && buy > 0 ? (
                              <>
                                <span className="price-buy">{formatPrice(buy)}</span>
                                {bestBuy ? <span className="best-badge best-buy">melhor</span> : null}
                              </>
                            ) : (
                              <span className="price-na">sem dados</span>
                            )}
                          </td>
                          <td>
                            <span className={`updated-cell ${freshnessClass(updated)}`}>
                              {formatRelativeTime(updated)}
                            </span>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              )}
            </>
          )}
        </div>
      </div>

      <PriceHistoryBlock region={region} itemId={resolvedItemId} quality={quality} />

      <FlipPanel byCity={byCity} />

      <p className="data-disclaimer">
        Dados da comunidade (Albion Data Project). spreads aproximados.
      </p>
    </div>
  );
}
