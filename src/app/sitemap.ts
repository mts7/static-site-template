import type { MetadataRoute } from 'next';

import { siteConfig } from '@/lib/site-config';
import { getStaticRoutes } from '@/lib/routes';

export const dynamic = 'force-static';

export default function sitemap(): MetadataRoute.Sitemap {
	return getStaticRoutes().map((route) => ({
		url: `${siteConfig.url}${route === '/' ? '' : route}`,
		lastModified: new Date(),
	}));
}
