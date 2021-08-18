#pragma rtGlobals=1		// Use modern global access method.

Function CreateImage(imagewave)
wave imagewave

Make/o/n=(Dimsize(imagewave,0),dimsize(imagewave,1)) Image
Image[][] = (imagewave[p][q][0]+imagewave[p][q][1]+imagewave[p][q][2])/3

End





