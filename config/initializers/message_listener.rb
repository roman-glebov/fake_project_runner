class MessageListener
  EXCHANGE_NAME = 'amq.topic'.freeze

  def initialize(event_publisher: EventRegister.new, event_listener: EventListener.new)
    @event_publisher ||= event_publisher
    @event_listener ||= event_listener
  end

  def self.call
    new.call
  end

  def call
    event_publisher.subscribe(event_listener)
    EventRegister::ROUTING_COLLECTION.each { |routing| queue.bind(exchange, routing_key: routing) }
    queue.subscribe do |delivery_info, _properties, payload|
      event_publisher.publish(delivery_info[:routing_key], payload: JSON.parse(payload))
    end
  end

  private

  attr_reader :event_publisher, :event_listener

  def exchange
    @exchange ||= channel.topic(EXCHANGE_NAME)
  end

  def queue
    @queue ||= channel.queue('', exclusive: true)
  end

  def channel
    @channel ||= connection.create_channel
  end

  def connection
    @connection ||= Bunny.new.tap(&:start)
  end
end

MessageListener.call
