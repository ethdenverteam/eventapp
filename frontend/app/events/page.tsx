'use client'

import { Header } from '@/components/header'
import { Button } from '@/components/ui/button'
import { Calendar, MapPin, Clock, Users, Search, Filter } from 'lucide-react'
import { motion } from 'framer-motion'
import { useState } from 'react'

// Моковые данные событий
const mockEvents = [
  {
    id: '1',
    title: 'Конференция по веб-разработке 2024',
    description: 'Крупнейшая конференция для веб-разработчиков в России. Два дня интенсивов, мастер-классов и нетворкинга.',
    date: '2024-02-15',
    time: '10:00',
    location: 'Москва, ул. Тверская, 1',
    price: '5000',
    participants: 45,
    maxParticipants: 100,
    category: 'Технологии',
    image: '/api/placeholder/400/200'
  },
  {
    id: '2',
    title: 'Встреча стартаперов',
    description: 'Ежемесячная встреча предпринимателей для обмена опытом и поиска партнеров.',
    date: '2024-02-20',
    time: '19:00',
    location: 'Онлайн (Zoom)',
    price: '0',
    participants: 23,
    maxParticipants: 50,
    category: 'Бизнес',
    image: '/api/placeholder/400/200'
  },
  {
    id: '3',
    title: 'Мастер-класс по дизайну интерфейсов',
    description: 'Практический мастер-класс по созданию современных UI/UX дизайнов.',
    date: '2024-02-25',
    time: '14:00',
    location: 'Санкт-Петербург, Невский пр., 28',
    price: '3000',
    participants: 18,
    maxParticipants: 30,
    category: 'Дизайн',
    image: '/api/placeholder/400/200'
  },
  {
    id: '4',
    title: 'Фестиваль музыки и искусства',
    description: 'Трехдневный фестиваль с выступлениями музыкантов, выставками и мастер-классами.',
    date: '2024-03-01',
    time: '12:00',
    location: 'Парк Горького, Москва',
    price: '2000',
    participants: 120,
    maxParticipants: 500,
    category: 'Искусство',
    image: '/api/placeholder/400/200'
  }
]

const categories = ['Все', 'Технологии', 'Бизнес', 'Дизайн', 'Искусство', 'Образование', 'Спорт']

export default function EventsPage() {
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedCategory, setSelectedCategory] = useState('Все')
  const [sortBy, setSortBy] = useState('date')

  const filteredEvents = mockEvents.filter(event => {
    const matchesSearch = event.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         event.description.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesCategory = selectedCategory === 'Все' || event.category === selectedCategory
    return matchesSearch && matchesCategory
  })

  const sortedEvents = [...filteredEvents].sort((a, b) => {
    switch (sortBy) {
      case 'date':
        return new Date(a.date).getTime() - new Date(b.date).getTime()
      case 'price':
        return parseInt(a.price) - parseInt(b.price)
      case 'participants':
        return b.participants - a.participants
      default:
        return 0
    }
  })

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Header />
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Заголовок */}
        <motion.div 
          className="text-center mb-12"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-4">
            Найти мероприятие
          </h1>
          <p className="text-xl text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
            Откройте для себя увлекательные события, встречи и конференции в вашем городе
          </p>
        </motion.div>

        {/* Поиск и фильтры */}
        <motion.div 
          className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm border border-gray-200 dark:border-gray-700 mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.1 }}
        >
          <div className="flex flex-col lg:flex-row gap-4">
            {/* Поиск */}
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  placeholder="Поиск мероприятий..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
                />
              </div>
            </div>

            {/* Категории */}
            <div className="flex flex-wrap gap-2">
              {categories.map((category) => (
                <button
                  key={category}
                  onClick={() => setSelectedCategory(category)}
                  className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                    selectedCategory === category
                      ? 'bg-primary-600 text-white'
                      : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600'
                  }`}
                >
                  {category}
                </button>
              ))}
            </div>

            {/* Сортировка */}
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
            >
              <option value="date">По дате</option>
              <option value="price">По цене</option>
              <option value="participants">По популярности</option>
            </select>
          </div>
        </motion.div>

        {/* Список событий */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {sortedEvents.map((event, index) => (
            <motion.div
              key={event.id}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-lg transition-shadow duration-200"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
            >
              {/* Изображение */}
              <div className="h-48 bg-gradient-to-br from-primary-100 to-secondary-100 dark:from-primary-900/30 dark:to-secondary-900/30 flex items-center justify-center">
                <Calendar className="w-16 h-16 text-primary-600 dark:text-primary-400" />
              </div>

              {/* Контент */}
              <div className="p-6">
                {/* Категория */}
                <div className="mb-3">
                  <span className="inline-block px-3 py-1 bg-primary-100 dark:bg-primary-900/30 text-primary-800 dark:text-primary-200 text-xs font-medium rounded-full">
                    {event.category}
                  </span>
                </div>

                {/* Заголовок */}
                <h3 className="text-xl font-bold text-gray-900 dark:text-white mb-2 line-clamp-2">
                  {event.title}
                </h3>

                {/* Описание */}
                <p className="text-gray-600 dark:text-gray-400 text-sm mb-4 line-clamp-3">
                  {event.description}
                </p>

                {/* Детали */}
                <div className="space-y-2 mb-4">
                  <div className="flex items-center space-x-2 text-sm text-gray-600 dark:text-gray-400">
                    <Calendar className="w-4 h-4" />
                    <span>{new Date(event.date).toLocaleDateString('ru-RU')}</span>
                  </div>
                  <div className="flex items-center space-x-2 text-sm text-gray-600 dark:text-gray-400">
                    <Clock className="w-4 h-4" />
                    <span>{event.time}</span>
                  </div>
                  <div className="flex items-center space-x-2 text-sm text-gray-600 dark:text-gray-400">
                    <MapPin className="w-4 h-4" />
                    <span className="truncate">{event.location}</span>
                  </div>
                  <div className="flex items-center space-x-2 text-sm text-gray-600 dark:text-gray-400">
                    <Users className="w-4 h-4" />
                    <span>{event.participants}/{event.maxParticipants} участников</span>
                  </div>
                </div>

                {/* Цена и кнопка */}
                <div className="flex items-center justify-between">
                  <div className="text-lg font-bold text-gray-900 dark:text-white">
                    {event.price === '0' ? 'Бесплатно' : `₽${event.price}`}
                  </div>
                  <Button size="sm">
                    Подробнее
                  </Button>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Пустое состояние */}
        {sortedEvents.length === 0 && (
          <motion.div 
            className="text-center py-12"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
          >
            <Calendar className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">
              Мероприятия не найдены
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Попробуйте изменить параметры поиска или категорию
            </p>
          </motion.div>
        )}
      </main>
    </div>
  )
}
