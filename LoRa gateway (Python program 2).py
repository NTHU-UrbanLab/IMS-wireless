import numpy as np # version 1.19.0
import os
import serial # version 0.0.97
import time
import dropbox # version 10.7.0
from dropbox.files import WriteMode # version 10.7.0

# define the function for uploading the data to the cloud
# Reference: https://stackoverflow.com/questions/23894221/upload-file-to-my-dropbox-from-python-script
class TransferData:
    def __init__(self, access_token):
        self.access_token = access_token

    def upload_file(self, file_from, file_to):
        dbx = dropbox.Dropbox(self.access_token)
        with open(file_from, 'rb') as f:
            dbx.files_upload(f.read(), file_to, mode = dropbox.files.WriteMode.overwrite)

# define the function for creating a folder
def Folder(directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
            except OSError:
                print('Error: Creating directory')
date = time.strftime('%Y%m%d')
# The folder path can be changed (depend on the user)
filepath = '/home/pi/Desktop/Python/'
if os.path.exists(filepath+date):
    print("The folder path exists\n")
else:
    Folder(date)
    print("The folder has been created")

# set an infinite loop
while True:
# define the serial port from arduino uno (MCB3)
    try:
        arduinolora = serial.Serial("/dev/ttyUSB0",115200,timeout = 1)
    except:
        time.sleep(1)
    arduinolora.open
    time.sleep(1)
    a = arduinolora.readline()
    a = a.decode()
    a = a.rstrip()
    print(a)
    b = arduinolora.readline()
    b = b.decode()
    b = b.rstrip()
    print(b)
# set two matrix for retrieving the data
    drifttime = np.zeros((1400,1))
    intensity = np.zeros((1400,1))
    c = arduinolora.readline()
    c = c.decode()
    c = c.rstrip()
    while c == '':
        print("The data is not transmitted yet")
        c = arduinolora.readline()
        c = c.decode()
        c = c.rstrip()
    c = c.split(",")
    drifttime[0][0] = c[0]
    intensity[0][0] = c[1]
# start recording the data that is received
    for i in range(1,1400):
        q = arduinolora.readline()
        q = q.decode()
        q = q.rstrip()
        if q == '':
            i = i-1
        else:
            q = q.split(",")
            drifttime[i][0] = q[0]
            print(drifttime[i][0])
            intensity[i][0] = q[1]
            print(intensity[i][0])
    arduinolora.close()
# subtract baseline and turn the intensity into voltage
    mean = np.mean(intensity[0:175][0])
    intensity = (intensity - mean)*3.3/4096
    drifttime = drifttime/1000
    filepath2 = '/home/pi/Desktop/Python/'
    filepath = filepath2 +date
    filepath1 = "/home/pi/Desktop/Python/"
    drifttime = drifttime/1000
    os.chdir(filepath)
    i = 0
    while os.path.exists("IMS%s.txt" %i):
        i+=1
    filename = str("IMS%s.txt" %i)
    filetype = ('.txt')
    filename1 = ('IMS')
    filepath2 = '/test_dropbox/'
    with open(filename, "wb") as f:
        try:
            access_token = 'L_vkZ7RTFrAAAAAAAAAAGAbFteFGT4--UULYMfGjcsKvrIUn0_3aJiS4-WM6IR5r'
            dbx = dropbox.Dropbox(access_token)
            metadata, res = dbx.files_download(path = filepath2 + filename)
            f.write(res.content)
            systemfile = open(filename)
            GPS = systemfile.readlines()
            k = GPS[3]
		f = GPS[4]
            systemfile.close()
        except:
            f = i-1
            filename9 = str("IMS%s.txt" %f)
            systemfile = open(filename9)
            GPS = systemfile.readlines()
            q = GPS[3]
f = GPS[4]
            system.close()
    savefilename = filepath1 + filename
# save the data and other environmental information into .txt file
    file = open(savefilename, mode = 'w')
    file.write("NTHU PU-LAB PORTABLE CLOUD-INTEGRATED PEN-PROBE ANALYZER DATA \n")
    file.write("Date")
    file.write(time.strftime('%Y/%m/%d \n'))
    file.write("Time")
    file.write(time.strftime('%H:%M:%S \n'))
    file.write(k)
    file.write("\n")
file.write(f)
file.write("\n")
file.write("================================================================")
    file.write("\n")
    file.write("DT/ms   V/V")
    file.write("\n")
    file.write("================================================================")
    file.write("\n")
    for m in range(0,1400):
        file.writelines(str(float(drifttime[m])) + '\t' + str(int(intensity[m])) + '\n')
    file.close()
    #upload the data file
    time.sleep(8)
# upload the data to the Dropbox with the same filename
#Reference: https://stackoverflow.com/questions/23894221/upload-file-to-my-dropbox-from-python-script
    access_token = 'L_vkZ7RTFrAAAAAAAAAAGAbFteFGT4--UULYMfGjcsKvrIUn0_3aJiS4-WM6IR5r'
    transferData = TransferData(access_token)    
    file_from = savefilename
    filetarget = '/test_dropbox/' + filename
    file_to = filetarget # The full path to upload the file to, including the file name
    transferData.upload_file(file_from, file_to)
    pythonfile = "/home/pi/Desktop/Python"
    os.chdir(pythonfile)
