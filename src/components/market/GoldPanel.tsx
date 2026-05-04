import { useEffect, useState } from 'react';
import { Line } from 'react-chartjs-2';
import { fetchGoldHistory } from '../../lib/marketApi';
import { formatPrice } from '../../lib/formatPrice';
import type { GoldTick, RegionKey } from '../../types';

type Props = {
  region: RegionKey;
};

export function GoldPanel({ region }: Props) {
  const [count, setCount] = useState(24);
  const [series, setSeries] = useState<GoldTick[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const ac = new AbortController();
    setLoading(true);
    fetchGoldHistory(region, count, ac.signal)
      .then((d) => setSeries([...d].reverse()))
      .catch(() => setSeries([]))
      .finally(() => setLoading(false));
    return () => ac.abort();
  }, [region, count]);

  const data = {
    datasets: [
      {
        label: 'Gold',
        data: series.map((p) => ({ x: new Date(p.timestamp).getTime(), y: p.price })),
        borderColor: '#c9a84c',
        backgroundColor: 'rgba(201,168,76,0.08)',
        borderWidth: 2,
        pointRadius: 1,
        tension: 0.35,
        fill: true,
      },
    ],
  };

  return (
    <div className="gold-section fade-in">
      <div className="section-header">
        <div className="section-title">🥇 Preço do gold</div>
        <div className="section-actions">
          <button
            type="button"
            className={`btn-small ${count === 24 ? 'active' : ''}`}
            onClick={() => setCount(24)}
          >
            24 pts
          </button>
          <button
            type="button"
            className={`btn-small ${count === 168 ? 'active' : ''}`}
            onClick={() => setCount(168)}
          >
            7d
          </button>
        </div>
      </div>
      <div className="gold-chart-container">
        {loading && <div className="loading-state">Carregando…</div>}
        {!loading && series.length === 0 && <div className="no-data">Sem dados de gold.</div>}
        {!loading && series.length > 0 && (
          <Line
            data={data}
            options={{
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: { display: false },
                tooltip: {
                  backgroundColor: '#13151f',
                  borderColor: '#2a2d3d',
                  borderWidth: 1,
                  callbacks: {
                    label: (ctx) =>
                      ` ${formatPrice(typeof ctx.parsed.y === 'number' ? ctx.parsed.y : 0)}`,
                  },
                },
              },
              scales: {
                x: {
                  type: 'time',
                  grid: { color: '#1a1d2b' },
                  ticks: { color: '#5a5870', font: { family: 'Exo 2', size: 10 } },
                },
                y: {
                  grid: { color: '#1a1d2b' },
                  ticks: {
                    color: '#c9a84c',
                    font: { family: 'Share Tech Mono', size: 10 },
                  },
                },
              },
            }}
          />
        )}
      </div>
    </div>
  );
}
