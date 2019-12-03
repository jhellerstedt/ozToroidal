#pragma rtGlobals=1		// Use modern global access method.

Macro EDCPanel() : Panel

if(CheckName("EDCpanel", 9,"EDCpanel"))
		Dowindow/F EDCpanel
else
	string curfolder = getdatafolder(1)	
			Newdatafolder/O/S root:Packages:EDCPanelGlobs
				
				variable/g EsumWidthVAL = 0
				variable/g EsumCentreVAL = 0
				variable/g kincrementsVAL=0
				variable/g EsumPercentVAL = 0
				variable/g KEatFermiVAL = 0
				string/g Ewincalstr = "No User Cal Wave Set"

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1268,63,1602,468) as "EDCPanel"
	Dowindow/C EDCPanel
	ModifyPanel cbRGB=(65280,48896,55552)
	SetDrawLayer UserBack
	SetDrawEnv linethick= 2,fillpat= 0
	DrawRRect 3,6,328,80
	SetDrawEnv fstyle= 1
	DrawText 12,76,"EDC Processing"
	SetDrawEnv linethick= 2,fillpat= 0
	DrawRRect 4,85,328,181
	SetDrawEnv fstyle= 1
	DrawText 12,176,"Energy Window Summation"
	DrawRect 16,236,316,255
	SetDrawEnv linethick= 2,fillpat= 0
	DrawRRect 5,192,328,318
	SetDrawEnv fstyle= 1
	DrawText 11,314,"Energy Window Calibration"
	Button AddEDCSlicesButton,pos={11,91},size={137,25},proc=OverlayEDC,title="Sum Energy Channels"
	SetVariable numslices,pos={190,136},size={72,16},disable=2,title="# Ch"
	SetVariable numslices,value= root:Packages:EDCPanelGlobs:EsumWidthVAL
	PopupMenu overlaymode,pos={15,204},size={181,21},bodyWidth=100,proc=EwinCalModeSelect,title="E win Calibration"
	PopupMenu overlaymode,mode=1,popvalue="Internal",value= #"\"Internal; User Specified\""
	Button button0,pos={11,17},size={118,24},proc=Makekparallelplot,title="Make k parallel plot"
	SetVariable CentreCh,pos={166,114},size={96,16},disable=2,title="Centre Ch"
	SetVariable CentreCh,limits={0,inf,1},value= root:Packages:EDCPanelGlobs:EsumCentreVAL
	SetVariable Kincrements,pos={136,19},size={110,16},title="k increments"
	SetVariable Kincrements,value= root:Packages:EDCPanelGlobs:kincrementsVAL
	Button button1,pos={16,264},size={125,23},proc=DetermineEChOffsets,title="Determine E Ch Offsets"
	Button SetEcalButton,pos={200,203},size={105,21},disable=2,proc=UserSelectEWinCal,title="Set User E Win Cal"
	TitleBox EWinCalPath,pos={24,240},size={125,13},disable=2,title="Using Standard Calibration"
	TitleBox EWinCalPath,labelBack=(65535,65535,65535),frame=0
	SetVariable EnSumPercent,pos={162,92},size={100,16},title="Window %"
	SetVariable EnSumPercent,value= root:Packages:EDCPanelGlobs:EsumPercentVAL
	PopupMenu EnWinSumMode,pos={14,124},size={133,21},proc=EnWinSumModeChange,title="Sum Mode"
	PopupMenu EnWinSumMode,mode=1,popvalue="Window %",value= #"\"Window %; Channels\""
	SetVariable KEatFermi,pos={115,332},size={125,16},title="KE at Fermi (eV)"
	SetVariable KEatFermi,value= root:Packages:EDCPanelGlobs:KEatFermiVAL
	Button button2,pos={9,331},size={97,21},proc=ConvertDisplayedEDCtoBE,title="Convert to BE"
	Button button3,pos={9,358},size={97,21},proc=ConvertDisplayedEDCtoKE,title="Restore to KE"


setdatafolder $curfolder

endif

EndMacro





