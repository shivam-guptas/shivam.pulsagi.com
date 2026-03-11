$path = 'generate-agentforce-blog.ps1'
$raw = Get-Content -Raw $path

$startArch = $raw.IndexOf('function New-ArchitectureSvg {')
$startNext = $raw.IndexOf('function Get-ArchitectureDetail {')

if ($startArch -lt 0 -or $startNext -lt 0) {
  throw 'Could not locate diagram function boundaries.'
}

$replacement = @'
function New-ArchitectureSvg {
  param([hashtable]$spec)
  $cards = $spec.cards
  $theme = Get-DiagramTheme -Focus $spec.focus
  return @"
<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="860" viewBox="0 0 1400 860" role="img" aria-labelledby="title desc">
  <title>$($spec.title)</title>
  <desc>$($spec.subtitle)</desc>
  <defs>
    <linearGradient id="bg" x1="0%" x2="100%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="$($theme.start)"/>
      <stop offset="100%" stop-color="$($theme.finish)"/>
    </linearGradient>
    <linearGradient id="panel" x1="0%" x2="100%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="#ffffff" stop-opacity="0.98"/>
      <stop offset="100%" stop-color="$($theme.panel)" stop-opacity="0.98"/>
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="18" stdDeviation="18" flood-color="#0f172a" flood-opacity="0.18"/>
    </filter>
    <marker id="arrow" markerWidth="12" markerHeight="12" refX="9" refY="6" orient="auto">
      <path d="M0,0 L12,6 L0,12 z" fill="$($theme.edge)"/>
    </marker>
  </defs>
  <rect width="1400" height="860" rx="34" fill="#f8fafc"/>
  <rect x="26" y="26" width="1348" height="808" rx="30" fill="url(#bg)"/>
  <rect x="54" y="152" width="1290" height="616" rx="34" fill="rgba(255,255,255,0.06)" stroke="rgba(255,255,255,0.16)"/>
  <text x="78" y="92" font-family="'Merriweather', serif" font-size="42" fill="#ffffff" font-weight="700">$($spec.title)</text>
  <text x="78" y="132" font-family="'Source Sans 3', sans-serif" font-size="24" fill="$($theme.edge)">$($spec.subtitle)</text>
  <path d="M420 260 H560" stroke="$($theme.edge)" stroke-width="10" stroke-linecap="round" marker-end="url(#arrow)"/>
  <path d="M840 260 H980" stroke="$($theme.edge)" stroke-width="10" stroke-linecap="round" marker-end="url(#arrow)"/>
  <path d="M700 338 V472" stroke="$($theme.edge)" stroke-width="10" stroke-linecap="round" marker-end="url(#arrow)"/>
  <path d="M420 614 H560" stroke="$($theme.edge)" stroke-width="10" stroke-linecap="round" marker-end="url(#arrow)"/>
  <path d="M840 614 H980" stroke="$($theme.edge)" stroke-width="10" stroke-linecap="round" marker-end="url(#arrow)"/>
  <rect x="110" y="180" width="310" height="160" rx="28" fill="url(#panel)" filter="url(#shadow)"/>
  <rect x="545" y="180" width="310" height="160" rx="28" fill="url(#panel)" filter="url(#shadow)"/>
  <rect x="980" y="180" width="310" height="160" rx="28" fill="url(#panel)" filter="url(#shadow)"/>
  <rect x="110" y="530" width="310" height="160" rx="28" fill="url(#panel)" filter="url(#shadow)"/>
  <rect x="545" y="530" width="310" height="160" rx="28" fill="url(#panel)" filter="url(#shadow)"/>
  <rect x="980" y="530" width="310" height="160" rx="28" fill="url(#panel)" filter="url(#shadow)"/>
  <circle cx="164" cy="222" r="18" fill="$($theme.start)"/>
  <circle cx="599" cy="222" r="18" fill="$($theme.start)"/>
  <circle cx="1034" cy="222" r="18" fill="$($theme.start)"/>
  <circle cx="164" cy="572" r="18" fill="$($theme.start)"/>
  <circle cx="599" cy="572" r="18" fill="$($theme.start)"/>
  <circle cx="1034" cy="572" r="18" fill="$($theme.start)"/>
  <text x="156" y="228" font-family="'IBM Plex Mono', monospace" font-size="16" fill="#ffffff" font-weight="700">1</text>
  <text x="191" y="274" font-family="'Source Sans 3', sans-serif" font-size="34" fill="#0f172a" font-weight="700">$($cards[0].title)</text>
  <text x="191" y="316" font-family="'Source Sans 3', sans-serif" font-size="26" fill="#475569">$($cards[0].body)</text>
  <text x="591" y="228" font-family="'IBM Plex Mono', monospace" font-size="16" fill="#ffffff" font-weight="700">2</text>
  <text x="626" y="274" font-family="'Source Sans 3', sans-serif" font-size="34" fill="#0f172a" font-weight="700">$($cards[1].title)</text>
  <text x="626" y="316" font-family="'Source Sans 3', sans-serif" font-size="26" fill="#475569">$($cards[1].body)</text>
  <text x="1026" y="228" font-family="'IBM Plex Mono', monospace" font-size="16" fill="#ffffff" font-weight="700">3</text>
  <text x="1061" y="274" font-family="'Source Sans 3', sans-serif" font-size="34" fill="#0f172a" font-weight="700">$($cards[2].title)</text>
  <text x="1061" y="316" font-family="'Source Sans 3', sans-serif" font-size="26" fill="#475569">$($cards[2].body)</text>
  <text x="156" y="578" font-family="'IBM Plex Mono', monospace" font-size="16" fill="#ffffff" font-weight="700">4</text>
  <text x="191" y="624" font-family="'Source Sans 3', sans-serif" font-size="34" fill="#0f172a" font-weight="700">$($cards[3].title)</text>
  <text x="191" y="666" font-family="'Source Sans 3', sans-serif" font-size="26" fill="#475569">$($cards[3].body)</text>
  <text x="591" y="578" font-family="'IBM Plex Mono', monospace" font-size="16" fill="#ffffff" font-weight="700">5</text>
  <text x="626" y="624" font-family="'Source Sans 3', sans-serif" font-size="34" fill="#0f172a" font-weight="700">$($cards[4].title)</text>
  <text x="626" y="666" font-family="'Source Sans 3', sans-serif" font-size="26" fill="#475569">$($cards[4].body)</text>
  <text x="1026" y="578" font-family="'IBM Plex Mono', monospace" font-size="16" fill="#ffffff" font-weight="700">6</text>
  <text x="1061" y="624" font-family="'Source Sans 3', sans-serif" font-size="34" fill="#0f172a" font-weight="700">$($cards[5].title)</text>
  <text x="1061" y="666" font-family="'Source Sans 3', sans-serif" font-size="26" fill="#475569">$($cards[5].body)</text>
</svg>
"@
}

