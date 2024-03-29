#!/usr/bin/env node

import { join } from 'path';
import { cwd } from 'process';

import { build } from 'esbuild';

build({
    entryPoints: [join(cwd(), 'src', 'index.ts')],
    outdir: join(cwd(), 'out'),
    bundle: true,
    minify: true,
    sourcesContent: false,
    allowOverwrite: true,
    format: 'esm',
    platform: 'node',
    sourcemap: 'inline',
    tsconfig: join(cwd(), 'tsconfig.json'),
    packages: 'external',
});
