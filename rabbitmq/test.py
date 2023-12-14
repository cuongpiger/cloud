import pika

# Establish a connection
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

# Declare a queue
channel.queue_declare(queue='my_queue')

# Publish a message
channel.basic_publish(exchange='', routing_key='my_queue', body='Hello, RabbitMQ!')

# Consume a message
def callback(ch, method, properties, body):
    print(f"Received: {body}")

channel.basic_consume(queue='my_queue', on_message_callback=callback, auto_ack=True)

# Start consuming
channel.start_consuming()
