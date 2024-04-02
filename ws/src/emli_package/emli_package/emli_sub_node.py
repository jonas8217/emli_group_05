import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class EMLISubscriber(Node):
    def __init__(self):
        super().__init__('emli_subscriber')
        # create the subscriber which will call listener_callback()
        self.subscription = self.create_subscription(String,'emli',self.listener_callback,10)
        self.subscription  


    # prevent unused variable warning
    def listener_callback(self, msg):
        self.get_logger().info('I heard: "%s"' % msg.data)
            
def main(args=None):
    # initialize the node
    rclpy.init(args=args)
    
    # instantiate the publisher class
    subscriber = EMLISubscriber()
    
    # run the class
    rclpy.spin(subscriber)
    
    # destroy the class
    subscriber.destroy_node()
    rclpy.shutdown()
    
if __name__ == '__main__':
    main()
