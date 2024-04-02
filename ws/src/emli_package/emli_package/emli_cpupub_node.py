import rclpy 
from rclpy.node import Node
from std_msgs.msg import Float32
import subprocess


class EMLICPUPublisher(Node):
    def __init__(self):
        super().__init__('emli_CPU_publisher')
        
        # create the publisher
        self.publisher_ = self.create_publisher(Float32, 'cpu_temperature', 10)
        
        # create a timer that calls the timer_callback() function every second
        timer_period = 1  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)
        
        
    def timer_callback(self):
        # specify the float to publish
        msg = Float32()
        msg.data = get_cpu_temperature()
        
        # publish it
        self.publisher_.publish(msg)
        # log that it was published
        self.get_logger().info('Publishing: "%f"' % msg.data)

def get_cpu_temperature():
    command = "cat /sys/class/thermal/thermal_zone*/temp | awk '{s+=$1} END {print s/NR/1000}'"
    output = subprocess.check_output(command, shell=True).decode().strip()
    return float(output)
        
        
def main(args=None):
    # initialize the node
    rclpy.init(args=args)

    # instantiate the publisher class 
    publisher = EMLICPUPublisher()

    # run the class
    rclpy.spin(publisher)
    
    # destroy the class
    publisher.destroy_node()
    rclpy.shutdown()
    
if __name__ == '__main__':
    main()