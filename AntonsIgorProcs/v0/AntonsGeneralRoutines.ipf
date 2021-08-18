#pragma rtGlobals=1		// Use modern global access method.


Function ReplaceZeroWithNAN(data) //this function takes a 2D wave of data and replaces all 0's with Nan
wave data

variable i, j

for(i=0;i<dimsize(data, 0);i+=1)
	for(j=0;j<dimsize(data,1);j+=1)
		
		if(data[i][j]==0) //if data element is equal to zero
			data[i][j] = Nan
			
		endif
	endfor
endfor

End
		

Function CreateAngleSubset(Xvals,Yvals,startangle,endangle) //creates a subset wave from X,y values, whose angles (realtive to + x axis) fall within the range specified.
wave Xvals,Yvals
variable startangle, endangle

make/o/n = 0 xrestrict,yrestrict

variable i,angle,xx,yy

	for(i=0;i<numpnts(Xvals);i+=1)
	
		xx = Xvals[i]
		yy = Yvals[i]
		
		angle = atan2(yy,xx)*180/pi
		
		if(angle<0)
			angle = 360-angle
		endif
		
		if(angle>startangle&&angle<endangle)
		
			insertpoints 0,1,xrestrict, yrestrict
			xrestrict[0] = xx
			yrestrict[0] = yy
			
		endif
	endfor
	
	Duplicate/O xrestrict $(nameofwave(Xvals)+"Res")
	Duplicate/O yrestrict $(nameofwave(YVals)+"Res")
	
	killwaves/z xrestrict,yrestrict
end

Function NonNedgWaveDiff(wave1, Wave2) //wave returns the difference between two waves, wave1 and wave2. If Difference is negative, value is set to zero
wave wave1, wave2

variable i, j, value
Duplicate wave1 DiffWave

	for(i=0;i<dimsize(data,0);i+=1)
		for(j=0;j<dimsize(data,1);j+=1)
			value = wave1[i][j] - wave2[i][j]
				if(value<0)
					value = 0
				endif
				Diffwave[i][j] = value
		endfor
	endfor
end
	
				
		
Function AddKeyParamToNote(data,key,paramstring)
	wave data
	string key
	string paramstring

			string datanote =note(data)
			note/K data
			
			datanote = ReplaceStringByKey(key,datanote,paramstring,"=",":") //replace the settings
			Note data,datanote //appends the current setttings as a wave note to the current data	

End

Function/S WriteControlList(winNameStr, controllist)
string winnamestr, controllist


variable i
string totalinfo
variable spacepos
string controltype, controlname, controlvalue
	
	for(i=0;i<itemsinlist(controllist,";");i+=1)
			
			totalinfo = StringFromList(i, controllist,";")
			Controlname = StringFromList(0, totalinfo,",")
			Controlvalue = StringFromList(1, totalinfo,",")
			variable val = str2num(controlvalue)
			
			string existsinpanel = ControlNameList(winNameStr, ";" , controlname) // check to see if that control exists in the panel anymore, prevents generation of unecessary controls
				if(!stringmatch(existsinpanel,""))
					Controlinfo/W=$winnamestr $controlname
					spacepos = strsearch(S_recreation," ",0)
					controltype = S_recreation[1,spacepos-1]
			
						if(cmpstr(controltype,"SetVariable")==0)
							NVAR global = $(S_datafolder+S_value)
							global = val
							//Setvariable $controlname, win=$winnamestr
						elseif(cmpstr(controltype, "Checkbox")==0)
							Checkbox $controlname, win =$winnamestr, value=val
						elseif(cmpstr(controltype,"Popupmenu")==0)
							Popupmenu $controlname, win = $winnamestr, mode=val
						endif
				endif
		
	endfor
	
	Controlupdate/A/W=$winnamestr
//	
end

Function/S ForceStringToBeNice(astring) //function removes all funny cars and makes length less than 32 characters, compatible with window names
	string astring
	
	variable i, bad //gets the length of the string
	make/O/T forbiddenlist = {".","'","-",";","/",",","(",")","!"," ","#","`","{","}"} //search for this list of characters (ANTON: you can update this)
	
	for(i=0;i<dimsize(forbiddenlist,0);i+=1) //go throught the forbidden list
		do
		bad = strsearch(astring, forbiddenlist[i],0 ) 
		 //if bad character exists, replace it with "_"
			if(bad!=-1)
			astring[bad,bad] = "_"
			endif
		while(bad!=-1)
	endfor
	i = 0
	Do
			astring = astring[0,strlen(astring)-i]
			variable length = (strlen(astring))
			i+=1
	while(length>31)
		
		 
	killwaves forbiddenlist
	return astring
