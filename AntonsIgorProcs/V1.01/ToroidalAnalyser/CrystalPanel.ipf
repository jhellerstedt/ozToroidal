#pragma rtGlobals=1		// Use modern global access method.\

#include "AntonsGeneralRoutines"



Function GenerateCrystalPanel()

string curfolder = getdatafolder(1)
	
	if(CheckName("CrystalPanel", 9,"CrystalPanel"))
	
		Dowindow/F CrystalPanel
		
	else
		
			Newdatafolder/O/S root:Packages
			Newdatafolder/O/S root:Packages:CrystalPanelGlobs
	
			
			variable/g SurfX1VAL, SurfX2VAL, SurfX3VAL
			variable/g SurfY1VAL, SurfY2VAL, SurfY3VAL
			variable/g NormXVAL,NormYVAL,NormZVAL //the global variable for the crystal
			
		
			variable/g aVAL,bVAL,cVAL
			Variable/g alphaVAL, betaVAL, gamaVAL
			variable/g HemiVoVAL,HemiKEVAL,HemisizeVAL
			Newdatafolder/O/S :BZGen
		
			Newdatafolder/o/s :BZgen_fcc
			Make/o/n=3 A1,A2,A3	
			
			A1 = {1,1,-1}
			A2 = {1,-1,1}
			A3 = {-1,1,1}
			
			Setdatafolder ::
			
			Newdatafolder/o/s :BZGen_bcc
		
			Make/o/n=3 A1,A2,A3
	
			A1 ={0,1,1}
	
			A2 ={1,0,1}
	
			A3 ={1,1,0}
	
			Setdatafolder ::
		
			Newdatafolder/o/s :BZgen_sc
		
			Make/o/n=3 A1,A2,A3
		
			A1 ={1,0,0}
		
			A2 ={0,1,0}
			
			A3 ={0,0,1}
		
			Setdatafolder ::
			
		Newdatafolder/o/s :BZgen_hex
		
			Make/o/n=3 A1,A2,A3
			A1 ={1,-1/sqrt(3),0}
			A2 ={1,1/sqrt(3),0}
			A3 ={0,0,1}
			Setdatafolder ::

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(310,76,633,548)
	Dowindow/C CrystalPanel
	ModifyPanel cbRGB=(48896,49152,65280)
	SetDrawLayer UserBack
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 141,133,"X"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 140,162,"Y"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 160,131,"["
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 160,160,"["
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 301,163,"]"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 301,132,"]"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 140,162,"Y"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 301,163,"]"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 160,80,"["
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 301,83,"]"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 146,81,"n"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 146,75,"^"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 141,133,"X"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 140,162,"Y"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 160,131,"["
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 301,163,"]"
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 14,312,"Crystal System Information"
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 319,3,8,320
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 318,328,8,464
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 17,454,"Brillioun Zone Plotting"
	SetDrawEnv fstyle= 5
	DrawText 21,218,"Crystal"
	SetDrawEnv fstyle= 5
	DrawText 21,238,"Dimensions"
	DrawLine 11,184,306,184
	DrawLine 13,100,308,100
	DrawLine 16,47,311,47
	DrawLine 16,284,311,284
	PopupMenu CrystalFace,pos={39,63},size={90,21},proc=WPanelSCFunction,title="Face"
	PopupMenu CrystalFace,fStyle=0
	PopupMenu CrystalFace,mode=2,popvalue="(110)",value= #"\"(100);(110);(111)\""
	SetVariable SurfX3,pos={258,117},size={41,19},title=" "
	SetVariable SurfX3,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable SurfX3,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:SurfX3VAL,noedit= 1
	SetVariable SurfY3,pos={258,145},size={41,19},title=" "
	SetVariable SurfY3,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable SurfY3,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:SurfY3VAL,noedit= 1
	SetVariable SurfX1,pos={170,116},size={41,19},title=" "
	SetVariable SurfX1,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable SurfX1,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:SurfX1VAL,noedit= 1
	SetVariable SurfY1,pos={170,145},size={41,19},title=" "
	SetVariable SurfY1,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable SurfY1,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:SurfY1VAL,noedit= 1
	SetVariable SurfX2,pos={214,116},size={41,19},title=" "
	SetVariable SurfX2,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable SurfX2,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:SurfX2VAL,noedit= 1
	SetVariable SurfY2,pos={214,145},size={41,19},title=" "
	SetVariable SurfY2,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable SurfY2,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:SurfY2VAL,noedit= 1
	PopupMenu SurfDirection,pos={17,116},size={112,21},proc=WPanelSCSurfDirChanged,title="Surface Dir"
	PopupMenu SurfDirection,fStyle=0,mode=1,popvalue="GM",value= #"\"GM;GX\""
	PopupMenu Mode,pos={15,142},size={114,21},proc=WpanelModeChanged,title="Mode"
	PopupMenu Mode,fSize=12,fStyle=0
	PopupMenu Mode,mode=1,bodyWidth= 82,popvalue="Simple",value= #"\"Simple;Advanced\""
	SetVariable NormZ,pos={258,65},size={41,19},title=" "
	SetVariable NormZ,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable NormZ,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:NormZVAL,noedit= 1
	SetVariable NormX,pos={170,65},size={41,19},title=" "
	SetVariable NormX,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable NormX,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:NormXVAL,noedit= 1
	SetVariable NormY,pos={214,65},size={41,19},title=" "
	SetVariable NormY,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable NormY,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:NormYVAL,noedit= 1
	PopupMenu System,pos={76,20},size={177,24},proc=WPanelCrysSysChange,title="Crystal System"
	PopupMenu System,fSize=14,fStyle=1
	PopupMenu System,mode=1,bodyWidth= 69,popvalue="sc",value= #"\"sc;bcc;fcc;Hex;Tetrag;Rhombo;\""
	SetVariable a,pos={142,198},size={80,19},title="a",labelBack=(65535,65535,65535)
	SetVariable a,fSize=14,fStyle=1
	SetVariable a,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:aVAL
	SetVariable c,pos={141,250},size={81,19},disable=2,title="c"
	SetVariable c,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable c,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:cVAL,noedit= 1
	SetVariable b,pos={142,225},size={80,19},disable=2,title="b"
	SetVariable b,labelBack=(52224,52224,52224),fSize=14,frame=0,fStyle=1
	SetVariable b,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:bVAL,noedit= 1
	SetVariable alpha,pos={237,198},size={73,20},title="a"
	SetVariable alpha,labelBack=(52224,52224,52224),font="Symbol",fSize=14,frame=0
	SetVariable alpha,fStyle=1
	SetVariable alpha,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:alphaVAL,noedit= 1
	SetVariable beta,pos={240,225},size={70,20},title="b"
	SetVariable beta,labelBack=(52224,52224,52224),font="Symbol",fSize=14,frame=0
	SetVariable beta,fStyle=1
	SetVariable beta,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:betaVAL,noedit= 1
	SetVariable gamma,pos={241,251},size={69,20},title="g"
	SetVariable gamma,labelBack=(52224,52224,52224),font="Symbol",fSize=14,frame=0
	SetVariable gamma,fStyle=1
	SetVariable gamma,limits={-inf,inf,0},value= root:Packages:CrystalPanelGlobs:gamaVAL,noedit= 1
	Button PlotBZbutton,pos={18,338},size={122,22},proc=MakePlanarBZ,title="Generate Planar BZ"
	Button button1,pos={18,371},size={85,20},proc=DispBZresults,title="Display BZ Cut"
	Button button0,pos={120,372},size={70,20},proc=JoinBZPoints,title="Join Points"
	PopupMenu popup0,pos={207,372},size={102,21},title="Style"
	PopupMenu popup0,mode=1,bodyWidth= 74,popvalue="",value= #"\"*LINESTYLEPOP*\""
	Button button2,pos={19,402},size={50,20},proc=ReturnGindexOfCursor,title="Get Gref"


	endif
	
	setdatafolder $curfolder
