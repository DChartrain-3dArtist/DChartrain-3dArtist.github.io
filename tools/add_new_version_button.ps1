# Script pour ajouter le bouton "Nouvelle version" dans toutes les pages HTML
# Donovan Chartrain - 2024

Write-Host "Ajout du bouton 'Nouvelle version' dans toutes les pages HTML..." -ForegroundColor Green

# Fonction pour ajouter le bouton dans une page HTML
function Add-NewVersionButton {
    param(
        [string]$FilePath
    )
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Vérifier si le bouton existe déjà
        if ($content -match "Nouvelle version du site") {
            Write-Host "  ✓ Bouton déjà présent dans: $FilePath" -ForegroundColor Yellow
            return
        }
        
        # Pattern pour trouver la fin de la liste de navigation
        $pattern = '(<li><a href="/pages/contact\.html">// Contact</a></li>\s*</ul>\s*<div class="separator"></div>)'
        
        # Remplacement avec le bouton ajouté
        $replacement = @'
            <li><a href="/pages/contact.html">// Contact</a></li>
        </ul>
        <div class="separator"></div>
        <div class="new-version-section">
            <a href="https://donovan-dev3d.vercel.app" class="new-version-button" target="_blank" rel="noopener noreferrer">
                🚀 Nouvelle version du site
            </a>
        </div>
        <div class="separator"></div>
'@
        
        if ($content -match $pattern) {
            $newContent = $content -replace $pattern, $replacement
            Set-Content $FilePath $newContent -Encoding UTF8
            Write-Host "  ✓ Bouton ajouté dans: $FilePath" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Pattern non trouvé dans: $FilePath" -ForegroundColor Red
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
        Add-NewVersionButton -FilePath $file.FullName
    }
}

# Traitement des fichiers HTML
$workspacePath = Get-Location
Write-Host "Répertoire de travail: $workspacePath" -ForegroundColor Cyan

# Traiter tous les fichiers HTML du projet
Process-HtmlFiles -Directory $workspacePath

Write-Host "`nTraitement terminé !" -ForegroundColor Green
Write-Host "Le bouton 'Nouvelle version' a été ajouté dans toutes les pages HTML appropriées." -ForegroundColor Green