end



Function Antons2dinterpFix(data,x,y) ///i have had to write this since 3dinterp does not seem to work  when you try and use values on the side of the block furthest form te origin, in either x, y, or z.
wave data
variable x,y

variable edge=0,val
		
		if(x==dimoffset(data,0)+(dimsize(data,0)-1)*dimdelta(data,0))
			edge=1
		elseif(x==dimoffset(data,0))
			edge = 1
		elseif(y==dimoffset(data,1)+(dimsize(data,1)-1)*dimdelta(data,1))
			edge=1
		elseif(y==dimoffset(data,1))
			edge=1
		endif
		
		if(edge)
			//val = data(x)(y)
			val = Nan
		else
			val = interp2d(data,x,y)
		endif


return(val)

end

Function Antons3dinterpFix(data,x,y,z) ///i have had to write this since 3dinterp does not seem to work  when you try and use values on the side of the block furthest form te origin, in either x, y, or z.
wave data
variable x,y,z

variable out,val
		if(x==dimoffset(data,0)+(dimsize(data,0)-1)*dimdelta(data,0))
			out=1
		elseif(y==dimoffset(data,1)+(dimsize(data,1)-1)*dimdelta(data,1))
			out=1
		elseif(z==dimoffset(data,2)+(dimsize(data,2)-1)*dimdelta(data,2))
			out = 1
		endif
		
		if(out)
			val = data(x)(y)(z)
		else
			val = interp3d(data,x,y,z)
		endif
return(val)

end

 Function inarray(matrix,x,y) //this function returns whether point at row = x, col = y is in the array matrix
 wave matrix
 variable x,y

variable inside=1

if(numtype(x)==2||numtype(y)==2)
	inside = 0
endif

	if(x<dimoffset(matrix,0))
		inside = 0
	endif
	
	if(x>(dimoffset(matrix,0)+dimdelta(matrix,0)*(dimsize(matrix,0)-1)))
		inside = 0
	endif
	
	if(y<dimoffset(matrix,1))
		inside = 0
	endif
	
	if(y>(dimoffset(matrix,1)+dimdelta(matrix,1)*(dimsize(matrix,1)-1)))
		inside = 0
	endif


	
Return inside

End

 

Function CalcDirectionCosine (a,b,c,x,y,z) //for two vectors based on one cartesian coordinate system.
variable a,b,c,x,y,z

variable dircos

dircos = (a*x+b*y+c*z)/(sqrt(a^2+b^2+c^2)*sqrt(x^2+y^2+z^2))
//print dircos
return dircos

end function

Function GenCosMatrix(Vectors1, Vectors2)// to create cosine matric converting point in vectors2 coord system to vectors 1 coord system
wave vectors1,vectors2 //the wave containing the vectros defiining two right angles coordinate systems

	make/O/N = (3,3) Cosmatrix
	Cosmatrix[][] = CalcDirectionCosine(Vectors1[p][0],Vectors1[p][1],Vectors1[p][2],Vectors2[q][0],Vectors2[q][1],Vectors2[q][2])

End Function

Function TransCoord(Cosmatrix,x,y,z) //converts coordinate x,y,z in one frame into a,b,c in the other fram using the direction cosine matrix cosmatrix
variable x,y,z
wave cosmatrix


	Make/o/N  = (3) oldcoords
	oldcoords[0] = x
	oldcoords[1] = y
	oldcoords[2] = z

	MatrixMultiply Cosmatrix,  oldcoords
	//killwaves/z oldcoords

End function

Function TransformCoordArray(Cosmatrix,points) //this function takes a series of x,y,z pairs in one coordinate system and returns the same points in terms of another system
wave cosmatrix,points

	variable i,j,k

	Make/o/N  = (3) oldcoords
	Make/o/n= (dimsize(points,0),3) TransCoordArray
	
		for(i=0;i<dimsize(points,0);i+=1)
			
			oldcoords[] = points[i][p]
			MatrixMultiply Cosmatrix,  oldcoords
			wave M_product
			TransCoordArray[i][] = M_product[q]
			
		endfor
	
	//killwaves/z oldcoords

end

