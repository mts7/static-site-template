import { describe, expect, it } from 'vitest';

import { getStaticRoutes } from './routes';

describe('getStaticRoutes', () => {
	it('finds every page.tsx under src/app', () => {
		expect(getStaticRoutes()).toEqual(expect.arrayContaining(['/', '/about']));
	});

	it('excludes route groups, private folders, and the api directory', () => {
		expect(getStaticRoutes()).not.toEqual(expect.arrayContaining(['/api']));
	});
});
