$ErrorActionPreference = 'Stop'

$root = Join-Path $PSScriptRoot 'codex-claude-salesforce-guide'
$pagesDir = Join-Path $root 'pages'
$assetsDir = Join-Path $root 'assets'
$markdownPath = Join-Path $root 'index.md'
$manifestPath = Join-Path $root 'manifest.json'

New-Item -ItemType Directory -Force -Path $pagesDir, $assetsDir | Out-Null

function Write-Utf8File {
  param(
    [string]$Path,
    [string]$Content
  )

  Set-Content -Path $Path -Value $Content -Encoding UTF8
}

function Escape-Html {
  param([string]$Text)
  if ($null -eq $Text) { return '' }
  return [System.Net.WebUtility]::HtmlEncode($Text)
}

function Convert-InlineMarkdown {
  param([string]$Text)

  $encoded = Escape-Html $Text
  $encoded = [regex]::Replace($encoded, '`([^`]+)`', '<code>$1</code>')
  $encoded = [regex]::Replace($encoded, '\*\*([^\*]+)\*\*', '<strong>$1</strong>')
  $encoded = [regex]::Replace($encoded, '\*([^\*]+)\*', '<em>$1</em>')
  $encoded = [regex]::Replace($encoded, '\[([^\]]+)\]\(([^)]+)\)', '<a href="$2">$1</a>')
  return $encoded
}

function New-Slug {
  param([string]$Text)
  return (($Text.ToLower() -replace '[^a-z0-9]+', '-') -replace '(^-|-$)', '')
}