Function GetPlotSettings(ParamKey,panelname) //this function will retrieve the current settings the Fplot and write them into the appropriate panel
string panelname
string ParamKey

	string curfol = getdatafolder(1)
	wave data = ImageNameToWaveRef("",StringFromList(0, ImageNameList("", ";"),";")) //get ref to the wave in the top graph
	string info = GetKeyParamFromNote(ParamKey,data)
		
		if(cmpstr(info,"")!=0)
			WriteControlList(panelname, info)
			Controlupdate/A/W=AzScanPanel
		else
			Doalert 0, "Params Not Present in Displayed Data"
		endif
End	

Function/S GetKeyParamFromNote(Paramkey,data)
string Paramkey
wave data

	string datanote = note(data)
	string info = StringByKey(ParamKey,datanote, "=",":")
	
Return(info)
	
end

Function/S ExtractSpecificControlList(controldef,winNameStr) ///this function will extract the values /states of all controls with names involving "controldef" from the window "windnamestr
string winNameStr			//if "controldef" is left "" then all controls ' values are returned.
string controldef


string totallist = ControlNameList(winNameStr,";") //return a list of all of the control in the window
variable ok,i
variable ind=0, spacepos
string returnlist ="", controlname, controltype,value=""
	
	for(i=0;i<itemsinlist(totallist,";");i+=1)
		controlname = StringFromList(i,totallist,";")
		value=""
			if(stringmatch(controldef,"")) //set to read all controls
				ok=1
			else
				ok = strsearch(controlname,controldef,0)
			endif
			
			if(ok!=-1)
				Controlinfo/W=$winnamestr $controlname
				spacepos = strsearch(S_recreation," ",0)
				controltype = S_recreation[1,spacepos-1]
					if(cmpstr(controltype,"SetVariable")==0)
						value = num2str(V_value)
					elseif(cmpstr(controltype, "Checkbox")==0)
						value = num2str(V_value)
					elseif(cmpstr(controltype,"Popupmenu")==0)
						value=num2str(V_value)
					endif
						if(!stringmatch(value,""))
							returnlist+=controlname+","+value+";"
						endif
			endif
			
			
	endfor

return(returnlist)

End

Function NormaliseinX(data)  // this function normalises the data across in polar angle to see the effect 
wave data

	variable i
	string dataname = nameofwave(data)+"_"+"ICX"
	make/N= (dimsize(data,0)) xarray
	make/N=(dimsize(data,1)) yarray
	Setscale/P x,dimoffset(data,1),dimdelta(data,1), yarray
		for(i=0;i<dimsize(data,0);i+=1)
			yarray[] = data[i][q]
			xarray[i] = sum(yarray,dimoffset(yarray,0),dimoffset(yarray,0)+dimsize(yarray,0)*dimdelta(yarray,0))
		endfor
		
	Duplicate/O data,data2
	Data2[][] = data2[p][q]/abs(xarray[p])
	Duplicate/O data2, $dataname
	killwaves data2,yarray
End

Function NormaliseInY(data) //This function normalises a 2d data set in the vertical direction by the polar angle summed intensity distribution
wave data

	string wname  = Polarangleintegrate(data, -90, 90)
	wave crap = $wname
	string dataname = nameofwave(data)+"_"+"ICY"
	Duplicate/O data, data2
	Data2[][] = Data2[p][q]/abs(crap[q])
	Duplicate/O data2, $dataname
	Killwaves data2
	
End
	
Function rotatematrix(angle,matrix)
variable angle
wave matrix

angle = angle*pi/180 //converto radians

string name = nameofwave(matrix)+"rotate"

make/o/N = (dimsize(matrix,0),dimsize(matrix,1)) rotated


rotated[][] = matrix(cos(angle)*pnt2x(matrix,p)+sin(angle)*pnt2x(matrix,q))(-sin(angle)*pnt2x(matrix,p)+cos(angle)*pnt2x(matrix,q))

Setscale/P x, dimoffset(matrix,0), dimdelta(matrix,0), rotated
setscale/P y, dimoffset(matrix,1), dimdelta(matrix,1), rotated

matrix = rotated
killwaves rotated

end

Function rotatematrix2(angle,matrix)
variable angle
wave matrix

ImageRotate/A=(angle)/E=0/O matrix


end

