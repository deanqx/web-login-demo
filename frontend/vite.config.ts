import { sveltekit } from '@sveltejs/kit/vite'
import { defineConfig } from 'vite'

export default defineConfig({
    plugins: [sveltekit()],
    css: {
        preprocessorOptions: {
            scss: {
                additionalData: `@use '/src/_app.scss' as *;`
            }
        },
        postcss: './postcss.config.mjs'
    },
    server: {
        proxy: {
            '/api': 'http://localhost:4000'
        }
    }
})
