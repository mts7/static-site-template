<script setup lang="ts">
import { RouterLink } from 'vue-router';
import HelloWorld from '@/components/HelloWorld.vue';
</script>

<template lang="pug">
.page.page-index
	ul.nav
		li
			RouterLink(to='/about') About

	.page-content
		HelloWorld(
			msg="Static Site Template"
		)
</template>
