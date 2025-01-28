import * as esbuild from 'esbuild'
import vuePlugin from 'esbuild-plugin-vue-next'

const options = {
    entryPoints: ['app/javascript/admin-module.js'],
    bundle: true,
    sourcemap: true,
    format: 'esm',
    outdir: 'app/assets/builds',
    publicPath: '/assets',
    logLevel: 'info',
    plugins: [vuePlugin()],
    define: {
        __VUE_OPTIONS_API__: 'true',
        __VUE_PROD_DEVTOOLS__: 'false',
        __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: 'false'
    },
    alias: {
        'vue': 'vue/dist/vue.esm-bundler.js',
    },
}
const watchMode = process.argv.includes('--watch')

if (watchMode) {
    let ctx = await esbuild.context(options)
    await ctx.watch()
} else {
    await esbuild.build(options)
}
