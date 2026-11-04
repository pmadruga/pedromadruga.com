const { test, expect } = require('@playwright/test');

const pages = ['/', '/blog/domain-driven-ai/', '/notes/'];

async function expectTheme(page, theme) {
  await expect(page.locator('html')).toHaveAttribute('data-theme', theme);
  await expect(
    page.getByRole('button', { name: 'Toggle theme' })
  ).toHaveAttribute('aria-pressed', String(theme === 'dark'));
}

async function colors(page) {
  return page.locator('body').evaluate((body) => {
    const style = getComputedStyle(body);
    return { background: style.backgroundColor, text: style.color };
  });
}

for (const path of pages) {
  test(`${path} toggles colors and preserves the preference`, async ({
    page,
    colorScheme: systemTheme,
  }) => {
    const errors = [];
    page.on('pageerror', (error) => errors.push(error.message));
    const response = await page.goto(path);
    expect(response.ok()).toBeTruthy();
    expect(response.headers()['content-security-policy']).toContain(
      'script-src'
    );
    await expectTheme(page, systemTheme);
    const originalColors = await colors(page);
    const opposite = systemTheme === 'light' ? 'dark' : 'light';

    // A real click also catches overlays that intercept the button.
    await page.getByRole('button', { name: 'Toggle theme' }).click();
    await expectTheme(page, opposite);
    const changedColors = await colors(page);
    expect(changedColors.background).not.toBe(originalColors.background);
    expect(changedColors.text).not.toBe(originalColors.text);
    expect(await page.evaluate(() => localStorage.getItem('pref-theme'))).toBe(
      opposite
    );

    await page.reload();
    await expectTheme(page, opposite);
    expect(await colors(page)).toEqual(changedColors);

    // The saved preference must survive navigation to a different template.
    await page.goto(path === '/' ? '/notes/' : '/');
    await expectTheme(page, opposite);
    await page.goto(path);
    await expectTheme(page, opposite);

    // Exercise the reverse direction using the keyboard.
    await page.getByRole('button', { name: 'Toggle theme' }).focus();
    await page.keyboard.press('Enter');
    await expectTheme(page, systemTheme);
    expect(await colors(page)).toEqual(originalColors);
    expect(await page.evaluate(() => localStorage.getItem('pref-theme'))).toBe(
      systemTheme
    );
    await page.reload();
    await expectTheme(page, systemTheme);
    expect(errors).toEqual([]);
  });
}
