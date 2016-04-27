from scipy.misc import *
import numpy as np
import re
if __name__ == "__main__":

	with open("example_dump_1.txt",'r') as fptr:
		alllines = fptr.readlines()
	j = 0
	k = 0
	buffer1 = np.ndarray(shape=(256,256,3),dtype=np.uint8)
	buffer2 = np.ndarray(shape=(256,256,3),dtype=np.uint8)
	buffer3 = np.ndarray(shape=(256,256,3),dtype=np.uint8)
	for i in range(1, len(alllines)):
		m = re.search(r"(.*)\:(.*)\;",alllines[i])
		address = int(m.group(1))
		if 0 <= address <= 65535: 
			j = address / 256
			k = address % 256
			buffer1[j][k][0] = int(m.group(2)[0:2],16)
			buffer1[j][k][1] = int(m.group(2)[2:4],16)	
			buffer1[j][k][2] = int(m.group(2)[4:6],16)
		elif 65536 <= address <= 131071:			
			j = (address - 63356) / 256
			k = (address - 63356) % 256
			buffer2[j][k][0] = int(m.group(2)[0:2],16)
			buffer2[j][k][1] = int(m.group(2)[2:4],16)	
			buffer2[j][k][2] = int(m.group(2)[4:6],16)		
			
		elif 143360  <= address <= 208895:
			j = (address - 144360) / 256
			k = (address - 144360) % 256
			buffer3[j][k][0] = int(m.group(2)[0:2],16)
			buffer3[j][k][1] = int(m.group(2)[2:4],16)	
			buffer3[j][k][2] = int(m.group(2)[4:6],16)
	imsave("buffer1.png",buffer1)
	imsave("buffer2.png",buffer2)
	imsave("outputbuffer.png",buffer3)
		
