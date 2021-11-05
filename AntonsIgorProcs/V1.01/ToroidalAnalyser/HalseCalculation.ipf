#pragma rtGlobals=1		// Use modern global access method.

#include "AntonsGeneralRoutines"

Function CalculateFEFermiHalseContour(ctrlName) : ButtonControl
	String ctrlName
	
	variable mode,i
	wave Cu3AuCoeff = root:Packages:Halsepanelglobs:Cu3AuCoeff
	wave CuCoeff = root:Packages:Halsepanelglobs:CuCoeff
	
	NVAR deltak =root:Packages:Halsepanelglobs:DeltakVAL
	NVAR KE = root:Packages:Halsepanelglobs:HalseKEVAL
	NVAR Vo = root:Packages:Halsepanelglobs:HalseVoVAL
	NVAR size = root:Packages:Halsepanelglobs:ProjsizeVAL
	NVAR Eb = root:Packages:Halsepanelglobs:BindEnVAL
	
	
	Controlinfo/W=Halsepanel Crystaltype		
	string topfolder = getdatafolder(1)
	String Destfolder = "HalseFS" //start building  a path to the place where the results will be stored
	Destfolder+="_"+S_value+"_Free Electron Cut"
	
		If(datafolderexists(destfolder))
			Setdatafolder $destfolder
		else
			Newdatafolder/o/S $destfolder
		endif
		
		Make/o/n=(3,3) Normcoords
		Make/O/N = (3,3) CoordsMatrix
		Normcoords = {{1,0,0},{0,1,0},{0,0,1}}
		
		Controlinfo/W=Halsepanel Crystaltype	
			if(V_value==1)
				Duplicate/O Cu3Aucoeff, ccoeff
			elseif(V_value==2)
				Duplicate/O Cucoeff, ccoeff
			endif
			
			Controlinfo/W = Halsepanel CrystalFace
			if(V_value==1)
				Coordsmatrix = {{1,0,0},{0,1,0},{0,0,1}} //100 face selected
			elseif(V_value==2)
				Coordsmatrix = {{-1,0,1},{1,0,1},{0,1,0}} //if 110 face is selected
			elseif(V_value==3)
				Coordsmatrix = {{-1,-1,1},{1,-1,1},{0,2,1}} //if (111) face is selected
			endif
			
			GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix
			
			wave/z cosmatrix
			HalseHemisphereproject(ccoeff,cosmatrix,KE,Eb,Vo,size,deltak)
			variable/g Kenergy = KE
			variable/g InnerPot=Vo
			variable/g Ebinding = Eb
		
		killwaves/z ccoef,Ccoeff,Normcoords,cosmatrix,m_product,coordsmatrix, W_findlevels,XYProjection
		
		Setdatafolder $topfolder
	
End

