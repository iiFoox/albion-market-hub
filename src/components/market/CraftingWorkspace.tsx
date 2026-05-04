import { useMemo, useState } from 'react';
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

export function CraftingWorkspace({ item, region, enchantLevel, onEnchantLevel, quality, onQuality, onClose, resolvedItemId, onSwitchTier }: Props) {
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
      <div className="item-workspace fade-in-up" style={{ marginBottom: '60px' }}>
        <div className="item-header" style={{ justifyContent: 'space-between' }}>
          <div>
            <h2 className="item-title">Receita Indisponível</h2>
            <p style={{ color: 'var(--text-muted)' }}>Não encontramos receita para <strong>{item.name}</strong>. Este item pode não ser craftável com as regras atuais.</p>
          </div>
          <button className="link-btn" onClick={onClose} style={{ fontSize: '24px' }}>&times;</button>
        </div>
      </div>
    );
  }

  return (
    <div className="item-workspace fade-in-up" style={{ marginBottom: '60px' }}>
      {/* Header */}
      <div className="item-header">
        <div className="item-icon-box">
          <img src={`https://render.albiononline.com/v1/item/${resolvedItemId}.png?quality=${quality}`} alt={item.name}
            style={{ width: '64px', height: '64px', objectFit: 'contain' }}
            onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }} />
          <div className={`item-tier-badge tier-${item.tier}`}>T{item.tier}</div>
        </div>
        <div style={{ flex: 1 }}>
          <h2 className="item-title">{item.name}</h2>
          <div className="item-meta">
            <span className="item-badge category">{item.category}</span>
            <span className="item-id">{resolvedItemId}</span>
          </div>
        </div>

        <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', justifyContent: 'flex-end' }}>
          {onSwitchTier && item.tier > 0 && (
            <div style={{ display: 'flex', gap: '4px', background: 'var(--bg-card)', padding: '4px', borderRadius: '12px', border: '1px solid var(--border)' }}>
              {[4,5,6,7,8].map(t => (
                <button key={t} type="button" onClick={() => onSwitchTier(t)}
                  style={{ background: item.tier === t ? 'var(--gold)' : 'transparent', color: item.tier === t ? '#000' : 'var(--text-muted)', padding: '6px 12px', borderRadius: '8px', cursor: 'pointer', fontWeight: 800, fontSize: '13px', border: 'none', transition: 'all 0.2s' }}>
                  T{t}
                </button>
              ))}
            </div>
          )}
          <div style={{ display: 'flex', gap: '4px', background: 'var(--bg-card)', padding: '4px', borderRadius: '12px', border: '1px solid var(--border)' }}>
            {[0,1,2,3,4].map(lvl => (
              <button key={lvl} type="button" onClick={() => onEnchantLevel(lvl)}
                style={{ background: enchantLevel === lvl ? 'var(--gold)' : 'transparent', color: enchantLevel === lvl ? '#000' : 'var(--text-muted)', padding: '6px 14px', borderRadius: '8px', cursor: 'pointer', fontWeight: 800, fontSize: '13px', border: 'none', transition: 'all 0.2s' }}>
                .{lvl}
              </button>
            ))}
          </div>
          <button className="link-btn" onClick={onClose} aria-label="Fechar" style={{ fontSize: '24px', marginLeft: '4px' }}>&times;</button>
        </div>
      </div>

      {/* Config Bar */}
      <div style={{ background: 'var(--bg-secondary)', borderRadius: '12px', border: '1px solid var(--border)', padding: '16px 20px', display: 'flex', flexWrap: 'wrap', gap: '20px', alignItems: 'center', marginBottom: '16px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
          <span style={{ fontSize: '10px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px' }}>Cidade de Venda</span>
          <select value={sellCity} onChange={e => setSellCity(e.target.value)}
            style={{ background: 'var(--bg-card)', color: 'var(--text-primary)', border: '1px solid var(--border)', borderRadius: '8px', padding: '6px 10px', fontWeight: 600, fontSize: '13px', cursor: 'pointer' }}>
            {CRAFTING_CITIES.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
          <span style={{ fontSize: '10px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px' }}>Qualidade do Alvo</span>
          <select value={quality} onChange={e => onQuality(Number(e.target.value))}
            style={{ background: 'var(--bg-card)', color: 'var(--text-primary)', border: '1px solid var(--border)', borderRadius: '8px', padding: '6px 10px', fontWeight: 600, fontSize: '13px', cursor: 'pointer' }}>
            {QUALITIES.map(q => <option key={q} value={q}>{QUALITY_LABELS_PT[q]} ({q})</option>)}
          </select>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
          <span style={{ fontSize: '10px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px' }}>Taxa Barraca (%)</span>
          <input type="number" min={0} max={1000} step={10}
            style={{ width: '80px', background: 'var(--bg-card)', color: 'var(--text-primary)', border: '1px solid var(--border)', borderRadius: '8px', padding: '6px 10px', fontSize: '13px', fontWeight: 600 }}
            value={stationFee} onChange={e => setStationFee(Number(e.target.value))} />
        </div>
        <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
          <label style={{ display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer', fontSize: '13px', color: 'var(--text-primary)' }}>
            <input type="checkbox" checked={cityBonus} onChange={e => setCityBonus(e.target.checked)} />
            Bônus Cidade
          </label>
          <label style={{ display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer', fontSize: '13px', color: 'var(--gold)' }}>
            <input type="checkbox" checked={useFocus} onChange={e => setUseFocus(e.target.checked)} />
            Usar Foco
          </label>
          <label style={{ display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer', fontSize: '13px', color: 'var(--text-primary)' }}>
            <input type="checkbox" checked={useBestCity} onChange={e => setUseBestCity(e.target.checked)} />
            Melhor cidade p/ ingredientes
          </label>
        </div>
        <div style={{ marginLeft: 'auto', display: 'flex', gap: '4px', background: 'var(--bg-card)', padding: '4px', borderRadius: '10px', border: '1px solid var(--border)' }}>
          {(['calculator','cities'] as const).map(v => (
            <button key={v} type="button" onClick={() => setActiveView(v)}
              style={{ padding: '6px 16px', borderRadius: '7px', border: 'none', cursor: 'pointer', fontWeight: 600, fontSize: '12px', textTransform: 'uppercase', letterSpacing: '1px', transition: 'all 0.2s',
                background: activeView === v ? 'var(--gold)' : 'transparent', color: activeView === v ? '#000' : 'var(--text-muted)' }}>
              {v === 'calculator' ? '⚗️ Calculadora' : '🌍 Por Cidade'}
            </button>
          ))}
        </div>
      </div>

      {/* RRR Badge */}
      <div style={{ display: 'flex', gap: '12px', marginBottom: '16px', flexWrap: 'wrap' }}>
        {[
          { label: 'RRR Aplicado', value: `${((calc?.rrr ?? 0) * 100).toFixed(1)}%`, color: 'var(--gold)' },
          { label: 'Custo Bruto', value: calc ? formatPrice(calc.totalRawCost) : '—', color: 'var(--text-primary)' },
          { label: 'Custo Líquido', value: calc ? formatPrice(calc.netCost) : '—', color: 'var(--text-primary)' },
          { label: `Venda (Taxada 6.5%)`, value: calc?.sellRevenue ? formatPrice(calc.sellRevenue) : 'Sem dados', color: 'var(--text-primary)' },
          { label: 'Lucro Final', value: calc?.targetPrice ? formatPrice(calc.profit) : '—', color: calc && calc.profit > 0 ? '#4caf7d' : '#c94c4c' },
          { label: 'ROI (Margem)', value: calc?.targetPrice ? `${calc.margin.toFixed(1)}%` : '—', color: calc && calc.margin > 0 ? '#4caf7d' : '#c94c4c' },
        ].map(stat => (
          <div key={stat.label} style={{ background: 'var(--bg-card)', border: '1px solid var(--border)', borderRadius: '10px', padding: '12px 18px', flex: '1', minWidth: '110px' }}>
            <div style={{ fontSize: '10px', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '1px', marginBottom: '4px', whiteSpace: 'nowrap' }}>{stat.label}</div>
            <div style={{ fontSize: '18px', fontWeight: 800, color: stat.color, fontFamily: 'Share Tech Mono, monospace' }}>{stat.value}</div>
          </div>
        ))}
      </div>

      {loading ? (
        <div style={{ textAlign: 'center', padding: '60px', color: 'var(--text-muted)' }}>
          <div style={{ fontSize: '32px', marginBottom: '12px' }}>⚗️</div>
          <div>Buscando preços em todas as cidades...</div>
        </div>
      ) : activeView === 'calculator' ? (
        <div className="price-section fade-in" style={{ padding: '20px' }}>
          <h3 style={{ margin: '0 0 16px 0', fontSize: '15px', textTransform: 'uppercase', letterSpacing: '2px', color: 'var(--gold-dim)' }}>
            📦 Ingredientes {useBestCity ? '(Rota Otimizada)' : `(${sellCity})`}
          </h3>
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

          <div style={{ marginTop: '24px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
            <div style={{ background: 'var(--bg-secondary)', padding: '20px', borderRadius: '12px', border: '1px solid var(--border)' }}>
              <div style={{ fontSize: '11px', color: 'var(--text-muted)', letterSpacing: '2px', textTransform: 'uppercase', marginBottom: '12px' }}>Demonstrativo de Custos</div>
              {[
                { label: 'Custo Bruto dos Ingredientes', value: formatPrice(calc?.totalRawCost ?? 0), color: 'var(--text-primary)' },
                { label: `(-) Desconto de Retorno (${((calc?.rrr ?? 0) * 100).toFixed(1)}%)`, value: `- ${formatPrice(calc?.returnDiscount ?? 0)}`, color: '#4caf7d' },
                { label: `(+) Taxa de Produção (Estimada)*`, value: `+ ${formatPrice(calc?.feeCost ?? 0)}`, color: '#c94c4c' },
              ].map(row => (
                <div key={row.label} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '13px' }}>
                  <span style={{ color: row.color }}>{row.label}</span>
                  <span style={{ fontFamily: 'Share Tech Mono, monospace', color: row.color }}>{row.value}</span>
                </div>
              ))}
              <div style={{ display: 'flex', justifyContent: 'space-between', borderTop: '1px solid var(--border)', paddingTop: '10px', marginTop: '10px', fontWeight: 800, fontSize: '15px' }}>
                <span>Custo Líquido de Produção</span>
                <span style={{ fontFamily: 'Share Tech Mono, monospace', color: 'var(--gold)' }}>{formatPrice(calc?.netCost ?? 0)}</span>
              </div>
              <div style={{ marginTop: '12px', fontSize: '10px', color: 'var(--text-muted)', fontStyle: 'italic', lineHeight: '1.4' }}>
                * A Taxa de Produção mostrada aqui é uma estimativa baseada no custo dos ingredientes. No Albion, a taxa real da barraca usa o "Item Value" estático e o custo de nutrição.
              </div>
            </div>
            <div style={{ background: 'var(--bg-secondary)', padding: '20px', borderRadius: '12px', border: `1px solid ${(calc?.profit ?? 0) > 0 ? '#4caf7d55' : '#c94c4c55'}`, position: 'relative', overflow: 'hidden' }}>
              <div style={{ position: 'absolute', top: 0, right: 0, bottom: 0, width: '4px', background: (calc?.profit ?? 0) > 0 ? '#4caf7d' : '#c94c4c' }} />
              <div style={{ fontSize: '11px', color: 'var(--text-muted)', letterSpacing: '2px', textTransform: 'uppercase', marginBottom: '12px' }}>Estimativa de Venda em {sellCity}</div>
              {[
                { label: `Preço de Venda (Qualidade ${quality})`, value: calc?.targetPrice ? formatPrice(calc.targetPrice) : 'Sem dados', color: 'var(--text-primary)' },
                { label: '(-) Taxa Mercado 6.5%', value: calc?.targetPrice ? `- ${formatPrice(calc.targetPrice * 0.065)}` : '—', color: '#c94c4c' },
              ].map(row => (
                <div key={row.label} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '13px' }}>
                  <span style={{ color: 'var(--text-muted)' }}>{row.label}</span>
                  <span style={{ fontFamily: 'Share Tech Mono, monospace', color: row.color }}>{row.value}</span>
                </div>
              ))}
              <div style={{ display: 'flex', justifyContent: 'space-between', borderTop: '1px solid var(--border)', paddingTop: '10px', marginTop: '10px', fontWeight: 800, fontSize: '20px' }}>
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
        <div className="price-section fade-in" style={{ padding: '20px' }}>
          <h3 style={{ margin: '0 0 16px 0', fontSize: '13px', textTransform: 'uppercase', letterSpacing: '2px', color: 'var(--gold-dim)' }}>
            🌍 Comparativo de Lucro por Cidade (Qualidade {quality})
          </h3>
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
                  <tr key={city} style={{ borderBottom: '1px solid rgba(255,255,255,0.04)', background: isBest ? 'rgba(76,175,125,0.06)' : idx % 2 === 0 ? 'rgba(255,255,255,0.01)' : 'transparent', transition: 'background 0.2s' }}>
                    <td style={{ padding: '12px 8px' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <div style={{ width: '8px', height: '8px', borderRadius: '50%', background: color, flexShrink: 0 }} />
                        <span style={{ fontWeight: 600, color: isBest ? '#4caf7d' : 'var(--text-primary)' }}>{city}</span>
                        {isBest && <span style={{ background: '#4caf7d22', color: '#4caf7d', padding: '1px 6px', borderRadius: '4px', fontSize: '10px', fontWeight: 700, border: '1px solid #4caf7d44' }}>MAIOR LUCRO</span>}
                      </div>
                    </td>
                    <td style={{ padding: '12px 8px', fontFamily: 'Share Tech Mono, monospace' }}>{netCost ? formatPrice(netCost) : '—'}</td>
                    <td style={{ padding: '12px 8px', fontFamily: 'Share Tech Mono, monospace' }}>{targetPrice ? formatPrice(targetPrice) : <span style={{ color: 'var(--text-muted)' }}>Sem dados</span>}</td>
                    <td style={{ padding: '12px 8px', fontFamily: 'Share Tech Mono, monospace', fontWeight: 700, color: (profit ?? 0) > 0 ? '#4caf7d' : '#c94c4c' }}>
                      {targetPrice ? formatPrice(profit ?? 0) : '—'}
                    </td>
                    <td style={{ padding: '12px 8px', color: (margin ?? 0) > 0 ? '#4caf7d' : '#c94c4c', fontWeight: 600 }}>
                      {targetPrice ? `${(margin ?? 0).toFixed(1)}%` : '—'}
                    </td>
                    <td style={{ padding: '12px 8px', textAlign: 'center' }}>
                      <button type="button" onClick={() => { setSellCity(city); setActiveView('calculator'); }}
                        style={{ background: 'var(--bg-card)', border: '1px solid var(--border)', borderRadius: '6px', color: 'var(--text-muted)', padding: '4px 10px', fontSize: '11px', cursor: 'pointer', transition: 'all 0.2s', fontWeight: 600 }}>
                        Detalhes
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