End
Function WPanelCrysSysChange(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo/W=CrystalPanel system

	if(cmpstr(S_value,"sc")==0) //simple cubic system selected
		
		Popupmenu Crystalface value = "(100);(110);(111)", proc = WPanelSCFunction
		Popupmenu SurfDirection, proc = WPanelSCSurfDirChanged
	
	elseif(cmpstr(S_value,"bcc")==0)  //bcc cubic system selected
		
		
		Popupmenu Crystalface value =  "(100);(110);(111)", proc = WPanelBCCFunction
		Popupmenu SurfDirection, proc = WpanelBCCSurfDirChanged
	
	elseif(cmpstr(S_value,"fcc")==0) ///fcc cubic system selected
	
		
		Popupmenu Crystalface value =  "(100);(110);(111)", proc = WPanelFCCFunction
		Popupmenu SurfDirection, proc = WpanelFCCSurfDirChanged
	
	elseif(cmpstr(S_value,"hex")==0) 
	
		
		///Popupmenu Crystalface value =  "(100);(110);(111)", proc = FCCrystalfaceFunction
	
	endif

	ControlUpdate/W=CrystalPanel Crystalface ///force update3 of the Surface direction. updates values 

End



Function WPanelSCFunction(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	string face = popstr
	
		if(cmpstr(face,"(111)")==0)
			PopupMenu SurfDirection value="GM;GM2;GK"
			
		elseif(cmpstr(face,"(100)")==0)
			PopupMenu SurfDirection value="GM;GX"
		endif
		
	WPanelUPdateCrysNormToGlobals(str2num(face[1]),str2num(face[2]),str2num(face[3]))

	
end

Function WPanelBCCFunction(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	string face = popstr
		
		if(cmpstr(face,"(111)")==0)
			PopupMenu SurfDirection value="GM;GM2;GK"
		elseif(cmpstr(face,"(100)")==0)
			PopupMenu SurfDirection value="GM;GX"
		endif
	WPanelUPdateCrysNormToGlobals(str2num(face[1]),str2num(face[2]),str2num(face[3]))
end



Function WPanelFCCFunction(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	string face = popstr
	
	
	
		if(cmpstr(face,"(111)")==0)
			PopupMenu SurfDirection value="GM;GM2;GK"
		elseif(cmpstr(face,"(100)")==0)
			PopupMenu SurfDirection value="GM;GX"
		endif
		
	WPanelUPdateCrysNormToGlobals(str2num(face[1]),str2num(face[2]),str2num(face[3]))

end
	

Function WPanelSCSurfDirChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo crystalface
	string face = S_value
	Make/o/n=(2,3) SurfCoordswave
	string direction  = popstr
	
		if(cmpstr(face,"(111)")==0)
			
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{-2,1},{1,1},{1,1}}
				elseif(stringmatch(direction,"GM2"))
					Surfcoordswave  = {{-1,1},{-1,1},{2,1}}
				elseif(stringmatch(direction,"GK"))
					Surfcoordswave = {{-1,1},{0,1},{1,1}}
				endif
							
		elseif(cmpstr(face,"(100)")==0)
	
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{0,1},{1,0},{1,0}}
				elseif(stringmatch(direction,"GX"))
					Surfcoordswave = {{0,1},{1,0},{0,0}}
				endif
				
		endif
		
		WPanelUpdateSurfCoordtoGlobals(Surfcoordswave)
		Controlupdate/A/W= CrystalPanel
		killwaves Surfcoordswave
		
end
		
Function WPanelFCCSurfDirChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo crystalface
	string face = S_value
	Make/o/n=(2,3) SurfCoordswave
	string direction  = popstr
		
		if(cmpstr(face,"(111)")==0)
			
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{-2,1},{1,1},{1,1}}
				elseif(stringmatch(direction,"GM2"))
					Surfcoordswave  = {{-1,1},{2,1},{-1,1}}
				elseif(stringmatch(direction,"GK"))
					Surfcoordswave = {{-1,1},{0,1},{1,1}}
				endif
					
		elseif(cmpstr(face,"(100)")==0)
	
				if(stringmatch(direction,"GX"))
					Surfcoordswave =  {{0,1},{1,0},{1,0}}
				elseif(stringmatch(direction,"GM"))
					Surfcoordswave = {{0,1},{1,0},{0,0}}
				endif
				
		endif
		
		WPanelUpdateSurfCoordtoGlobals(Surfcoordswave)
		Controlupdate/A/W= CrystalPanel
		killwaves Surfcoordswave
		
end

Function WPanelBCCSurfDirChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	

	Controlinfo crystalface
	string face = S_value
	Make/o/n=(2,3) SurfCoordswave
	string direction  = popstr
		
		if(cmpstr(face,"(111)")==0)
			
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{-2,1},{1,1},{1,1}}
				elseif(stringmatch(direction,"GM2"))
					Surfcoordswave  = {{-1,1},{-1,1},{2,1}}
				elseif(stringmatch(direction,"GK"))
					Surfcoordswave = {{-1,1},{0,1},{0,1}}
				endif
					
		elseif(cmpstr(face,"(100)")==0)
	
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{0,1},{1,0},{1,0}}
				elseif(stringmatch(direction,"GX"))
					Surfcoordswave = {{0,1},{1,0},{0,0}}
				endif
				
		endif
		
		WPanelUpdateSurfCoordtoGlobals(Surfcoordswave)
		Controlupdate/A/W= CrystalPanel
		killwaves Surfcoordswave
		
end

Function WPanelUPdateCrysNormToGlobals(X,Y,Z)
variable X,Y,Z
	
	variable/g root:Packages:CrystalPanelGlobs:NormXVAL = X
	variable/g root:Packages:CrystalPanelGlobs:NormYVAL = Y
	variable/g root:Packages:CrystalPanelGlobs:NormZVAL = Z

End
	
Function WPanelUpdateSurfCoordtoGlobals(Surfcoordswave)
wave surfcoordswave

	variable/g root:Packages:CrystalPanelGlobs:SurfX1VAL = Surfcoordswave[0][0]
	variable/g root:Packages:CrystalPanelGlobs:SurfX2VAL = Surfcoordswave[0][1]
	variable/g root:Packages:CrystalPanelGlobs:SurfX3VAL = Surfcoordswave[0][2]
	variable/g root:Packages:CrystalPanelGlobs:SurfY1VAL = Surfcoordswave[1][0]
	variable/g root:Packages:CrystalPanelGlobs:SurfY2VAL = Surfcoordswave[1][2]
	variable/g root:Packages:CrystalPanelGlobs:SurfY3VAL = Surfcoordswave[1][2]


End

Function WPanelReadSurfCoordFromGlobals() 

Make/o/n=(2,3) SurfCoordswave

NVAR SurfX1VAL  = root:Packages:CrystalPanelGlobs:SurfX1VAL
NVAR SurfX2VAL= root:Packages:CrystalPanelGlobs:SurfX2VAL
NVAR SurfX3VAL= root:Packages:CrystalPanelGlobs:SurfX3VAL
NVAR SurfY1VAL= root:Packages:CrystalPanelGlobs:SurfY1VAL
NVAR SurfY2VAL= root:Packages:CrystalPanelGlobs:SurfY2VAL
NVAR SurfY3VAL= root:Packages:CrystalPanelGlobs:SurfY3VAL

Surfcoordswave[0][0]= SurfX1VAL
Surfcoordswave[0][1]= SurfX2VAL
Surfcoordswave[0][2]= SurfX3VAL
Surfcoordswave[1][0]= SurfY1VAL
Surfcoordswave[1][1]= SurfY2VAL
Surfcoordswave[1][2]= SurfY3VAL


end

Function WpanelModeChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	If(stringmatch(popstr,"Simple")) //if using simple mode
		popupmenu crystalface disable = 0
		popupmenu surfdirection disable = 0
		SetVariable SurfX1 noedit=1,frame=0,labelBack=(52224,52224,52224)
		Setvariable SurfX2 noedit=1,frame=0,labelBack=(52224,52224,52224)
		Setvariable SurfX3 noedit=1,frame=0,labelBack=(52224,52224,52224)
		Setvariable SurfY1 noedit=1,frame=0,labelBack=(52224,52224,52224)
		Setvariable SurfY2 noedit=1,frame=0,labelBack=(52224,52224,52224)
		Setvariable SurfY3 noedit=1,frame=0,labelBack=(52224,52224,52224)
		
		// when i have worked out a method for general faces i will enable theecontrols below
		
		//Setvariable NormX noedit=1,frame=0,labelBack=(52224,52224,52224)
		//Setvariable NormY noedit=1,frame=0,labelBack=(52224,52224,52224)
		//Setvariable NormZ noedit=1,frame=0,labelBack=(52224,52224,52224)

	elseif(stringmatch(popstr,"Advanced"))
	
		popupmenu crystalface disable = 2
		popupmenu surfdirection disable = 2
		SetVariable SurfX1 noedit = 0, frame=1,labelBack=(65535,65535,65535)
		Setvariable SurfX2 noedit = 0, frame=1,labelBack=(65535,65535,65535)
		Setvariable SurfX3 noedit = 0, frame=1,labelBack=(65535,65535,65535)
		Setvariable SurfY1 noedit = 0, frame=1,labelBack=(65535,65535,65535)
		Setvariable SurfY2 noedit = 0, frame=1,labelBack=(65535,65535,65535)
		Setvariable SurfY3 noedit = 0, frame=1,labelBack=(65535,65535,65535)
		
		//when i have worked out a method for general faces i will enable theecontrols below
		
		Setvariable NormX noedit = 0, frame=1,labelBack=(65535,65535,65535)
		Setvariable NormY noedit = 0, frame=1,labelBack=(65535,65535,65535)
		Setvariable NormZ noedit = 0, frame=1,labelBack=(65535,65535,65535)
		
		
	endif
	
