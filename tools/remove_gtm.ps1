Param(
    [string]$Root = (Resolve-Path ".").Path
)

$ErrorActionPreference = 'Stop'

Get-ChildItem -Path $Root -Recurse -Filter *.html | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Path $path -Raw

    # Remove GTM comment wrapped script blocks
    $content = [regex]::Replace(
        $content,
        '(?is)<!--\s*Google Tag Manager\s*-->.*?<!--\s*End Google Tag Manager\s*-->\s*',
        ''
    )

    # Remove GTM noscript blocks
    $content = [regex]::Replace(
        $content,
        '(?is)<!--\s*Google Tag Manager \(noscript\)\s*-->.*?<!--\s*End Google Tag Manager \(noscript\)\s*-->\s*',
        ''
    )

    # Remove any stray noscript iframe to googletagmanager
    $content = [regex]::Replace(
        $content,
        '(?is)<noscript>\s*<iframe[^>]*googletagmanager[^<]*</iframe>\s*</noscript>\s*',
        ''
    )

    # Remove direct <script src> to googletagmanager if any
    $content = [regex]::Replace(
        $content,
        '(?is)<script[^>]*googletagmanager[^>]*>\s*</script>\s*',
        ''
    )

    Set-Content -Path $path -Value $content -Encoding UTF8
}