Function/S UserSelectFolders(folderstring) //slect folders beginning with folderstring from the current datafolder
	string folderstring

	string totallist = datafolderdir(1)[8,strlen(datafolderdir(1))] //list all datafolders in the current directory
	variable i
	string validlist =""
	string destfolder
	
	
		string teststring
		for(i=0;i<itemsinlist(totallist, ",");i+=1) //step through the list and pick out the datafolder names that begin with folderstring
			teststring = stringfromlist(i,totallist,",")
			if(strsearch(teststring,folderstring,0)!=-1)
				validlist+=teststring+";"
			endif
		endfor
	
		if(cmpstr(validlist,"")!=0) //if search found folders with approprites names
		
			prompt destfolder, "Folder", popup, validlist
			string selectprompt = "Select Current"+" "+ folderstring+" "+"folder"
			doprompt selectprompt, destfolder
				if(V_Flag==1)
					destfolder = ""
				else
					setdatafolder :$destfolder
				endif
		
		else
		destfolder = ""
		endif
	return destfolder
End

Function SelectFolderbuttonProc(ctrlName) : ButtonControl
	String ctrlName
	
	Selectfolderwithincurrent()

End

Function SelectFolderWithinCurrent()

string totallist = datafolderdir(1)[8,strlen(datafolderdir(1))] //list all datafolders in the current directory
string destfolder

	string teststring,validlist=""
	variable i

		for(i=0;i<itemsinlist(totallist, ",");i+=1) 
			teststring = stringfromlist(i,totallist,",")
			validlist+=teststring+";"
		endfor

	prompt destfolder, "Folder", popup, validlist
			string selectprompt = "Select folder"
			doprompt selectprompt, destfolder
				if(V_Flag==1)
					destfolder = ""
				else
					setdatafolder :$destfolder
				endif
end

Function FitProfile(w,x) : FitFunc//this function fits one wave to another as best as possible using dilation and translation
	wave w
	variable x
	

wave/Z fitline


return w[0]*fitline(x-w[1])+w[2]

	
end

Function FlattenDataBlock(datablock, dimension) //this function takes a datablock and sums all the energy window planes (theta and E channel plane) over all steps in y

wave datablock
variable dimension
variable i

if(dimension==0) 

Make/o/n=(dimsize(datablock,2), dimsize(datablock,1)) DBlock_Flattened_0
Setscale/P x, dimoffset(datablock, 2), dimdelta(datablock,2), DBlock_Flattened_0
Setscale/P y, dimoffset(datablock, 1), dimdelta(datablock,1), DBlock_Flattened_0

DBlock_Flattened_0[][] = 0

For(i=0;i<=dimsize(Datablock, 0);i+=1)
	DBlock_Flattened_0[][]+=Datablock[i][q][p]
Endfor


elseif(dimension==1) 

Make/O/N=(dimsize(datablock,0), dimsize(datablock,2)) DBlock_Flattened_1
Setscale/P x, dimoffset(datablock, 0), dimdelta(datablock, 0), DBlock_Flattened_1
Setscale/P y, dimoffset(datablock, 2), dimdelta(datablock,2), DBlock_Flattened_1

DBlock_Flattened_1[][] = 0

For(i=0;i<=dimsize(Datablock, 1);i+=1)
	DBlock_Flattened_1[][]+=Datablock[p][i][q]
Endfor


elseif(dimension==2) 

Make/O/N=(dimsize(datablock,0), dimsize(datablock,1)) DBlock_Flattened_2
Setscale/P x, dimoffset(datablock, 0), dimdelta(datablock,0), DBlock_Flattened_2
Setscale/P y, dimoffset(datablock, 1), dimdelta(datablock,1), DBlock_Flattened_2

DBlock_Flattened_2[][] = 0

For(i=0;i<=dimsize(Datablock, 2);i+=1)
	DBlock_Flattened_2[][]+=Datablock[p][q][i]
Endfor


endif

End
	

Function Sum_in_Y(data) //this function sums up data over all phis/energies and creates a 1d wave of intenosty versus angle channel
wave data

make/O/N = (dimsize(data,0)) Int_Y
Make/o/n = (dimsize(data,1)) column
variable j
	
		for(j=0;j<dimsize(data,0);j+=1)
			column[] = data[j][p]
			Int_Y[j] = sum(column, 0, dimsize(data,1))/dimsize(data,1) 
		endfor
		
killwaves/Z column
end