end
		

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



Function Dup2dBZ(InplaneG,Vy,Vx,n) //this function duplicates a BZ into multiple waves for plotting onto data. as yet, have not yet figured out how to make i ctinous wave
wave InplaneG //the wave of all the G's that were converted earlier
wave Vy,Vx //the vertices found earlier
variable n //how many permutations you want (how many BZs)
string namex,namey
variable i,j
Make/o/n=(dimsize(Vx,0)) trans1, trans2
	
	for(j=1;j<n;j+=1)	
		for(i=0;i<dimsize(InplaneG,0);i+=1)
		
			namex = "BZx"+num2str(j)+num2str(i)
			namey = "BZy"+num2str(j)+num2str(i)
			
			trans1[] = (Vx[p]+j*InplaneG[i][0])
			trans2[] =(Vy[p]+j*InplaneG[i][1])
			Duplicate/O trans1 $namex
			Duplicate/O trans2 $namey
			
	
			endfor
	endfor
	
	Duplicate trans1, BZx00
	Duplicate trans2 BZy00
	BZx00 = Vx[p]
	BZy00 = Vy[p]
	Killwaves trans1,trans2

	end


Function VectorsinPlane(vectors,planenorm,Porigin) //this function creates a subwave out of vectors which are those vectors lying in plane
wave vectors //these are a set of vectors , of which, some will lie in the plane defined by plane and Porigin
wave planenorm //normal vector to the plane
wave Porigin //point plane passes through

variable i
variable LHS,RHS
make/o/n = (0,3) InPlaneV
make/o/n = 0 InplaneVRef //thi is a wave that contains the row numbers of all the vertices within the plane in the wave "vectors"


for(i=0;i<dimsize(vectors,0);i+=1)
	LHS = planenorm[0]*vectors[i][0]+planenorm[1]*vectors[i][1]+planenorm[2]*vectors[i][2]//solving the plane equation. Note in nw coord system z axis is 001 if g vectors are in plane, LHS should be zero  vectors[i][0]*plane[2][0]+vectors[i][1]*plane[2][1]+
	RHS = planenorm[0]*Porigin[0]+planenorm[1]*Porigin[1]+planenorm[2]*Porigin[2]
		if(abs(LHS-RHS)<0.01)
			insertpoints 0,1,InplaneV
			insertpoints 0,1,InplaneVRef
			InplaneV[0][] = vectors[i][q]
			InplaneVRef[0] = i
		endif
		
endfor

end

Function GetGsInPlane(Gwave,Plane) //this function creates a wave of the G vectors in the plane, and also trnaforms them into Gevectors relative ot the plane
wave Gwave
wave Plane //

variable i

make/o/n = 3 planenormal
planenormal[] = plane[2][p] //get normal vector of plane
make/o/n=3 Porigin
Porigin = 0 
Make/o/n = (3,3) Normcoords
Normcoords = {{1,0,0},{0,1,0},{0,0,1}}

VectorsinPlane(Gwave,planenormal,Porigin)
wave InPLaneV ///the wave of the G vectors in the plane
wave InplaneVref //the wave describing the row location in Gwave of those vectors

make/o/n = (dimsize(InplaneV,0)) InplaneGx,InPlaneGy

GenCosMatrix(plane,normcoords)
wave/z cosmatrix

for(i=0;i<dimsize(InplaneV,0);i+=1)

	TransCoord(Cosmatrix,InplaneV[i][0],InplaneV[i][1],InplaneV[i][2])
	wave M_Product
	InplaneGx[i] = M_Product[0]
	InplaneGy[i] = M_Product[1]

endfor

Duplicate/O InplaneV, InplaneG
Duplicate/O InplaneVref, InplaneGref
killwaves/z InplaneV, InplaneVRef, normcoords, Porigin
	
End	
	
	
	
	
	
	
	endfor




End



Function PermuteBasis(A1,A2,A3,n,symm) //this function permutes a set of basis g vectors into an extended set used for 3 way plane intersections later
wave A1,A2,A3
variable n,symm
//the rangein k space for valid g vectors so space doesnt get too large

	variable i,j,k,flag=0

	make/o/n= (0,3) Gwave, Gwave_ind// the wave of g vectors calculated from the basis and permuted n times

	for(i=-n;i<=n;i+=1)
		for(j=-n;j<=n;j+=1)
			for(k=-n;k<=n;k+=1)
			//	if((i==0)&&(j==0)&&(k==0))
					//print "origin"
				//else
					insertpoints/M=0 0,1,Gwave, Gwave_ind
					Gwave[0][] = i*A1[q]+j*A2[q]+k*A3[q] //get all linear combinations of the g vectors (restriced span of the basis)
					Gwave_ind[0][0] = i
					Gwave_ind[0][1] = j
					Gwave_ind[0][2] = k
				//endif
			endfor
		endfor
	endfor

	Deletepoints/M=0 dimsize(gwave,0),1,Gwave //correct for the crap insertion error

	if(symm) //if foldeing and symmetrising the permutation
		foldgwave(gwave)
		foldgwave(Gwave_ind)
	else
		Filtercopies3d(gwave)
		Filtercopies3d(gwave_ind)
	endif	

end

Function FoldGwave(gwave)
wave gwave
		
		variable size = dimsize(gwave,0)
		Duplicate/o Gwave, Gwavetemp
		
		insertpoints/m=0 0,size,gwave
		Gwave[0,size-1][]= gwavetemp[p][q]
		Gwave[0,size-1][0] = -gwavetemp[p][0]
		
		insertpoints/m=0 0,size,gwave
		Gwave[0,size-1][]= gwavetemp[p][q]
		Gwave[0,size-1][1] = -Gwavetemp[p][1]
		
		insertpoints/m=0 0,size,gwave
		Gwave[0,size-1][]= gwavetemp[p][q]
		Gwave[0,size-1][2] = -Gwavetemp[p][2]
		
	FilterCopies3d(Gwave)
	killwaves gwavetemp

end

Function ReturnGindexOfCursor(ctrlName) : ButtonControl
	String ctrlName
	
	string curfol = getdatafolder(1)
	wave destwave = CsrWaveref(A,"")
	Setdatafolder $GetWavesDataFolder(destwave,1)
	wave InPlaneG
	wave Gwave_Ind
	variable row, gindex
	make/o/n=3 position
	wave A1, A2, A3
	Make/o/n=(3,3) Gbasis
	Gbasis[0][] = A1[q]
	Gbasis[1][] = A2[q]
	Gbasis[2][] = A3[q]
	
		if(waveexists(InplaneGref))
			row = pcsr(A)
			position[] = InplaneG[row][p]
			SolveLinearEqn(Gbasis,position)
			wave M_B
			Print M_B[0], M_B[1], M_B[2]
			
			
		else
			Doalert 0, "Not valid wave"
		endif
			
		
End







Function SolveLinearEqn(M,B) //this function returns the solution 9(if any) to the equation Mx=B. It sets three x,y,z globals if solved and returns a flag that the solution exists
wave M,B

variable num = matrixdet(M)
	if(num!=0)
	
	variable solved,i
	MatrixLLS M B
	if(V_flag!=0)
	//	print V_flag
	endif
	wave M_B
	for(i=0;i<3;i+=1)
		if(abs(M_B[i])<1e-5)
			M_B[i]=0
		endif
	endfor
	
 	variable/g x = M_B[0]
	variable/g y = M_B[1]
	variable/g z =M_B[2]
	solved=1
	
else 
	solved =0
endif
	
return(solved)

End Function


Function FindALLVertices(Gwave)
wave Gwave//th wave of the Gvectors used to calculate the planes of intersection. 

Make/o/n=(3,3) LHSMatrix //a blank matrix in which the solutions will be computed for intersecting 3 planes
Make/o/n=3 RHSmatrix
Make/o/n=(3,3,0) VertDefWave
Make/o/n=(0,3) Vwave
variable i,j,k

variable ng = dimsize(Gwave,0) //the number of g vectors
variable solved 


