'use client'

import { useState } from 'react'
import { useTelegram } from './telegram-provider'
import { Button } from './ui/button'
import { Input } from './ui/input'
import { Label } from './ui/label'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './ui/card'
import { Alert, AlertDescription } from './ui/alert'
import { CheckCircle, AlertCircle, Link } from 'lucide-react'

export function TelegramLink() {
  const { user, isTelegram, linkAccount } = useTelegram()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle')
  const [message, setMessage] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    if (!email || !password) {
      setStatus('error')
      setMessage('Please fill in all fields')
      return
    }

    setIsLoading(true)
    setStatus('idle')

    try {
      const success = await linkAccount(email, password)
      
      if (success) {
        setStatus('success')
        setMessage('Account linked successfully!')
        setEmail('')
        setPassword('')
      } else {
        setStatus('error')
        setMessage('Invalid email or password. Please try again.')
      }
    } catch (error) {
      setStatus('error')
      setMessage('An error occurred. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  if (!isTelegram) {
    return null
  }

  return (
    <Card className="w-full max-w-md mx-auto">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Link className="w-5 h-5" />
          Link Telegram Account
        </CardTitle>
        <CardDescription>
          Connect your Telegram account to your EventApp account
        </CardDescription>
      </CardHeader>
      <CardContent>
        {user && (
          <div className="mb-4 p-3 bg-gray-50 dark:bg-gray-800 rounded-lg">
            <p className="text-sm text-gray-600 dark:text-gray-400">
              Telegram User: {user.first_name} {user.last_name || ''}
            </p>
            {user.username && (
              <p className="text-sm text-gray-600 dark:text-gray-400">
                @{user.username}
              </p>
            )}
          </div>
        )}

        {status === 'success' && (
          <Alert className="mb-4">
            <CheckCircle className="h-4 w-4" />
            <AlertDescription>{message}</AlertDescription>
          </Alert>
        )}

        {status === 'error' && (
          <Alert className="mb-4" variant="destructive">
            <AlertCircle className="h-4 w-4" />
            <AlertDescription>{message}</AlertDescription>
          </Alert>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              type="email"
              placeholder="your@email.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              type="password"
              placeholder="Your EventApp password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          <Button 
            type="submit" 
            className="w-full" 
            disabled={isLoading}
          >
            {isLoading ? 'Linking...' : 'Link Account'}
          </Button>
        </form>

        <div className="mt-4 text-xs text-gray-500 dark:text-gray-400">
          <p>This will link your Telegram account to your existing EventApp account.</p>
          <p>You'll be able to access all your events and manage them through Telegram.</p>
        </div>
      </CardContent>
    </Card>
  )
}
