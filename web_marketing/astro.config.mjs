import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://sdevasingh.github.io',
  base: process.env.ASTRO_BASE || '/',
  output: 'static',
  compressHTML: true,
});
