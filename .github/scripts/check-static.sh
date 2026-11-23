#!/usr/bin/env bash
# Failt, wenn die Seite Drittanbieter laden, Cookies setzen oder Browser-Speicher nutzen könnte.
# Aufruf: bash .github/scripts/check-static.sh public
set -euo pipefail
dir="${1:-public}"
fail=0

# Binäre Einbettungen (base64) ausblenden, damit nur Code geprüft wird.
strip() { sed -E 's/base64,[A-Za-z0-9+\/=]{200,}/base64,<data>/g' "$1"; }

check() { # <Beschreibung> <Regex>
  local hits=""
  while IFS= read -r -d '' f; do
    if strip "$f" | grep -nEi -- "$2" >/tmp/hit.txt 2>/dev/null; then
      hits+=$'\n'"  $f:"$'\n'"$(cut -c1-160 /tmp/hit.txt | head -5)"
    fi
  done < <(find "$dir" -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' \) -print0)
  if [ -n "$hits" ]; then echo "FEHLER: $1$hits"; fail=1; fi
}

check "Externes Skript oder Stylesheet"      '<script[^>]+src=|<link[^>]+rel=.?stylesheet|@import'
check "Externe Ressource (src/srcset/url)"   '(src|srcset|poster)=["'\'']?(https?:)?//|url\((["'\'']?)(https?:)?//'
check "Iframe, Embed oder Objekt"            '<(iframe|embed|object)\b'
check "Netzwerkzugriff im Skript"            '\b(fetch\(|XMLHttpRequest|sendBeacon|WebSocket|EventSource)'
check "Cookies oder Browser-Speicher"        '\b(document\.cookie|localStorage|sessionStorage|indexedDB)\b'
check "Bekannte Tracker/Font-CDNs"           'googletagmanager|google-analytics|gtag\(|fonts\.(googleapis|gstatic)|cdnjs|jsdelivr|unpkg|plausible|matomo|hotjar'

if [ "$fail" -ne 0 ]; then exit 1; fi
echo "OK: keine Drittanbieter, keine Cookies, kein Browser-Speicher gefunden in $dir"