Function Secondderivative(data)
wave data

	
	variable rows = dimsize(data,0)
	variable cols = dimsize(data,1)
	string newwave = nameofwave(data)+"2ndDeriv"
	make/o/n = (rows,cols) $newwave
	wave diffwave = $newwave 
	Setscale/P x,dimoffset(data,0),dimdelta(data,0),diffwave
	Setscale/P y,dimoffset(data,1), dimdelta(data,1),diffwave
	variable i,j, num
	
		for(i=0;i<rows;i+=1)
			for(j=0;j<cols;j+=1)
			num =  (data[i+1][j]+data[i][j+1]+data[i-1][j]+data[i][j-1]-4*data[i][j])
				//if(num<=0)
				//	num = 1
				//else
			//	num=0
			//	endif
				diffwave[i][j] =num
			endfor
		endfor
		

end function

Function MakeLine(datawave)	//This function generates the xline and yline for display in MakeImage()
	Wave datawave	
	
	
	string xlinename  = nameofwave(datawave)+"_"+"xline"
	string ylinename = nameofwave(datawave)+"_"+"yline"
	string xcoordsname  = nameofwave(datawave)+"_"+"xlcoords"
	string ycoordsname = nameofwave(datawave)+"_"+"ylcoords"
	make/O/D/N=(dimsize(datawave,1)) yline,ylcoords
	make/O/D/N=(dimsize(datawave,0)) xline,xlcoords
	
	setscale/P x,Dimoffset(datawave,0),dimdelta(datawave,0),xline
	setscale/P x,dimoffset(datawave,1),dimdelta(datawave,1),yline
	xlcoords[] = dimoffset(datawave,0)+ p*dimdelta(datawave,0)
	ylcoords[] = dimoffset(datawave,1)+ p*dimdelta(datawave,1)
	Duplicate/O xline, $xlinename
	Duplicate/O yline, $ylinename
	Duplicate/O xlcoords, $xcoordsname
	Duplicate/O ylcoords, $ycoordsname
	killwaves xline, yline, xlcoords, ylcoords
	
end 

Function OffSetPolarAngle(Data,OffSet) //this function offsets the polar angle on the active window based on the wave wavname
	variable offset
	wave data
	
	string curfolder = getdatafolder(1) 
	setscale/P x, dimoffset(data,0)+offset, dimdelta(data,0),data //changes the x scaling
	
		
	end function



Function ApplyGen1dDisplayStyle()

					ModifyGraph mode=3,marker=8,msize=2
					ModifyGraph opaque=0,rgb=(65280,16384,35840),useMrkStrokeRGB=1;DelayUpdate
					ModifyGraph mrkStrokeRGB=(65280,0,0)
					modifygraph/Z wbRGB=(65000,65000,65000 ) 
end


Function ApplyGen2dDisplayStyle()

					ModifyImage ''#0 ctab= {*,*,Grays,0}
					ModifyGraph fStyle=0,fSize=10
					ModifyGraph axRGB=(0,0,0),tlblRGB=(0,0,0)
					ModifyGraph alblRGB=(0,0,0)
					ModifyGraph gbRGB = ( 65535,65535,65535)
					ModifyGraph standoff=1
					ModifyGraph mirror=1
					Modifygraph wbRGB=(65535,65535,65535) //make the window colour
					ModifyGraph width={Aspect,1}
					ModifyGraph height={Aspect,1}
					label left ""
					label bottom ""
end

function combineprofiles(profile1,profile2)
wave profile1
wave profile2

variable globleft = min(leftx(profile1), leftx(profile2))
variable globright = max(rightx(profile1), rightx(profile2))
Make/o/n= ((globright-globleft)/deltax(profile1)) combine
setscale/I x, globleft, globright, combine
variable i, angle, pnt2, pnt1, val1,val2,val
for(i=0;i<numpnts(combine);i+=1)
	val=0
	angle = pnt2x(combine,i)
	pnt1 = x2pnt(profile1,angle)
	pnt2 = x2pnt(profile2, angle)
	
		if(0<pnt2&&pnt2<numpnts(profile2))
			val2=profile2(angle)
		else
			val2=0
		endif
		
		if(0<pnt1&&pnt1<numpnts(profile1))
			val1 = profile1(angle)
		else
			val1 =0
		endif
		
		if(val1!=0&&val2!=0)
			val = (val1+val2)/2		
		else
			val = val1+val2
		endif
		
		combine[i] = val
		
		
endfor

end 

Function Int2dsheet(data,direction, start, finish) //function creates a a wave which is the direction integrated version of data)
	wave data
	variable direction //"x" intgrated profile anlong x,"y", integrated profile along y
	variable start, finish //index values of start and finish points

