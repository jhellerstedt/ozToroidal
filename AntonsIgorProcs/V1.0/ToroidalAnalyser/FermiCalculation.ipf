#pragma rtGlobals=1		// Use modern global access method.

Menu "BS Calculation"
	
	"Fermi Panel", FermiPanel()
	end
end



Function CalculateFermiContour(ctrlName) : ButtonControl
	String ctrlName
	
	variable mode,i
	wave Cu3AuCoeff = root:Packages:Fermipanelglobs:Cu3AuCoeff
	wave CuCoeff = root:Packages:Fermipanelglobs:CuCoeff
	NVAR kmax = root:Packages:Fermipanelglobs:PLanarnVAL	
	NVAR deltak =root:Packages:Fermipanelglobs:DeltakVAL
	NVAR KE = root:Packages:Fermipanelglobs:HalseKEVAL
	NVAR Vo = root:Packages:Fermipanelglobs:HalseVoVAL
	NVAR size = root:Packages:Fermipanelglobs:ProjsizeVAL
	NVAR Eb = root:Packages:Fermipanelglobs:BindEnVAL
	
	
	Controlinfo/W=Fermipanel Crystaltype

	if(V_value==2)
		
		string curfolder = getdatafolder(1)
		setdatafolder root:Packages				
		string validWienlist="", destWienFol ="", fol=""
			for(i=0;i<CountObjects("",4);i+=1)
				fol = GetIndexedObjName("", 4, i)
					if(strsearch(fol, "Wien2k",0)!=-1)
						validWienlist+=fol+";"
					endif
			endfor
	
		Prompt destwienfol, "WienFolder", popup, validWienlist
		Doprompt "Select Wien Results Folder", destwienfol
			if(V_flag==0)
				Setdatafolder :$destwienfol
				NVAR fermiEn
				destWienFol = Getdatafolder(1)
				string bandlist = WaveList("band*", ";", "DIMS:3")
			else	
				DestWienFol = ""
			endif
		setdatafolder $curfolder
	
	elseif(V_value==1)
		Duplicate/O Cu3Aucoeff, ccoeff
	elseif(V_value==3)
		Duplicate/O Cucoeff, ccoeff
	endif
	
	
	//print ccoeff[7]
				
	string topfolder = getdatafolder(1)
	String Destfolder = "" //start building  a path to the place where the results will be stored
	Controlinfo/W=Fermipanel Crystaltype
	Destfolder+=S_value+"_"
	Controlinfo/w=Fermipanel Cuttype
	destfolder+=S_Value+"_" //build the foldername for the halse calculation to be stored into
	
			
		If(V_value==1) //planar cut
			Controlinfo/W = Fermipanel CrystalDirection
			destfolder+=S_Value[1,3]+"_"
			Controlinfo/w=Fermipanel Surfdirection
			Destfolder+=S_Value
		endif
		
		If(datafolderexists(destfolder))
			Setdatafolder $destfolder
		else
			Newdatafolder/S $destfolder
		endif
		
		Make/o/n=(3,3) Normcoords
		Make/O/N = (3,3) CoordsMatrix
		Normcoords = {{1,0,0},{0,1,0},{0,0,1}}
		
	
		Controlinfo/w=Fermipanel Cuttype
		
		if(V_value==2) //if Hemisphere projection is selected
			
			Controlinfo/W = Fermipanel CrystalDirection
			if(V_value==1)
				Coordsmatrix = {{1,0,0},{0,1,0},{0,0,1}} //100 face selected
			elseif(V_value==2)
				Coordsmatrix = {{-1,0,1},{1,0,1},{0,1,0}} //if 110 face is selected
			elseif(V_value==3)
				Coordsmatrix = {{-1,-1,1},{1,-1,1},{0,2,1}} //if (111) face is selected
			endif
			
			GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix
			wave/z cosmatrix
			
			Controlinfo/W=Fermipanel Crystaltype
		
			if(V_value==1)
				Duplicate/O Cu3aucoeff, ccoeff
				HalseHemisphereproject(ccoeff,cosmatrix,KE,Eb,Vo,size,deltak)
			elseif(V_value==3)
				Duplicate/O Cucoeff, ccoeff
				HalseHemisphereproject(ccoeff,cosmatrix,KE,Eb,Vo,size,deltak)
			elseif(V_value==2)
				
					
					for(i=0;i<ItemsInList(bandlist,";");i+=1)
						string path = destwienfol+StringFromList(i,bandlist)
						wave band = $path
						wave Primvectors = $(destwienfol+"Primvectors")
						WienHemisphereproject(band,Primvectors,cosmatrix, KE,Eb+FermiEn,Vo,size,deltak)
						wave/z ProjectionY, ProjectionX
						Duplicate/o ProjectionY, $("ProjectionY"+num2str(i))
						Duplicate/o ProjectionX, $("ProjectionX"+num2str(i))
					endfor
					killwaves/z ProjectionY, ProjectionX, PrimUnitCoords
					
						
					
			endif
			
			variable/g Kenergy = KE
			variable/g InnerPot=Vo
			variable/g Ebinding = Eb
		
		elseif(V_value==1) //if planar slice is selected
		
			Controlinfo/W = Fermipanel CrystalDirection
				
				if(cmpstr(S_Value,"(111)")==0) //if 111 face is selected
					Controlinfo/w=Fermipanel Surfdirection
					if(cmpstr(S_value,"GM")==0) //what surface direction has been selected. here only details for the 111 face are shown. 
						Coordsmatrix = {{-2,1,0},{1,1,1},{1,1,-1}}
					elseif(cmpstr(S_value,"GK")==0)
						coordsmatrix = {{-1,1,-1},{0,1,2},{1,1,-1}}
					elseif(cmpstr(S_value,"GM2")==0)
						coordsmatrix={{-1,1,-1},{-1,1,1},{2,1,0}}
					endif
				endif
				
				GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix
				wave/z cosmatrix
				
				
				Controlinfo/W=Fermipanel Crystaltype
				if(V_value==1)
					Duplicate/O Cu3aucoeff, ccoeff
					HalsePlanarSlice(ccoeff,cosmatrix,kmax,size,Eb) //create the projection	
				elseif(V_value==3)
					Duplicate/O Cucoeff, ccoeff
					HalsePlanarSlice(ccoeff,cosmatrix,kmax,size,Eb) //create the projection	
				elseif(v_value==2)
					for(i=0;i<ItemsInList(bandlist,";");i+=1)
						path = destwienfol+StringFromList(i,bandlist)
						wave band = $path
						wave Primvectors = $(destwienfol+"Primvectors")
						WienPlanarSlice(band,Primvectors,cosmatrix,kmax,size,Eb+FermiEn)
						wave/z ProjectionY, ProjectionX
						Duplicate/o ProjectionY, $("ProjectionY"+num2str(i))
						Duplicate/o ProjectionX, $("ProjectionX"+num2str(i))
					endfor
					killwaves/z ProjectionY, ProjectionX, PrimUnitCoords
				endif
	
	
		endif	
		
		
		
		killwaves/z ccoef,Ccoeff,Normcoords,cosmatrix,m_product,coordsmatrix, W_findlevels
		
		Setdatafolder $topfolder
	
	
