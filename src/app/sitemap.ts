import type { MetadataRoute } from 'next';

import { siteConfig } from '@/lib/site-config';

export const dynamic = 'force-static';

export default function sitemap(): MetadataRoute.Sitemap {
	const routes = ['', '/about'];

	return routes.map((route) => ({
		url: `${siteConfig.url}${route}`,
		lastModified: new Date(),
	}));
}
