'use client'

import { createContext, useContext, useEffect, useState } from 'react'

interface TelegramUser {
  id: number
  first_name: string
  last_name?: string
  username?: string
  language_code?: string
  is_premium?: boolean
  photo_url?: string
}

interface TelegramContextType {
  user: TelegramUser | null
  isTelegram: boolean
  initData: string | null
  isReady: boolean
  linkAccount: (email: string, password: string) => Promise<boolean>
}

const TelegramContext = createContext<TelegramContextType | undefined>(undefined)

export function TelegramProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<TelegramUser | null>(null)
  const [isTelegram, setIsTelegram] = useState(false)
  const [initData, setInitData] = useState<string | null>(null)
  const [isReady, setIsReady] = useState(false)

  useEffect(() => {
    // Check if we're in Telegram Web App
    if (typeof window !== 'undefined' && window.Telegram?.WebApp) {
      setIsTelegram(true)
      
      const tg = window.Telegram.WebApp
      
      // Initialize Telegram Web App
      tg.ready()
      tg.expand()
      
      // Get user data
      if (tg.initDataUnsafe?.user) {
        setUser(tg.initDataUnsafe.user)
      }
      
      // Get init data
      if (tg.initData) {
        setInitData(tg.initData)
      }
      
      // Set theme
      if (tg.colorScheme === 'dark') {
        document.documentElement.classList.add('dark')
      }
      
      setIsReady(true)
    } else {
      setIsReady(true)
    }
  }, [])

  const linkAccount = async (email: string, password: string): Promise<boolean> => {
    if (!user || !initData) return false

    try {
      const response = await fetch('/api/telegram/link', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          telegramId: user.id,
          email,
          password,
        }),
      })

      if (response.ok) {
        const data = await response.json()
        // Store the token
        localStorage.setItem('token', data.token)
        return true
      }
      
      return false
    } catch (error) {
      console.error('Error linking account:', error)
      return false
    }
  }

  return (
    <TelegramContext.Provider value={{
      user,
      isTelegram,
      initData,
      isReady,
      linkAccount,
    }}>
      {children}
    </TelegramContext.Provider>
  )
}

export function useTelegram() {
  const context = useContext(TelegramContext)
  if (context === undefined) {
    throw new Error('useTelegram must be used within a TelegramProvider')
  }
  return context
}

// Extend Window interface for Telegram Web App
declare global {
  interface Window {
    Telegram?: {
      WebApp: {
        ready: () => void
        expand: () => void
        close: () => void
        initData: string
        initDataUnsafe: {
          user?: TelegramUser
          query_id?: string
        }
        colorScheme: 'light' | 'dark'
        themeParams: {
          bg_color?: string
          text_color?: string
          hint_color?: string
          link_color?: string
          button_color?: string
          button_text_color?: string
        }
        MainButton: {
          text: string
          color: string
          textColor: string
          isVisible: boolean
          isActive: boolean
          show: () => void
          hide: () => void
          enable: () => void
          disable: () => void
          onClick: (callback: () => void) => void
          offClick: (callback: () => void) => void
        }
        BackButton: {
          isVisible: boolean
          show: () => void
          hide: () => void
          onClick: (callback: () => void) => void
          offClick: (callback: () => void) => void
        }
        HapticFeedback: {
          impactOccurred: (style: 'light' | 'medium' | 'heavy' | 'rigid' | 'soft') => void
          notificationOccurred: (type: 'error' | 'success' | 'warning') => void
          selectionChanged: () => void
        }
      }
    }
  }
}
