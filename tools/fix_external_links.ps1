# Script pour corriger les liens externes dans toutes les pages HTML
# Donovan Chartrain - 2024

Write-Host "Correction des liens externes dans toutes les pages HTML..." -ForegroundColor Green

# Fonction pour corriger les liens externes dans une page HTML
function Fix-ExternalLinks {
    param(
        [string]$FilePath
    )
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        $originalContent = $content
        $modified = $false
        
        # Pattern pour trouver les liens externes sans rel="noopener noreferrer"
        $patterns = @(
            # Liens target="_blank" sans rel
            '(target="_blank")(?![^>]*rel=)',
            # Liens href commençant par http sans rel
            '(href="https?://[^"]*")(?![^>]*rel=)'
        )
        
        foreach ($pattern in $patterns) {
            if ($content -match $pattern) {
                # Ajouter rel="noopener noreferrer" aux liens externes
                $content = $content -replace $pattern, '$1 rel="noopener noreferrer"'
                $modified = $true
            }
        }
        
        # Correction spécifique pour les liens LinkedIn, Instagram, etc.
        $socialPatterns = @(
            'href="https://www\.linkedin\.com/[^"]*"(?![^>]*rel=)',
            'href="https://www\.instagram\.com/[^"]*"(?![^>]*rel=)',
            'href="https://www\.youtube\.com/[^"]*"(?![^>]*rel=)',
            'href="https://github\.com/[^"]*"(?![^>]*rel=)',
            'href="https://pages\.github\.com/[^"]*"(?![^>]*rel=)'
        )
        
        foreach ($pattern in $socialPatterns) {
            if ($content -match $pattern) {
                $content = $content -replace $pattern, '$1 rel="noopener noreferrer"'
                $modified = $true
            }
        }
        
        if ($modified) {
            Set-Content $FilePath $content -Encoding UTF8
            Write-Host "  ✓ Liens externes corrigés dans: $FilePath" -ForegroundColor Green
        } else {
            Write-Host "  ✓ Aucune correction nécessaire dans: $FilePath" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "  ✗ Erreur lors du traitement de: $FilePath" -ForegroundColor Red
        Write-Host "    $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Fonction pour traiter récursivement tous les fichiers HTML
function Process-HtmlFiles {
    param(
        [string]$Directory
    )
    
    $htmlFiles = Get-ChildItem -Path $Directory -Filter "*.html" -Recurse
    
    foreach ($file in $htmlFiles) {
        # Exclure la page d'accueil principale qui redirige
        if ($file.Name -eq "index.html") {
            Write-Host "  ⚠ Page d'accueil ignorée: $($file.FullName)" -ForegroundColor Cyan
            continue
        }
        
        Write-Host "Traitement de: $($file.Name)" -ForegroundColor White
        Fix-ExternalLinks -FilePath $file.FullName
    }
}

# Traitement des fichiers HTML
$workspacePath = Get-Location
Write-Host "Répertoire de travail: $workspacePath" -ForegroundColor Cyan

# Traiter tous les fichiers HTML du projet
Process-HtmlFiles -Directory $workspacePath

Write-Host "`nTraitement terminé !" -ForegroundColor Green
Write-Host "Tous les liens externes ont été corrigés avec rel='noopener noreferrer'." -ForegroundColor Green