for(i=0;i<ng;i+=1) //this complex looking loop basically runs through all possble combinations of three intersecting planes to find the common unique point of intersection
		LHSmatrix[0][] = Gwave[i][q] //plane normal defined by the G vector
		RHSmatrix[0] = 0.5*(Gwave[i][0]^2+Gwave[i][1]^2+Gwave[i][2]^2) //since plane passes through point 0.5*G normal to G

	for(j=(i+1);j<ng;j+=1)
			LHSmatrix[1][] = Gwave[j][q]
			RHSmatrix[1] = 0.5*(Gwave[j][0]^2+Gwave[j][1]^2+Gwave[j][2]^2)
			
		for(k=(j+1);k<ng;k+=1)
				
				LHSmatrix[2][] = Gwave[k][q]
				RHSmatrix[2] = 0.5*(Gwave[k][0]^2+Gwave[k][1]^2+Gwave[k][2]^2)
				
				solved = SolvelinearEqn(LHSmatrix, RHSmatrix) ///if solution exists
				NVAR x
				NVAR y
				NVAR z
				if(solved==1)
					Insertpoints/m=2 0,1,VertDefWave
					Insertpoints/m=0 0,1,Vwave
					Vertdefwave[][][0] = LHSmatrix[p][q]
					Vwave[0][0] = x
					Vwave[0][1] = y
					Vwave[0][2] =z
				endif
		endfor
	endfor
endfor
	string str ,value

		for(i=0;i<dimsize(Vwave,0);i+=1)
			for(j=0;j<dimsize(Vwave,1);j+=1)
			//	Value = num2str(Vwave[i][j])
				sprintf  value, "%.4f", Vwave[i][j]
				Vwave[i][j] = str2num(value)
			endfor
		endfor

	deletepoints/m=2 dimsize(Vwave,0),1,Vertdefwave
	killwaves/Z LHSmatrix,RHSmatrix, M_A, M_B
//this eliminates the slight differneces between the existing numbers in the10th dec place

end


			


Function GetBZVertices3d(Gwave,Vwave) //this function sifts through the vertices found and obtains the ones which constitute the first BZ 
wave Gwave,Vwave//,Vertdefwave	//waves Vx,Vy, and Vz will contain BZ vertices amongst others


variable Nullnorm 
Variable Gnorm
variable i,j,on,x,y,z
Make/O/N=0 badindex


//now remove the vertices definitions

for(i=0;i<dimsize(Vwave,0);i+=1) //run thru all vertexes
	x = Vwave[i][0]
	y = Vwave[i][1]
	z = Vwave[i][2]
	on = OnBZ(x,y,z,Gwave,0.005)
	if(on==0) //if vertex is not on the first BZ.ie point is closer to some other G point than the origin. 
		insertpoints 0,1,badindex
		badindex[0] = i
	endif
endfor

	Sort/R badindex,badindex //sort the bad indexes form highest to lowest
	//print dimsize(badindex,0)
	
		for(i=0;i<dimsize(badindex,0);i+=1) //kill the bad points
		//	Deletepoints/M=2 badindex[i],1,Vertdefwave
			deletepoints/m=0 badindex[i],1,Vwave
		endfor
	Filtercopies3d(Vwave)//final states are stored in the wave Vwave.Filter out the duplicate points
	wave/Z copyindex
		for(i=0;i<dimsize(copyindex,0);i+=1)
			//deletepoints/m=2 copyindex[i],1,Vertdefwave
		endfor
		
	killwaves/z badindex, copyindex
End


Function OnBZ(x,y,z,Gwave,corr) //this function determines whether a point (x,y,z) lies within the first BZ centred at the origin
variable x,y,z
wave gwave
variable corr

variable i,j,nullnorm,Gnorm, on=1

	
		i=0
		nullnorm = sqrt(x^2+y^2+z^2) //get distance of vertex from the origin
			Do
				Gnorm = sqrt((x-Gwave[i][0])^2+(y-Gwave[i][1])^2+(z-Gwave[i][2])^2) //get distance of point from each other "G centre"
				if((Gnorm+corr)<nullnorm) //if point is closer to some other G centre
					on=0
					Break 
					
				endif
			i+=1	
			while(i<dimsize(Gwave,0))
			
Return on

End

Function CreateTriangleWave(Vwave,BZG) ///this function creates the vertices of triangles making up the surface of the polyhedra BZ
wave Vwave,BZG //Vwave is the XYZ triplet wave identifying the  vertices of the BZ

	variable i,j
	make/o/n=3 G,halfG
	Make/o/n=(0,3) TriWave //the wave containing row references to the vertices defining the triangles making up the surfaces

	
		for(i=0;i<dimsize(BZG,0);i+=1)
			G[] = BZG[i][p]
			halfG = 0.5*G
			VectorsinPlane(Vwave,G,halfG)
			wave/Z inplaneVref
			wave/z InplaneV
			if(dimsize(InplaneV,0)>2) //if the amount of vectors found in the plane is greater than2 ie a planar surface is really found
				
				SortByAngleInPlane(InplaneV,G,HalfG) //this should sort the vectors in plane according to angle and also sort the ref wave as well. this is important
				insertpoints 0,(dimsize(InplaneV,0)-2), Triwave //make room for (foundpoints-2) triangles
				for(j=0;j<(dimsize(InplaneV,0)-2);j+=1)
					Triwave[j][0] = InplaneVref[0]
					Triwave[j][1] = InplaneVref[j+1]
					Triwave[j][2] = InplaneVref[j+2]
				endfor
				
			endif
		endfor
	
	killwaves/z G,halfg,Vxplane,Vyplane,Vzplane
	Killwaves/Z InplaneV,InplaneVRef,anglewave,normcoords,cosmatrix

					
End



Function FindFirstBZ(A1,A2,A3) //returns the first BZ from a primitive recicporcal basis
wave A1,A2,A3 //refers to the real space lattice type
variable a //lattice constant

			PermuteBasis(A1,A2,A3,1,0) //make G lattice out of the basis
			wave/z Gwave

			FindALLVertices(Gwave) //find all intersection points between 3 interecting planes defd by the perpendicular bisectros of G vectors
			wave/z Vwave,VertDefwave
			killwaves vertdefwave
			
			GetBZVertices3d(Gwave,Vwave) //get those lying in the first BZ.
		
			FindBZG(Vwave,Gwave) //this then finds the G vectors defining the faces of the first BZ
			wave BZG
			
			
			
end


	

Function ScaleVertices(Vx,Vy,Vz,a) //this function returns the scaled vertices using a lattice constant parameter
wave Vx,Vy,Vz
variable a

Vx[] = 2*pi/a*Vx[p]
Vy[] = 2*pi/a*Vy[p]
Vz[] = 2*pi/a*Vz[p]

End

Function Translate3dBZ(Vwave,BZG,Gwave) //this function creates 2 waves. Translates the basic BZ by the set of G vectors to get a total vertex wave. Also creates a wave of all the midpoints of the faces of the the BZs
wave BZG //the set of G vectors defining  the faces of the BZ
wave Gwave //set of points used in translating the BZ in 3d
wave Vwave //wave of all the vertices in the BZ

Make/O/N= (0,3) BZFace3d,BZcentre3d, BZVertices3d
variable numg = dimsize(BZG,0)
variable numv = dimsize(Vwave,0)

variable i

	for(i=0;i<dimsize(Gwave,0);i+=1)
		Insertpoints 0,numg, BZface3d,BZCentre3d
		INsertpoints 0,numv, BZVertices3d
		BZface3d[0,numg-1][] = 0.5*BZG[p][q]+Gwave[i][q]
		BZvertices3d[0,numv-1][] = bzvertices3d[p][q]+Gwave[i][q]
		BZCentre3d[0,numg-1][]  = Gwave[i][q]
		
	Endfor
	


End

Function WhichG(x,y,z,Gwave)// this function returns the row reference number of the G vector in Gwave closest to the point (x,y,z) in question.
variable x,y,z
wave Gwave

	make/o/n=(dimsize(Gwave,0)) magwave
	magwave[] = sqrt((x-Gwave[p][0])^2+(y-Gwave[p][1])^2+(z-Gwave[p][2])^2) //get a wave of the distance of the point (x,y,z) from each of the G points
	wavestats/Q magwave
	killwaves magwave

return V_minloc //return the index of the Gwave where the minimum distance was found
End


