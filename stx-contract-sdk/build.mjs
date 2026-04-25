import { build } from 'esbuild';

const buildOptions = {
  entryPoints: ['src/index.ts'],
  bundle: true,
  platform: 'neutral',
  external: ['@stacks/network', '@stacks/transactions'],
};

async function runBuild() {
  await Promise.all([
    // ESM build
    build({
      ...buildOptions,
      format: 'esm',
      outfile: 'dist/index.js',
    }),
    // CJS build
    build({
      ...buildOptions,
      format: 'cjs',
      outfile: 'dist/index.cjs',
    }),
  ]);
  console.log('Build completed successfully!');
}

runBuild().catch((err) => {
  console.error('Build failed:', err);
  process.exit(1);
});
