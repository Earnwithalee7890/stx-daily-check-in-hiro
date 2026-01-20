import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import { Analytics } from '@vercel/analytics/next'

const inter = Inter({ subsets: ['latin'] })

import { ToastProvider } from '@/components/AchievementSystem';

export const metadata: Metadata = {
    title: 'STX Builder Hub | Premium Deployer',
    description: 'Deploy contracts, mint NFTs, and manage Stacks assets with premium tools',
}

export default function RootLayout({
    children,
}: {
    children: React.ReactNode
}) {
    return (
        <html lang="en">
            <body className={inter.className}>
                <ToastProvider>
                    {children}
                </ToastProvider>
                <Analytics />
            </body>
        </html>
    )
}
