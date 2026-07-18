import { fileURLToPath } from 'node:url';

import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
	output: 'export',
	images: {
		unoptimized: true,
	},
	turbopack: {
		root: fileURLToPath(new URL('.', import.meta.url)),
	},
};

export default nextConfig;
