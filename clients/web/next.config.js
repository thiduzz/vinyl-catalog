/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  async rewrites() {
    return [
      {
        source: '/backend/:path*',
        destination: process.env.NEXT_PUBLIC_BACKEND_URL + '/:path*',
      },
    ]
  },
}