End





Function WienHemisphereproject(band,Primvectors,cosmatrix,Ek,En,Vo,s,deltak)
wave  band,Primvectors //teh se of calculatin gcoeffs for the fs..could be cu or Cu3AU
variable Ek,Vo,s,deltak, En // s is the size of the projected array, a is the lattice constant. ek the measured kinetic energy, Vo the inner potential
wave cosmatrix

variable r //the radius ofthe fre electron final state in inverse angstroms
r = 0.511*sqrt(Ek+Vo) //calculate radius of free electron final state. 
variable i,j,k,x,y,z, value

variable d = round((deltak*(s+1)/2*r)/2)
make/O/N =(s+1,s+1,2*d+1) XYProjection
Setscale/I x,-r,r, XYprojection
Setscale/I y,-r,r, XYprojection

for(k=0;k<=2*d;k+=1)
	for(i=0;i<(s+1);i+=1) 
		for(j=0;j<(s+1);j+=1)
		
	
			x = pnt2x(XYprojection,i)
			y = pnt2x(Xyprojection,j)
			
				if(d!=0)
					z = sqrt(r^2-(x^2+y^2))+deltak*((k/(d))-1)
				else
					z = sqrt(r^2-(x^2+y^2))
				endif
		
			Transcoord(cosmatrix,x,y,z) //converrt point in the hemisphere frame to one in the normal fram
		
			wave/z M_Product
		
			if(z>=0.511*sqrt(Vo))
				value = ReturnEatK(band, Primvectors, M_product)
			else 
				value = Nan
			endif

			XYprojection[i][j][k] = value //calculates the Calcres function at each point on the free electron final state sphere
		
		endfor
	endfor
