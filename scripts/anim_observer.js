document.addEventListener('DOMContentLoaded', () => {
    const observer = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const delay = entry.target.getAttribute('data-delay') || '0s';
          entry.target.style.animationDelay = delay; // Ajoute le délai
          entry.target.classList.add('visible'); // Ajoute la classe visible
          observer.unobserve(entry.target); // Stoppe l'observation après animation
        }
      });
    });
  
    document.querySelectorAll('.animate').forEach((el) => observer.observe(el));
  });  