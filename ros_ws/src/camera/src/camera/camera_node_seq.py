import thread
import io

import rospy

from sensor_msgs.msg import Image, CompressedImage, CameraInfo
from sensor_msgs.srv import SetCameraInfo, SetCameraInfoResponse

from picamera import PiCamera
from picamera.array import PiRGBArray

class CameraNode(object):
    """ Pi_Camera ROS Node
    Based on https://github.com/duckietown/Software/blob/master/catkin_ws/src/pi_camera/src/camera_node_sequence.py
    """
    def __init__(self):
        self.node_name = rospy.get_name()
        rospy.loginfo("[%s] Initializing......" %(self.node_name))
        self.is_shutdown = False
        self.update_framerate = False
        self.has_published = False

        self.framerate_high = self.setup_param("~framerate_high", 30.0)
        self.framerate_low = self.setup_param("~framerate_low", 15.0)
        self.res_w = self.setup_param("~res_w", 640)
        self.res_h = self.setup_param("~res_h", 480)

        self.stream = io.BytesIO()
        self.image_msg = CompressedImage()

        self.camera = PiCamera()
        self.framerate = self.framerate_high # default to high
        self.camera.framerate = self.framerate
        self.camera.resolution = (self.res_w, self.res_h)

        self.frame_id = rospy.get_namespace().strip('/') + "/camera_optical_frame"

        # Create service (for camera_calibration)
        # self.srv_set_camera_info = rospy.Service("~set_camera_info", SetCameraInfo, self.cbSrvSetCameraInfo)

        # Create Publisher
        self.pub_img = rospy.Publisher("~image/compressed", CompressedImage, queue_size=1)
        # self.sub_switch_high = rospy.Subscriber("~framerate_high_switch", BoolStamped, self.cbSwitchHigh, queue_size=1)
        # Setup timer
        rospy.loginfo("[%s] Initialized." %(self.node_name))

    def setup_param(self, param_name, default_value):
        """Get param_name from ROS and push to Parameter server
        param_name -- parameter name
        default_value -- default value
        """
        value = rospy.get_param(param_name, default_value)
        rospy.set_param(param_name, value) # Write to parameter server for transparancy
        rospy.loginfo("[%s] %s = %s " %(self.node_name, param_name, value))
        return value

    def start_capturing(self):
        """Start capturing and streaming images"""
        rospy.loginfo("[%s] Start capturing." %(self.node_name))
        # rate = rospy.Rate(10) # 10hz - should match framerate
        while not self.is_shutdown and not rospy.is_shutdown():
            next_stream = self.get_next_stream()
            try:
                self.camera.capture_sequence(
                    next_stream, 'jpeg',
                    use_video_port=True, splitter_port=0)
            except StopIteration:
                pass

            self.camera.framerate = self.framerate
            self.update_framerate = False
            # rate.sleep()

        self.camera.close()
        rospy.loginfo("[%s] Capture Ended." %(self.node_name))

    def get_next_stream(self):
        """Generates a new 'stream' sequence and then waits for data.
        Once the data is received, it is Published and a new 'stream' sequence is generated."""
        while not self.update_framerate and not self.is_shutdown and not rospy.is_shutdown():
            yield self.stream # publish a new 'stream' sequence to capture the next image into

            self.stream.seek(0) # reset the stream to extract the captured image
            # Generate compressed image
            image_msg = CompressedImage()
            image_msg.header.stamp = rospy.Time.now()
            image_msg.header.frame_id = self.frame_id
            image_msg.format = "jpeg"
            image_msg.data = self.stream.getvalue()

            self.pub_img.publish(image_msg)

            # Clear stream
            self.stream.seek(0)
            self.stream.truncate()

            if not self.has_published:
                rospy.loginfo("[%s] Published the first image." %(self.node_name))
                self.has_published = True

            rospy.sleep(rospy.Duration.from_sec(0.001))

    def on_shutdown(self):
        """ Called by ROS when shutting down"""
        rospy.loginfo("[%s] Closing camera." %(self.node_name))
        self.is_shutdown = True
        rospy.loginfo("[%s] Shutdown." %(self.node_name))


def main():
    """Initialize ROS node"""
    rospy.init_node('camera', anonymous=False)

    camera_node = CameraNode()
    rospy.on_shutdown(camera_node.on_shutdown)
    thread.start_new_thread(camera_node.start_capturing, ())
    rospy.spin()


if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
