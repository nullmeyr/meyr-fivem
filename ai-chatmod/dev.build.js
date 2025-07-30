const {resolve} = require('path')
const buildPath = resolve(__dirname, "build")

const {build} = require('esbuild') 

build({
    entryPoints: ['./client/client.ts'],
    outdir: resolve(buildPath, 'client'),
    bundle: true,
    minify: true,
    platform: 'browser',
    target: 'es2020',
    logLevel: "info"
}).then((r) => {
  console.log("✨ Build succeeded.");
  r.watch(); 
  console.log("watching...");
}).catch(() => process.exit(1))