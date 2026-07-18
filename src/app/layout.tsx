import type { Metadata, Viewport } from 'next';
import Image from 'next/image';
import Link from 'next/link';

import { GoogleTagManagerNoScript, GoogleTagManagerScript } from '@/components/google-tag-manager';
import { siteConfig } from '@/lib/site-config';
import logo from '@/assets/logo.png';

import './globals.css';

export const metadata: Metadata = {
	metadataBase: new URL(siteConfig.url),
	title: {
		default: siteConfig.name,
		template: `%s - ${siteConfig.name}`,
	},
	description: siteConfig.description,
	openGraph: {
		type: 'website',
		siteName: siteConfig.name,
		title: siteConfig.name,
		description: siteConfig.description,
		url: siteConfig.url,
	},
	twitter: {
		card: 'summary_large_image',
		site: siteConfig.twitterHandle,
		title: siteConfig.name,
		description: siteConfig.description,
	},
};

export const viewport: Viewport = {
	width: 'device-width',
	initialScale: 1,
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
	return (
		<html lang="en">
			<body>
				<GoogleTagManagerNoScript />
				<GoogleTagManagerScript />

				<header>
					<Link href="/">
						<Image src={logo} alt="mts7 logo" className="logo" width={125} height={125} priority />
					</Link>
				</header>

				<main>{children}</main>
			</body>
		</html>
	);
}
