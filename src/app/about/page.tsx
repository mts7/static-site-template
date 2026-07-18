import type { Metadata } from 'next';

export const metadata: Metadata = {
	title: 'About',
	description: 'TODO: A short, unique description of the about page for search engines and social previews.',
};

export default function AboutPage() {
	return (
		<div className="page page-about">
			<h2>About</h2>

			<div className="story">
				<p>This is a static site.</p>
			</div>
		</div>
	);
}
