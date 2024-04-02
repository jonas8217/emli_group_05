from setuptools import find_packages, setup

package_name = 'emli_package'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='anders',
    maintainer_email='anders@todo.todo',
    description='TODO: Package description',
    license='TODO: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'emli_node = emli_package.emli_node:main',
            'emli_pub_node = emli_package.emli_pub_node:main',
            'emli_sub_node = emli_package.emli_sub_node:main',
            'emli_cpupub_node = emli_package.emli_cpupub_node:main'
        ],
    },
)