Function CalculatePlanarHalseContour(ctrlName) : ButtonControl
	String ctrlName
	
	variable mode,i
	wave Cu3AuCoeff = root:Packages:Halsepanelglobs:Cu3AuCoeff
	wave CuCoeff = root:Packages:Halsepanelglobs:CuCoeff
	NVAR deltak =root:Packages:Halsepanelglobs:DeltakVAL
	NVAR Vo = root:Packages:Halsepanelglobs:HalseVoVAL
	NVAR size = root:Packages:Halsepanelglobs:ProjsizeVAL
	NVAR Eb = root:Packages:Halsepanelglobs:BindEnVAL
	NVAR kmax = root:Packages:Halsepanelglobs:kmaxVAL	
	
	string topfolder = getdatafolder(1)
	
	String Destfolder = "HalseFS_" //start building a path to the place where the results will be stored
	Controlinfo/W=Halsepanel Crystaltype		
	Destfolder+=S_value+"_"+"Planar"+"_"
	Controlinfo/W = Halsepanel CrystalFace
	destfolder+=S_Value[1,3]+"_"
	Controlinfo/w=Halsepanel Surfdirection
	Destfolder+=S_Value

		
		If(datafolderexists(destfolder))
			Setdatafolder $destfolder
		else
			Newdatafolder/o/S $destfolder
		endif
		
		Make/o/n=(3,3) Normcoords
		Make/O/N = (3,3) CoordsMatrix
		Normcoords = {{1,0,0},{0,1,0},{0,0,1}}
		
		Controlinfo/W=Halsepanel Crystaltype	
			if(V_value==1)
				Duplicate/O Cu3Aucoeff, ccoeff
			elseif(V_value==2)
				Duplicate/O Cucoeff, ccoeff
			endif
			
		Controlinfo/W = Halsepanel CrystalFace
				
				if(cmpstr(S_Value,"(111)")==0) //if 111 face is selected
					
					Controlinfo/w=Halsepanel Surfdirection
					
					if(cmpstr(S_value,"GM")==0) //what surface direction has been selected. here only details for the 111 face are shown. 
						Coordsmatrix = {{-2,1,0},{1,1,1},{1,1,-1}}
					elseif(cmpstr(S_value,"GK")==0)
						coordsmatrix = {{-1,1,-1},{0,1,2},{1,1,-1}}
					elseif(cmpstr(S_value,"GM2")==0)
						coordsmatrix={{-1,1,-1},{-1,1,1},{2,1,0}}
					endif
					
				elseif(cmpstr(S_Value,"(100)")==0)
				
					Controlinfo/w=Halsepanel Surfdirection
					if(cmpstr(S_value,"GX")==0) //what surface direction has been selected. here only details for the 111 face are shown. 
						Coordsmatrix = {{0,1,0},{1,0,0},{0,0,1}}
					elseif(cmpstr(S_value,"GM")==0)
						coordsmatrix = {{0,1,0},{1,0,-1},{1,0,1}}
					endif
				
				endif
					
				GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix
				wave/z cosmatrix
				HalsePlanarSlice(ccoeff,cosmatrix,kmax,size,Eb) //create the projection	
				variable/g Ebinding = Eb
	
		
		
		killwaves/z ccoef,Ccoeff,Normcoords,cosmatrix,m_product,coordsmatrix, W_findlevels,XYProjection
		
		Setdatafolder $topfolder
	
End


Macro HalsePanel() : Panel


