import { useMemo, useState } from 'react';
import { MARKET_CITIES } from '../../config';
import { formatPrice } from '../../lib/formatPrice';
import type { MarketPriceRow } from '../../types';

type Props = {
  byCity: Map<string, MarketPriceRow>;
};

export function FlipPanel({ byCity }: Props) {
  const [buyCity, setBuyCity] = useState('');
  const [sellCity, setSellCity] = useState('');

  const buyPrice = buyCity ? (byCity.get(buyCity)?.sell_price_min ?? 0) : 0;
  const sellPrice = sellCity ? (byCity.get(sellCity)?.sell_price_min ?? 0) : 0;

  const calc = useMemo(() => {
    if (!buyCity || !sellCity || buyPrice <= 0 || sellPrice <= 0) return null;
    const gross = sellPrice - buyPrice;
    const net = sellPrice * 0.935 - buyPrice; // 6.5% tax with premium
    const margin = (net / buyPrice) * 100;
    return { gross, net, margin };
  }, [buyCity, sellCity, buyPrice, sellPrice]);

  return (
    <div className="flip-section fade-in">
      <div className="section-header">
        <div className="section-title">⚖️ Calculadora de Transporte (Arbitragem)</div>
      </div>
      <div className="flip-grid">
        <div className="flip-col">
          <span className="flip-label">Comprar em (Compra direta)</span>
          <select
            className="flip-select"
            value={buyCity}
            onChange={(e) => setBuyCity(e.target.value)}
            aria-label="Cidade de compra"
          >
            <option value="">Cidade…</option>
            {MARKET_CITIES.map((c) => (
              <option key={c} value={c}>
                {c}
              </option>
            ))}
          </select>
          <span className="flip-label">Custo (Menor Venda)</span>
          <div className="flip-mono positive">
            {buyCity && buyPrice === 0 ? 'Sem dados' : buyPrice > 0 ? formatPrice(buyPrice) : '—'}
          </div>
        </div>
        <div className="flip-col">
          <span className="flip-label">Transportar e Vender em (Ordem de venda)</span>
          <select
            className="flip-select"
            value={sellCity}
            onChange={(e) => setSellCity(e.target.value)}
            aria-label="Cidade de venda"
          >
            <option value="">Cidade…</option>
            {MARKET_CITIES.map((c) => (
              <option key={c} value={c}>
                {c}
              </option>
            ))}
          </select>
          <span className="flip-label">Receita (Menor Venda)</span>
          <div className="flip-mono negative">
            {sellCity && sellPrice === 0 ? 'Sem dados' : sellPrice > 0 ? formatPrice(sellPrice) : '—'}
          </div>
        </div>
      </div>
      <div className="flip-result">
        <div className="flip-stat">
          <div className="flip-stat-label">Lucro bruto</div>
          <div className={`flip-stat-value ${calc && calc.gross > 0 ? 'positive' : calc ? 'negative' : 'neutral'}`}>
            {calc ? formatPrice(Math.round(calc.gross)) : '—'}
          </div>
        </div>
        <div className="flip-stat">
          <div className="flip-stat-label">Após taxa Premium (~6.5%)</div>
          <div className={`flip-stat-value ${calc && calc.net > 0 ? 'positive' : calc ? 'negative' : 'neutral'}`}>
            {calc ? formatPrice(Math.round(calc.net)) : '—'}
          </div>
        </div>
        <div className="flip-stat">
          <div className="flip-stat-label">Margem</div>
          <div
            className={`flip-stat-value ${calc && calc.margin > 0 ? 'positive' : calc ? 'negative' : 'neutral'}`}
          >
            {calc ? `${calc.margin.toFixed(1)}%` : '—'}
          </div>
        </div>
      </div>
    </div>
  );
}
