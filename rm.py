import shutil

try:
    shutil.rmtree('bin')
except OSError as e:
    print(e)
try:
    shutil.rmtree('develop-eggs')
except OSError as e:
    print(e)
try:
    shutil.rmtree('eggs')
except OSError as e:
    print(e)