function Convert-MarkdownLinesToHtml {
  param([string[]]$Lines)

  $parts = New-Object System.Collections.Generic.List[string]
  $i = 0
  $inCode = $false
  $codeLanguage = ''
  $codeLines = New-Object System.Collections.Generic.List[string]

  while ($i -lt $Lines.Count) {
    $line = $Lines[$i]
    $trim = $line.TrimEnd()

    if ($trim -match '^```(.*)$') {
      if (-not $inCode) {
        $inCode = $true
        $codeLanguage = $Matches[1].Trim()
        $codeLines.Clear()
      }
      else {
        $langAttr = if ($codeLanguage) { " class=""language-$codeLanguage""" } else { '' }
        $codeHtml = Escape-Html (($codeLines -join "`n"))
        $parts.Add("<pre><code$langAttr>$codeHtml</code></pre>")
        $inCode = $false
        $codeLanguage = ''
      }
      $i += 1
      continue
    }

    if ($inCode) {
      $codeLines.Add($trim)
      $i += 1
      continue
    }

    if ([string]::IsNullOrWhiteSpace($trim)) {
      $i += 1
      continue
    }

    if ($trim -eq '---') {
      $parts.Add('<hr />')
      $i += 1
      continue
    }

    if ($trim -match '^###\s+(.*)$') {
      $heading = $Matches[1].Trim()
      $parts.Add("<h3 id=""$(New-Slug $heading)"">$(Convert-InlineMarkdown $heading)</h3>")
      $i += 1
      continue
    }

    if ($trim -match '^##\s+(.*)$') {
      $heading = $Matches[1].Trim()
      $parts.Add("<h2 id=""$(New-Slug $heading)"">$(Convert-InlineMarkdown $heading)</h2>")
      $i += 1
      continue
    }

    if ($trim -match '^#\s+(.*)$') {
      $heading = $Matches[1].Trim()
      $parts.Add("<h1 id=""$(New-Slug $heading)"">$(Convert-InlineMarkdown $heading)</h1>")
      $i += 1
      continue
    }

    if ($trim -match '^\|') {
      $tableLines = New-Object System.Collections.Generic.List[string]
      while ($i -lt $Lines.Count -and $Lines[$i].Trim() -match '^\|') {
        $tableLines.Add($Lines[$i].Trim())
        $i += 1
      }
      if ($tableLines.Count -ge 2) {
        $rows = @()
        foreach ($tableLine in $tableLines) {
          $cells = $tableLine.Trim('|').Split('|') | ForEach-Object { $_.Trim() }
          $rows += ,$cells
        }
        $header = $rows[0]
        $body = @()
        if ($rows.Count -gt 2) {
          $body = $rows[2..($rows.Count - 1)]
        }
        $thead = '<thead><tr>' + (($header | ForEach-Object { "<th>$(Convert-InlineMarkdown $_)</th>" }) -join '') + '</tr></thead>'
        $tbodyRows = foreach ($row in $body) {
          '<tr>' + (($row | ForEach-Object { "<td>$(Convert-InlineMarkdown $_)</td>" }) -join '') + '</tr>'
        }
        $tbody = '<tbody>' + ($tbodyRows -join '') + '</tbody>'
        $parts.Add("<div class=""table-wrap""><table>$thead$tbody</table></div>")
      }
      continue
    }

    if ($trim -match '^- ') {
      $items = New-Object System.Collections.Generic.List[string]
      while ($i -lt $Lines.Count -and $Lines[$i].Trim() -match '^- ') {
        $items.Add(($Lines[$i].Trim() -replace '^- ', ''))
        $i += 1
      }
      $html = '<ul>' + (($items | ForEach-Object { "<li>$(Convert-InlineMarkdown $_)</li>" }) -join '') + '</ul>'
      $parts.Add($html)
      continue
    }

    if ($trim -match '^\d+\. ') {
      $items = New-Object System.Collections.Generic.List[string]
      while ($i -lt $Lines.Count -and $Lines[$i].Trim() -match '^\d+\. ') {
        $items.Add(($Lines[$i].Trim() -replace '^\d+\. ', ''))
        $i += 1
      }
      $html = '<ol>' + (($items | ForEach-Object { "<li>$(Convert-InlineMarkdown $_)</li>" }) -join '') + '</ol>'
      $parts.Add($html)
      continue
    }

    $paragraphLines = New-Object System.Collections.Generic.List[string]
    while (
      $i -lt $Lines.Count -and
      -not [string]::IsNullOrWhiteSpace($Lines[$i]) -and
      $Lines[$i].Trim() -ne '---' -and
      $Lines[$i].Trim() -notmatch '^#{1,3}\s+' -and
      $Lines[$i].Trim() -notmatch '^```' -and
      $Lines[$i].Trim() -notmatch '^\|' -and
      $Lines[$i].Trim() -notmatch '^- ' -and
      $Lines[$i].Trim() -notmatch '^\d+\. '
    ) {
      $paragraphLines.Add($Lines[$i].Trim())
      $i += 1
    }
    if ($paragraphLines.Count -gt 0) {
      $parts.Add("<p>$(Convert-InlineMarkdown ($paragraphLines -join ' '))</p>")
    }
  }

  return ($parts -join "`n")
}

function Get-Sections {
  param([string[]]$Lines)

  $execStart = [array]::IndexOf($Lines, '## Executive Summary')
  $tocStart = [array]::IndexOf($Lines, '## Table of Contents')
  $sections = [ordered]@{}

  $sections['Executive Summary'] = $Lines[($execStart + 1)..($tocStart - 1)]

  $currentTitle = ''
  $currentLines = New-Object System.Collections.Generic.List[string]

  for ($i = $tocStart + 1; $i -lt $Lines.Count; $i++) {
    $line = $Lines[$i]
    if ($line -match '^##\s+(Section\s+\d+:\s+.*|Appendix\s+[A-Z]:\s+.*)$') {
      if ($currentTitle) {
        $sections[$currentTitle] = $currentLines.ToArray()
      }
      $currentTitle = $Matches[1].Trim()
      $currentLines = New-Object System.Collections.Generic.List[string]
      $currentLines.Add($line)
    }
    elseif ($currentTitle) {
      $currentLines.Add($line)
    }
  }

  if ($currentTitle) {
    $sections[$currentTitle] = $currentLines.ToArray()
  }

  return $sections
}

