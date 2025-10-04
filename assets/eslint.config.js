import js from '@eslint/js';
import tsParser from '@typescript-eslint/parser';
import tsPlugin from '@typescript-eslint/eslint-plugin';
import miregoPlugin from 'eslint-plugin-mirego';
import globals from 'globals';

export default [
  js.configs.recommended,
  {
    ignores: ['node_modules/*', '**/static/*.js', 'static/**/*.js']
  },
  {
    files: ['**/*.ts'],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
      parser: tsParser,
      parserOptions: {
        project: null
      },
      globals: {
        ...globals.browser,
        ...globals.es2021
      }
    },
    plugins: {
      '@typescript-eslint': tsPlugin,
      mirego: miregoPlugin
    },
    rules: {
      ...tsPlugin.configs.recommended.rules,
      ...miregoPlugin.configs.recommended.rules
    }
  }
];