string curfolder = getdatafolder(1)
	
		if(CheckName("Halsepanel", 9,"Halsepanel"))
			Dowindow/F Halsepanel
		else
			Newdatafolder/O/S root:Packages
			Newdatafolder/O/S :HalsePanelGlobs
		
			Make/O/N = 8  Cu3AuCoeff
			Cu3Aucoeff=  {0.70257,-0.0369375,-0.629,-0.0385215,-0.0840095,-0.00932025,0.0214617,3.75}
			Make/O/N = 8  CuCoeff
			CuCoeff = {1.69131,0.006574,-0.422661,-0.017235,-0.054863,-0.005457,0.014955,3.6288}
			
			string/g CurBS, CurBSname
			variable/g HalseKEVAL
			variable/g HalseVoVal
			variable/g ProjsizeVAL
			variable/g DeltaKVAL
			variable/g FS3dnVAL
			variable/g FS3dsizeVAL
			variable/g BindEnVal=0
			variable/g kmaxVAL

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(558,94,889,393)
	ModifyPanel cbRGB=(65280,65280,16384)
	Dowindow/C Halsepanel
	SetDrawLayer UserBack
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 15,283,"Halse Calculation Panel"
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 299,4,4,292
	DrawLine 20,77,275,77
	DrawLine 18,156,273,156
	SetVariable KE,pos={14,89},size={92,16},title="KE (eV)"
	SetVariable KE,value= root:Packages:HalsePanelGlobs:HalseKEVAL
	SetVariable Vo,pos={114,89},size={82,16},title="Vo (eV)"
	SetVariable Vo,value= root:Packages:HalsePanelGlobs:HalseVoVal
	PopupMenu CrystalFace,pos={142,15},size={124,21},proc=Updatesurfdirection,title="Crystal Face"
	PopupMenu CrystalFace,mode=1,popvalue="(100)",value= #"\"(100);(110);(111)\""
	PopupMenu Crystaltype,pos={17,15},size={89,21},title="Crystal"
	PopupMenu Crystaltype,mode=2,popvalue=" Cu",value= #"\"Cu3Au; Cu\""
	SetVariable ProjSize,pos={17,46},size={122,16},title="ProjSize(pixels)"
	SetVariable ProjSize,limits={0,inf,50},value= root:Packages:HalsePanelGlobs:ProjsizeVAL
	SetVariable setvar0,pos={175,167},size={70,16},title="kmax"
	SetVariable setvar0,value= root:Packages:HalsePanelGlobs:kmaxVAL
	PopupMenu SurfDirection,pos={18,164},size={139,21},title="Surface Direction"
	PopupMenu SurfDirection,mode=2,popvalue="GX",value= #"\"GM;GX\""
	SetVariable DeltaK,pos={206,89},size={74,16},title="DeltaK"
	SetVariable DeltaK,limits={0,inf,0.01},value= root:Packages:HalsePanelGlobs:DeltaKVAL
	Button FECutButton,pos={17,119},size={90,20},proc=CalculateFEFermiHalseContour,title="Calculate  FE Cut"
	SetVariable BindEnVAL,pos={172,47},size={92,16},title="Eb (eV)"
	SetVariable BindEnVAL,limits={-inf,inf,0.05},value= root:Packages:HalsePanelGlobs:BindEnVal
	Button Planarcutbutton,pos={15,200},size={120,20},proc=CalculatePlanarHalseContour,title="Calculate  Planar Cut"

	endif
	
	Setdatafolder $curfolder
	
EndMacro

Function UpdateSurfDirection(ctrlName,popNum,popStr) : PopupMenuControl //this function updates the surface direction values to reflect the face` at hand
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo/W = Halsepanel CrystalFace
			if(cmpstr(S_Value,"(111)")==0) //if 111 face is selected
				Popupmenu SurfDirection value = "GM;GM2;GK"
				Controlupdate/W=Halsepanel SurfDirection
			elseif(cmpstr(S_value,"(100)")==0)
				Popupmenu SurfDirection value = "GM;GX"
				Controlupdate/W=Halsepanel SurfDirection
			endif
				
			
End

Function CalcRes(kx,ky,kz, ccoef)
	Variable kx,ky,kz
	wave ccoef
	
	//a=2*(pi/a)

	variable a = ccoef[7]
	variable sumc
	variable cakx=cos(a*kx)
	variable caky=cos(a*ky)
	variable cakz=cos(a*kz)
	variable ca12kx=cos(a*kx/2)
	variable ca12ky=cos(a*ky/2)
	variable ca12kz=cos(a*kz/2)
	variable ca32kx=cos(3*a*kx/2)
	variable ca32ky=cos(3*a*ky/2)
	variable ca32kz=cos(3*a*kz/2)

			sumc= -ccoef[0] +(3-ca12ky*ca12kz-ca12kz*ca12kx-ca12kx*ca12ky)
			sumc+=ccoef[1]*(3-cakx-caky-cakz)
			sumc+=ccoef[2]*(3-cakx*ca12ky*ca12kz-caky*ca12kz*ca12kx-cakz*ca12kx*ca12ky)
			sumc+=ccoef[3]*(3-caky*cakz-cakz*cakx-cakx*caky)
			sumc+=ccoef[4]*(6-ca32kx*ca12ky-ca32ky*ca12kz-ca32kz*ca12kx-ca32ky*ca12kx-ca32kz*ca12ky-ca32kx*ca12kz)
			sumc+=ccoef[5]*(1-cakx*caky*cakz)
			sumc+=ccoef[6]*(6-ca32kx*caky*ca12kz-ca32ky*cakz*ca12kx-ca32kz*cakx*ca12ky-ca32kz*caky*ca12kx-ca32kx*cakz*ca12ky-ca32ky*cakx*ca12kz)
			
	return sumc
