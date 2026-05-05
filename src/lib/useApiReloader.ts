import { useCallback, useEffect, useRef, useState } from 'react';

export type ApiStatus = 'idle' | 'loading' | 'ok' | 'error';

export interface UseApiReloaderOptions {
  /** Auto-refresh interval in seconds. Default: 30 */
  intervalSec?: number;
  /** Called every time a refresh is due (auto or manual). */
  onRefresh: () => Promise<void>;
}

export interface ApiReloaderState {
  status: ApiStatus;
  lastUpdated: Date | null;
  /** Seconds remaining until next auto-refresh */
  countdown: number;
  intervalSec: number;
  setIntervalSec: (s: number) => void;
  /** Trigger an immediate manual refresh */
  manualRefresh: () => void;
}

export function useApiReloader({
  intervalSec: initialInterval = 30,
  onRefresh,
}: UseApiReloaderOptions): ApiReloaderState {
  const [status, setStatus] = useState<ApiStatus>('idle');
  const [lastUpdated, setLastUpdated] = useState<Date | null>(null);
  const [intervalSec, setIntervalSec] = useState(initialInterval);
  const [countdown, setCountdown] = useState(initialInterval);

  const onRefreshRef = useRef(onRefresh);
  onRefreshRef.current = onRefresh;

  const runRefresh = useCallback(async () => {
    setStatus('loading');
    try {
      await onRefreshRef.current();
      setStatus('ok');
      setLastUpdated(new Date());
    } catch {
      setStatus('error');
    }
  }, []);

  // Auto-refresh interval
  useEffect(() => {
    setCountdown(intervalSec);

    const tick = window.setInterval(() => {
      setCountdown((prev) => {
        if (prev <= 1) {
          runRefresh();
          return intervalSec;
        }
        return prev - 1;
      });
    }, 1_000);

    return () => window.clearInterval(tick);
  }, [intervalSec, runRefresh]);

  // Run once on mount
  useEffect(() => {
    runRefresh();
  }, [runRefresh]);

  const manualRefresh = useCallback(() => {
    setCountdown(intervalSec);
    runRefresh();
  }, [intervalSec, runRefresh]);

  return { status, lastUpdated, countdown, intervalSec, setIntervalSec, manualRefresh };
}