Function BZplane(plane,Gwave,BZG)
wave plane //orthogonal srt of vectors defining the x, y and normal to the plane directions
wave Gwave,BZG
variable a

	string curfolder = getdatafolder(1)
	variable valid,solved,i,j,k,bznum=0,l
	string namex,namey
	
	
  	GetGsInPlane(Gwave,Plane)
	wave InplaneGx, INplaneGy
  	
	Make/O/N=(3,3) normcoords
	Make/O/N=3 Porigin
	Normcoords={{1,0,0},{0,1,0},{0,0,1}}
	Porigin[] = 0
	
	make/o/n=3 G
	Make/O/N=3 RHSmatrix
	Make/O/N=(3,3) LHSmatrix
	Make/o/n=(0) BZResX,BZResY
	
	LHSmatrix[0][] = Plane[2][q] //this part of the matrix descibes the plane of interest
	RHSmatrix[0] = 0
	
	
	for(i=0;i<dimsize(Gwave,0);i+=1) //run through all the G centres
		G[]=Gwave[i][p]
		make/o/n=(0,3) solwave
		Gencosmatrix(plane, normcoords)
		wave/z cosmatrix
		
		for(j=0;j<dimsize(BZG,0);j+=1) //find the intersection points between all pairs of planes and the plane of interest centred on this G.
				LHSmatrix[1][] = BZG[j][q]
				RHSmatrix[1] = BZG[j][0]*(0.5*BZG[j][0]+G[0])+BZG[j][1]*(0.5*BZG[j][1]+G[1])+BZG[j][2]*(0.5*BZG[j][2]+G[2])
			
			for(k=(j+1);k<dimsize(BZG,0);k+=1)
				
					LHSmatrix[2][] = BZG[k][q]
					RHSmatrix[2] = BZG[k][0]*(0.5*BZG[k][0]+G[0])+BZG[k][1]*(0.5*BZG[k][1]+G[1])+BZG[k][2]*(0.5*BZG[k][2]+G[2])
				
					solved = SolvelinearEqn(LHSmatrix, RHSmatrix) 
					NVAR x
					NVAR z
					NVAR y

					if(solved==1)//if solution exists
						string value
						sprintf  value, "%.4f", x
						x = str2num(value)
						sprintf  value, "%.4f", y
						y = str2num(value)
						sprintf  value, "%.4f", z
						z = str2num(value)
						
						Valid = OnBZ(x-G[0],y-G[1],z-G[2],Gwave,0.005) //is the intersection of the planes lying on the BZ of interest?
							if(valid==1) //point lies on the BZ ie is part of the BZ
								insertpoints/m=0 0,1,solwave
								solwave[0][0] =x
								solwave[0][1] = y
								solwave[0][2] = z
								
							endif
					endif
			endfor
		endfor
		
			if(dimsize(solwave,0)>2) //if the number of found points is greater than 2
					Filtercopies3d(solwave)
				
					for(l=0;l<dimsize(solwave,0);l+=1)
				
						TransCoord(cosmatrix,solwave[l][0],solwave[l][1],solwave[l][2]) //convert the found points into coordinates in the plane
						wave/z M_Product
						solwave[l][] = M_Product[q]
				
					endfor	
					
					Filtercopies2d(solwave)
					variable numfound = numpnts(solwave)
					Insertpoints 0,numfound, BZResX, BZResY
					BZResX[0,numfound-1] = solwave[p][0]
					BZResY[0,numfound-1] = solwave[p][1]
					
				//	FindcommonCentre(solwave)
				//	//wave/z comcentre
					//Make/o/n = 3 Norm1
				//	Norm1 = {0,0,1}
				//	SortByAngleInPlane(solwave,Norm1, comcentre) //sort the points of intersection by angle in the plane
					
					
				//	Make/o/n=(dimsize(solwave,0)) solx,soly
				//	solx[] = solwave[p][0]
					//soly[] = solwave[p][1]
				//	insertpoints/m=0 0,1,solx,soly
				//	solx[0] = solwave[dimsize(solwave,0)][0]
				//	soly[0]  = solwave[dimsize(solwave,0)][1]
				//	namex = "BZ"+num2str(bznum)+"x"
				////	namey =  "BZ"+num2str(bznum)+"y"
				//	Duplicate/O solx, $namex
				//	Duplicate/O soly, $namey
					//Duplicate/O comcentre, $(namex+"centre")
				//	Duplicate/O comcentre[1], $(namey+"centre")
			//		bznum+=1
			endif
					killwaves/z solx,soly,solwave
					Gencosmatrix(Plane,Normcoords) 
					wave/z cosmatrix
	endfor
End
		

Function FindCOM(X,Y,Z) //this function finds the centre of mass of a colleciton of points 
wave X,Y,Z //x,y, and z values of the points
					
					make/o/n= 3 COM
					COM[0] = sum(X, 0,dimsize(X,0)-1)/dimsize(x,0)
					COM[1]= sum(Y, 0,dimsize(Y,0)-1)/dimsize(x,0)
					COM[2] = sum(Z, 0,dimsize(Z,0)-1)/dimsize(x,0)
					
End


Function SortByAngleInPlane(Vwave,planenormal, Porigin) //sorts a set of points previously determined to be in a plane  according to the angle relative to the vector V1-Porigin, where Porigin is an arbitrary origin inthe plane aswell
wave Vwave,planenormal, Porigin


	variable i,angle

	Make/o/N=(3,3) normcoords
	Normcoords={{1,0,0},{0,1,0},{0,0,1}} ///create the norm coords wave


	make/o/n= (dimsize(Vwave,0)) Vxwave,Vywave,Vzwave
	Vxwave[] = Vwave[p][0]
	Vywave[] =Vwave[p][1]
	Vzwave[] =Vwave[p][2]

	make/o/N=(dimsize(Vwave,0)) Anglewave
		Make/o/n=3 RefV //get a ref vector in the plane to calc vectors rel to. 
	Make/o/n=(3,3) PlaneCoords
	duplicate/O Vwave, Vwave2

	RefV[0] = Vwave[0][0]-Porigin[0]
	RefV[1] = Vwave[0][1]-Porigin[1]
	RefV[2] = Vwave[0][2]-Porigin[2]
	Planecoords[0][] = RefV[q]
	PlaneCoords[2][] = planenormal[q]
	Planecoords[1][0] = (RefV[1]*planenormal[2])-(RefV[2]*planenormal[1]) //generate up a right angled coord system to provide angle calc
	Planecoords[1][1] = (RefV[2]*planenormal[0])-(RefV[0]*planenormal[2])
	Planecoords[1][2] = (RefV[0]*planenormal[1])-(RefV[1]*planenormal[0])
	
	GenCosMatrix(normcoords, planecoords) //calculate the conversion between values in the noorm frame and in the rigt angle frame defined by plane normal, RefV and ross product of normal andRefV
	
	wave/z Cosmatrix
	
		for(i=0;i<dimsize(Vwave,0);i+=1)
			TransCoord(cosmatrix,Vwave2[i][0],Vwave2[i][1],Vwave2[i][2])
			wave/z M_Product
			Vwave2[i][0] = M_Product[0]
			Vwave2[i][1] = M_product[1]
			Vwave2[i][2] = M_Product[2]
		endfor
		
	Anglewave[] = atan2(Vwave2[p][1],Vwave2[p][0])
	
	wave/z inplaneVref	
		if(WaveExists(InplaneVRef)) //in case someone has used the Vectorsinplane routine, can sort the
			wave/z InplaneVRef
			Sort Anglewave Vxwave,Vywave,Vzwave,InplaneVRef,anglewave
		else
			Sort Anglewave Vxwave,Vywave, Vzwave, anglewave
		endif
	Vwave[][0] = Vxwave[p]
	Vwave[][1] = Vywave[p]
	Vwave[][2] = Vzwave[p]
	killwaves/z Vwave2,RefV,planecoords,M_Product,Vxwave,Vywave,Vzwave
	

End


	
Function ConvertGs(plane,Gwave,normcoords)
wave plane,gwave,normcoords //convert a set of G values to one relative to this new coordinate system

Make/O/N = (dimsize(Gwave,0),dimsize(Gwave,1)) GwaveCon
Gencosmatrix(Plane,Normcoords) //calculate the direction cosine matrix between the coordinates in the plane of interest and the coord system t which the g vectros are currrely based
wave/z cosmatrix
 //convert the Gwave into Gs relative to the coord system at hand
Variable i,j,k
	Wave/z M_Product

	for(i=0;i<dimsize(Gwave,0);i+=1) //transform the Gwave into one which is rotated relative tothe coordinate system
		Transcoord(cosmatrix,Gwave[i][0],Gwave[i][1],Gwave[i][2])
		Wave/z M_Product
		GwaveCon[i][] = M_Product[q]
	endfor
	
	
