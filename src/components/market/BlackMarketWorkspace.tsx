import { useState, useEffect } from 'react';
import { fetchMarketPrices } from '../../lib/marketApi';
import { formatPrice } from '../../lib/formatPrice';
import { CRAFTING_CITIES, CITY_COLORS } from '../../lib/useCraftingCalc';
import type { AlbionItemMini, RegionKey } from '../../types';

interface Props {
  items: AlbionItemMini[];
  region: RegionKey;
  quality: number;
  enchantLevel: number;
}

interface FlipOpportunity {
  item: AlbionItemMini;
  fullId: string;
  buyCity: string;
  buyPrice: number;
  bmPrice: number;
  profit: number;
  margin: number;
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

export function BlackMarketWorkspace({ items, region, quality, enchantLevel }: Props) {
  const [scanning, setScanning] = useState(false);
  const [results, setResults] = useState<FlipOpportunity[]>([]);
  const [hasScanned, setHasScanned] = useState(false);
  const isMobile = useIsMobile();

  const scanItems = items.slice(0, 100);

  const handleScan = async () => {
    if (scanItems.length === 0) return;
    setScanning(true);
    setHasScanned(false);

    const ids = scanItems.map(i => enchantLevel > 0 ? `${i.id}@${enchantLevel}` : i.id);
    
    try {
      const data = await fetchMarketPrices(region, ids, undefined, { qualities: [quality] });
      
      const opportunities: FlipOpportunity[] = [];

      for (let i = 0; i < scanItems.length; i++) {
        const item = scanItems[i];
        const fullId = ids[i];

        const bmRow = data.find(p => p.item_id === fullId && p.city === 'Black Market' && p.quality === quality);
        const bmPrice = bmRow?.buy_price_max || bmRow?.sell_price_min || 0;

        if (bmPrice <= 0) continue;

        let bestCity = '';
        let bestPrice = Infinity;

        for (const city of CRAFTING_CITIES) {
          const p = data.find(r => r.item_id === fullId && r.city === city && r.quality === quality);
          const price = p?.sell_price_min ?? 0;
          if (price > 0 && price < bestPrice) {
            bestPrice = price;
            bestCity = city;
          }
        }

        if (bestPrice < Infinity && bestPrice < bmPrice) {
          const sellRevenue = bmPrice * 0.935;
          const profit = sellRevenue - bestPrice;
          
          if (profit > 0) {
            opportunities.push({
              item,
              fullId,
              buyCity: bestCity,
              buyPrice: bestPrice,
              bmPrice,
              profit,
              margin: (profit / bestPrice) * 100
            });
          }
        }
      }

      setResults(opportunities.sort((a, b) => b.profit - a.profit));
    } catch (e) {
      console.error(e);
    } finally {
      setScanning(false);
      setHasScanned(true);
    }
  };

  return (
    <div className="browse-section" style={{ display: 'flex', flexDirection: 'column', gap: '24px', maxWidth: '1200px', margin: '0 auto', width: '100%', marginBottom: '60px' }}>
      {/* Hero card */}
      <div className="welcome-state glass-panel fade-in" style={{ padding: '30px', borderRadius: '16px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '20px', textAlign: 'center' }}>
        <div>
          <h2 className="welcome-title" style={{ fontSize: '24px', margin: '0 0 8px 0', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '12px' }}>
            <span aria-hidden>🦇</span> Radar do Mercado Negro
          </h2>
          <p className="welcome-sub" style={{ color: 'var(--text-muted)', margin: 0, fontSize: '14px' }}>
            Buscando oportunidades de flip de {scanItems.length} itens da categoria atual.
          </p>
        </div>
        <button 
          onClick={handleScan}
          disabled={scanning || scanItems.length === 0}
          style={{ 
            background: 'var(--gold)', color: '#000', border: 'none', padding: '12px 32px', 
            borderRadius: '8px', fontWeight: 800, fontSize: '15px', cursor: scanning ? 'wait' : 'pointer',
            opacity: (scanning || scanItems.length === 0) ? 0.5 : 1, transition: 'all 0.2s',
            width: '100%', maxWidth: '280px'
          }}
        >
          {scanning ? '⏳ Analisando...' : 'Escanear Oportunidades'}
        </button>
      </div>

      {/* Empty state */}
      {hasScanned && results.length === 0 && (
        <div className="glass-panel fade-in-up" style={{ padding: '40px', textAlign: 'center', borderRadius: '16px' }}>
          <div style={{ fontSize: '48px', marginBottom: '16px' }}>🤷</div>
          <h3 style={{ color: 'var(--text-primary)', margin: '0 0 8px 0' }}>Nenhuma Oportunidade Encontrada</h3>
          <p style={{ color: 'var(--text-muted)', margin: 0 }}>Tente mudar o Tier, a Categoria ou a Qualidade.</p>
        </div>
      )}

      {/* Results */}
      {results.length > 0 && (
        <div className="glass-panel fade-in-up" style={{ padding: isMobile ? '12px' : '20px', borderRadius: '16px' }}>
          
          {/* Header bar */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '16px', flexWrap: 'wrap', gap: '8px' }}>
            <span style={{ fontSize: '13px', color: 'var(--gold)', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '1px' }}>
              🎯 {results.length} oportunidades
            </span>
            <span style={{ fontSize: '11px', color: 'var(--text-muted)' }}>Lucro estimado após 6.5% de taxa</span>
          </div>

          {/* MOBILE: Card layout */}
          {isMobile ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
              {results.map((res) => (
                <div
                  key={res.fullId}
                  style={{
                    background: 'rgba(255,255,255,0.03)',
                    border: '1px solid var(--border)',
                    borderRadius: '12px',
                    padding: '12px',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '10px',
                  }}
                >
                  {/* Row 1: icon + name + ROI badge */}
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    <img
                      src={`https://render.albiononline.com/v1/item/${res.fullId}.png?size=48`}
                      style={{ width: '40px', height: '40px', borderRadius: '8px', background: 'rgba(0,0,0,0.3)', flexShrink: 0 }}
                      alt=""
                      onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
                    />
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ fontWeight: 700, fontSize: '14px', color: 'var(--text-primary)', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                        {res.item.name}
                      </div>
                      <div style={{ fontSize: '10px', color: 'var(--text-muted)', marginTop: '2px', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                        {res.fullId}
                      </div>
                    </div>
                    <span style={{ background: '#4caf7d22', color: '#4caf7d', border: '1px solid #4caf7d44', borderRadius: '6px', padding: '3px 8px', fontSize: '12px', fontWeight: 800, flexShrink: 0 }}>
                      {res.margin.toFixed(1)}%
                    </span>
                  </div>

                  {/* Row 2: stats grid */}
                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '6px' }}>
                    <div style={{ background: 'rgba(0,0,0,0.2)', borderRadius: '8px', padding: '8px', textAlign: 'center' }}>
                      <div style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '3px' }}>Comprar em</div>
                      <div style={{
                        fontSize: '11px', fontWeight: 700,
                        color: CITY_COLORS[res.buyCity] ?? 'var(--text-primary)',
                        whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'
                      }}>
                        {res.buyCity}
                      </div>
                    </div>
                    <div style={{ background: 'rgba(0,0,0,0.2)', borderRadius: '8px', padding: '8px', textAlign: 'center' }}>
                      <div style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '3px' }}>Compra</div>
                      <div style={{ fontSize: '12px', fontWeight: 700, color: '#e05555', fontFamily: 'monospace' }}>
                        {formatPrice(res.buyPrice)}
                      </div>
                    </div>
                    <div style={{ background: 'rgba(76,175,125,0.1)', border: '1px solid rgba(76,175,125,0.2)', borderRadius: '8px', padding: '8px', textAlign: 'center' }}>
                      <div style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.5px', marginBottom: '3px' }}>Lucro</div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: '#4caf7d', fontFamily: 'monospace' }}>
                        {formatPrice(res.profit)}
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            /* DESKTOP: Full table */
            <table style={{ width: '100%', textAlign: 'left', borderCollapse: 'collapse', fontSize: '14px' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)' }}>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)' }}>Item</th>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)' }}>Comprar em</th>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)', textAlign: 'right' }}>Preço Compra</th>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)', textAlign: 'right' }}>Vender (Black Market)</th>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)', textAlign: 'right' }}>Lucro (6.5% Tx)</th>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)', textAlign: 'right' }}>ROI</th>
                </tr>
              </thead>
              <tbody>
                {results.map((res, idx) => (
                  <tr key={res.fullId} style={{ borderBottom: '1px solid rgba(255,255,255,0.04)', background: idx % 2 === 0 ? 'rgba(255,255,255,0.01)' : 'transparent' }}>
                    <td style={{ padding: '14px 0', display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <img src={`https://render.albiononline.com/v1/item/${res.fullId}.png?size=48`}
                        style={{ width: '40px', height: '40px', borderRadius: '6px', background: 'rgba(0,0,0,0.2)' }} alt=""
                        onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }} />
                      <div style={{ display: 'flex', flexDirection: 'column' }}>
                        <span style={{ color: 'var(--text-primary)', fontWeight: 600, fontSize: '15px' }}>{res.item.name}</span>
                        <span style={{ color: 'var(--text-muted)', fontSize: '12px' }}>{res.fullId}</span>
                      </div>
                    </td>
                    <td style={{ padding: '14px 0' }}>
                      <span style={{ background: CITY_COLORS[res.buyCity] + '33', color: CITY_COLORS[res.buyCity] ?? 'var(--text-muted)', padding: '4px 10px', borderRadius: '5px', fontSize: '13px', fontWeight: 600, border: `1px solid ${CITY_COLORS[res.buyCity] ?? 'var(--border)'}44` }}>
                        {res.buyCity}
                      </span>
                    </td>
                    <td style={{ padding: '14px 0', textAlign: 'right', fontFamily: 'Share Tech Mono, monospace', fontSize: '14px', color: '#c94c4c' }}>
                      {formatPrice(res.buyPrice)}
                    </td>
                    <td style={{ padding: '14px 0', textAlign: 'right', fontFamily: 'Share Tech Mono, monospace', fontSize: '14px', color: 'var(--gold)' }}>
                      {formatPrice(res.bmPrice)}
                    </td>
                    <td style={{ padding: '14px 0', textAlign: 'right', fontFamily: 'Share Tech Mono, monospace', fontWeight: 800, fontSize: '15px', color: '#4caf7d' }}>
                      {formatPrice(res.profit)}
                    </td>
                    <td style={{ padding: '14px 0', textAlign: 'right', fontWeight: 700, fontSize: '14px', color: '#4caf7d' }}>
                      {res.margin.toFixed(1)}%
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      )}
    </div>
  );
}