endfor

FindFermiLevel(XYprojection, En) //find the fermi level contour

end

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
	

Function SelectBSFile(ctrlName) : ButtonControl
	String ctrlName
	
	variable i
	SVAR curBSname = root:Packages:Fermipanelglobs:CurBSname
	SVAR curBS = root:Packages:Fermipanelglobs:CurBS
	string curfolder = getdatafolder(1)
	string dflist=""
	Setdatafolder root:Packages:Bandstructure	
		for(i=0;i<CountObjects("", 4);i+=1) //list all currently loaded BS files
			dflist+=GetIndexedObjName("", 4, i)+";"
		endfor
	string wienwaves = ListMatch(dflist, "Wien2k*")
	string destwienfol, destfol
		
		Prompt destwienfol, "WienFolder", popup, wienwaves
		Doprompt "Select Wien Results Folder", destwienfol

			If(V_flag==0)
				Setdatafolder :$destwienfol
				CurBSname  = getdatafolder(0)
				CurBS = getdatafolder(1)
				setdatafolder $curfolder
			endif


End


Window Fermipanel() : Panel


			
			Newdatafolder/O/S root:Packages:FermiPanelGlobs
			
			string/g CurBS, CurBSname
			variable/g HalseKEVAL
			variable/g HalseVoVal
			variable/g ProjsizeVAL
			variable/g DeltaKVAL
			variable/g PLanarNVAL
			variable/g FS3dnVAL
			variable/g FS3dsizeVAL
			variable/g BindEnVal=0
			

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(0,81,597,607)
	ModifyPanel cbRGB=(48896,65280,57344)
	Dowindow/C Fermipanel
	SetDrawLayer UserBack
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 15,267,"FS Calculation Panel"
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 4,278,300,123
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 5,284,300,368
	DrawRRect 1,52,0,53
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 15,359,"3D FS Calculation"
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 7,376,299,511
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 13,500,"BZ Calculation"
	DrawLine -1.7100704908371,0.483646303415298,-1.02600967884064,1.45105445384979
	DrawLine -1.7100704908371,0.483646303415298,-1.02600967884064,1.45105445384979
	DrawLine -1.7100704908371,0.483646303415298,-1.02600967884064,1.45105445384979
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 307,4,565,278
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 4,4,299,119
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 16,111,"Crystal Info"
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 315,267,"BS Calculation"
	DrawText 134,494,"put on separate panel later"
	DrawPICT 330,298,0.859316,0.831967,Procglobal#FermiplusBZ
	SetVariable KE,pos={16,174},size={88,16},title="KE (eV)"
	SetVariable KE,value= root:Packages:FermiPanelGlobs:HalseKEVAL
	SetVariable Vo,pos={22,152},size={82,16},title="Vo (eV)"
	SetVariable Vo,value= root:Packages:FermiPanelGlobs:HalseVoVal
	PopupMenu CutType,pos={104,213},size={115,21},title="Cut Type"
	PopupMenu CutType,mode=1,popvalue="Planar",value= #"\"Planar;Free Electron Cut\""
	PopupMenu CrystalDirection,pos={138,16},size={142,21},proc=Updatesurfdirection,title="Crystal Direction"
	PopupMenu CrystalDirection,mode=3,popvalue="(111)",value= #"\"(001);(110);(111)\""
	PopupMenu Crystaltype,pos={17,15},size={89,21},title="Crystal"
	PopupMenu Crystaltype,mode=3,popvalue=" Cu",value= #"\"Cu3Au_D; Cu3Au_O; Cu\""
	SetVariable ProjSize,pos={17,132},size={122,16},title="ProjSize(pixels)"
	SetVariable ProjSize,limits={0,inf,50},value= root:Packages:FermiPanelGlobs:ProjsizeVAL
	SetVariable setvar0,pos={166,153},size={70,16},title="kmax"
	SetVariable setvar0,value= root:Packages:FermiPanelGlobs:planarNVAL
	PopupMenu SurfDirection,pos={140,44},size={141,21},title="Surface Direction"
	PopupMenu SurfDirection,mode=1,popvalue="GM",value= #"\"GM;GM2;GK\""
	SetVariable DeltaK,pos={162,132},size={74,16},title="DeltaK"
	SetVariable DeltaK,limits={0,inf,0.01},value= root:Packages:FermiPanelGlobs:DeltaKVAL
	Button CutButton,pos={13,211},size={70,20},proc=CalculateFermiContour,title="Calculate Cut"
	Button Calc3dButton,pos={15,291},size={70,20},proc=Calc3dFS,title="Calc 3d FS"
	SetVariable FS3dn,pos={102,294},size={110,16},title="n (num cells)"
	SetVariable FS3dn,value= root:Packages:FermiPanelGlobs:FS3dnVAL
	SetVariable FS3dsize,pos={124,316},size={87,16},title="size (pts)"
	SetVariable FS3dsize,value= root:Packages:FermiPanelGlobs:FS3dsizeVAL
	SetVariable BindEnVAL,pos={144,174},size={92,16},title="Eb (eV)"
	SetVariable BindEnVAL,limits={-inf,inf,0.05},value= root:Packages:FermiPanelGlobs:bindEnVAL
	Button PlotBZbutton,pos={15,389},size={60,20},proc=MakeBZ,title="Make BZ"
	Button LoadWienButton,pos={314,217},size={80,20},proc=LoadWien2k,title="Load Wien2k"
	Button button0,pos={14,425},size={70,20},proc=JoinBZPoints,title="Join Points"
	Button button1,pos={81,389},size={85,20},proc=ButtonProc,title="Display BZ Cut"
	Button button2,pos={14,454},size={50,20},proc=ReturnGindexOfCursor,title="Get Gref"
	Button SelectBSbutton,pos={318,20},size={70,20},proc=SelectBSFile,title="Set BS File"
	SetVariable CurBS,pos={313,62},size={248,16},disable=2,title="Current BS File"
	SetVariable CurBS,value= root:Packages:FermiPanelGlobs:curbsname,bodyWidth= 174
	Button button3,pos={317,90},size={80,20},proc=CalcLinBS,title="Calc BS Profile"
	PopupMenu BSCursorDir,pos={414,88},size={131,21},title="Direction"
	PopupMenu BSCursorDir,mode=1,popvalue="Horizontal",value= #"\"Horizontal;Vertical\""
	PopupMenu popup0,pos={91,426},size={178,21},title="Style"
	PopupMenu popup0,mode=1,popvalue="",value= #"\"*LINESTYLEPOP*\""
