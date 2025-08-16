'use client'

import { motion } from 'framer-motion'
import { 
  Calendar, 
  Users, 
  CreditCard, 
  BarChart3, 
  Smartphone, 
  Shield,
  Zap,
  Globe
} from 'lucide-react'

const features = [
  {
    icon: Calendar,
    title: 'Создание событий',
    description: 'Легко создавайте красивые страницы мероприятий с настраиваемым дизайном и всеми необходимыми деталями.'
  },
  {
    icon: Users,
    title: 'Управление участниками',
    description: 'Отслеживайте регистрации, управляйте списком гостей и общайтесь с участниками в реальном времени.'
  },
  {
    icon: CreditCard,
    title: 'Продажа билетов',
    description: 'Настройте различные типы билетов, промокоды и безопасные платежи для монетизации ваших событий.'
  },
  {
    icon: BarChart3,
    title: 'Аналитика и отчеты',
    description: 'Получайте детальную статистику по посещаемости, продажам и эффективности ваших мероприятий.'
  },
  {
    icon: Smartphone,
    title: 'Мобильная оптимизация',
    description: 'Полностью адаптивный дизайн для всех устройств с поддержкой мобильных приложений.'
  },
  {
    icon: Shield,
    title: 'Безопасность',
    description: 'Защищенные платежи, шифрование данных и соответствие международным стандартам безопасности.'
  },
  {
    icon: Zap,
    title: 'Быстрая настройка',
    description: 'Готовые шаблоны и интуитивный интерфейс позволяют создать событие за несколько минут.'
  },
  {
    icon: Globe,
    title: 'Глобальный доступ',
    description: 'Поддержка множественных языков и валют для международных мероприятий.'
  }
]

export function Features() {
  return (
    <section className="py-20 px-4 sm:px-6 lg:px-8 bg-white dark:bg-gray-900">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <motion.h2 
            className="text-3xl sm:text-4xl font-bold text-gray-900 dark:text-white mb-4"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
          >
            Все необходимое для успешного мероприятия
          </motion.h2>
          <motion.p 
            className="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.2 }}
          >
            Наша платформа предоставляет полный набор инструментов для организации, 
            продвижения и проведения мероприятий любого масштаба.
          </motion.p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              className="text-center p-6 rounded-xl bg-gray-50 dark:bg-gray-800 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200"
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
            >
              <div className="w-16 h-16 bg-primary-100 dark:bg-primary-900/30 rounded-full flex items-center justify-center mx-auto mb-4">
                <feature.icon className="w-8 h-8 text-primary-600 dark:text-primary-400" />
              </div>
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                {feature.title}
              </h3>
              <p className="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
                {feature.description}
              </p>
            </motion.div>
          ))}
        </div>

        {/* CTA секция */}
        <motion.div 
          className="text-center mt-16 p-8 bg-gradient-to-r from-primary-600 to-secondary-600 rounded-2xl text-white"
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          <h3 className="text-2xl font-bold mb-4">
            Готовы начать?
          </h3>
          <p className="text-primary-100 mb-6 max-w-2xl mx-auto">
            Присоединяйтесь к тысячам организаторов, которые уже используют нашу платформу 
            для создания незабываемых мероприятий.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <a 
              href="/register" 
              className="inline-block bg-white text-primary-600 hover:bg-gray-100 font-medium py-3 px-6 rounded-lg transition-colors duration-200"
            >
              Создать аккаунт
            </a>
            <a 
              href="/demo" 
              className="inline-block border-2 border-white text-white hover:bg-white hover:text-primary-600 font-medium py-3 px-6 rounded-lg transition-colors duration-200"
            >
              Посмотреть демо
            </a>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