function Get-PageGroups {
  return @(
    @{
      slug = 'overview'
      title = 'Overview, Comparison, and Lifecycle'
      summary = 'Executive framing for leadership and delivery teams, plus lifecycle and comparison guidance.'
      sections = @('Executive Summary','Section 2: Introduction to AI Assistants in Salesforce','Section 3: Codex vs Claude for Salesforce','Section 4: End-to-End Salesforce Lifecycle Overview')
    },
    @{
      slug = 'discovery-and-architecture'
      title = 'Discovery and Architecture'
      summary = 'Requirements translation, solution design, architecture options, NFRs, and org strategy.'
      sections = @('Section 5: Use in Requirements Gathering and Discovery','Section 6: Use in Solution Design and Architecture')
    },
    @{
      slug = 'admin-development-and-automation'
      title = 'Admin, Development, and Automation'
      summary = 'Admin work, Apex, LWC, and Flow/automation guidance for implementation teams.'
      sections = @('Section 7: Use in Salesforce Admin Work','Section 8: Use in Apex Development','Section 9: Use in LWC Development','Section 10: Use in Flow and Automation')
    },
    @{
      slug = 'integrations-quality-and-delivery'
      title = 'Integrations, Quality, and Delivery'
      summary = 'Integration architecture, migration, DevOps, release management, and QA/testing.'
      sections = @('Section 11: Use in Integrations','Section 12: Use in Data Migration and Data Quality','Section 13: Use in DevOps, Releases, and Environment Management','Section 14: Use in QA and Testing')
    },
    @{
      slug = 'documentation-operations-and-prompts'
      title = 'Documentation, Operations, and Prompt Library'
      summary = 'Documentation, support, leadership usage, role-based adoption, and reusable prompt patterns.'
      sections = @('Section 15: Use in Documentation','Section 16: Use in Support and Maintenance','Section 17: Use for Leadership, PM, and Delivery Management','Section 18: Role-Based Usage Model','Section 19: Prompt Library')
    },
    @{
      slug = 'governance-roadmap-and-appendices'
      title = 'Governance, Roadmap, and Operating Model'
      summary = 'Enterprise governance, quality control, KPI tracking, adoption roadmap, and operating model.'
      sections = @('Section 20: Sample End-to-End Workflows','Section 21: Governance, Security, and Compliance','Section 22: Quality Control and Human Review Model','Section 23: Limitations and Failure Modes','Section 24: KPI and ROI Framework','Section 25: Implementation Roadmap','Section 26: Recommended Operating Model','Section 27: Final Recommendations','Appendix A: Enterprise Maturity Model','Appendix B: Human Review Required Notes','Appendix C: Practical Anti-Patterns')
    }
  )
}

