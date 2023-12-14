import shutil

root_path = '/home/jenkins-slave/workspace/staging_prozorro_simple_defence_LLC/'
bin_path = root_path + 'bin'
dev_eggs_path = root_path + 'develop-eggs'
eggs_path = root_path + 'eggs'

try:
    shutil.rmtree(bin_path)
except OSError as e:
    print(e)

try:
    shutil.rmtree(dev_eggs_path)
except OSError as e:
    print(e)

try:
    shutil.rmtree(eggs_path)
except OSError as e:
    print(e)