end

Function CalcK(m,n,ccoef) //a is the lattice constant and n the number if reciporcal unit cells wide the area. This evaluates the CalcRes function over the entire cube
	variable n,m
	
	wave ccoef
	variable a = ccoef[dimsize(ccoef,0)]
	make/O/N = (m+1,m+1,m+1) kmatrix 
	setscale/I x,-n*2*pi/a, n*2*pi/a, kmatrix
	setscale/I y,-n*2*pi/a, n*2*pi/a, kmatrix
	setscale/I z,-n*2*pi/a, n*2*pi/a, kmatrix
	
	kmatrix[][][]= CalcRes(pnt2x(kmatrix,p),pnt2x(kmatrix,q),pnt2x(kmatrix,r), ccoef)
	
end

Function GenerateFermi3d(kmatrix)
wave kmatrix

variable tracesize,i,j,k
variable size = dimsize(kmatrix,0)
make/O/N= (1) FermiX, FermiY, FermiZ //the XYZ triplet wave that will be eventual contour
make/O/N = (size) singlerow
Setscale/P x,dimoffset(kmatrix,0), dimdelta(kmatrix,0), singlerow


	for(j=0;j<size;j+=1)
		for(i=0;i<size;i+=1)
			
			singlerow[] = kmatrix[p][i][j]
				
					findlevels/Q singlerow,0
					
					
					 //find all x values wehre single row passes thru zero
					wave/Z W_findlevels
						if(V_flag==1) //if somewhere btween 1 and size of kmatrix crossings were found put thm into found bins
							variable num = dimsize(W_findlevels,0)
							InsertPoints 0, num, FermiX, FermiY, FermiZ
							FermiX[0,num-1] = W_findlevels[p]
							FermiY[0,num-1] = pnt2x(singlerow,i)
							FermiZ[0,num-1 ] = pnt2x(singlerow,j)
						endif
						
		endfor
	endfor
	
	DeletePoints (dimsize(FermiX,0)-1),1,FermiX, FermiY, FermiZ
	killwaves singlerow
						
						

	
					
end		

Function HalseHemisphereproject(ccoeff,cosmatrix,Ek,En,Vo,s,deltak)
wave  ccoeff,cosmatrix //teh se of calculatin gcoeffs for the fs..could be cu or Cu3AU
variable Ek,Vo,s,deltak, En // s is the size of the projected array, a is the lattice constant. ek the measured kinetic energy, Vo the inner potential

variable r //the radius ofthe fre electron final state in inverse angstroms
r = 0.511*sqrt(Ek+Vo) //calculate radius of free electron final state. 
variable i,j,k,x,y,z, value, xx,yy,zz


//variable d = round((deltak*(s+1)/2*r)/2)
make/O/N =(s+1,s+1,1) XYProjection
Setscale/I x,-r,r, XYprojection
Setscale/I y,-r,r, XYprojection

//for(k=0;k<=10;k+=1)
	for(i=0;i<(s+1);i+=1) 
		for(j=0;j<(s+1);j+=1)
		
	
			x = pnt2x(XYprojection,i)
			y = pnt2x(Xyprojection,j)
			
				
					z = sqrt(r^2-(x^2+y^2))//-deltak+(k/10)*2*deltak
				
		
			Transcoord(cosmatrix,x,y,z) //converrt point in the hemisphere frame to one in the normal fram
		
			wave/z M_Product
		
			xx = M_Product[0]
			yy = M_Product[1]
			zz=M_Product[2]
		
		
			if(z>=0.511*sqrt(Vo))
				value = CalcRes(xx,yy,zz, ccoeff)
			else 
				value = Nan
			endif

			XYprojection[i][j][k] = value //calculates the Calcres function at each point on the free electron final state sphere
		
		endfor
	endfor
