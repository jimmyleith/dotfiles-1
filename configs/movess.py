import os
import shutil

take='/home/anshi/'
source=os.listdir(take)
SSfolder='/home/anshi/Pictures/SS'

for files in source:
    if files.endswith('.png'):
        shutil.move(os.path.join(take,files), os.path.join(SSfolder, files))