EndMacro









Function WienPlanarSlice(band,Primvectors,cosmatrix,kmax,s,En)
variable kmax,s, En
wave cosmatrix, band, Primvectors

Make/O/N = (s+1,s+1) XYprojection
Setscale/I x,-kmax,kmax,XYprojection
Setscale/I y,-kmax,kmax,XYprojection
variable x,y,z,i,j,value




for(i=0;i<dimsize(XYprojection,0);i+=1)
	x = dimoffset(XYProjection,0)+i*dimdelta(XYProjection,0)
	for(j=0;j<dimsize(XYprojection,1);j+=1)
		y = dimoffset(XYProjection,1)+j*dimdelta(XYProjection,1)
		Transcoord(cosmatrix,x,y,0)
		wave/z M_Product
		value = ReturnEatK(band, Primvectors, M_product)
		XYprojection[i][j] = value //calculates the Calcres function at each point 
		
			
	endfor
endfor

FindFermilevel(XYprojection,En)

end		

Function ReturnEatK(band, Primvectors, k)
wave k, Primvectors, band

variable energy
		
		MapktoPrimUnit(k,PrimVectors)
		wave/z Primunitcoords
		energy =  Interp3D(band, PrimUNitcoords[0], Primunitcoords[1], Primunitcoords[2])
		killwaves/z Primunitcoords
