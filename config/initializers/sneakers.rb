Sneakers.configure  amqp: 'amqp://guest:guest@localhost:5672',
                    vhost: '/',
                    exchange: 'amq.topic',
                    exchange_type: :topic,
                    durable: true,
                    workers: 1

Sneakers.logger.level = Logger::INFO
