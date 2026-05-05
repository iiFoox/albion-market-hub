import type { ApiReloaderState } from '../../lib/useApiReloader';

const INTERVAL_OPTIONS = [
  { label: '30s', value: 30 },
  { label: '1min', value: 60 },
  { label: '5min', value: 300 },
];

const STATUS_DOT: Record<string, { color: string; label: string; pulse: boolean }> = {
  idle:    { color: '#888', label: 'Aguardando',  pulse: false },
  loading: { color: '#f5a623', label: 'Atualizando…', pulse: true },
  ok:      { color: '#4ade80', label: 'Online',    pulse: false },
  error:   { color: '#f87171', label: 'Erro na API', pulse: true },
};

function formatRelative(date: Date): string {
  const sec = Math.floor((Date.now() - date.getTime()) / 1000);
  if (sec < 5)  return 'agora mesmo';
  if (sec < 60) return `há ${sec}s`;
  const min = Math.floor(sec / 60);
  return `há ${min}min`;
}

interface Props {
  reloader: ApiReloaderState;
}

export function ApiStatusBadge({ reloader }: Props) {
  const { status, lastUpdated, countdown, intervalSec, setIntervalSec, manualRefresh } = reloader;
  const dot = STATUS_DOT[status];
  const pct = Math.round(((intervalSec - countdown) / intervalSec) * 100);

  return (
    <div className="api-status-badge" title="Status da API de mercado">
      {/* Status dot */}
      <span
        className={`api-dot ${dot.pulse ? 'api-dot--pulse' : ''}`}
        style={{ background: dot.color }}
        aria-label={dot.label}
      />

      {/* Info column */}
      <div className="api-info">
        <span className="api-info__label">{dot.label}</span>
        {lastUpdated && (
          <span className="api-info__sub">{formatRelative(lastUpdated)}</span>
        )}
      </div>

      {/* Progress ring */}
      <svg className="api-ring" viewBox="0 0 28 28" aria-hidden>
        <circle cx="14" cy="14" r="11" fill="none" stroke="rgba(255,255,255,0.08)" strokeWidth="2.5" />
        <circle
          cx="14"
          cy="14"
          r="11"
          fill="none"
          stroke={dot.color}
          strokeWidth="2.5"
          strokeLinecap="round"
          strokeDasharray={`${2 * Math.PI * 11}`}
          strokeDashoffset={`${2 * Math.PI * 11 * (1 - pct / 100)}`}
          transform="rotate(-90 14 14)"
          style={{ transition: 'stroke-dashoffset 1s linear' }}
        />
        <text x="14" y="18" textAnchor="middle" fontSize="7" fill={dot.color} fontWeight="700">
          {countdown}s
        </text>
      </svg>

      {/* Interval selector */}
      <div className="api-interval">
        {INTERVAL_OPTIONS.map((opt) => (
          <button
            key={opt.value}
            type="button"
            className={`api-interval__btn ${intervalSec === opt.value ? 'active' : ''}`}
            onClick={() => setIntervalSec(opt.value)}
            title={`Atualizar a cada ${opt.label}`}
          >
            {opt.label}
          </button>
        ))}
      </div>

      {/* Manual refresh */}
      <button
        type="button"
        className={`api-refresh-btn ${status === 'loading' ? 'spinning' : ''}`}
        onClick={manualRefresh}
        disabled={status === 'loading'}
        aria-label="Forçar atualização agora"
        title="Atualizar agora"
      >
        ↺
      </button>
    </div>
  );
}