End	 


Function HemiProjBZ(ctrlName) : ButtonControl
	String ctrlName
	
		NVAR Vo= root:Packages:CrystalPanelGlobs:HemiVoVAL
		NVAR KE= root:Packages:CrystalPanelGlobs:HemiKEVAL
		NVAR size = root:Packages:CrystalPanelGlobs:HemiSizeVAL
		
		variable radius = 0.511*sqrt(KE+Vo)

		string curfolder=getdatafolder(1)
		
		Controlinfo/W=CrystalPanel system
		string basisname = S_value
		
		Controlinfo/W=CrystalPanel crystalface
  	
		Make/O/N = (3,3) CoordsMatrix
		
			if(stringmatch(S_value,"(100)"))
				Coordsmatrix = {{1,0,0},{0,1,0},{0,0,1}} //100 face selected
			elseif(stringmatch(S_value,"(110)"))
				Coordsmatrix = {{-1,0,1},{1,0,1},{0,1,0}} //if 110 face is selected
			elseif(stringmatch(S_value,"(111)"))
				Coordsmatrix = {{-1,-1,1},{1,-1,1},{0,2,1}} //if (111) face is selected
			endif
	


	string dfname = "FEBZproj"+"_"+basisname
		
  	InitiateBZCalc(basisname)
  	wave A1,A2,A3,BZG,Gwave
  		
  	variable ok =0 ,i=0
  	
  		do //this loop permutes the Gvectors enough such that some lie outide the free electron radius/might need to mod this section
  	
  			i+=1
			Make/o/n=(dimsize(Gwave,0)) magwave
			magwave[] = sqrt(Gwave[p][0]^2+Gwave[p][1]^2+Gwave[p][2]^2)
			wavestats/Q Magwave
			
				if(V_max<radius)
				
					PermuteBasis(A1,A2,A3,i+1,1)
					i+=1
				
				else
					
					ok=1
				endif
		
		while(ok)


		
		Make/o/n=(0) BZprojX,BZProjY
		Make/o/n=(3,3) Normcoords
		
		Make/o/n = (3,3) Normcoords
		Normcoords = {{1,0,0},{0,1,0},{0,0,1}}
		
		GenCosMatrix(coordsmatrix,Normcoords)
		wave/z cosmatrix

		for(i=0;i<dimsize(G,0);i+=1)
			TransCoord(Cosmatrix,Gwave[i][0],Gwave[i][1],Gwave[i][2]) //convert the G vectors and BZG to vectors relative to the plane of interest. 
			wave/z M_Product
			Gwave[i][] = M_Product[q]
		endfor
	
		for(i=0;i<dimsize(BZG,0);i+=1)
			TransCoord(Cosmatrix,BZG[i][0],BZG[i][1],BZG[i][2])	
			wave/z M_Product	
			BZG[i][] = M_Product[q]
		endfor
		
	
		variable z1,z2,z3,k,x,l,m,n,y,on,j,h,z

	for(j=0;j<=s;j+=1)
		
			for(i=0;i<dimsize(Gwave,0);i+=1)
				
				for(h=0;h<dimsize(BZG,0);h+=1)
					
					l =BZG[h][0] //normal vectors to the plane.
					m = BZG[h][1]
					n = BZG[h][2]
					k = l*(0.5*BZG[h][0]+Gwave[i][0])+m*(0.5*BZG[h][1]+Gwave[i][1])+n*(0.5*BZG[h][2]+Gwave[i][2]) //point on the plane

					x = -radius+j*(2*radius)/s
					
					
					z1 = 1 + (m/n)^2 //calculate solutions for fixed x
					z2 = -2*(k*m+l*m*x)/(n^2)
					z3 = (1+(l/n)^2)*x^2-(radius^2-(k/n)^2)-(2*k*l*x/(n^2))

					if((z2^2-4*z1*z3)>=0) //find the (at most) 2 points of intersection of the sphere with the plane and check that they lie on the BZ
					
						y = (-z2-sqrt(z2^2-4*z1*z3))/(2*z1)
						z = (k-(l*x)-(m*y))/n //calc z value of the intersection
 						on = ONBZ((x-Gwave[i][0]),(y-Gwave[i][1]),(z-Gwave[i][2]),G2,0.1)
						
							if((on==1)&&(z>=0)) //if the point is on the mapped back BZ
								insertpoints 0,1,BZprojX,BZprojY
								BZprojX[0] = x
								BZProjY[1] = y
							endif
				

					endif
								
					
				endfor
			endfor
	endfor
	
	Setdatafolder ::
end
		


Function SortVerticesBySize(Vx,Vy,Vz)
wave Vx,Vy,Vz

Make/o/n=(dimsize(Vx,0)) magwave
magwave[] = sqrt((vx[p])^2+(vy[p])^2+(vz[p])^2)
Sort magwave,Vx,Vy,Vz,magwave

End

Function Filtercopies1d(wave1) //removes copies form a 1d wave
wave wave1

Sort/R wave1, wave1
variable i,j

i=0
Do
	j=i+1
	Do
		
		if(wave1[i]==wave1[j])
		deletepoints j,1,wave1
		j=i
		endif
		j+=1
	while(j<dimsize(wave1,0))
	i+=1
	while(i<dimsize(wave1,0))
End
	
	


			
Function FilterCopies3d(wave1)//this function goes throught the vertex wave and finds all points that  have the same X,Y, and Z value.
Wave wave1

make/o/n= 0,copyindex

variable i,j,k,free
for(i=0;i<dimsize(wave1,0);i+=1) //obtain al positions of duplicate points
	for(j=i+1;j<dimsize(wave1,0);j+=1)
			if((wave1[j][0]==wave1[i][0])&&(wave1[j][1]==wave1[i][1])&&(wave1[j][2]==wave1[i][2]))
				
				insertpoints 0,1,copyindex
				copyindex[0] = j
				
				
				
			endif
	endfor
endfor

Filtercopies1d(copyindex) //remove duplicate points
Sort/R copyindex,copyindex

		for(i=0;i<(dimsize(copyindex,0));i+=1)
			deletepoints copyindex[i],1,wave1
		endfor
		
	killwaves/z copyindex
End
			
Function FilterCopies2d(wave1)//this function goes throught the vertex wave and finds all points that  have the same X and Y values
wave wave1

	make/o/n= 0,copyindex
	variable i,j,k,free
		for(i=0;i<dimsize(wave1,0);i+=1) //obtain al positions of duplicate points
			for(j=i+1;j<dimsize(wave1,0);j+=1)
				if((wave1[j][0]==wave1[i][0])&&(wave1[j][1]==wave1[i][1]))
					insertpoints 0,1,copyindex
					copyindex[0] = j
				endif
			endfor
		endfor
	Filtercopies1d(copyindex) //remove duplicate points
	Sort/R copyindex,copyindex

		for(i=0;i<(dimsize(copyindex,0));i+=1)
			deletepoints copyindex[i],1,wave1
		endfor
	
End

Function FindBZG(Vwave,Gwave) //this function finds the G vectors that define the faces of the found BZ
wave Vwave,Gwave

variable i 
Make/O/N=3 G,halfG
Make/o/N = (0,3) BZG //a wave decribing the G vectors defing the faces of the BZ
	for(i=0;i<dimsize(Gwave,0);i+=1) //find the G vectors defining the faces of the BZ
			G[] = Gwave[i][p]
			halfG = 0.5*G
			VectorsinPlane(Vwave,G,halfG)
			wave/Z inplaneVref
			wave/z InplaneV
				if(dimsize(InplaneV,0)>2) ///if some f the points on the BZ lie on a plane defined by normal G and centre halfG
					Insertpoints/M=0 0,1, BZG
					BZG[0][] = G[q] //fill in the G vector
				endif
	endfor
	
	Killwaves/z G,halfG,InplaneVref, InplaneV

End
			
			
			





Function FindcommonCentre(points)
wave points

variable i

	Make/o/n =3 comcentre
	variable xtotal = 0,ytotal=0,ztotal=0
		for(i=0;i<dimsize(points,0);i+=1)

			xtotal+=points[i][0]
			ytotal+=points[i][1]
			ztotal+=points[i][2]
	
		endfor

	comcentre[0] = xtotal/(dimsize(points,0))
	comcentre[1] = ytotal/(dimsize(points,0))
	comcentre[2] = ztotal/(dimsize(points,0))

End


