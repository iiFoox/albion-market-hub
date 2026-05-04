export function formatPrice(n: number): string {
  if (n == null || n === 0) return '0';
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(2)}M`;
  if (n >= 1_000) return `${(n / 1_000).toFixed(1)}K`;
  return n.toLocaleString('pt-BR');
}

export function formatRelativeTime(dateStr: string | undefined): string {
  if (!dateStr) return '—';
  const d = new Date(dateStr);
  if (Number.isNaN(d.getTime())) return '—';
  const diffMin = (Date.now() - d.getTime()) / 60000;
  if (diffMin < 1) return 'agora';
  if (diffMin < 60) return `${Math.round(diffMin)}min`;
  if (diffMin < 1440) return `${Math.round(diffMin / 60)}h`;
  return `${Math.round(diffMin / 1440)}d`;
}

export function freshnessClass(dateStr: string | undefined): string {
  if (!dateStr) return '';
  const d = new Date(dateStr);
  if (Number.isNaN(d.getTime())) return '';
  const diffMin = (Date.now() - d.getTime()) / 60000;
  if (diffMin < 60) return 'updated-fresh';
  if (diffMin < 720) return 'updated-medium';
  return 'updated-old';
}