Function EnWinSumModeChange(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	if(popnum==1) //if using the default mode, which is binning a user definable percentage of the energy window about the centre channel
		SetVariable Ensumpercent disable = 0
		Setvariable CentreCh disable = 2
		Setvariable numslices disable = 2
	elseif(popnum==2) //if using raw channel summation
		SetVariable Ensumpercent disable = 2
		Setvariable CentreCh disable = 0
		Setvariable numslices disable = 0
	endif

End



				
				
				
				
				
				
	
	
	
	










Function EDCtoKParallel(data,kincs)
wave data // the raw data
variable kincs         

	Make/o/n = (kincs, dimsize(data,1)) $(nameofwave(data)+"_"+"kpara")
	wave Process =  $(nameofwave(data)+"_"+"kpara")
	variable maxk = 0.511*sqrt(dimoffset(data,1)+dimsize(data,1)*dimdelta(data,1)) //get the maximum bounds of the plot (max k parallel)
	
End


Function DetermineChoffsets(Datablock) //this function will create a wave describing the channel offset in "direction" of one slie from the next using integrated profiles
wave datablock

make/o/n=(dimsize(Datablock,0), dimsize(datablock,1)) sheet1, sheet2
variable i,diff, pos1, pos2, shiftguess
variable layers = dimsize(datablock,2)
variable rows = dimsize(datablock,0)
variable cols = dimsize(datablock,1)
variable layerstep = dimdelta(datablock,2) //the difference betwen adjacent slices in the offset of the y scaling
variable estep = dimdelta(datablock,1)
variable midlayer = (layers-1)/2

shiftguess = estep/layerstep //guess the relative shift between the slices in channels usnig approx "estep" as the difference
Make/o/n=(layers) ChoffsetWave=0
sheet1[][] = datablock[p][q][midlayer]
Int2dsheet(sheet1,0,0,rows)
wave/z intwave
	Duplicate/O Intwave, Profile1 //Profile 1 is the angle integrated EDC of the central channel

		for(i=midlayer;i<(layers-1);i+=1) //these loops determine the energy difference between the central channel in the data block and the neighbouring channels....
		
			sheet2[][] = datablock[p][q][i+1]
			Int2dsheet(Sheet2, 0,0,rows)
			Duplicate/O INtwave, Profile2
			diff = OverlapProfiles(Profile1,Profile2,shiftguess)
			Choffsetwave[i+1] = diff*estep
			shiftguess = diff
		
		endfor
		
		shiftguess = -dimdelta(datablock,2)/dimdelta(datablock,1)
		
		for(i=midlayer;i>0;i-=1) //make a wave describing the relative shift in steps between the first and second, second and third, third and fourth , layers etc....
			
			sheet2[][] = datablock[p][q][i-1]
			Int2dsheet(Sheet2, 0,0,rows)
			Duplicate/O INtwave, Profile2
			diff = OverlapProfiles(Profile1,Profile2,shiftguess)
			Choffsetwave[i-1] = diff*estep
			shiftguess = diff	
			
		endfor
		
		Choffsetwave[midlayer] = 0
	
		Duplicate/O choffsetwave, CorrY
		
		killwaves/z Sheet1, sheet2, Intwave, fit_Profile1, fit_Profile2, Profile1, Profile2,choffsetwave, fitcoeff
		
End


Function OverlaySlices(datablock,corrY, num, centre) //this function takes the datablock and overlays 2num+1 slices together  to form  an integrated version
wave corrY,  datablock
variable num, centre

NVAR startKE

//note CorrY is the correction wave which may not have the same number of channels as the datablock. It is important  that this wave is scaled 0 to 1 where 1 is the 100% distance across the energy window, CorrY_scale
duplicate/O CorrY CorrY_Scale
setscale/I x, 0,1,CorrY_scale //set to 0, to 1 if not already done so. 
variable centre_frac =  centre/(dimsize(datablock,2)-1)
variable frac

variable i
 
make/o/n = (dimsize(datablock,0), dimsize(datablock,1)) sheet

sheet[][] = datablock[p][q][centre]
Setscale/P y,CorrY_scale(centre_frac)+startKE, dimdelta(datablock,1), sheet //get the energy scaling of the
Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet
		
variable centrestart = dimoffset(sheet,1) //get the start KE value of the centre sheet
variable delta = dimdelta(datablock,1)

variable ,j,k,mid  = ((dimsize(datablock,2)-1)/2), angle, energy, in, total, num2, Eoff,KE
killwaves/z sheet
Newdatafolder/o/S :tempaddfol

	for(i=0;i<=(2*num);i+=1) //build set of 2d waves from the data block, scaling each according the previously determined offsets
	
		make/o/n = (dimsize(datablock,0), dimsize(datablock,1)) sheet
		string wname= "sheet"+num2str(i)
		sheet[][] = datablock[p][q][centre-num+i]
		frac =  (centre-num+i)/(dimsize(datablock,2)-1) //fractional distance across the energy window
		Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet
		Setscale/P y, centrestart+CorrY_scale(frac), dimdelta(datablock,1), sheet
		Duplicate/O sheet, $wname
			
	endfor
	 
	killwaves sheet	
	
	string sheets = WaveList("sheet*", ";", "DIMS:2")
	wave startwave = $(StringFromList(0,sheets))
	wave endwave = $(Stringfromlist(ItemsInList(sheets)-1,sheets))
	variable globstart = dimoffset(endwave,1)
	variable globstart_trunc =  ceil(globstart/delta)*delta
	variable globend = dimoffset(startwave,1)+(dimsize(startwave,1)-1)*dimdelta(startwave,1)
	variable globend_trunc = floor(globend/delta)*delta
	
	
	variable size = 1+round((globend_trunc-globstart_trunc)/delta)
	Make/o/n = (dimsize(datablock,0), size) Overlay
	Setscale/P x, dimoffset(datablock,0), dimdelta(datablock,0), "deg", overlay
	Setscale/P y, globstart_trunc, delta, "KE (eV)", overlay
	variable numsheets = ItemsInList(sheets,";")
	
	for(i=0;i<dimsize(overlay,0);i+=1)
		angle = dimoffset(overlay,0)+i*dimdelta(overlay,0)
			for(j=0;j<dimsize(overlay,1);j+=1)
				KE = dimoffset(overlay,1)+j*dimdelta(overlay,1)
				total = 0
				num = 0
					for(k=0;k<numsheets;k+=1)
					wave crap = $(StringFromList(k, sheets,";"))
							total+=interp2d(crap,angle,KE)
							//total+=antons2dinterpfix(crap,angle,KE)		
					endfor
				overlay[i][j] = total/numsheets
					
			endfor
	endfor
	
	Duplicate/O overlay ::overlay
	Setdatafolder ::
	killdatafolder :tempaddfol

end

Function OverlaySlices_Simple(datablock,centrechan,numchan) //this function takes the datablock with known energy separation/scaling between the energy channels
wave datablock
variable centrechan, numchan

Variable Sum_Estart, Sum_Eend, Sum_EInc,i,j,k, theta, Echindex, energy, total //These will be the appropriate values for the start and end energy of the summed data set such that there are an integer number of point with size 
variable KEstep = dimdelta(datablock, 1)


variable ech_step = dimdelta(datablock,2) //the energy separation between adjacent channels, 
variable ech_offset = dimoffset(datablock, 2) //the startKE of the innermost energy channel


Variable innerKE = dimoffset(datablock, 2) + (centrechan+numchan)*ech_step //defines the start energy of the outermost slice being used. Defines the absolute start energy of the summed data. 
variable outerKE =  dimoffset(datablock, 2) + ((centrechan-numchan)*ech_step)+((dimsize(datablock,1)-1)*(dimdelta(datablock, 1))   //defines the end energy energy of the innermost slice being used. Defines the absolute end energy of the summed data



//now we need to find a happy enegry range with the same delta E used in the 

Sum_Estart = ceil(InnerKE/KEstep)*KEstep //obtain the start energy of the Summed EDC rounded to the nearest KEstep
Sum_Eend = floor(OuterKE/KEstep)*KEstep //obtain the end energy of the summed EDC, rounded to the nearest KEstep
Sum_Einc = 1 + round((Sum_Eend-Sum_Estart)/KEstep)

Make/o/n = (Dimsize(datablock, 0), Sum_EInc) Sum_EDC //creating the blank array for the summed data. 
Setscale/P x, dimoffset(Datablock, 0), Dimdelta(Datablock, 0), Sum_EDC
Setscale/P y, Sum_Estart, KEstep, Sum_EDC

Make/o/n = (Sum_Einc) Sumline
Make/o/n = (dimsize(datablock,1)) Echline
Setscale/I x, Sum_Estart, Sum_Eend, sumline


for(i=0;i<dimsize(Sum_EDC,0);i+=1) //run through all the polar angles

sumline = 0

		for(j= 0; j<(Sum_Einc+1);j+=1) //step through each energy in Sum_EDC, at  that polar angle
			
			energy = pnt2x(Sumline, j)
			total = 0
				
				for(k=0;k<(2*numchan+1);k+=1) //interpolate from each energy channel, the data at that given energy
					
					Echindex = centrechan-numchan+k
					Echline[] = datablock[i][p][Echindex]
					Setscale/P x, ech_offset+Echindex*ech_step, KEstep, Echline
					
					if(energy>=leftx(Echline)&&energy<=rightx(Echline))
						total+= Echline(energy)
					endif
					
				endfor
				
				sumline[j] = total
		endfor
		
		Sum_EDC[i][] = sumline[q]
endfor

end


interp2d



end
					
Function FitProfiles(w,x) : FitFunc
	Wave w
	Variable x //in this function, x will be  purely in terms of (non integer) point numbers

	wave/z Fit //this wave must exists in the curren data folder: it will provide the "function" to fit to the data
	variable num
	
	num = w[2]*Fit(x-w[0])+w[1]
	
	return(num)
	
End


Function OverlayEDC(ctrlName) : ButtonControl
	String ctrlName
	
	
	NVAR EsumwidthVAL = root:Packages:EDCPanelGlobs:EsumWidthVAL
	NVAR EsumCentreVAL = root:Packages:EDCpanelGLOBS:EsumCentreVAL
	NVAR EsumPercentVAL = root:Packages:EDCPanelGlobs:EsumPercentVAL
	SVAR Ewincalstr = root:Packages:EDCPanelGlobs:EWinCalStr	
	NVAR ewinstep
	NVAR CentralECh
	Wave/z datablock 
	
	if(!WaveExists(datablock)) //if there is not datablock in the current folder
		Doalert 0, "No Datablock in the current folder!!"
		return 0
	endif

	
	Variable layers = dimsize(datablock,2)
	
	Controlinfo overlaymode
	
		if(v_value==1) //using internal calibration ewinstep where ewinstep represents the energy separation between adjacent channels (assumed fixed for all channels)
					
			Make/o/n=(layers) Ewincal
			Ewincal[] = -(CentralEch*ewinstep)+p*ewinstep
			
			Controlinfo EnWinSumMode
			
				if(v_value==1) //if using the percentage summation methosd
					
					Esumwidthval = round((EsumpercentVAL*0.01*(layers-1)/2))
					OverlaySlices(datablock,EwinCal,Esumwidthval,CentralECh)
					
				elseif(v_value==2) //using chosen channel method
					variable minhalfwidth = min(CentralEch, layers-CentralEch)
						if(EsumwidthVAL>minhalfwidth)
							Doalert 0, "Range outside energy window! Reduce # of channels"
							return 0
						endif 
					OverlaySlices(datablock,EwinCal,Esumwidthval,EsumCentreVAL)
				endif
					
					
		else //using the user specified wave. This may be where the dispersion function is not linear, for example, and the user wants to use their own version of a calibration
			
			if(WaveExists(Ewincal)==0)
				Doalert 0, "No User Defined Calibraiton wave selected!"
				return 0
			else	
				wave/z Ewincal = $Ewincalstr
			endif
			
		endif
		

		
		wave overlay
		Displaywave(overlay)
		killwaves/z Edispersion
		
		
End


Function Kparallelplot(data,increments)
wave data
variable increments


variable maxKE = dimoffset(data,1)+(dimsize(data,1)-1)*dimdelta(data,1)
variable minKE = dimoffset(data,1)

variable kparamax, kparamin, thetamin, thetamax
thetamin = dimoffset(data,0)
thetamax = dimoffset(data, 0)+(dimsize(data,0)-1)*dimdelta(data, 0)

kparamax = 0.511*sqrt(maxKE)*sin(pi/180*thetamax)
kparamin = 0.511*sqrt(maxKE)*sin(pi/180*thetamin)

variable angle, energy,i,j, theta, k, value, val


Make/o/n = (increments, dimsize(data,1)) kp
setscale/I x, kparamin, kparamax,  "k (A^-1)", kp
setscale/P y, dimoffset(data,1), dimdelta(data,1), waveunits(data,1), kp


for(j=0;j<dimsize(kp,1);j+=1)
	energy = dimoffset(kp,1)+j*dimdelta(kp,1)
		
		for(i=0;i<dimsize(kp,0);i+=1)
	
		k = dimoffset(kp,0)+i*dimdelta(kp,0)
		theta = (180/pi)*asin(k/(0.511*sqrt(energy)))
			if(inarray(data,theta,energy))
				val = Antons2dinterpFix(data,theta,energy)
				kp[i][j] = val	
			endif
				
	endfor
endfor


End

Function Makekparallelplot(ctrlName) : ButtonControl
	String ctrlName
	
	
	wave data = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	NVAR increments = root:Packages:EDCpanelGLOBS:kincrementsVAL
	String dataname = nameofwave(data)
	string plotname = "kplot_"+dataname
	
	
	Kparallelplot(data,increments)
	wave kp
	Duplicate/O kp $plotname
	killwaves/z kp
	Displaywave($plotname)
		

End



Function CorrectEDC(edc,corrwave) //this function is intendedto to correct an edc for it energy variation by using a correction wave previously determined elsewhere
wave edc
wave corrwave

	  wavestats/Q corrwave
	  variable maxcorr = V_max
	  variable mincorr = V_min
	  variable curEstart = dimoffset(edc,1)
	//  variable curEend =  dimoffset(edc,1)+(dimsize(edc,1)-1)*dimdelta(edc,1)
	  variable i
	  variable estep = dimdelta(edc,1)
////	  variable newEstart = curEstart+maxcorr
	//  variable newEend = curEend+mincorr
//	  variable size = round((newEend-newEstart)/estep)
	  variable angle
	  duplicate/O edc, newedc
	//  make/o/n = (dimsize(edc,0),size) newedc
	  Setscale/P x,dimoffset(edc,0),dimdelta(edc,0), newedc
	  setscale/P y,dimoffset(edc,1), dimdelta(edc,1), newedc
			 
	 // Setscale/I y,newEstart, newEend, newedc
	  
	  make/o/n=(dimsize(edc,1)) ywave
	
	  
	  	for(i=0;i<dimsize(newedc,0);i+=1)
			ywave[] = edc[i][p]
			angle = dimoffset(edc,0)+i*dimdelta(edc,0)
			variable linestart = curEstart+corrwave(angle)
			setscale/P x,linestart,estep, ywave
			newedc[i][] = ywave(dimoffset(newedc,1)+q*dimdelta(newedc,1))
		endfor
	// newedc[][] = edc[p](dimoffset(edc,1)+q*dimdelta(edc,1)- corrwave[p])
	duplicate/O newedc, $nameofwave(edc)
	
	killwaves newedc
		
			
end	  	


Function UseCentreChannelCheck(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	Controlinfo UseCentralChannel
	
		if(V_Value==1)
			setvariable centre disable =1
		else
			setvariable centre disable =0
		endif

End


Function EwinRangeSelection(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo EwinrangeSelect
	
		if(V_value==1) //User has selected the energy window fraction
			Setvariable EwinRange title = "No. of Channels"
		else 
			Setvariable Ewinrange title = "E Win Fraction (0 - 1)"
		endif
			
			
End


Function DetermineEChOffsets(ctrlName) : ButtonControl
	String ctrlName
	
wave/z datablock
	
	if(WaveExists(datablock)) //if the datablock exists in the current directory, coninue

		DetermineChoffsets(Datablock)
		wave/z CorrY
		displaywave(CorrY)
	else

		Doalert 0, "No Datablock in current folder!!"
	endif
	

End

Function UserSelectEWinCal(ctrlName) : ButtonControl
	String ctrlName
	
	
	SVAR EWincalStr = root:Packages:EDCPanelGlobs:EWinCalStr
	string wavetouse
	string waveslist = wavelist("*", ";", "")
	prompt wavetouse, "", popup, waveslist
	Doprompt "Select Wave Display", wavetouse //prompt user to select a wave from the current df
	NVAR cancel = V_Flag
	wave/z chosenwave = $wavetouse


	If(V_Flag==0)
		Ewincalstr = 	GetWavesDataFolder(chosenwave, 2)
	endif
	

End

Function EwinCalModeSelect(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	SVAR pathstring  = root:Packages:EDCPanelGlobs:Ewincalstr
	
	if(popNum==1) //selecting internal calibration of energy window associated with the file
		Button SetEcalbutton disable = 2
		Titlebox Ewincalpath disable = 2, title = "Using Standard Calibration"
		
	elseif(popNum==2)
		Button SetEcalbutton disable = 0
		Titlebox Ewincalpath disable = 0, title = pathstring
	endif

	
End

Function ConvertToBE(data, FermiEn) //here data is an EDC, FermiEn is the KE at the Fermi Energy required as an input to the function. 
wave data
variable FermiEn

string energyunits = WaveUnits(data, 1)
variable startKE, endKE, startBE, endBE

	if(!cmpstr(energyunits,"KE (eV)")) //data in KE not binding energy"
	
			startKE = dimoffset(data, 1)
			endKE = startKE+(dimsize(data, 1)-1)*dimdelta(data, 1)
			startBE = -(startKE-FermiEn)
			EndBE = -(endKE-FermiEn)
			Setscale/I y, startBE, endBE, "BE (eV)", data
			Note/K data //kill existing note
			Note data, "StartKE="+num2str(startKE)+":"+"EndKE="+num2str(endKE)+":"+"FermiEn="+num2str(FermiEn) //saves the kinetic energy infomration and Fermi energy used for the BE scaling
			
	elseif(!cmpstr(energyunits, "BE (eV)")) //already in binding energy, will overwrite and update current BE scaling

			startKE = str2num(GetKeyParamFromNote("StartKE",data))
			endKE = str2num(GetKeyParamFromNote("EndKE",data))
			startBE = -(startKE-FermiEn)
			EndBE = -(endKE-FermiEn)
			Setscale/I y, startBE, endBE, "BE (eV)", data	
	
else
	Doalert 0, "No energy scale to work with!!"
endif

end


Function RevertKEScale(data)
wave data

	string wavenote = note(data)
		if(strsearch(wavenote, "EndKE",0)==-1) //if EndKE is not found in the note, i.e data has not yet been converted to BE in the past
			return -1
		else
	
		variable startKE, endKE, startBE, endBE	
			startKE = str2num(GetKeyParamFromNote("StartKE",data))
			endKE = str2num(GetKeyParamFromNote("EndKE",data))
			Setscale/I y, startKE, endKE, "KE (eV)", data
			
			
	endif
end

Function ConvertDisplayedEDCtoBE(ctrlName) : ButtonControl
	String ctrlName
	
	wave displaydata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	NVAR FermiEn = root:Packages:EDCPanelGlobs:KEatFermiVAL
	ConvertToBE(displaydata, FermiEn) 

End

Function ConvertDisplayedEDCtoKE(ctrlName) : ButtonControl
	String ctrlName
	
	wave displaydata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	RevertKEScale(displaydata)
 

End


















		
		




				
				
				
				
				
				
	
		
		






			
	
	

