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
  Heart,
  Settings,
  Bell,
  Star,
  UserPlus,
  Bookmark
} from 'lucide-react'
import { motion } from 'framer-motion'

// Моковые данные для демонстрации
const mockStats = {
  totalVisitedEvents: 8,
  totalCreatedEvents: 5,
  upcomingEvents: 3,
  followers: 24
}

const mockUpcomingEvents = [
  {
    id: '1',
    title: 'Web Development Conference',
    date: '2024-02-15',
    time: '10:00',
    location: 'Moscow, Tverskaya St., 1',
    participants: 45,
    maxParticipants: 100,
    type: 'my-registration'
  },
  {
    id: '2',
    title: 'Startup Meetup',
    date: '2024-02-20',
    time: '19:00',
    location: 'Online (Zoom)',
    participants: 23,
    maxParticipants: 50,
    type: 'my-created'
  },
  {
    id: '3',
    title: 'Design Workshop',
    date: '2024-02-25',
    time: '14:00',
    location: 'St. Petersburg, Nevsky Ave., 28',
    participants: 18,
    maxParticipants: 30,
    type: 'favorite-topic'
  },
  {
    id: '4',
    title: 'Tech Innovation Summit',
    date: '2024-03-01',
    time: '09:00',
    location: 'Online (Teams)',
    participants: 67,
    maxParticipants: 200,
    type: 'following-user'
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
          <p className="mt-4 text-gray-600 dark:text-gray-400">Loading...</p>
        </div>
      </div>
    )
  }

  if (!user) {
    return null
  }

  const getEventTypeIcon = (type) => {
    switch (type) {
      case 'my-registration':
        return <Bookmark className="w-4 h-4 text-blue-500" />
      case 'my-created':
        return <Plus className="w-4 h-4 text-green-500" />
      case 'favorite-topic':
        return <Heart className="w-4 h-4 text-red-500" />
      case 'following-user':
        return <UserPlus className="w-4 h-4 text-purple-500" />
      default:
        return <Calendar className="w-4 h-4 text-gray-500" />
    }
  }

  const getEventTypeLabel = (type) => {
    switch (type) {
      case 'my-registration':
        return 'My Registration'
      case 'my-created':
        return 'Created by Me'
      case 'favorite-topic':
        return 'Favorite Topic'
      case 'following-user':
        return 'Following User'
      default:
        return 'Event'
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Header />
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Welcome */}
        <motion.div 
          className="mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
            Welcome, {user.name}! 👋
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Manage your events and track your statistics
          </p>
        </motion.div>

        {/* Statistics */}
        <motion.div 
          className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
        >
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Total Visited Events</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">{mockStats.totalVisitedEvents}</p>
              </div>
              <div className="w-12 h-12 bg-blue-100 dark:bg-blue-900/30 rounded-lg flex items-center justify-center">
                <Calendar className="w-6 h-6 text-blue-600 dark:text-blue-400" />
              </div>
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Total Created Events</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">{mockStats.totalCreatedEvents}</p>
              </div>
              <div className="w-12 h-12 bg-green-100 dark:bg-green-900/30 rounded-lg flex items-center justify-center">
                <Plus className="w-6 h-6 text-green-600 dark:text-green-400" />
              </div>
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Upcoming Events</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">{mockStats.upcomingEvents}</p>
              </div>
              <div className="w-12 h-12 bg-purple-100 dark:bg-purple-900/30 rounded-lg flex items-center justify-center">
                <Clock className="w-6 h-6 text-purple-600 dark:text-purple-400" />
              </div>
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Followers</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">{mockStats.followers}</p>
              </div>
              <div className="w-12 h-12 bg-pink-100 dark:bg-pink-900/30 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-pink-600 dark:text-pink-400" />
              </div>
            </div>
          </div>
        </motion.div>

        {/* Quick Actions */}
        <motion.div 
          className="mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.2 }}
        >
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Quick Actions</h2>
            <div className="flex flex-wrap gap-4">
              <Button 
                className="flex items-center space-x-2"
                onClick={() => router.push('/create')}
              >
                <Plus className="w-4 h-4" />
                <span>Create Event</span>
              </Button>
              <Button variant="outline" className="flex items-center space-x-2">
                <Users className="w-4 h-4" />
                <span>Manage Participants</span>
              </Button>
              <Button variant="outline" className="flex items-center space-x-2">
                <Heart className="w-4 h-4" />
                <span>My Favorites</span>
              </Button>
              <Button variant="outline" className="flex items-center space-x-2">
                <Settings className="w-4 h-4" />
                <span>Settings</span>
              </Button>
            </div>
          </div>
        </motion.div>

        {/* Upcoming Events */}
        <motion.div 
          className="mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.3 }}
        >
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white">Upcoming Events</h2>
              <Button variant="outline" size="sm" onClick={() => router.push('/events')}>
                View All
              </Button>
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
                    <div className="flex items-center space-x-2 mb-1">
                      {getEventTypeIcon(event.type)}
                      <h3 className="font-medium text-gray-900 dark:text-white">{event.title}</h3>
                      <span className="text-xs px-2 py-1 bg-gray-200 dark:bg-gray-600 rounded-full text-gray-600 dark:text-gray-400">
                        {getEventTypeLabel(event.type)}
                      </span>
                    </div>
                    <div className="flex items-center space-x-4 text-sm text-gray-600 dark:text-gray-400">
                      <span className="flex items-center space-x-1">
                        <Calendar className="w-4 h-4" />
                        <span>{new Date(event.date).toLocaleDateString('en-US')}</span>
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
                      {event.participants}/{event.maxParticipants} participants
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
      </main>
    </div>
  )
}