function New-PageHtml {
  param(
    [hashtable]$Page,
    [int]$Index,
    [array]$Pages,
    [hashtable]$Sections
  )

  $sectionHtml = New-Object System.Collections.Generic.List[string]
  $tocItems = New-Object System.Collections.Generic.List[string]
  foreach ($sectionName in $Page.sections) {
    $sectionLines = $Sections[$sectionName]
    $headingLine = if ($sectionName -eq 'Executive Summary') { 'Executive Summary' } else { $sectionLines[0] -replace '^##\s+', '' }
    $sectionAnchor = if ($sectionName -eq 'Executive Summary') { 'executive-summary' } else { New-Slug $headingLine }
    $titleText = if ($sectionName -eq 'Executive Summary') { 'Executive Summary' } else { $headingLine }
    $tocItems.Add("<li><a href=""#$sectionAnchor"">$titleText</a></li>")
    if ($sectionName -eq 'Executive Summary') {
      $sectionHtml.Add("<section id=""$sectionAnchor""><h2>Executive Summary</h2>$(Convert-MarkdownLinesToHtml -Lines $sectionLines)</section>")
    }
    else {
      $sectionHtml.Add("<section id=""$sectionAnchor"">$(Convert-MarkdownLinesToHtml -Lines $sectionLines)</section>")
    }
  }

  $prev = if ($Index -gt 0) { $Pages[$Index - 1] } else { $null }
  $next = if ($Index -lt ($Pages.Count - 1)) { $Pages[$Index + 1] } else { $null }
  $prevHtml = if ($prev) { "<a class=""button button-secondary"" href=""./$($prev.slug).html"">Previous: $($prev.title)</a>" } else { '<span></span>' }
  $nextHtml = if ($next) { "<a class=""button button-primary"" href=""./$($next.slug).html"">Next: $($next.title)</a>" } else { '<a class="button button-primary" href="../index.html">Back to guide home</a>' }
  $readingTime = switch ($Index) { 0 { '18 min read' } 1 { '16 min read' } 2 { '18 min read' } 3 { '16 min read' } 4 { '18 min read' } default { '20 min read' } }

  return @"
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>$($Page.title) | Codex and Claude in Salesforce</title><meta name="description" content="$($Page.summary)" /><meta name="author" content="Shivam Gupta" /><meta name="robots" content="index, follow" /><link rel="canonical" href="https://shivam.pulsagi.com/codex-claude-salesforce-guide/pages/$($Page.slug).html" /><meta property="og:type" content="article" /><meta property="og:site_name" content="Salesforce AI Delivery Guide" /><meta property="og:title" content="$($Page.title)" /><meta property="og:description" content="$($Page.summary)" /><meta property="og:url" content="https://shivam.pulsagi.com/codex-claude-salesforce-guide/pages/$($Page.slug).html" /><meta property="og:image" content="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1400&q=80" /><meta name="twitter:card" content="summary_large_image" /><link rel="preconnect" href="https://fonts.googleapis.com" /><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin /><link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=Merriweather:wght@700&family=Source+Sans+3:wght@400;600;700&display=swap" rel="stylesheet" /><link rel="stylesheet" href="../../AI-blog/assets/site.css" /><link rel="stylesheet" href="../assets/guide.css" /></head>
<body><header class="site-header"><div class="header-inner"><a class="brand" href="../index.html"><span class="brand-mark">Salesforce AI Delivery Guide</span><span class="brand-sub">Codex and Claude for enterprise Salesforce teams</span></a><nav class="nav-links" aria-label="Primary"><a href="../index.html">Guide home</a><a href="../../agentforce-blog/index.html">Agentforce blog</a><a href="../../index.html">Main site</a></nav></div></header>
<main class="page-shell article-page"><section class="article-hero doc-hero"><div class="article-hero-copy"><div class="eyebrow">Enterprise Guide  -  Codex and Claude in Salesforce</div><h1 class="article-title">$($Page.title)</h1><p class="article-standfirst">$($Page.summary)</p><div class="reading-meta"><span>$readingTime</span><span>Updated March 11, 2026</span><span>By Shivam Gupta</span></div></div><div class="article-hero-media doc-hero-panel"><div class="hero-metrics"><div class="metric"><strong>6</strong><span>Linked documentation pages</span></div><div class="metric"><strong>27</strong><span>Core guide sections</span></div><div class="metric"><strong>Mixed audience</strong><span>Architecture to leadership</span></div><div class="metric"><strong>Operational</strong><span>Prompts, governance, roadmaps</span></div></div></div></section><div class="article-layout"><aside class="toc-card" aria-label="Page table of contents"><h2>On this page</h2><ol>$($tocItems -join '')</ol></aside><article class="content-card doc-content">$($sectionHtml -join "`n")<section class="related-section"><h2>Continue reading</h2><div class="doc-nav">$prevHtml $nextHtml</div></section></article></div></main><footer class="site-footer"><div class="footer-inner"><span>(c) 2026 Shivam Gupta. Salesforce AI delivery documentation.</span><span><a href="../index.html">All guide pages</a></span></div></footer></body></html>
"@
}

