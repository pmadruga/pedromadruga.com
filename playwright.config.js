const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests/browser',
  forbidOnly: !!process.env.CI,
  workers: 1,
  globalTimeout: 180_000,
  use: {
    baseURL: 'http://127.0.0.1:4173',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
  projects: ['light', 'dark'].map((colorScheme) => ({
    name: `firefox-${colorScheme}`,
    use: {
      browserName: 'firefox',
      colorScheme,
      // Native preference survives navigation with production isolation
      // headers, where Firefox can lose Playwright's media emulation.
      launchOptions: {
        firefoxUserPrefs: {
          'ui.systemUsesDarkTheme': colorScheme === 'dark' ? 1 : 0,
        },
      },
    },
  })),
  webServer: {
    command: 'python3 scripts/serve-browser-tests.py',
    url: 'http://127.0.0.1:4173',
    reuseExistingServer: false,
    timeout: 120_000,
    gracefulShutdown: { signal: 'SIGTERM', timeout: 5000 },
  },
});
