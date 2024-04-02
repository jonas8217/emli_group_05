import rclpy 
from rclpy.node import Node
from std_msgs.msg import String


class EMLIPublisher(Node):
    def __init__(self):
        super().__init__('emli_publisher')
        
        # create the publisher
        self.publisher_ = self.create_publisher(String, 'emli', 10)
        
        # create a timer that calls the timer_callback() function every second
        timer_period = 1  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)
        
        
    def timer_callback(self):
        # specify the string to publish
        msg = String()
        msg.data = 'Hello EMLI World'
        
        # publish it
        self.publisher_.publish(msg)
        # log that it was published
        self.get_logger().info('Publishing: "%s"' % msg.data)
        
        
def main(args=None):
    # initialize the node
    rclpy.init(args=args)

    # instantiate the publisher class 
    publisher = EMLIPublisher()

    # run the class
    rclpy.spin(publisher)
    
    # destroy the class
    publisher.destroy_node()
    rclpy.shutdown()
    
if __name__ == '__main__':
    main()