Return(energy)

End
				 

	

Function FlipSlice(ctrlName) : ButtonControl
	String ctrlName
	
	if(waveexists(ProjectionY))
		wave/z ProjectionY,ProjectionX
		
	ProjectionY[] = -ProjectionY[p]
	
	endif
	

End


Function MapktoPrimUnit(k,PrimVectors) //this function maps a point k (coords rel to unit prim basis vectors) back to coords rel to the first prim cell with the prim vectors as  the new basis
wave k //change the k point
wave PrimVectors //the wave containing the defintion of the primitive reciprocal vectors

	MatrixOP/O coords = (inv(Primvectors^t)) x k
	Wave/z coords //the absolute coordinates of the k point in terms  of the prim vectors
	Duplicate/O coords Primunitcoords
	Primunitcoords[] = (coords[p]<0)+coords[p]-trunc(coords[p])
	killwaves/Z coords
End

Function CreateKwave(kstart,kend,num) //this function returns a wave of ktriplets extending from kstart to kend
wave kstart
wave kend
variable num

	make/o/n=(num+1,3) kwave
	kwave[][] = kstart[q]+p*(kend[q]-kstart[q])/num
	
End

Function Getbandprofile(band,primvectors,kwave)
wave kwave
wave band
wave primvectors

variable i

make/o/n=(dimsize(kwave,0)) bandwave
make/o/n=3 k
	for(i=0;i<dimsize(kwave,0);i+=1)
		k[] = kwave[i][p]
		bandwave[i]  = ReturnEatK(band, Primvectors, k)
	endfor
	
end








Function LoadBS()
	variable refnum
	variable err
	string buffer
	variable curpos
	
	variable v1, v2,v3, v4, v5, v6, i,j,k,nbands,bandindex
	
	open/R/Z=2 refnum

	Err = V_Flag

	if (err == -1)
		return -1			// User cancelled.
	endif
	
	if (err != 0)
		return err
	endif
	
	Fstatus refnum
	
	Newdatafolder/O/S :$("Wien2k"+"_"+S_filename)
	variable/g FermiEn
	Make/o/n = (3,3) PrimVectors
	
	Freadline/t = (num2char(10)) refnum, buffer //read the fermi energy
	sscanf buffer, "%f", FermiEn
	
	//FermiEn   = 13.6*FermiEn
	
	for(j=0;j<3;j+=1) //read the primtive translation vectors
		Freadline/t = (num2char(10)) refnum, buffer
		sscanf buffer,"%f %f %f", v1, v2, v3
		Primvectors[j][0] = v1
		Primvectors[j][1] = v2
		Primvectors[j][2] = v3
	endfor
	
	Primvectors[] = 2*pi*1.8904*Primvectors //convert bohr^-1 to A^-1, then scale lengths by 2pi since recip space
	
	Freadline/t = (num2char(10)) refnum, buffer //read the fermi energy
	sscanf buffer,"%f %f %f %f", v1, v2, v3, v4 //read how many bands are there, and how many k points sampled along each prim vector direction
	
	nbands = v1
	
	
	for(i=0;i<nbands;i+=1) //create blank data cubes to put band info into
		Make/o/n=(v2,v3,v4) $("band"+num2str(i))
		Setscale/I x, 0,1, $("band"+num2str(i))
		Setscale/I y, 0,1, $("band"+num2str(i))
		Setscale/I z, 0,1, $("band"+num2str(i))
	endfor
	
	
	i=0
	k=0
	Do
	
		Freadline/t = (num2char(10)) refnum, buffer 
		sscanf buffer,"%f %f %f %f %f", v1, v2, v3, v4, v5 //read each abdn index, cooords, and energy
		Bandindex = v1
		wave curband = $("band"+num2str(Bandindex))
		curband[v2][v3][v4] = (v5-FermiEn)*13.6 //insert the energy data into thecurrent band cube, converting to eV. 
		Fstatus refnum
		
		if(V_filepos==V_logEOF) //iif end of file is reached
			break
		endif
		
	while(1)
	
	close refnum
	
	Setdatafolder ::
	
	
	
