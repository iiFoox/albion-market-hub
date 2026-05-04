import { useState } from 'react';
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

export function BlackMarketWorkspace({ items, region, quality, enchantLevel }: Props) {
  const [scanning, setScanning] = useState(false);
  const [results, setResults] = useState<FlipOpportunity[]>([]);
  const [hasScanned, setHasScanned] = useState(false);

  const scanItems = items.slice(0, 100); // Limit to 100 to prevent API spam

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

        // Find BM price
        const bmRow = data.find(p => p.item_id === fullId && p.city === 'Black Market' && p.quality === quality);
        const bmPrice = bmRow?.buy_price_max || bmRow?.sell_price_min || 0;

        if (bmPrice <= 0) continue;

        // Find cheapest city
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
          // BM has 6.5% tax for sell orders, or 0%?
          // If you fulfill a buy order directly, there is still the setup fee? No setup fee for direct fulfillment. But there is a premium tax of 4% / non-premium 8%. Let's assume 6.5% average.
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
      <div className="welcome-state glass-panel fade-in" style={{ padding: '30px', borderRadius: '16px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <h2 className="welcome-title" style={{ fontSize: '24px', margin: '0 0 8px 0', display: 'flex', alignItems: 'center', gap: '12px' }}>
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
            background: 'var(--gold)', color: '#000', border: 'none', padding: '12px 24px', 
            borderRadius: '8px', fontWeight: 800, fontSize: '15px', cursor: scanning ? 'wait' : 'pointer',
            opacity: (scanning || scanItems.length === 0) ? 0.5 : 1, transition: 'all 0.2s'
          }}
        >
          {scanning ? 'Analisando...' : 'Escanear Oportunidades'}
        </button>
      </div>

      {hasScanned && results.length === 0 && (
        <div className="glass-panel fade-in-up" style={{ padding: '40px', textAlign: 'center', borderRadius: '16px' }}>
          <div style={{ fontSize: '48px', marginBottom: '16px' }}>🤷</div>
          <h3 style={{ color: 'var(--text-primary)', margin: '0 0 8px 0' }}>Nenhuma Oportunidade Encontrada</h3>
          <p style={{ color: 'var(--text-muted)', margin: 0 }}>Tente mudar o Tier, a Categoria ou a Qualidade.</p>
        </div>
      )}

      {results.length > 0 && (
        <div className="glass-panel fade-in-up" style={{ padding: '20px', borderRadius: '16px' }}>
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
        </div>
      )}
    </div>
  );
}
