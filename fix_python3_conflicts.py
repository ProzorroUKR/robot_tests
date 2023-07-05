# op_tests remove decode
# Read in the file
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
