import { del, get, set } from 'idb-keyval';
import type { AlbionItemMini } from '../types';
import { ITEMS_JSON_URL } from '../config';
import { categorizeItem } from './itemCategory';
import { inferSidebarGroup, inferTier } from './sidebarGroup';

const CACHE_KEY = 'albion-vip-catalog-v3';

type RawItem = {
  UniqueName?: string;
  LocalizedNames?: Record<string, string>;
};

function pickName(item: RawItem): string {
  const names = item.LocalizedNames;
  if (!names) return item.UniqueName ?? '?';
  return (
    names['PT-BR'] ||
    names['EN-US'] ||
    names['DE-DE'] ||
    Object.values(names)[0] ||
    item.UniqueName ||
    '?'
  );
}

export async function loadCachedCatalog(): Promise<AlbionItemMini[] | null> {
  try {
    const cached = await get<AlbionItemMini[]>(CACHE_KEY);
    if (Array.isArray(cached) && cached.length > 500) return cached;
  } catch {
    /* ignore */
  }
  return null;
}

export async function fetchAndBuildCatalog(
  onDownloadProgress: (pct: number) => void,
  onProcessProgress: (pct: number) => void,
  signal?: AbortSignal,
): Promise<AlbionItemMini[]> {
  const res = await fetch(ITEMS_JSON_URL, { signal });
  if (!res.ok) throw new Error(`Falha ao baixar catálogo (${res.status})`);

  const total = Number(res.headers.get('Content-Length')) || 24_000_000;
  const reader = res.body?.getReader();
  if (!reader) {
    const text = await res.text();
    return processRawJson(JSON.parse(text) as RawItem[], onProcessProgress);
  }

  const chunks: Uint8Array[] = [];
  let received = 0;
  for (;;) {
    if (signal?.aborted) throw new DOMException('Aborted', 'AbortError');
    const { done, value } = await reader.read();
    if (done) break;
    chunks.push(value);
    received += value.length;
    onDownloadProgress(Math.min(99, Math.round((received / total) * 100)));
  }

  const blob = new Blob(chunks as BlobPart[], { type: 'application/json' });
  const text = await blob.text();
  onDownloadProgress(100);

  const raw = JSON.parse(text) as RawItem[];
  const slim = await processRawJson(raw, onProcessProgress);

  try {
    await set(CACHE_KEY, slim);
  } catch {
    /* quota — ignora cache */
  }

  return slim;
}

async function processRawJson(
  raw: RawItem[],
  onProcessProgress: (pct: number) => void,
): Promise<AlbionItemMini[]> {
  const out: AlbionItemMini[] = [];
  const batch = 2500;
  const n = raw.length;

  for (let i = 0; i < n; i += batch) {
    const end = Math.min(i + batch, n);
    for (let j = i; j < end; j++) {
      const item = raw[j];
      const id = item.UniqueName;
      if (!id) continue;
      const category = categorizeItem(id);
      out.push({
        id,
        name: pickName(item),
        category,
        sidebarGroup: inferSidebarGroup(id, category),
        tier: inferTier(id),
      });
    }
    onProcessProgress(Math.round((end / n) * 100));
    await new Promise<void>((resolve) => {
      requestAnimationFrame(() => resolve());
    });
  }

  return out;
}

/** Limpa cache local (útil após grandes atualizações do jogo). */
export async function clearCatalogCache(): Promise<void> {
  try {
    await del(CACHE_KEY);
  } catch {
    /* ignore */
  }
}
