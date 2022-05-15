import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/

console.log(process.env);

export default defineConfig({
  plugins: [react()],
  server: {
    port: process.env.PORT
  }
})