$guideCss = @'
.doc-hero .article-hero-media{display:flex;align-items:center;justify-content:center}
.doc-hero-panel{background:linear-gradient(180deg,rgba(255,255,255,.14),rgba(255,255,255,.06)),linear-gradient(135deg,rgba(8,61,119,.95),rgba(15,118,110,.84));color:#fff}
.doc-content h1,.doc-content h2,.doc-content h3{scroll-margin-top:108px}
.doc-content h2{margin-top:10px}
.doc-content hr{border:0;border-top:1px solid rgba(221,212,196,.95);margin:30px 0}
.doc-content table{width:100%;border-collapse:collapse;background:#fff;border-radius:18px;overflow:hidden}
.doc-content th,.doc-content td{padding:12px 14px;border:1px solid rgba(221,212,196,.9);text-align:left;vertical-align:top;font-size:.98rem}
.doc-content th{background:rgba(11,92,171,.08);color:#0f172a}
.table-wrap{overflow-x:auto;margin:22px 0}
.doc-content ul,.doc-content ol{margin:14px 0 18px}
.doc-content pre{margin:18px 0}
.doc-nav{display:flex;gap:14px;flex-wrap:wrap;margin-top:16px}
.guide-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:22px;margin-top:28px}
.guide-card{background:var(--surface);border:1px solid rgba(221,212,196,.95);border-radius:var(--radius);box-shadow:0 14px 36px rgba(148,163,184,.08);padding:24px}
.guide-card h3{margin:0 0 10px;font-family:"Merriweather",serif;font-size:1.28rem}
.guide-card p{margin:0 0 16px;color:var(--muted)}
.guide-meta{display:flex;gap:12px;flex-wrap:wrap;margin-bottom:12px;color:var(--muted);font-size:.9rem}
.guide-callout{padding:20px 22px;border-radius:22px;background:linear-gradient(180deg,rgba(11,92,171,.06),rgba(255,255,255,.88));border:1px solid rgba(11,92,171,.16)}
'@

$lines = Get-Content -Path $markdownPath
$sections = Get-Sections -Lines $lines
$pages = Get-PageGroups

Write-Utf8File -Path (Join-Path $assetsDir 'guide.css') -Content $guideCss

for ($i = 0; $i -lt $pages.Count; $i++) {
  $page = $pages[$i]
  $html = New-PageHtml -Page $page -Index $i -Pages $pages -Sections $sections
  Write-Utf8File -Path (Join-Path $pagesDir "$($page.slug).html") -Content $html
}

$cards = foreach ($page in $pages) {
@"
<article class="guide-card">
  <div class="guide-meta"><span>Documentation page</span><span>$($page.sections.Count) sections</span></div>
  <h3>$($page.title)</h3>
  <p>$($page.summary)</p>
  <a class="button button-secondary" href="./pages/$($page.slug).html">Open page</a>
</article>
"@
}

$indexHtml = @"
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>Codex and Claude in Salesforce | Shivam Gupta</title><meta name="description" content="A multi-page enterprise guide for using Codex and Claude across the full Salesforce delivery lifecycle." /><meta name="author" content="Shivam Gupta" /><meta name="robots" content="index, follow" /><link rel="canonical" href="https://shivam.pulsagi.com/codex-claude-salesforce-guide/" /><meta property="og:type" content="website" /><meta property="og:site_name" content="Salesforce AI Delivery Guide" /><meta property="og:title" content="Codex and Claude in Salesforce" /><meta property="og:description" content="Strategy, use cases, prompts, governance, and enterprise implementation guidance for Salesforce teams." /><meta property="og:url" content="https://shivam.pulsagi.com/codex-claude-salesforce-guide/" /><meta property="og:image" content="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1400&q=80" /><meta name="twitter:card" content="summary_large_image" /><link rel="preconnect" href="https://fonts.googleapis.com" /><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin /><link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=Merriweather:wght@700&family=Source+Sans+3:wght@400;600;700&display=swap" rel="stylesheet" /><link rel="stylesheet" href="../AI-blog/assets/site.css" /><link rel="stylesheet" href="./assets/guide.css" /></head>
<body><header class="site-header"><div class="header-inner"><a class="brand" href="./index.html"><span class="brand-mark">Salesforce AI Delivery Guide</span><span class="brand-sub">Codex and Claude for enterprise Salesforce teams</span></a><nav class="nav-links" aria-label="Primary"><a href="#pages">Pages</a><a href="../agentforce-blog/index.html">Agentforce blog</a><a href="../index.html">Main site</a></nav></div></header>
<main class="page-shell"><section class="hero"><div class="hero-card"><div class="hero-grid"><div class="hero-copy"><div class="eyebrow">Enterprise AI Enablement Documentation</div><h1>How Codex and Claude can be used end-to-end in Salesforce.</h1><p>This guide translates AI-assisted delivery into a practical Salesforce operating model covering requirements, architecture, admin work, development, testing, releases, support, governance, and enterprise adoption.</p><p>It is structured as a multi-page documentation set so architects, developers, admins, QA, delivery managers, and leadership teams can navigate the material without reading one monolithic whitepaper.</p><div class="hero-actions"><a class="button button-primary" href="#pages">Browse guide pages</a><a class="button button-secondary" href="./index.md">View markdown source</a></div></div><div class="hero-media doc-hero-panel"><div class="hero-metrics"><div class="metric"><strong>27</strong><span>Core guide sections</span></div><div class="metric"><strong>6</strong><span>Linked HTML pages</span></div><div class="metric"><strong>Prompt library</strong><span>Reusable enterprise templates</span></div><div class="metric"><strong>Governance</strong><span>Security, compliance, review model</span></div></div></div></div></div></section><section class="section"><h2 class="section-heading">What this guide covers</h2><p class="section-intro">The documentation set explains where Codex is stronger, where Claude is stronger, and how both can be used together across Sales Cloud, Service Cloud, Experience Cloud, marketing-related operations, custom development, integrations, migration, support, and enterprise governance.</p><div class="card-grid"><article class="card"><h3>Practical scope</h3><p>Requirements, architecture, admin configuration, Apex, LWC, Flow, integrations, QA, DevOps, support, and leadership reporting.</p></article><article class="card"><h3>Enterprise controls</h3><p>Prompt hygiene, human review, signoff models, security risk management, quality checklists, KPIs, and rollout phases.</p></article><article class="card"><h3>Reusable assets</h3><p>Includes prompt templates, decision frameworks, anti-patterns, maturity model guidance, and operational checklists.</p></article></div></section><section class="section" id="pages"><h2 class="section-heading">Guide pages</h2><p class="section-intro">Start with the overview page if you want the strategic framing first, or jump directly into the delivery domain that matches your role.</p><div class="guide-grid">$($cards -join "`n")</div></section><section class="section"><h2 class="section-heading">Recommended reading order</h2><div class="guide-callout"><p>For leadership and architects: start with <strong>Overview, Comparison, and Lifecycle</strong>, then move to <strong>Governance, Roadmap, and Operating Model</strong>. For implementation teams: start with <strong>Discovery and Architecture</strong>, then continue into the build and delivery pages. For support and enablement teams: prioritize the documentation, operations, and prompt library page.</p></div></section></main><footer class="site-footer"><div class="footer-inner"><span>(c) 2026 Shivam Gupta. Salesforce AI delivery documentation.</span><span><a href="../index.html">Back to main site</a></span></div></footer></body></html>
"@

Write-Utf8File -Path (Join-Path $root 'index.html') -Content $indexHtml

$manifest = Get-Content -Raw -Path $manifestPath | ConvertFrom-Json
$manifest | Add-Member -NotePropertyName html_entry -NotePropertyValue 'index.html' -Force
$manifest | Add-Member -NotePropertyName pages -NotePropertyValue @($pages | ForEach-Object { @{ title = $_.title; file = "pages/$($_.slug).html" } }) -Force
Write-Utf8File -Path $manifestPath -Content (($manifest | ConvertTo-Json -Depth 6))

