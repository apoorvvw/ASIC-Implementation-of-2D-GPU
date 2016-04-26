from scipy.misc import *
import numpy as np
import re
if __name__ == "__main__":

	with open("example_dump_1.txt",'r') as fptr:
		alllines = fptr.readlines()
	j = 0
	k = 0
	img = np.ndarray(shape=(64,64,3),dtype=np.uint8)
	for i in range(1, len(alllines)):
		m = re.search(r"\:(.*)\;",alllines[i])
		img[j][k][0] = int(m.group(1)[0:2],16)
		img[j][k][1] = int(m.group(1)[2:4],16)	
		img[j][k][2] = int(m.group(1)[4:6],16)
		k += 1
		if k == 64 :
			j += 1
			k = 0
	imsave("shu.png",img)
		
