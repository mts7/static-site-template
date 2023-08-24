import { nextTick } from 'vue';
import { createRouter, createWebHistory } from 'vue-router';

const siteTitle = ' - TODO: Website Title';

const router = createRouter({
	history: createWebHistory('/'),
	routes: [
		{
			path: '/',
			name: 'home',
			component: () => import('../views/IndexView.vue'),
			meta: {
				title: 'Home',
			},
		},
		{
			path: '/about',
			name: 'about',
			meta: {
				title: 'About',
			},
			component: () => import('../views/AboutView.vue'),
		},
	],
});

router.beforeEach((to) => {
	nextTick(() => {
		document.title = to.meta.title + siteTitle;
	});
});

export default router;
