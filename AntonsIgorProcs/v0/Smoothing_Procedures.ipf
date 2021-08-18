#pragma rtGlobals=1		// Use modern global access method.

//make/O/I/N=(5,5)  Swave


Function genS(Swave,m,n)
	Variable m,n
	Wave Swave
	Variable i=-m, j=-n,k=0,l=0,ifac,jfac
	Swave=0

	do
		l=0
		do
			i=-m
			do
				j=-n
				do
					if (i==0 && k==0) 
						ifac=1
					else 
						ifac =i^(k)
					endif
					
					if(j==0 && l==0) 
						jfac=1
					else 
						jfac =j^(l)
					endif
					
					Swave[k][l]+=ifac*jfac
				//	print i,j,k,l,Swave[k][l]
					j+=1
				while (j<n+1)
				i+=1
			while (i<m+1)
			l+=2
		while (l<5)
		k+=2
	while (k<5)

	end



Function Gencoeff(Sinv,m,n)
	Wave Sinv
	Variable m,n
	
	Wave Stermarray=:Stermarray
	Variable i=0
	make/O/D/N=(2*m+1,2*n+1) coeffmatrix
	
	coeffmatrix=0
	
	GenSterms(m,n,0,0)
	coeffmatrix=Sinv[0][0]*Stermarray
	GenSterms(m,n,0,2)
	coeffmatrix+=Sinv[0][1]*Stermarray
	GenSterms(m,n,2,0)
	coeffmatrix+=Sinv[0][2]*Stermarray
	genSterms(m,n,2,2)
	coeffmatrix+=Sinv[0][3]*Stermarray

end

Function GenSterms(m,n,r,s)
	variable m,n,r,s

	variable i,j,ifac,jfac
	string genname = "Stermarray"

	make/O/D/N=(2*m+1,2*n+1) Stermarray
	Stermarray=0
	
			i=-m
			do
				j=-n
				do
					if (i==0 && r==0) 
						ifac=1
					else 
						ifac =i^(r)
					endif
					
					if(j==0 && s==0) 
						jfac=1
					else 
						jfac =j^(s)
					endif
					
					Stermarray[i+m][j+n]=ifac*jfac
					j+=1
				while (j<n+1)
				i+=1
			while (i<m+1)
end
 

Function Smoothcoefs()
	
	variable m,n
	prompt m, "m dimension"
	prompt n, "n dimension"
	Doprompt "dimensions of smoothing template", m, n
	variable cancel = V_Flag //if procedure was cancelled
	
	if(cancel==0) 
	
	Variable i=0,j=0
	string df=GetDataFolder(1)
	NewDataFolder/O/S root:Smoothing
	make/O/D/N=(5,5) Swave
	make/O/D/N=(4,4) SMatrix,Smatrixcopy
	genS(Swave,m,n)
	
//	Allocate the values generated in Swave to the components in SMatrix

	SMatrix[0][0] = Swave[0][0]
	SMatrix[1][0] = Swave[2][0]
	SMatrix[2][0] = Swave[2][0]
	SMatrix[3][0] = Swave[2][2]
	SMatrix[0][1] = Swave[2][0]
	SMatrix[1][1] = Swave[4][0]
	SMatrix[2][1] = Swave[2][2]
	SMatrix[3][1] = Swave[4][2]
	SMatrix[0][2] = Swave[2][0]
	SMatrix[1][2] = Swave[2][2]
	SMatrix[2][2] = Swave[4][0]
	SMatrix[3][2] = Swave[4][2]
	SMatrix[0][3] = Swave[2][2]
	SMatrix[1][3] = Swave[4][2]
	SMatrix[2][3] = Swave[4][2]
	SMatrix[3][3] = Swave[4][4]
	
	smatrixcopy=smatrix
	make/O/D/N=(4,4) unitmatrix
	unitmatrix=0
	
	unitmatrix[0][0]=1;unitmatrix[1][1]=1;unitmatrix[2][2]=1;unitmatrix[3][3]=1
	
//	detemine inverse.  found in M_B	
	MatrixLLS smatrix,unitmatrix
	gencoeff(M_B,m,n)
	SetDataFolder df
	
	endif
	
	return V_Flag
	
end macro

//This function smooths the data using coeffmatrix and overwrites the wave.
Function SmoothARUPS(smdata)
	wave smdata
	
	Wave coeffmatrix=root:Smoothing:coeffmatrix //need to have the wave coeeff wave existing
	variable mrows=DimSize(smdata,0)-1,ncols=DimSize(smdata,1)-1//determine size of data matrix-1
	variable msmooth=DimSize(coeffmatrix,0),nsmooth=Dimsize(coeffmatrix,1)//determine size of coeff matrix
	variable i=0,j=0,k=0,l=0,iindex=0,jindex=0										//create indexes
	variable mval=floor((msmooth-1)/2),nval=floor((nsmooth-1)/2)	//set m x n values
//	print mval,nval,mrows,ncols
	duplicate/O smdata smcopy
	smdata=0
	
	for (i=0;i<mrows+1;i+=1)
//		print i
		for(j=0;j<ncols+1;j+=1)
//			print j
			for(k=-mval;k<(mval+1);k+=1)				
				iindex=i+k
				if(iindex>mrows||iindex<0) 	
					iindex=Foldcoord(iindex,mrows)
				endif
//				print "iind ",iindex," k ",k
				for(l=-nval;l<(nval+1);l+=1)					
					jindex=j+l
					if(jindex>ncols||jindex<0) 	
						jindex=Foldcoord(jindex,ncols)
					endif
//					print "jind ",jindex," l ",l
					smdata[i][j]+=smcopy[iindex][jindex]*coeffmatrix[k+mval][l+nval]
				endfor
			endfor
//			print smcopy[i][j]
		endfor
	endfor
end

Function SmoothARUPS2(smdata)
wave smdata

wave coeffmatrix=root:Smoothing:coeffmatrix
MatrixConvolve coeffMatrix, smdata

end
	