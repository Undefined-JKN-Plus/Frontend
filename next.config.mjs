/** @type {import('next').NextConfig} */
const nextConfig = {
    output: 'standalone',
    async rewrites() { 
        return [
            {
                source: '/api/:path*',
                destination: `${process.env.NEXT_PUBLIC_API_BACKEND}/:path*`,
            },
        ];
    }
};

export default nextConfig;