//endfor

FindFermiLevel(XYprojection, En) //find the fermi level contour

end

Function HalsePlanarSlice(ccoeff,cosmatrix,kmax,s,En)
variable kmax,s, En
wave cosmatrix, ccoeff

Make/O/N = (s+1,s+1) XYprojection
Setscale/I x,-kmax,kmax,XYprojection
Setscale/I y,-kmax,kmax,XYprojection
variable x,y,z,i,j

for(i=0;i<dimsize(XYprojection,0);i+=1)
	for(j=0;j<dimsize(XYprojection,1);j+=1)
		
		Transcoord(cosmatrix, pnt2x(XYprojection,i),pnt2x(XYprojection,j),0)
		wave/z M_Product
		
		x= M_Product[0]
		y=M_Product[1]
		z=M_Product[2]
		
		Xyprojection[i][j] = CalcRes(x,y,z,ccoeff)
			
	endfor
endfor

FindFermilevel(XYprojection,En)

end	

Function Calc3dFS(ctrlName) : ButtonControl
	String ctrlName
	

	Newdatafolder/O/S :Halse3dFS
	NVAR n =root:Packages:Halsepanelglobs:FS3dnVAL
	NVAR size = root:Halsepanelglobs:FS3dsizeVAL
	wave Cu3Aucoeff = root:Packages:Halsepanelglobs:Cu3AuCoeff
	wave Cucoeff = root:Packages:Halsepanelglobs:CuCoeff
	Controlinfo/W=Halsepanel Crystaltype
		if(cmpstr(S_value,"Cu3Au")==0)
			CalcK(size,n, Cu3Aucoeff)
		elseif(cmpstr(S_value,"Cu")==0)
			CalcK(size,n,Cucoeff)
		endif
	 
	wave/z kmatrix
	
	GenerateFermi3d(kmatrix)
	//killwaves kmatrix
	Setdatafolder ::

End

Static Function FindFermiLevel(matrix,level) //this finds the zero value in the matrix ad creates two wave of the coordinates of the FS contour
wave matrix
variable level //the value to look for at the fermi level

Make/O/N =(0) ProjectionX , ProjectionY
Make/O/N =(dimsize(matrix,0)) onedrow
Setscale/P x,dimoffset(Xyprojection,0),dimdelta(Xyprojection,0), onedrow
variable i,j,k,num

for(j=0;j<=dimsize(matrix,2);j+=1)
	for(i=0;i<(dimsize(matrix,0));i+=1) //detect all values = 0 of the resultant projection array
		
		onedrow[]  = matrix[i](pnt2x(onedrow,p))[j]
		findlevels/Q onedrow, level
		wave/Z W_findlevels
						if(V_flag==1) //if somewhere btween 1 and size of kmatrix crossings were found put thm into found bins
							num = dimsize(W_findlevels,0)
							InsertPoints 0, num, ProjectionX, ProjectionY
							ProjectionY[0,num-1] = W_findlevels[p]
							ProjectionX[0,num-1] = dimoffset(XYprojection,0) +i*dimdelta(XYprojection,0)
						endif
				
						
	endfor
	
	for(i=0;i<(dimsize(matrix,0));i+=1) //detect all values = 0 of the resultant projection array
		
		onedrow[]  = matrix(pnt2x(onedrow,p))[i][j]
		findlevels/Q onedrow, level
		wave/Z W_findlevels
						if(V_flag==1) //if somewhere btween 1 and size of kmatrix crossings were found put thm into found bins
							num = dimsize(W_findlevels,0)
							InsertPoints 0, num, ProjectionX, ProjectionY
							ProjectionX[0,num-1] = W_findlevels[p]
							ProjectionY[0,num-1] = dimoffset(XYprojection,0) +i*dimdelta(XYprojection,0)
						endif
				
						
	endfor
endfor
	
	killwaves onedrow

	
End function
	
	
		
	