Function InitiateBZCalc(system) //creates the intial BZ calculation for planar or full BZ calculations
string system


	NVAR a = root:Packages:CrystalPanelGlobs:aVAL
	NVAR b = root:Packages:CrystalPanelGlobs:bVAL
	NVAR c = root:Packages:CrystalPanelGlobs:cVAL
	NVAR alpha = root:Packages:CrystalPanelglobs:alphaVAL
	NVAR beta = root:Packages:CrystalPanelGlobs:betaVAL
	NVAR gama = root:Packages:CrystalPanelGlobs:gamaVAL
		

	string curfolder = getdatafolder(1)
	Setdatafolder root:Packages:CrystalPanelGlobs:BZGen
	string BZfolder = "BZGen"+"_"+lowerstr(system)
	Setdatafolder :$BZfolder
	wave A1,A2,A3
	Setdatafolder $curfolder
	Duplicate/o A1, A1
	Duplicate/o A2, A2
	Duplicate/o A3, A3
	
	if(stringmatch(system,"bcc"))
		A1*=(2*pi/a)
		A2*=(2*pi/a)
		A3*=(2*pi/a)
		FindfirstBZ(A1,A2,A3) //find the first BZ and associated waves	
  	endif
  	
  	if(stringmatch(system,"fcc"))
		A1*=(2*pi/a)
		A2*=(2*pi/a)
		A3*=(2*pi/a)
		FindfirstBZ(A1,A2,A3) //find the first BZ and associated waves	
  	endif
  	
  	if(stringmatch(system,"sc"))
		A1*=(2*pi/a)
		A2*=(2*pi/a)
		A3*=(2*pi/a)
		FindfirstBZ(A1,A2,A3) //find the first BZ and associated waves	
  	endif
  	
  	if(stringmatch(system,"hex"))
		A1*=(2*pi/a)
		A2*=(2*pi/a)
		A3*=(2*pi/c)
		FindfirstBZ(A1,A2,A3) //find the first BZ and associated waves	
  	endif
  		
  //create temporary copiues of the waves in the current folder	
  	

 End

Function MakeFullBZ(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = Getdatafolder(1)
	
	NVAR a = root:Packages:CrystalPanelGlobs:aVAL
	NVAR b = root:Packages:CrystalPanelGlobs:bVAL
	NVAR c = root:Packages:CrystalPanelGlobs:cVAL

	wave/z Gwave,Gwave2,Vwave
	controlinfo system
	string basisname = S_value
	string dfname = "FullBZ"+"_"+basisname
	Newdatafolder/o/s :$dfname
	
	InitiateBZCalc(basisname) //check whether the BZ calculatio has ben done and transfer copies of the wave into the current data folder
	
	wave/z Vwave,BZG,vertdefwave,basis,Gwave,Gwave2,Gwave2_ind
	killwaves/z vertdefwave,basis,Gwave,Gwave2,Gwave2_ind //dont need this for the minute
	
  	BZG*= 2*pi/a
  	Vwave*=2*pi/a
  	
	CreateTriangleWave(Vwave,BZG) //creatae the trianlge definition wave
	wave Triwave
	
	
	Setdatafolder $curfolder
	
End

	
	
Function MakePlanarBZ(ctrlName) : ButtonControl
	String ctrlName
		
		string curfolder=getdatafolder(1)

		
		string planename	
		Controlinfo/W=CrystalPanel system
		string basisname = S_value
		
		Controlinfo mode
		
			if(stringmatch(S_value,"Simple"))
				controlinfo Surfdirection
				planename = S_value
			elseif(stringmatch(S_value,"Advanced"))
				planename="Custom"
			endif
			
		string dfname = "BZplane"+"_"+basisname+"_"+planename
		Newdatafolder/o/s :$dfname
	
		InitiateBZCalc(basisname)
		wave A1,A2,A3,BZG,Gwave, Gwave_ind
		
		Permutebasis(A1,A2,A3,5,1) //make a larger Gwave for BZplane plottin

  	
 //this section creates the coordinate system used for the plane of interest		
		ReadSurfCoordWaveFromGlobals()
		wave SurfCoordswave 
		Make/o/n=(3,3) plane
		Make/o/n=3 Xaxis
		Make/o/n=3 Yaxis
		Xaxis[] = Surfcoordswave[0][p]
		Yaxis[] = Surfcoordswave[1][p]
		Cross Xaxis, Yaxis 
		wave W_cross
		
		plane[0][] = Surfcoordswave[0][q]
		plane[1][] = Surfcoordswave[1][q]
		plane[2][] = W_cross[q]
		BZplane(plane,Gwave,BZG) //calculate the intersection of the plane with the BZ structure
		
		Setdatafolder $curfolder
		
		killwaves/z Xaxis,Yaxis,W_Cross,Surfcoordswave
	
End


Function Displayresults()
	
	wave/z BZResX
	Wave/z BZresY
	wave/z InplaneGy
	wave/z InplaneGx
		if(waveexists(BZResX))
			PauseUpdate; Silent 1		// building window...
			Display/W=(5.25,42.5,399.75,251)
			AppendToGraph BZResY vs BZResX
			AppendToGraph InplaneGy vs InplaneGx
			ModifyGraph mode=3
			ModifyGraph marker=19
			ModifyGraph rgb(BZResY)=(0,0,0)
			ModifyGraph msize(BZResY)=1,msize(InPlaneGy)=2
		else
			Doalert 0, "No BZ results in the current folder"
		endif

				

//AppendToGraph  vs x
//	ModifyGraph mode(InplaneGy)=
End

Function AppendResultsToImage()
	
	string curwindow = winname(0,1)
	
	string folname = getdatafolder(0)
	variable i
	string namey,namex
		i=0
			do
				namey = "BZ"+num2str(i)+"y"
				namex = "BZ"+num2str(i)+"x"
				wave currenty = $namey
				wave currentx = $namex
					
					if(waveexists(currenty))
						removefromgraph/z $nameofwave(currenty)
						AppendTograph Currenty vs currentx
						ModifyGraph mode($nameofwave(currenty))=3, marker($nameofwave(currenty))=19, rgb($nameofwave(currenty)) = (0,0,0)
					else
						break
					endif
					
			i+=1
	Wave InplaneGx, InplaneGy
	
	
	
		
while(1)


//AppendToGraph InplaneGy vs InplaneGx
//	ModifyGraph mode(InplaneGy)=
End


Function JoinBZPoints(ctrlName) : ButtonControl
	String ctrlName
	
	string topwin = winname(0,1)
	controlinfo/W=crystalpanel popup0
	variable style = V_value-1
	SetDrawEnv/W=$topwin dash = style, linefgc = (V_red,V_green,V_blue), xcoord=bottom,ycoord = left, linethick =1
	if(cmpstr(CsrWave(A, topwin),"")==0||cmpstr(CsrWave(B, topwin),"")==0)
		Doalert 0, "Need Both Cursors On Graph"
	else
	
		SetDrawEnv/W=$topwin dash = style,xcoord=bottom,ycoord = left, linethick =1
		Drawline/w=$topwin hcsr(A), vcsr(A), hcsr(B), vcsr(B)
	endif
	
	

End

Function DispBZresults(ctrlName) : ButtonControl
	String ctrlName
	
	Displayresults()
	

End

Function AppendBZresults(ctrlName) : ButtonControl
	String ctrlName
	
	 AppendResultsToImage()
	

End




Function SetSurfDirectionVectorEditMode(mode)
variable mode


if(mode==1)
	SetVariable SurfX1 frame=0,noedit=1,labelBack=(52224,52224,52224)
	SetVariable SurfX2 frame=0,noedit=1,labelBack=(52224,52224,52224)
	SetVariable SurfX3 frame=0,noedit=1,labelBack=(52224,52224,52224)
	SetVariable SurfY1 frame=0,noedit=1,labelBack=(52224,52224,52224)
	SetVariable SurfY2 frame=0, noedit=1,labelBack=(52224,52224,52224)
	SetVariable SurfY3 frame=0,noedit=1, labelBack=(52224,52224,52224)
	SetVariable SurfZ1 frame=0,noedit=1,labelBack=(52224,52224,52224)
	SetVariable SurfZ2 frame=0,noedit=1,labelBack=(52224,52224,52224)
	SetVariable SurfZ3 frame=0,noedit=1,labelBack=(52224,52224,52224)
elseif(mode==2)
	
	
	SetVariable SurfX1 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfX2 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfX3 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfY1 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfY2 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfY3 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfZ1 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfZ2 frame=1,labelBack=(65535,65535,65535)
	SetVariable SurfZ3 frame=1,labelBack=(65535,65535,65535)

endif

end

Function SCCrystalfaceFunction(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	string face = popstr
	
		if(cmpstr(face,"(111)")==0)
			PopupMenu SurfDirection value="GM;GM2;GK"
		elseif(cmpstr(face,"(100)")==0)
			PopupMenu SurfDirection value="GM;GX"
		endif
	Controlupdate/W=CrystalPanel Surfdirection
end

Function BCCCrystalfaceFunction(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	string face = popstr
		
		if(cmpstr(face,"(111)")==0)
			PopupMenu SurfDirection value="GM;GM2;GK"
		elseif(cmpstr(face,"(100)")==0)
			PopupMenu SurfDirection value="GM;GX"
		endif
	Controlupdate/W=CrystalPanel Surfdirection
end

Function FCCCrystalfaceFunction(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	string face = popstr
	
		if(cmpstr(face,"(111)")==0)
			PopupMenu SurfDirection value="GM;GM2;GK"
		elseif(cmpstr(face,"(100)")==0)
			PopupMenu SurfDirection value="GM;GX"
		endif
	Controlupdate/W=CrystalPanel Surfdirection

end
	


Function CrystalSystemChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	
	wave PrimRealVectors =  root:Packages:CrystalPanelGlobs:Primrealvectors
	Controlinfo/W=CrystalPanel system

	if(cmpstr(S_value,"sc")==0) //simple cubic system selected
		
		Setvariable a  frame=1,noedit=0,labelBack=(65535,65535,65535)
		Setvariable b  frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable c  frame=0,noedit=1,labelBack=(52224,52224,52224)
		
		Setvariable alpha frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable beta frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable gamma frame=0,noedit=1,labelBack=(52224,52224,52224)
		
		Popupmenu Crystalface value = "(100);(110);(111)", proc = SCCrystalfaceFunction
		Popupmenu SurfDirection, proc = SCSurfaceDirectionChanged
	
	elseif(cmpstr(S_value,"bcc")==0)  //bcc cubic system selected
		
		Setvariable a  frame=1,noedit=0,labelBack=(65535,65535,65535)
		Setvariable b  frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable c  frame=0,noedit=1,labelBack=(52224,52224,52224)
		
		Setvariable alpha frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable beta frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable gamma frame=0,noedit=1,labelBack=(52224,52224,52224)
		
		Popupmenu Crystalface value =  "(100);(110);(111)", proc = BCCCrystalfaceFunction
		Popupmenu SurfDirection, proc = BCCSurfaceDirectionChanged
	
	elseif(cmpstr(S_value,"fcc")==0) ///fcc cubic system selected
	
		Setvariable a  frame=1,noedit=0,labelBack=(65535,65535,65535)
		Setvariable b  frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable c  frame=0,noedit=1,labelBack=(52224,52224,52224)
		
		Setvariable alpha frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable beta frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable gamma frame=0,noedit=1,labelBack=(52224,52224,52224)
		
		Popupmenu Crystalface value =  "(100);(110);(111)", proc = FCCCrystalfaceFunction
		Popupmenu SurfDirection, proc = FCCSurfaceDirectionChanged
	
	elseif(cmpstr(S_value,"hex")==0) 
	
		Setvariable a  frame=1,noedit =0 ,labelBack=(65535,65535,65535)
		Setvariable b  frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable c  frame=1,noedit = 0,labelBack=(65535,65535,65535)
		
		Setvariable alpha frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable beta frame=0,noedit=1,labelBack=(52224,52224,52224)
		Setvariable gamma frame=0,noedit=1,labelBack=(52224,52224,52224)
	
		///Popupmenu Crystalface value =  "(100);(110);(111)", proc = FCCrystalfaceFunction
	
	endif

	ControlUpdate/W=CrystalPanel Crystalface ///force update3 of the Surface direction. updates values 

End


Function SCSurfaceDirectionChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo crystalface
	string face = S_value
	Make/o/n=(2,3) SurfCoordswave
	string direction  = popstr
	
		if(cmpstr(face,"(111)")==0)
			
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{-2,1},{1,1},{1,1}}
				elseif(stringmatch(direction,"GM2"))
					Surfcoordswave  = {{-1,1},{-1,1},{2,1}}
				elseif(stringmatch(direction,"GK"))
					Surfcoordswave = {{-1,1},{0,1},{1,1}}
				endif
							
		elseif(cmpstr(face,"(100)")==0)
	
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{0,1},{1,0},{1,0}}
				elseif(stringmatch(direction,"GX"))
					Surfcoordswave = {{0,1},{1,0},{0,0}}
				endif
				
		endif
		
		UpdateSurfCoordwavetoGlobals(Surfcoordswave)
		Controlupdate/A/W= CrystalPanel
		killwaves Surfcoordswave
		
end
		

Function FCCSurfaceDirectionChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo crystalface
	string face = S_value
	Make/o/n=(2,3) SurfCoordswave
	string direction  = popstr
		
		if(cmpstr(face,"(111)")==0)
			
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{-2,1},{1,1},{1,1}}
				elseif(stringmatch(direction,"GM2"))
					Surfcoordswave  = {{-1,1},{2,1},{-1,1}}
				elseif(stringmatch(direction,"GK"))
					Surfcoordswave = {{-1,1},{0,1},{1,1}}
				endif
					
		elseif(cmpstr(face,"(100)")==0)
	
				if(stringmatch(direction,"GX"))
					Surfcoordswave =  {{0,1},{1,0},{1,0}}
				elseif(stringmatch(direction,"GM"))
					Surfcoordswave = {{0,1},{1,0},{0,0}}
				endif
				
		endif
		
		UpdateSurfCoordwavetoGlobals(Surfcoordswave)
		Controlupdate/A/W= CrystalPanel
		killwaves Surfcoordswave
		
end

Function BCCSurfaceDirectionChanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	

	Controlinfo crystalface
	string face = S_value
	Make/o/n=(2,3) SurfCoordswave
	string direction  = popstr
		
		if(cmpstr(face,"(111)")==0)
			
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{-2,1},{1,1},{1,1}}
				elseif(stringmatch(direction,"GM2"))
					Surfcoordswave  = {{-1,1},{-1,1},{2,1}}
				elseif(stringmatch(direction,"GK"))
					Surfcoordswave = {{-1,1},{0,1},{0,1}}
				endif
					
		elseif(cmpstr(face,"(100)")==0)
	
				if(stringmatch(direction,"GM"))
					Surfcoordswave =  {{0,1},{1,0},{1,0}}
				elseif(stringmatch(direction,"GX"))
					Surfcoordswave = {{0,1},{1,0},{0,0}}
				endif
				
		endif
		
		UpdateSurfCoordwavetoGlobals(Surfcoordswave)
		Controlupdate/A/W= CrystalPanel
		killwaves Surfcoordswave
		
