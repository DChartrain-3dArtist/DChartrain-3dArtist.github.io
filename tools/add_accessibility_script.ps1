# Script pour ajouter le script d'accessibilité dans toutes les pages HTML
# Donovan Chartrain - 2024

Write-Host "Ajout du script d'accessibilité dans toutes les pages HTML..." -ForegroundColor Green

# Fonction pour ajouter le script d'accessibilité dans une page HTML
function Add-AccessibilityScript {
    param(
        [string]$FilePath
    )
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Vérifier si le script existe déjà
        if ($content -match "accessibility.js") {
            Write-Host "  ✓ Script déjà présent dans: $FilePath" -ForegroundColor Yellow
            return
        }
        
        # Pattern pour trouver la fin des scripts
        $pattern = '(<script defer src="/scripts/anim_observer\.js"></script>)'
        
        # Remplacement avec le script d'accessibilité ajouté
        $replacement = @'
    <script defer src="/scripts/anim_observer.js"></script>
    <script defer src="/scripts/accessibility.js"></script>
'@
        
        if ($content -match $pattern) {
            $newContent = $content -replace $pattern, $replacement
            Set-Content $FilePath $newContent -Encoding UTF8
            Write-Host "  ✓ Script ajouté dans: $FilePath" -ForegroundColor Green
        } else {
            # Essayer de trouver une autre position pour ajouter le script
            $pattern2 = '(<script defer src="/scripts/anim_observer\.js"></script>\s*</head>)'
            $replacement2 = @'
    <script defer src="/scripts/anim_observer.js"></script>
    <script defer src="/scripts/accessibility.js"></script>
</head>
'@
            
            if ($content -match $pattern2) {
                $newContent = $content -replace $pattern2, $replacement2
                Set-Content $FilePath $newContent -Encoding UTF8
                Write-Host "  ✓ Script ajouté dans: $FilePath" -ForegroundColor Green
            } else {
                Write-Host "  ✗ Position pour ajouter le script non trouvée dans: $FilePath" -ForegroundColor Red
            }
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
        Add-AccessibilityScript -FilePath $file.FullName
    }
}

# Traitement des fichiers HTML
$workspacePath = Get-Location
Write-Host "Répertoire de travail: $workspacePath" -ForegroundColor Cyan

# Traiter tous les fichiers HTML du projet
Process-HtmlFiles -Directory $workspacePath

Write-Host "`nTraitement terminé !" -ForegroundColor Green
Write-Host "Le script d'accessibilité a été ajouté dans toutes les pages HTML appropriées." -ForegroundColor Green