End

Function LoadWien2k(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = getdatafolder(1)
	Setdatafolder root:Packages:Bandstructure
		LoadBS()
	Setdatafolder $curfolder

End


Function CalcLinBS(ctrlName) : ButtonControl
	String ctrlName

	string curfolder = getdatafolder(1)
	SVAR CurBSpath = root:Packages:FermiPanelGlobs:CurBS

	if(cmpstr(CurBSpath,"")!=0) //if there is existing a current bandstructure file 
		if((cmpstr(CsrWave(A),"")!=0&&(cmpstr(CsrWave(B),"")!=0))) //if cursor A is on an active graph
	
			variable i	, start, ende
			Setdatafolder $CurBSpath
			NVAR Fermien
			wave Primvectors
			string bandlist = WaveList("band*", ";","")
		

				Newdatafolder/O/S root:Packages:Bandstructure:Calcs:BSLineProfile
				Make/o/n= 3 kstart, kend, kstartabs, kendabs
				kstart = {hcsr(A),vcsr(A),0} //create waves describing the start and end k points of the profile in the frame of reference of the graph
 				kend = {hcsr(B), vcsr(B),0} 
		
	
			Make/o/n=(3,3) coordsmatrix,normcoords
	
			Controlinfo/W = Fermipanel CrystalDirection
				
				if(cmpstr(S_Value,"(111)")==0) //if 111 face is selected
					Controlinfo/w=Fermipanel Surfdirection
					if(cmpstr(S_value,"GM")==0) //what surface direction has been selected. here only details for the 111 face are shown. 
						Coordsmatrix = {{-2,1,0},{1,1,1},{1,1,-1}}
					elseif(cmpstr(S_value,"GK")==0)
						coordsmatrix = {{-1,1,-1},{0,1,2},{1,1,-1}}
					elseif(cmpstr(S_value,"GM2")==0)
						coordsmatrix={{-1,1,-1},{-1,1,1},{2,1,0}}
					endif
				endif
	
			Normcoords = {{1,0,0},{0,1,0},{0,0,1}}
			GenCosMatrix(normcoords,coordsmatrix) //generate the cosmatrix to converrt k values from the planar frame to the global normal frame
	
			TransCoord(Cosmatrix,kstart[0],kstart[1],kstart[2]) //convert the start k point
			wave/z M_Product
			kstartabs[] = M_Product[p]
	
			TransCoord(Cosmatrix,kend[0],kend[1],kend[2]) //convert the start k point
			kendabs[] = M_Product[p]
	
			CreateKwave(kstartabs,kendabs,50) //create a wave
			wave kwave
	
				for(i=0;i<ItemsInList(bandlist);i+=1)
					wave/z band = $curBspath+StringFromList(i, bandlist,";")
					Getbandprofile(band,primvectors,kwave)
					wave bandwave
				//	setscale/I x,start, ende, bandwave
					duplicate/O bandwave $nameofwave(band)
				endfor
				
			killwaves/z normcoords, coordsmatrix, k, bandwave, kend, kstart, cosmatrix, kwave, Primunitcoords, kstartabs, kendabs,M_Product
			
			Setdatafolder $curfolder
	
			else

				Doalert 0, "Need Cursor A on Image"
			endif
	else
		Doalert 0 ,"Need to Select a BS File First!!!"
	endif
	
End
		