function New-WorkflowSvg {
  param([hashtable]$spec)
  $steps = $spec.steps
  $theme = Get-DiagramTheme -Focus $spec.focus
  return @"
<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="520" viewBox="0 0 1400 520" role="img" aria-labelledby="title desc">
  <title>$($spec.title)</title>
  <desc>$($spec.subtitle)</desc>
  <defs>
    <linearGradient id="flowbg" x1="0%" x2="100%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="$($theme.start)"/>
      <stop offset="100%" stop-color="$($theme.finish)"/>
    </linearGradient>
    <linearGradient id="flowcard" x1="0%" x2="100%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="#ffffff" stop-opacity="0.98"/>
      <stop offset="100%" stop-color="$($theme.panel)" stop-opacity="0.98"/>
    </linearGradient>
    <filter id="flowshadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="16" stdDeviation="16" flood-color="#0f172a" flood-opacity="0.16"/>
    </filter>
    <marker id="flowarrow" markerWidth="12" markerHeight="12" refX="9" refY="6" orient="auto">
      <path d="M0,0 L12,6 L0,12 z" fill="$($theme.edge)"/>
    </marker>
  </defs>
  <rect width="1400" height="520" rx="30" fill="#f8fafc"/>
  <rect x="24" y="24" width="1352" height="472" rx="28" fill="url(#flowbg)"/>
  <rect x="52" y="158" width="1296" height="250" rx="30" fill="rgba(255,255,255,0.06)" stroke="rgba(255,255,255,0.16)"/>
  <text x="76" y="86" font-family="'Merriweather', serif" font-size="38" fill="#ffffff" font-weight="700">$($spec.title)</text>
  <text x="76" y="122" font-family="'Source Sans 3', sans-serif" font-size="22" fill="$($theme.edge)">$($spec.subtitle)</text>
  <path d="M262 284 H336" stroke="$($theme.edge)" stroke-width="8" stroke-linecap="round" marker-end="url(#flowarrow)"/>
  <path d="M472 284 H546" stroke="$($theme.edge)" stroke-width="8" stroke-linecap="round" marker-end="url(#flowarrow)"/>
  <path d="M682 284 H756" stroke="$($theme.edge)" stroke-width="8" stroke-linecap="round" marker-end="url(#flowarrow)"/>
  <path d="M892 284 H966" stroke="$($theme.edge)" stroke-width="8" stroke-linecap="round" marker-end="url(#flowarrow)"/>
  <path d="M1102 284 H1176" stroke="$($theme.edge)" stroke-width="8" stroke-linecap="round" marker-end="url(#flowarrow)"/>
  <rect x="82" y="190" width="180" height="180" rx="26" fill="url(#flowcard)" filter="url(#flowshadow)"/>
  <rect x="292" y="190" width="180" height="180" rx="26" fill="url(#flowcard)" filter="url(#flowshadow)"/>
  <rect x="502" y="190" width="180" height="180" rx="26" fill="url(#flowcard)" filter="url(#flowshadow)"/>
  <rect x="712" y="190" width="180" height="180" rx="26" fill="url(#flowcard)" filter="url(#flowshadow)"/>
  <rect x="922" y="190" width="180" height="180" rx="26" fill="url(#flowcard)" filter="url(#flowshadow)"/>
  <rect x="1132" y="190" width="180" height="180" rx="26" fill="url(#flowcard)" filter="url(#flowshadow)"/>
  <text x="106" y="236" font-family="'IBM Plex Mono', monospace" font-size="22" fill="$($theme.start)" font-weight="700">STEP 1</text>
  <text x="316" y="236" font-family="'IBM Plex Mono', monospace" font-size="22" fill="$($theme.start)" font-weight="700">STEP 2</text>
  <text x="526" y="236" font-family="'IBM Plex Mono', monospace" font-size="22" fill="$($theme.start)" font-weight="700">STEP 3</text>
  <text x="736" y="236" font-family="'IBM Plex Mono', monospace" font-size="22" fill="$($theme.start)" font-weight="700">STEP 4</text>
  <text x="946" y="236" font-family="'IBM Plex Mono', monospace" font-size="22" fill="$($theme.start)" font-weight="700">STEP 5</text>
  <text x="1156" y="236" font-family="'IBM Plex Mono', monospace" font-size="22" fill="$($theme.start)" font-weight="700">STEP 6</text>
  <text x="106" y="288" font-family="'Source Sans 3', sans-serif" font-size="22" fill="#0f172a" font-weight="700">$($steps[0])</text>
  <text x="316" y="288" font-family="'Source Sans 3', sans-serif" font-size="22" fill="#0f172a" font-weight="700">$($steps[1])</text>
  <text x="526" y="288" font-family="'Source Sans 3', sans-serif" font-size="22" fill="#0f172a" font-weight="700">$($steps[2])</text>
  <text x="736" y="288" font-family="'Source Sans 3', sans-serif" font-size="22" fill="#0f172a" font-weight="700">$($steps[3])</text>
  <text x="946" y="288" font-family="'Source Sans 3', sans-serif" font-size="22" fill="#0f172a" font-weight="700">$($steps[4])</text>
  <text x="1156" y="288" font-family="'Source Sans 3', sans-serif" font-size="22" fill="#0f172a" font-weight="700">$($steps[5])</text>
</svg>
"@
}
'@

$updated = $raw.Substring(0, $startArch) + $replacement + "`r`n" + $raw.Substring($startNext)
Set-Content -Path $path -Value $updated -Encoding UTF8