variable i,total,val,j
		
	if(direction==0) //integrated along x direction
	
		Make/o/n=(dimsize(data,1)) Intwave
		Make/o/n=(dimsize(data,0)) wave1		
			for(i=0;i<dimsize(data,1);i+=1)
				wave1[] = data[p][i]
				intwave[i] = sum(wave1,start,finish)
			endfor
			
	elseif(direction==1) //integrated along y direction
	 
		Make/o/n=(dimsize(data,0)) Intwave
		Make/o/n=(dimsize(data,1)) wave1		
			for(i=0;i<dimsize(data,0);i+=1)
				wave1[] = data[i][p]
				intwave[i] = sum(wave1,start,finish)
			endfor
			
	endif
	killwaves/z wave1
	
End



Function PolyFermiFit(curve,polyorder, begin, finish) //this function performs a differentiation of a polyorder level fit to edc to determine
	wave curve
	variable polyorder
	variable begin
	variable finish
	variable direction
	
	
	variable fermilevel
	Curvefit/N/Q/L=750 poly polyorder, curve(begin,finish)/D 
	string fitwave = "fit_"+nameofwave(curve)
	wave fit=$fitwave
	Duplicate/O fit fit2
	Differentiate fit2 //create the differentiated EDC
	variable value
	variable i = x2pnt(fit,begin)
	variable endindex = x2pnt(fit,finish)

		do
			i+=1
			value = fit2[i]
	
				if((fit2[i]<fit2[i-1])&&(fit2[i]<fit2[i+1])) //if the element is less than the neighboiring elements (ie a minima)
					break
				elseif((fit2[i]>fit2[i-1])&&(fit2[i]>fit2[i+1])) //if the element is greater than the neighboiring elements (ie a maxima)
					break
				endif
		while(i<endindex)
		
	// find poitn of mimimum unless it gets to the end
	fermilevel = pnt2x(fit2,i)
	//print fermilevel
	
	//Killwaves/z fit, fit2, fit_edc
	
	return(fermilevel)
	//killwaves/z fit2, fit
	
end function

Function/S PolarAngleIntegrate(data,left,right) //integrates over arbitrary polar angles a particular plot containing some quanitiy versus polar angle
wave data
variable left, right
	
		string wname = nameofwave(data)+"_"+"angleint" //name of the new angle int wave
		string windowname = NameWindow(wname)
		variable start = (left-dimoffset(data,0))/dimdelta(data,0)
		variable finish = (right-dimoffset(data,0))/dimdelta(data,0)
		Int2dsheet(data,0, start, finish)
		wave/z intwave
		Setscale/P x, dimoffset(data,1), dimdelta(data,1), waveunits(data,1), Intwave
		Duplicate/O intwave, $wname
		Killwaves/z intwave
		
	
	return wname
	
end function

Function AngleCorrect2dSheet(data, anglecalwave)
wave data
wave anglecalwave

string caldataname = nameofwave(data)+"_"+"angcal"
variable angle,i,j,k
make/o/n = (dimsize(data,0),dimsize(data,1)) corrsheet
make/o/n=(dimsize(data,0)) row

Setscale/P x, dimoffset(data,0), dimdelta(data,0), corrsheet,row
Setscale/P y, dimoffset(data,1), dimdelta(data,1), corrsheet


		
		for(j=0;j<dimsize(corrsheet,1);j+=1)
			row = data[p][j]
			corrsheet[][j] = row(anglecalwave(dimoffset(corrsheet,0)+p*dimdelta(corrsheet,0)))
			
		endfor
	
				

	duplicate/O corrsheet, $caldataname
	killwaves/z corrsheet, row
	
end



	






	
	
		
		
	


Function CorrPolarAngleByStep(data,centrewave) //this function takes a data sheeet, and uses a correction wave to create a new corrected version
wave data								// centrewave is the wave describing the polar offset needed each step in y of data
wave centrewave			
		
			variable i, phi, thetacorr
			Duplicate/O data, fixdata
			make/o/n = (dimsize(data,0)) oldline, newline
			Setscale/P x, dimoffset(data,0), dimdelta(data,0), oldline, newline
			
				for(i=0;i<dimsize(data,1);i+=1)
					phi = dimoffset(data, 1)+i*dimdelta(data, 1) //get the angle you are at
					oldline[] = data[p][i]
					thetacorr = centrewave[i]
					newline[] = oldline(pnt2x(newline,p)+centrewave[i])
					data[][i] = newline[p]
				endfor
				
			killwaves/z oldline, newline
			doalert 1, "Undo?"
			
				if(V_Flag==1)
					data = fixdata
					killwaves fixdata
				else
					killwaves fixdata
				endif		
	
