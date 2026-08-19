import js from '@eslint/js';
import tsParser from '@typescript-eslint/parser';
import tsPlugin from '@typescript-eslint/eslint-plugin';
import miregoPlugin from 'eslint-plugin-mirego';
import globals from 'globals';

export default [
  js.configs.recommended,
  {
    ignores: ['node_modules/*', '**/static/*.js', 'static/**/*.js', 'vendor/*']
  },
  {
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.es2021,
        process: 'readonly'
      }
    },
    plugins: {
      mirego: miregoPlugin
    },
    rules: {
      ...miregoPlugin.configs.recommended.rules,
      'no-unused-vars': ['error', {argsIgnorePattern: '^_'}]
    }
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
        ...globals.es2021,
        process: 'readonly'
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
