import { expect, test } from '@playwright/test';

test('home page links to the about page', async ({ page }) => {
	await page.goto('/');

	await expect(page.getByRole('heading', { name: 'Static Site Template' })).toBeVisible();

	await page.getByRole('link', { name: 'About' }).click();

	await expect(page).toHaveURL(/\/about/);
	await expect(page.getByRole('heading', { name: 'About' })).toBeVisible();
});
