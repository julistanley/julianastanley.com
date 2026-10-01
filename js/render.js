// Markdown -> sanitized HTML, plus small formatting helpers.
// Both libraries load from a CDN as ES modules and are pinned to a version.
import { marked } from 'https://cdn.jsdelivr.net/npm/marked@12.0.2/+esm';
import DOMPurify from 'https://cdn.jsdelivr.net/npm/dompurify@3.1.6/+esm';

// GitHub-style ids on headings so in-page anchors (tables of contents) work.
function slugify(text) {
  return text.toLowerCase().trim()
    .replace(/<[^>]+>/g, '')
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-');
}

const renderer = {
  heading(text, level, raw) {
    return `<h${level} id="${slugify(raw)}">${text}</h${level}>\n`;
  },
};

marked.use({ gfm: true, renderer });

// Markdown bodies may carry inline HTML (the about-page photo, embeds).
// The sanitizer strips iframes by default; allow them, but only https ones
// (e.g. an embedded published calendar).
DOMPurify.addHook('uponSanitizeElement', (node, data) => {
  if (data.tagName === 'iframe'
      && !(node.getAttribute?.('src') ?? '').startsWith('https://')) {
    node.remove();
  }
});

export function renderMarkdown(md) {
  return DOMPurify.sanitize(marked.parse(md ?? ''), {
    ADD_TAGS: ['iframe'],
    ADD_ATTR: ['frameborder', 'allowfullscreen', 'scrolling', 'loading'],
  });
}

/** '2022-08-01' -> 'Aug 1, 2022' (date-only, so pin to UTC to avoid drift). */
export function fmtDate(iso) {
  if (!iso) return '';
  const d = new Date(iso.length <= 10 ? iso + 'T00:00:00Z' : iso);
  return d.toLocaleDateString('en-US',
    { year: 'numeric', month: 'short', day: 'numeric', timeZone: 'UTC' });
}

export function escapeHtml(s) {
  return String(s ?? '').replace(/[&<>"']/g,
    c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}
