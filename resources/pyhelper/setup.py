import setuptools

package_name="PACKAGE_NAME"

setuptools.setup(
        name=package_name,
        version='0.0.1',
        packages=setuptools.find_packages(),
        entry_points={
            'console_scripts': [ '{0:s}={0:s}:main'.format(package_name) ]
        }
    )
