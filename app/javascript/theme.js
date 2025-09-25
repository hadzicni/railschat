// Theme Manager for RailsChat
class ThemeManager {
  constructor() {
    this.currentTheme = this.getStoredTheme() || 'light';
    this.init();
  }

  init() {
    // Apply stored theme on load
    this.applyTheme(this.currentTheme);

    // Listen for system theme changes
    this.watchSystemTheme();
  }

  getStoredTheme() {
    return localStorage.getItem('railschat-theme');
  }

  setStoredTheme(theme) {
    localStorage.setItem('railschat-theme', theme);
  }

  getSystemTheme() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  watchSystemTheme() {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
      if (!this.getStoredTheme()) {
        this.applyTheme(e.matches ? 'dark' : 'light');
      }
    });
  }

  toggleTheme() {
    const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
    this.setTheme(newTheme);
  }

  setTheme(theme) {
    this.currentTheme = theme;
    this.setStoredTheme(theme);
    this.applyTheme(theme);
    this.updateToggleButton();
  }

  applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);

    // Update Bootstrap theme if available
    if (theme === 'dark') {
      document.documentElement.setAttribute('data-bs-theme', 'dark');
    } else {
      document.documentElement.removeAttribute('data-bs-theme');
    }
  }

  updateToggleButton() {
    const toggleButton = document.getElementById('theme-toggle');
    const toggleIcon = document.getElementById('theme-toggle-icon');

    if (toggleButton && toggleIcon) {
      if (this.currentTheme === 'dark') {
        toggleIcon.className = 'bi bi-sun-fill';
        toggleButton.setAttribute('title', 'Switch to Light Mode');
      } else {
        toggleIcon.className = 'bi bi-moon-fill';
        toggleButton.setAttribute('title', 'Switch to Dark Mode');
      }
    }
  }
}

// Initialize theme manager when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  window.themeManager = new ThemeManager();

  // Attach event listener to theme toggle button
  const themeToggle = document.getElementById('theme-toggle');
  if (themeToggle) {
    themeToggle.addEventListener('click', function() {
      window.themeManager.toggleTheme();
    });
  }
});

// Export for use in other modules
window.ThemeManager = ThemeManager;
