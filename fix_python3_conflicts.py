# op_tests remove decode
# Read in the file
import os
import shutil

with open("bin/op_tests", 'r') as file:
    filedata = file.read()

# Replace the target string
filedata = filedata.replace(".decode('utf-8')", '')

# Write the file out again
with open("bin/op_tests", 'w') as file:
    file.write(filedata)

# openprocurement_client/utils.py substitute basestring for str
# Read in the file
with open("src/openprocurement_client/openprocurement_client/utils.py", 'r') as file:
    filedata = file.read()

# Replace the target string
filedata = filedata.replace("basestring", 'str')

# Write the file out again
with open("src/openprocurement_client/openprocurement_client/utils.py", 'w') as file:
    file.write(filedata)

# src/openprocurement_client/openprocurement_client/resources/tenders.py substitute basestring for str
# Read in the file
with open("src/openprocurement_client/openprocurement_client/resources/tenders.py", 'r') as file:
    filedata = file.read()

# Replace the target string
filedata = filedata.replace("basestring", 'str')

# Write the file out again
with open("src/openprocurement_client/openprocurement_client/resources/tenders.py", 'w') as file:
    file.write(filedata)

# rebot update output function
# Read in the file
with open("bin/rebot", 'r') as file:
    filedata = file.read()

# Replace the target string
filedata = filedata.replace("robot.rebot.rebot_cli()", 'robot.rebot_cli()')

# Write the file out again
with open("bin/rebot", 'w') as file:
    file.write(filedata)

# Clean workspace
if os.path.exists('test_output'):
    shutil.rmtree('test_output')

# Add permission to selenium-manager
file_path = '/home/jenkins-slave/.buildout/eggs/selenium-4.9.1-py3.9.egg/selenium/webdriver/common/linux/selenium-manager'
if os.path.exists(file_path):
    permissions = 0o755  # Give read, write, and execute permissions to the owner, and read and execute permissions to others

    # Add permissions to the file
    os.chmod(file_path, permissions)



