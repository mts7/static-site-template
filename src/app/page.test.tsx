import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';

import HomePage from './page';

describe('HomePage', () => {
	it('renders the heading', () => {
		render(<HomePage />);

		expect(screen.getByRole('heading', { name: 'Static Site Template' })).toBeInTheDocument();
	});

	it('links to the about page', () => {
		render(<HomePage />);

		expect(screen.getByRole('link', { name: 'About' })).toHaveAttribute('href', '/about');
	});
});
