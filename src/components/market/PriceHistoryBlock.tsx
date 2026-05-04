import { useEffect, useMemo, useState } from 'react';
import { Line } from 'react-chartjs-2';
import { CITY_COLORS, MARKET_CITIES } from '../../config';
import { fetchChartsHistory } from '../../lib/marketApi';
import type { ChartLocationRow, RegionKey } from '../../types';

type Props = {
  region: RegionKey;
  itemId: string;
  quality: number;
};

type Scale = 1 | 6 | 24;

export function PriceHistoryBlock({ region, itemId, quality }: Props) {
  const [scale, setScale] = useState<Scale>(24);
  const [rows, setRows] = useState<ChartLocationRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [activeCities, setActiveCities] = useState<Set<string>>(
    () => new Set(['Caerleon', 'Bridgewatch', 'Lymhurst']),
  );

  useEffect(() => {
    const ac = new AbortController();
    setLoading(true);
    fetchChartsHistory(region, itemId, ac.signal, { timeScale: scale })
      .then(setRows)
      .catch(() => setRows([]))
      .finally(() => setLoading(false));
    return () => ac.abort();
  }, [region, itemId, scale]);

  const chartData = useMemo(() => {
    const filtered = rows.filter((r) => r.quality === quality && activeCities.has(r.location));
    const datasets = filtered
      .map((r) => {
        const color = CITY_COLORS[r.location] ?? '#888';
        const ts = r.data?.timestamps ?? [];
        const pr = r.data?.prices_avg ?? [];
        const points = ts
          .map((t, i) => ({
            x: new Date(t).getTime(),
            y: pr[i] ?? 0,
          }))
          .filter((p) => p.y > 0);

        return {
          label: r.location,
          data: points,
          borderColor: color,
          backgroundColor: `${color}18`,
          borderWidth: 2,
          pointRadius: 2,
          tension: 0.35,
          fill: false,
        };
      })
      .filter((d) => d.data.length > 0);

    return { datasets };
  }, [rows, quality, activeCities]);

  const toggleCity = (city: string) => {
    setActiveCities((prev) => {
      const n = new Set(prev);
      if (n.has(city)) {
        if (n.size <= 1) return prev;
        n.delete(city);
      } else {
        n.add(city);
      }
      return n;
    });
  };

  return (
    <div className="chart-section fade-in">
      <div className="section-header">
        <div className="section-title">📈 Histórico de preços (média)</div>
        <div className="section-actions section-actions--wrap">
          <button
            type="button"
            className={`btn-small ${scale === 1 ? 'active' : ''}`}
            onClick={() => setScale(1)}
          >
            Horário
          </button>
          <button
            type="button"
            className={`btn-small ${scale === 6 ? 'active' : ''}`}
            onClick={() => setScale(6)}
          >
            6h
          </button>
          <button
            type="button"
            className={`btn-small ${scale === 24 ? 'active' : ''}`}
            onClick={() => setScale(24)}
          >
            Diário
          </button>
          <div className="chart-city-filters">
            {MARKET_CITIES.map((city) => (
              <button
                key={city}
                type="button"
                className={`btn-small ${activeCities.has(city) ? 'active' : ''}`}
                style={{
                  borderColor: activeCities.has(city) ? CITY_COLORS[city] : undefined,
                  color: activeCities.has(city) ? CITY_COLORS[city] : undefined,
                }}
                onClick={() => toggleCity(city)}
              >
                {city}
              </button>
            ))}
          </div>
        </div>
      </div>
      <div className="chart-container">
        {loading && <div className="loading-state">Carregando histórico…</div>}
        {!loading && chartData.datasets.length === 0 && (
          <div className="no-data">Sem histórico para esta qualidade / cidades.</div>
        )}
        {!loading && chartData.datasets.length > 0 && (
          <Line
            data={chartData}
            options={{
              responsive: true,
              maintainAspectRatio: false,
              interaction: { mode: 'index', intersect: false },
              plugins: {
                legend: {
                  labels: {
                    color: '#949082',
                    font: { family: 'Exo 2', size: 11 },
                    boxWidth: 12,
                  },
                },
                tooltip: {
                  backgroundColor: '#13151f',
                  borderColor: '#2a2d3d',
                  borderWidth: 1,
                },
              },
              scales: {
                x: {
                  type: 'time',
                  time: { unit: scale >= 24 ? 'day' : 'hour' },
                  grid: { color: '#1a1d2b' },
                  ticks: { color: '#5a5870', font: { family: 'Exo 2', size: 10 } },
                },
                y: {
                  grid: { color: '#1a1d2b' },
                  ticks: {
                    color: '#5a5870',
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
