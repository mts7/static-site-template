import AxeBuilder from '@axe-core/playwright';
import { expect, test } from '@playwright/test';

import { getStaticRoutes } from '../src/lib/routes';

for (const route of getStaticRoutes()) {
	test(`${route} has no automatically detectable accessibility issues`, async ({ page }) => {
		await page.goto(route);

		const results = await new AxeBuilder({ page }).analyze();

		expect(results.violations).toEqual([]);
	});
}
