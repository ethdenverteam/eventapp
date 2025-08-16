'use client'

import { useState, useEffect } from 'react'
import { useAuth } from '@/components/auth-provider'
import { useRouter } from 'next/navigation'
import { Header } from '@/components/header'
import { Button } from '@/components/ui/button'
import { 
  Calendar, 
  Users, 
  MapPin, 
  Clock, 
  Plus, 
  TrendingUp,
  Settings,
  Bell,
  Star
} from 'lucide-react'
import { motion } from 'framer-motion'

// Моковые данные для демонстрации
const mockStats = {
  totalEvents: 12,
  upcomingEvents: 3,
  totalParticipants: 156,
  totalRevenue: 45000
}

const mockUpcomingEvents = [
  {
    id: '1',
    title: 'Конференция по веб-разработке',
    date: '2024-02-15',
    time: '10:00',
    location: 'Москва, ул. Тверская, 1',
    participants: 45,
    maxParticipants: 100
  },
  {
    id: '2',
    title: 'Встреча стартаперов',
    date: '2024-02-20',
    time: '19:00',
    location: 'Онлайн (Zoom)',
    participants: 23,
    maxParticipants: 50
  },
  {
    id: '3',
    title: 'Мастер-класс по дизайну',
    date: '2024-02-25',
    time: '14:00',
    location: 'Санкт-Петербург, Невский пр., 28',
    participants: 18,
    maxParticipants: 30
  }
]

export default function DashboardPage() {
  const { user, isLoading } = useAuth()
  const router = useRouter()
  const [activeTab, setActiveTab] = useState('overview')

  useEffect(() => {
    if (!isLoading && !user) {
      router.push('/login')
    }
  }, [user, isLoading, router])

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 dark:bg-gray-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto"></div>
          <p className="mt-4 text-gray-600 dark:text-gray-400">Загрузка...</p>
        </div>
      </div>
    )
  }

  if (!user) {
    return null
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Header />
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Приветствие */}
        <motion.div 
          className="mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
            Добро пожаловать, {user.name}! 👋
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Управляйте вашими мероприятиями и отслеживайте статистику
          </p>
        </motion.div>

        {/* Статистика */}
        <motion.div 
          className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
        >
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Всего событий</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">{mockStats.totalEvents}</p>
              </div>
              <div className="w-12 h-12 bg-blue-100 dark:bg-blue-900/30 rounded-lg flex items-center justify-center">
                <Calendar className="w-6 h-6 text-blue-600 dark:text-blue-400" />
              </div>
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Предстоящие</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">{mockStats.upcomingEvents}</p>
              </div>
              <div className="w-12 h-12 bg-green-100 dark:bg-green-900/30 rounded-lg flex items-center justify-center">
                <Clock className="w-6 h-6 text-green-600 dark:text-green-400" />
              </div>
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Участники</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">{mockStats.totalParticipants}</p>
              </div>
              <div className="w-12 h-12 bg-purple-100 dark:bg-purple-900/30 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-purple-600 dark:text-purple-400" />
              </div>
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Доход</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">₽{mockStats.totalRevenue.toLocaleString()}</p>
              </div>
              <div className="w-12 h-12 bg-yellow-100 dark:bg-yellow-900/30 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-yellow-600 dark:text-yellow-400" />
              </div>
            </div>
          </div>
        </motion.div>

        {/* Быстрые действия */}
        <motion.div 
          className="mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.2 }}
        >
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Быстрые действия</h2>
            <div className="flex flex-wrap gap-4">
              <Button className="flex items-center space-x-2">
                <Plus className="w-4 h-4" />
                <span>Создать событие</span>
              </Button>
              <Button variant="outline" className="flex items-center space-x-2">
                <Users className="w-4 h-4" />
                <span>Управление участниками</span>
              </Button>
              <Button variant="outline" className="flex items-center space-x-2">
                <TrendingUp className="w-4 h-4" />
                <span>Аналитика</span>
              </Button>
              <Button variant="outline" className="flex items-center space-x-2">
                <Settings className="w-4 h-4" />
                <span>Настройки</span>
              </Button>
            </div>
          </div>
        </motion.div>

        {/* Предстоящие события */}
        <motion.div 
          className="mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.3 }}
        >
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white">Предстоящие события</h2>
              <Button variant="outline" size="sm">Посмотреть все</Button>
            </div>
            
            <div className="space-y-4">
              {mockUpcomingEvents.map((event, index) => (
                <motion.div
                  key={event.id}
                  className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700 rounded-lg"
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ duration: 0.3, delay: index * 0.1 }}
                >
                  <div className="flex-1">
                    <h3 className="font-medium text-gray-900 dark:text-white mb-1">{event.title}</h3>
                    <div className="flex items-center space-x-4 text-sm text-gray-600 dark:text-gray-400">
                      <span className="flex items-center space-x-1">
                        <Calendar className="w-4 h-4" />
                        <span>{new Date(event.date).toLocaleDateString('ru-RU')}</span>
                      </span>
                      <span className="flex items-center space-x-1">
                        <Clock className="w-4 h-4" />
                        <span>{event.time}</span>
                      </span>
                      <span className="flex items-center space-x-1">
                        <MapPin className="w-4 h-4" />
                        <span>{event.location}</span>
                      </span>
                    </div>
                  </div>
                  
                  <div className="text-right">
                    <div className="text-sm text-gray-600 dark:text-gray-400 mb-1">
                      {event.participants}/{event.maxParticipants} участников
                    </div>
                    <div className="w-24 bg-gray-200 dark:bg-gray-600 rounded-full h-2">
                      <div 
                        className="bg-primary-600 h-2 rounded-full"
                        style={{ width: `${(event.participants / event.maxParticipants) * 100}%` }}
                      ></div>
                    </div>
                  </div>
                </motion.div>
              ))}
            </div>
          </div>
        </motion.div>

        {/* Последние активности */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.4 }}
        >
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Последние активности</h2>
            <div className="space-y-3">
              <div className="flex items-center space-x-3 text-sm">
                <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                <span className="text-gray-600 dark:text-gray-400">Новая регистрация на "Конференция по веб-разработке"</span>
                <span className="text-gray-400">2 минуты назад</span>
              </div>
              <div className="flex items-center space-x-3 text-sm">
                <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                <span className="text-gray-600 dark:text-gray-400">Событие "Встреча стартаперов" обновлено</span>
                <span className="text-gray-400">1 час назад</span>
              </div>
              <div className="flex items-center space-x-3 text-sm">
                <div className="w-2 h-2 bg-yellow-500 rounded-full"></div>
                <span className="text-gray-600 dark:text-gray-400">Новый отзыв о мероприятии "Мастер-класс по дизайну"</span>
                <span className="text-gray-400">3 часа назад</span>
              </div>
            </div>
          </div>
        </motion.div>
      </main>
    </div>
  )
}
