Param(
    [string]$Root = (Resolve-Path ".").Path
)

$ErrorActionPreference = 'Stop'

$htmlFiles = Get-ChildItem -Path $Root -Recurse -Filter *.html
foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw

    # Remove any existing robots meta to avoid duplicates
    $content = [regex]::Replace(
        $content,
        '(?is)<meta\s+name\s*=\s*"robots"[^>]*>\s*',
        ''
    )

    # Remove SEO-related meta/link/script (anywhere in the file)
    $content = [regex]::Replace(
        $content,
        '(?is)<meta\s+name\s*=\s*"(?:description|keywords|author|google-site-verification)"[^>]*>\s*',
        ''
    )
    $content = [regex]::Replace(
        $content,
        '(?is)<meta\s+property\s*=\s*"og:[^"]+"[^>]*>\s*',
        ''
    )
    $content = [regex]::Replace(
        $content,
        '(?is)<meta\s+name\s*=\s*"twitter:[^"]+"[^>]*>\s*',
        ''
    )
    $content = [regex]::Replace(
        $content,
        '(?is)<link\s+rel\s*=\s*"canonical"[^>]*>\s*',
        ''
    )
    $content = [regex]::Replace(
        $content,
        '(?is)<script[^>]*type\s*=\s*"application/ld\+json"[^>]*>.*?</script>\s*',
        ''
    )

    # Normalize Accueil links to /index-old.html so internal nav points to old home
    $content = $content -replace '(?i)href=\s*"/index_old\.html"','href="/index-old.html"'

    # Insert a single robots meta right after <head>
    $content = [regex]::Replace(
        $content,
        '(?is)<head\b([^>]*)>',
        { param($m) $m.Value + [environment]::NewLine + '<meta name="robots" content="noindex, nofollow">' + [environment]::NewLine },
        1
    )

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

# Block all crawling at robots.txt
Set-Content -Path (Join-Path $Root 'robots.txt') -Value "User-agent: *`r`nDisallow: /" -Encoding ascii

# Remove sitemap.xml if present
$sitemapPath = Join-Path $Root 'sitemap.xml'
if (Test-Path $sitemapPath) {
    Remove-Item $sitemapPath -Force
}


