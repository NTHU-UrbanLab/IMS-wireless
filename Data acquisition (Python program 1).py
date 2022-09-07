import serial # 0.0.97
import numpy # version 1.19.0
import matplotlib.pyplot as plt # version 3.3.2
import dropbox # version 10.7.0
import time
import serial.tools.list_ports # 0.0.97
import os
from dropbox.files import WriteMode # version 10.7.0

startTime = time.time()
# define the function to find arduino port
def find_port(serial_number):
    for port in serial.tools.list_ports.comports():
        if port.serial_number == serial_number:
            return serial.Serial(port.device)
# define function to upload the file to Dropbox
# Reference: https://stackoverflow.com/questions/23894221/upload-file-to-my-dropbox-from-python-script
class TransferData:
    def __init__(self, access_token):
        self.access_token = access_token

    def upload_file(self, file_from, file_to):
        # upload a file to Dropbox using API v2
        dbx = dropbox.Dropbox(self.access_token)
        with open(file_from, 'rb') as f:
            dbx.files_upload(f.read(), file_to, mode = dropbox.files.WriteMode.overwrite)

# connect to arduino uno (MCB1 for gps & temp)       
try:
    arduino2 = find_port(serial_number = '55834323832351B06141')
    arduino2.baudrate = 115200
    arduino2.timeout = 3
    print(arduino2)
except:
    time.sleep(1)

# acquire GPS data and temperature data from MCB1
time.sleep(3)
arduino2.write(b'g')
time.sleep(1)
c = arduino2.readline()
c = c.decode()
c = c.rstrip()
arduino2.close()
# connect to MCB2 for temperature and relative humidity of drift gas
arduino = find_port(serial_number = '754393239353511121E2')
arduino.baudrate = 115200
arduino.timeout = 3
print(arduino)
for i in range(2):
    arduino.write(b'3')
    time.sleep(1)
    a = arduino.readline()
    a = a.decode()
    a = a.rstrip()
    b = arduino.readline()
    b = b.decode()
    b = b.rstrip()
if a =='':
   print('b')
else:
    e = arduino.readline()
    e = e.decode()
    e = e.rstrip()
arduino.close()
print(a)
print(e)
# create data matrix
drifttime = numpy.zeros((1575,1))
raw = numpy.zeros((1575,1))
# connect to arduino due (MCB2 for data acquisition)
arduino = find_port(serial_number = '754393239353511121E2')
arduino.baudrate = 115200
arduino.timeout = 3
print(arduino.open)
arduino.write
time.sleep(1)
# '0' for low resolution, '1' for medium resolution, '2' for high resolution
arduino.write(b'1')
time.sleep(2)
for k in range(1575):
    b = arduino.readline()
    b = b.decode()
    b = b.rstrip()
    b = b.split(",")
    drifttime[k][0] = b[0]
    print(b[0])
    print(b[1])
    raw[k][0] = b[1]
arduino.close()
# turn µs into ms
drifttime = drifttime / 1000
# subtract the baseline and turn the intensity into voltage
avr = numpy.mean(raw[0:175][0])
avr = ((raw-avr)/4096)*3.3
filetime = time.strftime('%Y%m%d_%H%M%S')
filetime = time.strftime('%Y%m%d_%H%M%S')

# IMS plot (show and saved)
plt.plot(drifttime, avr, 'b')
plt.xlabel("Drift time / ms")
plt.ylabel("Voltage / V")
plt.title("Medium Resolution Ion-Mobility Spectrum")
plt.savefig("/home/linaro/Desktop/Data/%s.png" %(filetime), bbox_inches='tight')
plt.show(block = False)
plt.pause(3)
plt.close()
print("/home/linaro/Desktop/Data/%s.png" %(filetime))

# save as a .txt file
savefilepath ="/home/linaro/Desktop/Data/"
os.chdir('/home/linaro/Desktop/Data/')
i=1
while os.path.exists("IMS%s.txt" %(i)):
    i+=1
    print(i)
print(i)
savefilename = str("IMS%s.txt" %(i))
filename = savefilepath + savefilename
file = open(filename,mode = 'w')
file.write("NTHU PU-LAB PORTABLE CLOUD-INTEGRATED PEN-PROBE ANALYZER DATA \n")
file.write("Date")
file.write(time.strftime('%Y/%m/%d \n'))
file.write("Time")
file.write(time.strftime('%H:%M:%S \n'))
file.write(c)
file.write("\n")
file.write("Humidity of drift gas:"+" "+a)
file.write("\t")
file.write("Temperature of drift gas:"+" "+ e +"°C")
file.write("\n")
file.write("================================================================")
file.write("\n")
file.write("DT/ms   V/V")
file.write("\n")
file.write("================================================================")
file.write("\n")
for m in range(1400):
    file.writelines(str(float(drifttime[m])) + '\t' + str(round(float(avr[m]),3)) + '\n')
file.close()
print(filename + " " + "has been saved successfully")
# upload to Dropbox
# Reference: https://stackoverflow.com/questions/23894221/upload-file-to-my-dropbox-from-python-script
access_token = 'L_vkZ7RTFrAAAAAAAAAAGAbFteFGT4--UULYMfGjcsKvrIUn0_3aJiS4-WM6IR5r'
transferData = TransferData(access_token)
file_from = filename
filetarget = '/test_dropbox/' + savefilename
file_to = filetarget # The full path to upload the file to, including the file name
transferData.upload_file(file_from, file_to)
