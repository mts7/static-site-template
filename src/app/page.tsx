import type { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
	title: 'Home',
	description: 'TODO: A short, unique description of the home page for search engines and social previews.',
};

export default function HomePage() {
	return (
		<div className="page page-index">
			<ul className="nav">
				<li>
					<Link href="/about">About</Link>
				</li>
			</ul>

			<div className="page-content">
				<h1>Static Site Template</h1>
			</div>
		</div>
	);
}
