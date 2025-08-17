import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/theme-provider'
import { QueryProvider } from '@/components/query-provider'
import { AuthProvider } from '@/components/auth-provider'
import { TelegramProvider } from '@/components/telegram-provider'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'EventApp - Event Management',
  description: 'Create, organize and manage events with ease',
  keywords: 'events, tickets, organization, management',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <QueryProvider>
          <ThemeProvider>
            <TelegramProvider>
              <AuthProvider>
                {children}
              </AuthProvider>
            </TelegramProvider>
          </ThemeProvider>
        </QueryProvider>
      </body>
    </html>
  )
}
