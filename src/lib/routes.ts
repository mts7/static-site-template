import { readdirSync } from 'node:fs';
import { join } from 'node:path';

const APP_DIR = join(process.cwd(), 'src/app');

function isRouteSegment(name: string): boolean {
	return (
		!name.startsWith('_') &&
		!name.startsWith('.') &&
		!name.startsWith('(') &&
		!name.startsWith('[') &&
		name !== 'api'
	);
}

export function getStaticRoutes(dir: string = APP_DIR, base = ''): string[] {
	const entries = readdirSync(dir, { withFileTypes: true });
	const routes: string[] = [];

	if (entries.some((entry) => entry.isFile() && entry.name === 'page.tsx')) {
		routes.push(base === '' ? '/' : base);
	}

	for (const entry of entries) {
		if (!entry.isDirectory() || !isRouteSegment(entry.name)) {
			continue;
		}

		routes.push(...getStaticRoutes(join(dir, entry.name), `${base}/${entry.name}`));
	}

	return routes;
}
