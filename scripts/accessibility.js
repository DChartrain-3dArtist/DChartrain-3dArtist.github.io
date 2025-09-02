// Script d'amélioration de l'accessibilité - Donovan Chartrain Portfolio
// Ajoute les attributs ARIA manquants et améliore l'expérience utilisateur

(function() {
    'use strict';
    
    // Amélioration du bouton menu hamburger
    function enhanceMenuAccessibility() {
        const menuToggle = document.getElementById('menu-toggle');
        const menuLabel = document.querySelector('.menu-toggle-label');
        const sidebar = document.querySelector('.sidebar');
        
        if (menuToggle && menuLabel && sidebar) {
            // Ajout des attributs ARIA
            menuLabel.setAttribute('aria-label', 'Ouvrir le menu de navigation');
            menuLabel.setAttribute('aria-controls', 'sidebar');
            menuLabel.setAttribute('aria-expanded', 'false');
            
            // Synchronisation de aria-expanded avec l'état du menu
            function updateAriaExpanded() {
                const isExpanded = menuToggle.checked;
                menuLabel.setAttribute('aria-expanded', isExpanded ? 'true' : 'false');
            }
            
            // État initial
            updateAriaExpanded();
            
            // Écouteur d'événement pour les changements
            menuToggle.addEventListener('change', updateAriaExpanded);
            
            // Ajout d'un ID unique à la sidebar si pas déjà présent
            if (!sidebar.id) {
                sidebar.id = 'sidebar';
            }
            
            // Amélioration de la navigation au clavier
            const menuLinks = sidebar.querySelectorAll('a');
            menuLinks.forEach(link => {
                if (!link.hasAttribute('tabindex')) {
                    link.setAttribute('tabindex', '0');
                }
            });
        }
    }
    
    // Amélioration des images
    function enhanceImages() {
        const images = document.querySelectorAll('img:not([loading])');
        images.forEach(img => {
            // Ajout du lazy loading
            img.loading = 'lazy';
            img.decoding = 'async';
            
            // Amélioration des attributs alt si manquants
            if (!img.alt || img.alt.trim() === '') {
                img.alt = 'Image de Donovan Chartrain Portfolio';
            }
        });
    }
    
    // Amélioration des liens externes
    function enhanceExternalLinks() {
        const externalLinks = document.querySelectorAll('a[href^="http"]:not([rel*="noopener"])');
        externalLinks.forEach(link => {
            if (!link.rel.includes('noopener')) {
                link.rel = link.rel ? link.rel + ' noopener noreferrer' : 'noopener noreferrer';
            }
        });
    }
    
    // Ajout d'un lien "Aller au contenu" pour l'accessibilité
    function addSkipLink() {
        if (!document.querySelector('.skip-link')) {
            const skipLink = document.createElement('a');
            skipLink.href = '#main';
            skipLink.textContent = 'Aller au contenu principal';
            skipLink.className = 'skip-link';
            skipLink.setAttribute('tabindex', '0');
            
            // Insertion au début du body
            document.body.insertBefore(skipLink, document.body.firstChild);
        }
    }
    
    // Ajout d'un ID au contenu principal
    function enhanceMainContent() {
        const mainContent = document.querySelector('main');
        if (mainContent && !mainContent.id) {
            mainContent.id = 'main';
        }
    }
    
    // Amélioration de la navigation
    function enhanceNavigation() {
        const sidebar = document.querySelector('.sidebar');
        if (sidebar && !sidebar.hasAttribute('aria-label')) {
            sidebar.setAttribute('aria-label', 'Menu de navigation principal');
        }
        
        // Ajout de la classe active sur la page courante
        const currentPath = window.location.pathname;
        const menuLinks = sidebar.querySelectorAll('a');
        
        menuLinks.forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
                link.setAttribute('aria-current', 'page');
            }
        });
    }
    
    // Support des préférences de réduction de mouvement
    function supportReducedMotion() {
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            const style = document.createElement('style');
            style.textContent = `
                *, *::before, *::after {
                    animation-duration: 0.01ms !important;
                    animation-iteration-count: 1 !important;
                    transition-duration: 0.01ms !important;
                }
            `;
            document.head.appendChild(style);
        }
    }
    
    // Initialisation quand le DOM est prêt
    function init() {
        enhanceMenuAccessibility();
        enhanceImages();
        enhanceExternalLinks();
        addSkipLink();
        enhanceMainContent();
        enhanceNavigation();
        supportReducedMotion();
    }
    
    // Exécution immédiate si le DOM est déjà prêt
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
    
})();