end


Function TrackSurfState(data, left,right) //this function tracks the position of the surface state as it weaves about it a non normally oriented sample's exp
wave data
variable left , right


variable lindex, rindex, pos1,pos2,i
lindex = (left- dimoffset(data,0))/dimdelta(data,0)
rindex = (right-dimoffset(data,0))/dimdelta(data,0)

make/o/n = (dimsize(data,0)) xline
Setscale/P x,dimoffset(data,0), dimdelta(data,0), xline
make/o/n=(dimsize(data,1)) centrewave

	for(i=0;i<dimsize(data,1);i+=1)
		xline = data[p][i]
		Findpeak/B=20/Q/R=(left,right) xline
		pos1=V_peakloc
		Findpeak/B=20/Q/R=(right,left) xline
		pos2 = V_peakloc
		Centrewave[i] = (pos1+pos2)/2
	endfor
	smooth/B 10, Centrewave
	
	
end


Function/S NameWindow(wavname)
string wavname

string totalname = wavname+"_"+getdatafolder(0)
string windowname =cleanupname(totalname,0)

return windowname

End			


Function DisplayWave(datawave)
wave datawave


variable dimdata
variable displayed
	
	if((dimsize(datawave,0)<=1)||(dimsize(datawave,1)<=1))
		 dimdata = 1 //checks on the dimension of the input wave
		else 
		dimdata = 2
	endif

string dfname = getdatafolder(1) //gets the full path to the current data folder
String wavname = nameofwave(datawave)
string windowname = namewindow(wavname)
string windowtitle = wavname+"_"+getdatafolder(0)
 //get status on the overwrite button

string wlist = winlist(windowname,";","WIN:1") //list all windows with the name of File+(subset of data folder name)

		if(dimdata==1)
			
			if(stringmatch(wlist,"")==1) // if windowname does not exist iewindow does not exist or overwrite is selected
	 		
	 			PauseUpdate; Silent 1		// building window...
				Display/W=(53,142,500,500)
				Dowindow/C $windowname
	 			AppendToGraph/W=$windowname datawave
				Dowindow/T $windowname windowtitle //gives the title of the window the same name as the name
				Applygen1ddisplaystyle()
				Dowindow/F $windowname
			
			else
				Dowindow/F $windowname
				displayed =1
			endif
	
		elseif(dimdata==2) //data is going to be displayed as an image
		
			if(stringmatch(wlist,"")==1) // if windowname does not exist iewindow does not exist
	 				
	 				PauseUpdate; Silent 1		// building window...
					Display/W=(53,142,500,500)
	 				Dowindow/C $windowname
					AppendImage/W=$windowname datawave
					Dowindow/T $windowname windowtitle
					
					ApplyGen2dDisplayStyle()
					
					if((dimsize(datawave,1)*dimdelta(datawave,1)+dimoffset(datawave,1))<(dimoffset(datawave,1)))
						SetAxis/A/R left
					endif
					
			else
				Dowindow/F $windowname
			endif
		endif
		
		// Dowindow/F $windowname
		return(displayed)
		
end function

Function CorrectPolarAngle(Matrix,Inc,data)
wave Matrix,data //matrix is the  correction matrix. data is the datablock
variable inc //the angle of incidence of the light rel to the surface normal of the sample

variable i,j,k, theta,radindex
Make/o/n= (dimsize(data,0)) Corrtheta //make a wave of all the polar angles in the raw data
CorrTheta[] = (dimoffset(data,0))+p*dimdelta(data,0)
Make/O/N=(dimsize(data,0)) RawTheta //make a wave to store correct values of theta in
Duplicate/O Data, Data2
	for(i=0;i<dimsize(data,2);i+=1)
		radindex = (dimsize(Matrix,1)*i/(dimsize(data,2)))   
		//print radindex
		Rawtheta[] = Corrtheta[p]-Matrix(Rawtheta[p]-inc)[radindex] //get the corrcted interpolated angle wave from the matrix corr wave.Note scaling of Matrix is in reverse
			for(j=0;j<dimsize(data,1);j+=1)
				for(k=0;k<dimsize(data,0);k+=1)
					theta = interp(CorrTheta[k],CorrTheta,RawTheta)
					Data2[k][j][i] = Data(theta)[j][i] //fill in the corrected data spots with interpolated values from the original data using the polar angle correction waves	
				endfor
			endfor
	endfor