end
	

Function UpdateSurfCoordwavetoGlobals(Surfcoordswave)
wave surfcoordswave

variable/g root:Packages:CrystalPanelGlobs:SurfX1VAL = Surfcoordswave[0][0]
variable/g root:Packages:CrystalPanelGlobs:SurfX2VAL = Surfcoordswave[0][1]
variable/g root:Packages:CrystalPanelGlobs:SurfX3VAL = Surfcoordswave[0][2]
variable/g root:Packages:CrystalPanelGlobs:SurfY1VAL = Surfcoordswave[1][0]
variable/g root:Packages:CrystalPanelGlobs:SurfY2VAL = Surfcoordswave[1][1]
variable/g root:Packages:CrystalPanelGlobs:SurfY3VAL = Surfcoordswave[1][2]


End

Function ReadSurfCoordWaveFromGlobals() //creates the coordsmatrix for use int BZ cutting from the displayed globals in the anel

Make/o/n=(2,3) SurfCoordswave

NVAR SurfX1VAL  = root:Packages:CrystalPanelGlobs:SurfX1VAL
NVAR SurfX2VAL= root:Packages:CrystalPanelGlobs:SurfX2VAL
NVAR SurfX3VAL= root:Packages:CrystalPanelGlobs:SurfX3VAL
NVAR SurfY1VAL= root:Packages:CrystalPanelGlobs:SurfY1VAL
NVAR SurfY2VAL= root:Packages:CrystalPanelGlobs:SurfY2VAL
NVAR SurfY3VAL= root:Packages:CrystalPanelGlobs:SurfY3VAL

Surfcoordswave[0][0]= SurfX1VAL
Surfcoordswave[0][1]= SurfX2VAL
Surfcoordswave[0][2]= SurfX3VAL
Surfcoordswave[1][0]= SurfY1VAL
Surfcoordswave[1][1]= SurfY2VAL
Surfcoordswave[1][2]= SurfY3VAL


end



		


	








	








