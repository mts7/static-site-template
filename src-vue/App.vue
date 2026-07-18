<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router';
</script>

<template>
	<div>
		<!-- Google Tag Manager (noscript) -->
		<noscript>
			<iframe
				src="https://www.googletagmanager.com/ns.html?id=TODO-GTM-TAG-ID"
				height="0"
				width="0"
				style="display: none; visibility: hidden"></iframe>
		</noscript>
		<!-- End Google Tag Manager (noscript) -->
		<header>
			<RouterLink to="/">
				<img alt="mts7 logo" class="logo" src="@/assets/logo.png" width="125" height="125" />
			</RouterLink>
			<div class="wrapper">
				<Header />
			</div>
		</header>

		<main>
			<RouterView />
		</main>
	</div>
</template>

<style scoped>
header {
	line-height: 1.5;
	max-height: 100vh;
}

.logo {
	display: block;
	margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
	header {
		display: block;
		width: 100%;
	}

	.logo {
		margin: 0 2rem 0 0;
	}
}
</style>