End

Function TakeLogOfImage(data) //this function creates a new wave..the log of thewave in the window
wave data


Duplicate/O data, logdata
logdata = log(data)


end


Function CompleteSetMovie(startE,endE,step)
variable startE
variable endE
variable step

Newdatafolder/O/S :FSMovie
NVAR KE = root:Packages:WienPanelGlobs:AzScanKEVAL
variable i,j
string calcwavenames

variable frames = (endE-startE)/step //get number of frames built up

	for(i=0;i<=frames;i+=1)
		
		KE = startE+step*i //updates KE on the Wien Panel
		Execute/Z "GenWienFEdata(\"FECutButton\")"
		Setdatafolder :WienCalc_FE
		
		controlinfo/W=WienPanel incbroad
			
			If(V_value)
				calcwavenames = WaveList("BroadAzplot*", ";", "DIMS:2" ) //build list of calculated waves
			else	
				calcwavenames = WaveList("Projection*", ";", "DIMS:1" )
			endif
		
			For(j=0;j<ItemsInList(calcwavenames,":");j+=1)
			
				string calc = StringFromList(j, calcwavenames, ";")
				string framename = calc+"f"+num2str(i)
				Duplicate/O  $calc, ::$framename
				
			endfor
			
		Setdatafolder ::
			
	endfor
	
end

Function Makemovie()


variable i

string frames = WaveList("BroadAzPlot*", ";", "DIMS:2" )

Newimage/S=0 $(stringfromlist(0,frames,";"))
ModifyGraph height={perUnit,40,left} , width={perUnit,40,left}
ModifyImage ''#0 ctab= {*,50,Gold,0}
doupdate

NewMovie/F=1/I/L




	for(i=0;i<ItemsInList(frames);i+=1)

			
			removeimage ''#0
			AppendImage $(stringfromlist(i,frames,";"))
			ModifyImage ''#0 ctab= {*,50,Gold,0}
			DoUpdate
			AddMovieFrame
			
	
	
	endfor
	
	CloseMovie
	
End

//########################################
// The functions below are for loading the separate slices which were saved from the BESSY APRIl09 beamtime
//#########################################

Function LoadSlices()

variable refnum

Open/R/D refNum 

LoadWave/O/G/M/D/L={0,45,0,0,0}/A=data/K=1 S_filename


end function

Function Filldatablock()

wave datablock
variable i
string sheetname

for (i=0;i<51;i+=1)

sheetname = "data"+num2str(i)
wave sheet = $sheetname
	Datablock[][][i]= sheet[p][q]
endfor
	
end



Function OverlapProfiles(Profile, Fitprofile,shiftguess) //this function determines the shift required in index number to fit one line to another, and returns this shift. 
	wave Profile//the data to be fitted
	wave Fitprofile //the data providing the fit ie the one being shifted
	variable shiftguess

	
	Duplicate/O FitProfile, Fit
	
	make/o/n=(numpnts(Profile)) dilatewave, transwave
	Dilatewave[] = Profile[p]/Fitprofile[p]
	Transwave[] = Profile[p]-FitProfile[p]
	wavestats/Q Dilatewave
	Variable dilate = V_avg
	wavestats/Q transwave
	Variable trans = V_avg
	Make/o/n = 3 Fitcoeff
	Fitcoeff[0] = shiftguess
	Fitcoeff[1] = trans
	Fitcoeff[2] = dilate
	FuncFit/N/Q/W=2/H="000" FitProfiles, Fitcoeff, Profile /D
	killwaves/z Dilatewave,transwave, Fit
	
Return(Fitcoeff[0])

End


//function GenDifference(wave1, wave2) //function takes difference of wave1 and wave2 and sets all negative values to zero
	

//end

Function IntegratedPolarProfile(data)

	wave data

	Make/o/n=(dimsize(data,0)) IntPolarProfile
	variable i
	make/o/n=(dimsize(data,0)) array

		for(i=0;i<=(dimsize(data,0));i+=1)
			array[] = data[i][p]
			IntPolarProfile[i] = sum(array)
		endfor

	wavestats IntPolarProfile
	variable minimum = V_min
	IntPolarProfile[] = IntPolarProfile[p]/minimum //normalise the profile to 1 at minimumm....
	killwaves/z  array
	string name = "IntPolarProfile"+"_"+nameofwave(data)
	rename IntPolarProfile, $name
	
	
end










