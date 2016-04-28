from scipy.misc import *
import numpy as np
import re
if __name__ == "__main__":

	with open("example_dump_1.txt",'r') as fptr:
		alllines = fptr.readlines()
	j = 0
	k = 0
	buffer1 = np.ndarray(shape=(256,256,3),dtype=np.uint8)
	buffer1.fill(0)
	buffer2 = np.ndarray(shape=(256,256,3),dtype=np.uint8)
	buffer2.fill(0)
	buffer3 = np.ndarray(shape=(256,256,3),dtype=np.uint8)
	buffer3.fill(0)
	for i in range(1, len(alllines)):
		m = re.search(r"(.*)\:(.*)\;",alllines[i])
		address = int(m.group(1))
		if (address <= 65535) and (0 <= address) : 
			j = address / 256
			k = address % 256
			buffer1[j][k][0] = int(m.group(2)[0:2],16)
			buffer1[j][k][1] = int(m.group(2)[2:4],16)	
			buffer1[j][k][2] = int(m.group(2)[4:6],16)
		elif (65536 <= address)  and (address <= 131071):			
			j = (address - 65536) / 256
			k = (address - 65536) % 256
			buffer2[j][k][0] = int(m.group(2)[0:2],16)
			buffer2[j][k][1] = int(m.group(2)[2:4],16)	
			buffer2[j][k][2] = int(m.group(2)[4:6],16)		
			
		elif (143360  <= address) and (address <= 208895):
			j = (address - 143360) / 256
			k = (address - 143360) % 256
			buffer3[j][k][0] = int(m.group(2)[0:2],16)
			buffer3[j][k][1] = int(m.group(2)[2:4],16)	
			buffer3[j][k][2] = int(m.group(2)[4:6],16)
	imsave("buffer1.png",buffer1)
	imsave("buffer2.png",buffer2)
	imsave("outputbuffer.png",buffer3)
		
