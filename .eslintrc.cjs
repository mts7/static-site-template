require('@rushstack/eslint-patch/modern-module-resolution');

module.exports = {
	root: true,
	env: {
		node: true,
	},
	extends: [
		'plugin:vue/vue3-essential',
		'eslint:recommended',
		'@vue/eslint-config-prettier',
		'@vue/eslint-config-typescript',
		'@vue/prettier',
		'@vue/typescript/recommended',
	],
	parserOptions: {
		ecmaVersion: 'latest',
	},
	plugins: ['prettier'],
	rules: {
		'no-cond-assign': 'error',
		'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
		'no-const-assign': 'error',
		'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
		'quotes': ['warn', 'single', { avoidEscape: true }],
		'@typescript-eslint/no-unused-vars': 'off',
	},
	noInlineConfig: true,
	overrides: [
		{
			files: ['**/__tests__/*.{j,t}s?(x)', '**/tests/unit/**/*.spec.{j,t}s?(x)'],
			env: {
				jest: true,
			},
		},
	],
};
