# !!! DO NOT USE: $ python setup.py install
# !!! USE CATKIN INSTEAD: $ catkin build
# For more info, see:
#    http://docs.ros.org/api/catkin/html/user_guide/setup_dot_py.html

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

setup_args = generate_distutils_setup(
    packages=['camera'],
    #scripts=['bin/myscript'],
    #package_dir={'': 'include'}
    package_dir={'': 'src'}
)

setup(**setup_args)
