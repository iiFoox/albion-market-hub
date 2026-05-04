import { useMemo, useState, useEffect } from 'react';
import { QUALITIES, QUALITY_LABELS_PT } from '../../config';
import { getIngredientName } from '../../lib/recipes';
import { formatPrice } from '../../lib/formatPrice';
import { CRAFTING_CITIES, CITY_COLORS, calcForCity, useCraftingCalc } from '../../lib/useCraftingCalc';
import type { AlbionItemMini, RegionKey } from '../../types';

type Props = {
  item: AlbionItemMini;
  region: RegionKey;
  enchantLevel: number;
  onEnchantLevel: (e: number) => void;
  quality: number;
  onQuality: (q: number) => void;
  onClose: () => void;
  resolvedItemId: string;
  onSwitchTier?: (t: number) => void;
};

function useIsMobile() {
  const [mobile, setMobile] = useState(() => window.innerWidth < 900);
  useEffect(() => {
    const handler = () => setMobile(window.innerWidth < 900);
    window.addEventListener('resize', handler, { passive: true });
    return () => window.removeEventListener('resize', handler);
  }, []);
  return mobile;
}

export function CraftingWorkspace({ item, region, enchantLevel, onEnchantLevel, quality, onQuality, onClose, resolvedItemId, onSwitchTier }: Props) {
  const isMobile = useIsMobile();
  const { recipe, allPrices, loading } = useCraftingCalc(item, region, enchantLevel, resolvedItemId);

  const [sellCity, setSellCity] = useState<string>(CRAFTING_CITIES[0]);
  const [useFocus, setUseFocus] = useState(false);
  const [cityBonus, setCityBonus] = useState(true);
  const [stationFee, setStationFee] = useState(300);
  const [useBestCity, setUseBestCity] = useState(true);
  const [activeView, setActiveView] = useState<'calculator' | 'cities'>('calculator');

  const calc = useMemo(() =>
    calcForCity(recipe, allPrices, sellCity, useFocus, cityBonus, stationFee, resolvedItemId, useBestCity, quality),
    [recipe, allPrices, sellCity, useFocus, cityBonus, stationFee, resolvedItemId, useBestCity, quality]
  );

  const cityComparison = useMemo(() => {
    if (!recipe) return [];
    return CRAFTING_CITIES.map(city => {
      const r = calcForCity(recipe, allPrices, city, useFocus, cityBonus, stationFee, resolvedItemId, false, quality);
      return { city, ...r };
    }).sort((a, b) => (b?.profit ?? -Infinity) - (a?.profit ?? -Infinity));
  }, [recipe, allPrices, useFocus, cityBonus, stationFee, resolvedItemId, quality]);

  const bestProfitCity = cityComparison[0]?.city ?? '';

  if (!recipe) {
    return (
      <div className="item-workspace fade-in-up" style={{ marginBottom: '60px', padding: isMobile ? '16px' : '0' }}>
        <div className="item-header" style={{ justifyContent: 'space-between', flexDirection: isMobile ? 'column' : 'row', gap: '16px' }}>
          <div>
            <h2 className="item-title" style={{ fontSize: isMobile ? '20px' : '24px' }}>Receita Indisponível</h2>
            <p style={{ color: 'var(--text-muted)', fontSize: '14px' }}>Não encontramos receita para <strong>{item.name}</strong>.</p>
          </div>
          <button className="link-btn" onClick={onClose} style={{ fontSize: '24px', alignSelf: isMobile ? 'flex-end' : 'center' }}>&times;</button>
        </div>
      </div>
    );
  }

  return (
    <div className="item-workspace fade-in-up" style={{ marginBottom: '60px', padding: isMobile ? '12px' : '0' }}>
      {/* Header */}
      <div className="item-header" style={{ flexDirection: isMobile ? 'column' : 'row', alignItems: isMobile ? 'center' : 'flex-start', textAlign: isMobile ? 'center' : 'left', gap: isMobile ? '16px' : '24px' }}>
        <div className="item-icon-box" style={{ width: '64px', height: '64px' }}>
          <img src={`https://render.albiononline.com/v1/item/${resolvedItemId}.png?quality=${quality}`} alt={item.name}
            style={{ width: '64px', height: '64px', objectFit: 'contain' }}
            onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }} />
          <div className={`item-tier-badge tier-${item.tier}`}>T{item.tier}</div>
        </div>
        <div style={{ flex: 1 }}>
          <h2 className="item-title" style={{ fontSize: isMobile ? '24px' : '28px', margin: '0 0 4px 0' }}>{item.name}</h2>
          <div className="item-meta" style={{ justifyContent: isMobile ? 'center' : 'flex-start' }}>
            <span className="item-badge category">{item.category}</span>
            <span className="item-id">{resolvedItemId}</span>
          </div>
        </div>

        <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', justifyContent: isMobile ? 'center' : 'flex-end', width: isMobile ? '100%' : 'auto' }}>
          {onSwitchTier && item.tier > 0 && (
            <div style={{ display: 'flex', gap: '2px', background: 'var(--bg-card)', padding: '3px', borderRadius: '10px', border: '1px solid var(--border)' }}>
              {[4,5,6,7,8].map(t => (
                <button key={t} type="button" onClick={() => onSwitchTier(t)}
                  style={{ background: item.tier === t ? 'var(--gold)' : 'transparent', color: item.tier === t ? '#000' : 'var(--text-muted)', padding: '6px 10px', borderRadius: '7px', cursor: 'pointer', fontWeight: 800, fontSize: '13px', border: 'none' }}>
                  T{t}
                </button>
              ))}
            </div>
          )}
          <div style={{ display: 'flex', gap: '2px', background: 'var(--bg-card)', padding: '3px', borderRadius: '10px', border: '1px solid var(--border)' }}>
            {[0,1,2,3,4].map(lvl => (
              <button key={lvl} type="button" onClick={() => onEnchantLevel(lvl)}
                style={{ background: enchantLevel === lvl ? 'var(--gold)' : 'transparent', color: enchantLevel === lvl ? '#000' : 'var(--text-muted)', padding: '6px 12px', borderRadius: '7px', cursor: 'pointer', fontWeight: 800, fontSize: '13px', border: 'none' }}>
                .{lvl}
              </button>
            ))}
          </div>
          {!isMobile && <button className="link-btn" onClick={onClose} aria-label="Fechar" style={{ fontSize: '24px', marginLeft: '4px' }}>&times;</button>}
        </div>
      </div>

      {/* Config Bar */}
      <div style={{ background: 'var(--bg-secondary)', borderRadius: '12px', border: '1px solid var(--border)', padding: isMobile ? '12px' : '16px 20px', display: 'flex', flexWrap: 'wrap', gap: isMobile ? '12px' : '20px', alignItems: 'center', marginBottom: '16px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', flex: isMobile ? '1' : 'none', minWidth: isMobile ? '120px' : 'auto' }}>
          <span style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px' }}>Venda</span>
          <select value={sellCity} onChange={e => setSellCity(e.target.value)}
            style={{ background: 'var(--bg-card)', color: 'var(--text-primary)', border: '1px solid var(--border)', borderRadius: '8px', padding: '6px 10px', fontWeight: 600, fontSize: '13px', width: '100%' }}>
            {CRAFTING_CITIES.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', flex: isMobile ? '1' : 'none', minWidth: isMobile ? '120px' : 'auto' }}>
          <span style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px' }}>Qualidade</span>
          <select value={quality} onChange={e => onQuality(Number(e.target.value))}
            style={{ background: 'var(--bg-card)', color: 'var(--text-primary)', border: '1px solid var(--border)', borderRadius: '8px', padding: '6px 10px', fontWeight: 600, fontSize: '13px', width: '100%' }}>
            {QUALITIES.map(q => <option key={q} value={q}>{QUALITY_LABELS_PT[q]} ({q})</option>)}
          </select>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', flex: isMobile ? '1' : 'none' }}>
          <span style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px' }}>Taxa (%)</span>
          <input type="number" min={0} max={1000} step={10}
            style={{ width: '100%', background: 'var(--bg-card)', color: 'var(--text-primary)', border: '1px solid var(--border)', borderRadius: '8px', padding: '6px 10px', fontSize: '13px', fontWeight: 600 }}
            value={stationFee} onChange={e => setStationFee(Number(e.target.value))} />
        </div>
        <div style={{ display: 'flex', gap: '12px', alignItems: 'center', width: isMobile ? '100%' : 'auto', flexWrap: 'wrap' }}>
          <label style={{ display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer', fontSize: '12px', color: 'var(--text-primary)' }}>
            <input type="checkbox" checked={cityBonus} onChange={e => setCityBonus(e.target.checked)} />
            Bônus
          </label>
          <label style={{ display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer', fontSize: '12px', color: 'var(--gold)' }}>
            <input type="checkbox" checked={useFocus} onChange={e => setUseFocus(e.target.checked)} />
            Foco
          </label>
          <label style={{ display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer', fontSize: '12px', color: 'var(--text-primary)' }}>
            <input type="checkbox" checked={useBestCity} onChange={e => setUseBestCity(e.target.checked)} />
            Rota Otimizada
          </label>
        </div>
        <div style={{ width: isMobile ? '100%' : 'auto', display: 'flex', gap: '2px', background: 'var(--bg-card)', padding: '3px', borderRadius: '10px', border: '1px solid var(--border)', marginTop: isMobile ? '4px' : '0' }}>
          {(['calculator','cities'] as const).map(v => (
            <button key={v} type="button" onClick={() => setActiveView(v)}
              style={{ flex: isMobile ? '1' : 'none', padding: '6px 12px', borderRadius: '7px', border: 'none', cursor: 'pointer', fontWeight: 600, fontSize: '11px', textTransform: 'uppercase', letterSpacing: '1px',
                background: activeView === v ? 'var(--gold)' : 'transparent', color: activeView === v ? '#000' : 'var(--text-muted)' }}>
              {v === 'calculator' ? '⚗️ Calc' : '🌍 Cidades'}
            </button>
          ))}
        </div>
      </div>

      {/* RRR Badge / Summary */}
      <div style={{ display: 'grid', gridTemplateColumns: isMobile ? '1fr 1fr' : 'repeat(auto-fit, minmax(140px, 1fr))', gap: '10px', marginBottom: '16px' }}>
        {[
          { label: 'RRR', value: `${((calc?.rrr ?? 0) * 100).toFixed(1)}%`, color: 'var(--gold)' },
          { label: 'Lucro Final', value: calc?.targetPrice ? formatPrice(calc.profit) : '—', color: calc && calc.profit > 0 ? '#4caf7d' : '#c94c4c' },
          { label: 'Margem ROI', value: calc?.targetPrice ? `${calc.margin.toFixed(1)}%` : '—', color: calc && calc.margin > 0 ? '#4caf7d' : '#c94c4c' },
          { label: 'Custo Líq.', value: calc ? formatPrice(calc.netCost) : '—', color: 'var(--text-primary)' },
        ].map(stat => (
          <div key={stat.label} style={{ background: 'var(--bg-card)', border: '1px solid var(--border)', borderRadius: '10px', padding: '12px', textAlign: 'center' }}>
            <div style={{ fontSize: '9px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginBottom: '4px' }}>{stat.label}</div>
            <div style={{ fontSize: isMobile ? '16px' : '18px', fontWeight: 800, color: stat.color, fontFamily: 'Share Tech Mono, monospace' }}>{stat.value}</div>
          </div>
        ))}
      </div>

      {loading ? (
        <div style={{ textAlign: 'center', padding: '60px', color: 'var(--text-muted)' }}>
          <div style={{ fontSize: '32px', marginBottom: '12px' }}>⚗️</div>
          <div style={{ fontSize: '14px' }}>Analisando mercados...</div>
        </div>
      ) : activeView === 'calculator' ? (
        <div className="price-section fade-in" style={{ padding: isMobile ? '12px' : '20px' }}>
          <h3 style={{ margin: '0 0 16px 0', fontSize: '13px', textTransform: 'uppercase', letterSpacing: '2px', color: 'var(--gold-dim)' }}>
            📦 Ingredientes {useBestCity ? '(Otimizado)' : `(${sellCity})`}
          </h3>
          
          {isMobile ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
              {calc?.breakdown.map(ing => (
                <div key={ing.id} style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--border)', borderRadius: '10px', padding: '10px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    <img src={`https://render.albiononline.com/v1/item/${ing.id}.png?size=48`}
                      style={{ width: '32px', height: '32px', borderRadius: '4px', background: 'rgba(0,0,0,0.2)' }} alt=""
                      onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }} />
                    <div style={{ flex: 1 }}>
                      <div style={{ color: 'var(--text-primary)', fontWeight: 600, fontSize: '14px' }}>{getIngredientName(ing.id)}</div>
                      <div style={{ fontSize: '10px', color: 'var(--text-muted)' }}>{ing.id}</div>
                    </div>
                    <div style={{ fontWeight: 800, color: 'var(--gold)', fontSize: '14px' }}>{ing.count}×</div>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', background: 'rgba(0,0,0,0.2)', padding: '6px 10px', borderRadius: '6px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <div style={{ width: '6px', height: '6px', borderRadius: '50%', background: CITY_COLORS[ing.sourceCity] ?? '#888' }} />
                      <span style={{ fontWeight: 600, color: CITY_COLORS[ing.sourceCity] ?? 'var(--text-muted)' }}>{ing.sourceCity}</span>
                    </div>
                    <div style={{ fontFamily: 'monospace', fontWeight: 700 }}>
                       {ing.price > 0 ? formatPrice(ing.price) : <span style={{ color: 'var(--red)' }}>S/ dados</span>}
                    </div>
                    <div style={{ fontFamily: 'monospace', fontWeight: 800, color: 'var(--text-primary)' }}>{formatPrice(ing.cost)}</div>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <table style={{ width: '100%', textAlign: 'left', borderCollapse: 'collapse', fontSize: '14px' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)' }}>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)' }}>Ingrediente</th>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)', textAlign: 'center' }}>Qtd</th>
                  {useBestCity && <th style={{ padding: '12px 0', color: 'var(--text-muted)' }}>Comprar em</th>}
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)', textAlign: 'right' }}>Preço Unit.</th>
                  <th style={{ padding: '12px 0', color: 'var(--text-muted)', textAlign: 'right' }}>Custo Total</th>
                </tr>
              </thead>
              <tbody>
                {calc?.breakdown.map(ing => (
                  <tr key={ing.id} style={{ borderBottom: '1px solid rgba(255,255,255,0.04)' }}>
                    <td style={{ padding: '14px 0', display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <img src={`https://render.albiononline.com/v1/item/${ing.id}.png?size=48`}
                        style={{ width: '40px', height: '40px', borderRadius: '6px', background: 'rgba(0,0,0,0.2)' }} alt=""
                        onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }} />
                      <div style={{ display: 'flex', flexDirection: 'column' }}>
                        <span style={{ color: 'var(--text-primary)', fontWeight: 600, fontSize: '15px' }}>{getIngredientName(ing.id)}</span>
                        <span style={{ color: 'var(--text-muted)', fontSize: '12px' }}>{ing.id}</span>
                      </div>
                    </td>
                    <td style={{ padding: '14px 0', textAlign: 'center', fontWeight: 700, color: 'var(--gold-dim)', fontSize: '15px' }}>{ing.count}×</td>
                    {useBestCity && (
                      <td style={{ padding: '14px 0' }}>
                        <span style={{ background: CITY_COLORS[ing.sourceCity] + '33', color: CITY_COLORS[ing.sourceCity] ?? 'var(--text-muted)', padding: '4px 10px', borderRadius: '5px', fontSize: '13px', fontWeight: 600, border: `1px solid ${CITY_COLORS[ing.sourceCity] ?? 'var(--border)'}44` }}>
                          {ing.sourceCity}
                        </span>
                      </td>
                    )}
                    <td style={{ padding: '14px 0', textAlign: 'right', fontFamily: 'Share Tech Mono, monospace', fontSize: '14px' }}>
                      {ing.price > 0 ? formatPrice(ing.price) : <span style={{ color: 'var(--red)' }}>Sem dados</span>}
                    </td>
                    <td style={{ padding: '14px 0', textAlign: 'right', fontFamily: 'Share Tech Mono, monospace', fontWeight: 700, fontSize: '14px' }}>
                      {formatPrice(ing.cost)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          <div style={{ marginTop: '24px', display: 'grid', gridTemplateColumns: isMobile ? '1fr' : '1fr 1fr', gap: '16px' }}>
            <div style={{ background: 'var(--bg-secondary)', padding: '20px', borderRadius: '12px', border: '1px solid var(--border)' }}>
              <div style={{ fontSize: '11px', color: 'var(--text-muted)', letterSpacing: '2px', textTransform: 'uppercase', marginBottom: '12px' }}>Demonstrativo de Custos</div>
              {[
                { label: 'Custo Bruto', value: formatPrice(calc?.totalRawCost ?? 0), color: 'var(--text-primary)' },
                { label: `(-) Desconto RRR`, value: `- ${formatPrice(calc?.returnDiscount ?? 0)}`, color: '#4caf7d' },
                { label: `(+) Taxas`, value: `+ ${formatPrice(calc?.feeCost ?? 0)}`, color: '#c94c4c' },
              ].map(row => (
                <div key={row.label} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '13px' }}>
                  <span style={{ color: row.color }}>{row.label}</span>
                  <span style={{ fontFamily: 'Share Tech Mono, monospace', color: row.color }}>{row.value}</span>
                </div>
              ))}
              <div style={{ display: 'flex', justifyContent: 'space-between', borderTop: '1px solid var(--border)', paddingTop: '10px', marginTop: '10px', fontWeight: 800, fontSize: '15px' }}>
                <span>Custo Líquido</span>
                <span style={{ fontFamily: 'Share Tech Mono, monospace', color: 'var(--gold)' }}>{formatPrice(calc?.netCost ?? 0)}</span>
              </div>
            </div>
            <div style={{ background: 'var(--bg-secondary)', padding: '20px', borderRadius: '12px', border: `1px solid ${(calc?.profit ?? 0) > 0 ? '#4caf7d55' : '#c94c4c55'}`, position: 'relative', overflow: 'hidden' }}>
              <div style={{ position: 'absolute', top: 0, right: 0, bottom: 0, width: '4px', background: (calc?.profit ?? 0) > 0 ? '#4caf7d' : '#c94c4c' }} />
              <div style={{ fontSize: '11px', color: 'var(--text-muted)', letterSpacing: '2px', textTransform: 'uppercase', marginBottom: '12px' }}>Venda em {sellCity}</div>
              {[
                { label: `Preço (Q${quality})`, value: calc?.targetPrice ? formatPrice(calc.targetPrice) : 'Sem dados', color: 'var(--text-primary)' },
                { label: '(-) Taxa 6.5%', value: calc?.targetPrice ? `- ${formatPrice(calc.targetPrice * 0.065)}` : '—', color: '#c94c4c' },
              ].map(row => (
                <div key={row.label} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '13px' }}>
                  <span style={{ color: 'var(--text-muted)' }}>{row.label}</span>
                  <span style={{ fontFamily: 'Share Tech Mono, monospace', color: row.color }}>{row.value}</span>
                </div>
              ))}
              <div style={{ display: 'flex', justifyContent: 'space-between', borderTop: '1px solid var(--border)', paddingTop: '10px', marginTop: '10px', fontWeight: 800, fontSize: '18px' }}>
                <span>Lucro Estimado</span>
                <span style={{ fontFamily: 'Share Tech Mono, monospace', color: (calc?.profit ?? 0) > 0 ? '#4caf7d' : '#c94c4c' }}>
                  {calc?.targetPrice ? formatPrice(calc.profit) : '—'}
                </span>
              </div>
            </div>
          </div>
        </div>
      ) : (
        /* City Comparison View */
        <div className="price-section fade-in" style={{ padding: isMobile ? '12px' : '20px' }}>
          <h3 style={{ margin: '0 0 16px 0', fontSize: '11px', textTransform: 'uppercase', letterSpacing: '2px', color: 'var(--gold-dim)' }}>
            🌍 Comparativo de Lucro (Qualidade {quality})
          </h3>
          
          {isMobile ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
              {cityComparison.map(({ city, targetPrice, profit, margin }) => {
                const isBest = city === bestProfitCity && (profit ?? 0) > 0;
                return (
                  <div key={city} onClick={() => { setSellCity(city); setActiveView('calculator'); }}
                    style={{ background: isBest ? 'rgba(76,175,125,0.06)' : 'rgba(255,255,255,0.03)', border: `1px solid ${isBest ? '#4caf7d55' : 'var(--border)'}`, borderRadius: '10px', padding: '12px', display: 'flex', flexDirection: 'column', gap: '8px', cursor: 'pointer' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <div style={{ width: '8px', height: '8px', borderRadius: '50%', background: CITY_COLORS[city] ?? '#888' }} />
                        <span style={{ fontWeight: 700, color: isBest ? '#4caf7d' : 'var(--text-primary)' }}>{city}</span>
                        {isBest && <span style={{ background: '#4caf7d22', color: '#4caf7d', padding: '1px 6px', borderRadius: '4px', fontSize: '9px', fontWeight: 700, border: '1px solid #4caf7d44' }}>BEST</span>}
                      </div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: (profit ?? 0) > 0 ? '#4caf7d' : '#c94c4c', fontFamily: 'monospace' }}>
                        {targetPrice ? formatPrice(profit ?? 0) : '—'}
                      </div>
                    </div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '11px', color: 'var(--text-muted)' }}>
                      <span>Venda: {targetPrice ? formatPrice(targetPrice) : '—'}</span>
                      <span>ROI: <strong style={{ color: (margin ?? 0) > 0 ? '#4caf7d' : '#c94c4c' }}>{(margin ?? 0).toFixed(1)}%</strong></span>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <table style={{ width: '100%', textAlign: 'left', borderCollapse: 'collapse', fontSize: '13px' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)' }}>
                  {['Cidade de Venda','Custo Líquido','Preço de Venda','Lucro Líquido','ROI',''].map(h => (
                    <th key={h} style={{ padding: '10px 8px', color: 'var(--text-muted)', fontSize: '11px', textTransform: 'uppercase', letterSpacing: '1px', textAlign: h === '' ? 'center' : 'left' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {cityComparison.map(({ city, netCost, targetPrice, profit, margin }, idx) => {
                  const isBest = city === bestProfitCity && (profit ?? 0) > 0;
                  const color = CITY_COLORS[city] ?? 'var(--text-muted)';
                  return (
                    <tr key={city} style={{ borderBottom: '1px solid rgba(255,255,255,0.04)', background: isBest ? 'rgba(76,175,125,0.06)' : idx % 2 === 0 ? 'rgba(255,255,255,0.01)' : 'transparent' }}>
                      <td style={{ padding: '12px 8px' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                          <div style={{ width: '8px', height: '8px', borderRadius: '50%', background: color }} />
                          <span style={{ fontWeight: 600, color: isBest ? '#4caf7d' : 'var(--text-primary)' }}>{city}</span>
                        </div>
                      </td>
                      <td style={{ padding: '12px 8px', fontFamily: 'Share Tech Mono, monospace' }}>{netCost ? formatPrice(netCost) : '—'}</td>
                      <td style={{ padding: '12px 8px', fontFamily: 'Share Tech Mono, monospace' }}>{targetPrice ? formatPrice(targetPrice) : '—'}</td>
                      <td style={{ padding: '12px 8px', fontFamily: 'Share Tech Mono, monospace', fontWeight: 700, color: (profit ?? 0) > 0 ? '#4caf7d' : '#c94c4c' }}>
                        {targetPrice ? formatPrice(profit ?? 0) : '—'}
                      </td>
                      <td style={{ padding: '12px 8px', color: (margin ?? 0) > 0 ? '#4caf7d' : '#c94c4c', fontWeight: 600 }}>
                        {targetPrice ? `${(margin ?? 0).toFixed(1)}%` : '—'}
                      </td>
                      <td style={{ padding: '12px 8px', textAlign: 'center' }}>
                        <button type="button" onClick={() => { setSellCity(city); setActiveView('calculator'); }}
                          style={{ background: 'var(--bg-card)', border: '1px solid var(--border)', borderRadius: '6px', color: 'var(--text-muted)', padding: '4px 10px', fontSize: '11px', cursor: 'pointer' }}>
                          Detalhes
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}
        </div>
      )}
    </div>
  );
}
