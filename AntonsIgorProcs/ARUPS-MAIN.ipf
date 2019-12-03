#pragma rtGlobals=1		// Use modern global access method.

#include "EDCProcs"
#include "AzScanProcs"
#include "CISprocs"
#include "All IP Procedures"
#include "AntonsGeneralRoutines"



Function OffsetDataBlockPolarAngle(ctrlName) : ButtonControl
	String ctrlName
	
wave datablock
variable new_theta, current_theta
NVAR offset  = root:Packages:ARPESPanelGlobs:DBOffsetTheta_VAL
	
	if(waveexists(datablock))
		
		current_theta = dimoffset(datablock, 0)
		new_theta  = current_theta+offset
		setscale/P x, new_theta, dimdelta(datablock, 0), datablock
		
	else
	
	DoAlert 0, "No Datablock in current folder!"
	
	endif
		

End


Function PolarAngleCalibrateData(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = getdatafolder(1)
	wave datablock
	
	if(waveexists(datablock)) //if the user is in a raw data directory
		
		NVAR AngleCorrected
		wave sampleinfo
		variable inc = sampleinfo[1] //ii have chnaged this to work with BESSSY09 data

		if(!anglecorrected)	
	
			Setdatafolder root:Packages:DataCorrection:PolarAngleCorrection
			string selwave
			String waves  =WaveList("*", ";", "" )
			Prompt selwave, "", popup, waves
			Doprompt "Select Angle Correction Wave", selwave
		
			if(V_flag==0)
				
				wave Globalanglecalwave = $selwave
				setdatafolder $curfolder
				AngleCorrectDatablock(datablock,inc,GlobalangleCalwave)
				anglecorrected = 1
			endif
			
		else
			Doalert 0, "Data already corrected"
		endif
	else
		DoAlert 0, "Folder Not Data Folder"
	endif		
Setdatafolder $curfolder
End

Function EnergyCorrectData(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = getdatafolder(1)
	wave datablock
	
	if(waveexists(datablock)) //if the user is in a raw data directory
		
		NVAR EnergyCorrected
		wave sampleinfo

		if(!Energycorrected)	
			
			if(DataFolderExists("root:Packages:DataCorrection:EwinCorrection"))
				Setdatafolder root:Packages:DataCorrection:EwinCorrection
				string selwave
				String waves  =WaveList("*", ";", "" )
				Prompt selwave, "", popup, waves
				Doprompt "Select Energy Correction Wave", selwave
			
				if(V_flag==0)
					wave EwinCal = $selwave
					setdatafolder $curfolder
					//EcorrectDatablock(datablock,EwinCal)
					Energycorrected = 1
				endif
			else
				Doalert 0, "Must Load Energy Calibration File First"
			endif	
		else
			Doalert 0, "Data already corrected"
		endif
	else
		DoAlert 0, "Folder Not Data Folder"
	endif

End

Function EcorrectDatablock2(datablock,inc,GlobalCEProf)
wave datablock, globalCEProf
variable inc

	make/o/n=  (dimsize(datablock,2)) row
	make/o/n=(dimsize(datablock,0)) chdiffwave
	variable i,j,k,rfractdiff,chdiff,val
	
	for(j=0;j<dimsize(datablock,0);j+=1)
			
			rfractdiff = GlobalCEProf(dimoffset(datablock,0)+j*dimdelta(datablock,0)-inc)
			chdiffwave[j] = rfractdiff*(dimsize(datablock,2)-1)
			
	endfor

		for(i=0;i<dimsize(datablock,1);i+=1)
				for(j=0;j<dimsize(datablock,0);j+=1)
						row[] = datablock[j][i][p]
						
							datablock[j][i][] =row[r+chdiffwave[j]]
					
								
					endfor
				endfor

		
		killwaves/z sheet, radprof, row
end

Function AngleCorrectDatablock(datablock,inc,GlobalangleCalwave)
wave datablock,Globalanglecalwave
variable inc

variable i, j,k,rfract,calradius
variable winsize = dimsize(datablock,2)
//duplicate datablock, datablock2, datablock3
make/o/n= (dimsize(datablock,0), dimsize(datablock,1)) sheet
Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet
Setscale/P y, dimoffset(datablock,1), dimdelta(datablock,1), sheet

Make/o/n = (dimsize(datablock,0)) AngleCalwave
Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), Anglecalwave
Make/o/n = (dimsize(GlobalAnglecalwave,0)) yprof

	for(k=0;k<dimsize(datablock,2);k+=1)
		
		rfract = k/(winsize-1)
		calradius = rfract*(dimsize(globalanglecalwave,0)-1)
		
		Anglecalwave[]  = (interp2d(Globalanglecalwave,calradius,pnt2x(Anglecalwave,p)-inc))+inc
			
			 
		Sheet[][] = datablock[p][q][k]
		AngleCorrect2dSheet(sheet, anglecalwave)
		wave sheet_angcal
		datablock[][][k] = sheet_angcal[p][q]
	
	endfor

killwaves sheet, sheet_angcal, yprof //AngleCalwave

end






Function EnergyCorrectData2(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = getdatafolder(1)
	wave datablock
	
	if(waveexists(datablock)) //if the user is in a raw data directory
		
		NVAR EnergyCorrected
		wave sampleinfo
		variable inc = -35 //sampleinfo[2]

		if(!Energycorrected)	
			
			if(DataFolderExists("root:Packages:DataCorrection:EwinCorrection"))
				Setdatafolder root:Packages:DataCorrection:EwinCorrection
				string selwave
				String waves  =WaveList("*", ";", "" )
				Prompt selwave, "", popup, waves
				Doprompt "Select Energy Correction Wave", selwave
			
				if(V_flag==0)
					wave GlobalCEProf = $selwave
					setdatafolder $curfolder
					EcorrectDatablock2(datablock,inc,GlobalCEProf)
					Energycorrected = 1
				endif
			else
				Doalert 0, "Must load Energy Correction Template First"
			
			endif	
		else
			Doalert 0, "Data already corrected"
		endif
	else
		DoAlert 0, "Folder Not Data Folder"
	endif

End


Function LoadTGM4CorrWave(ctrlName) : ButtonControl
	String ctrlName
	
	String curfolder =getdatafolder(1)
	NVAR PassEn
	
	Newdatafolder/O/S root:Packages:DataCorrection
	Newdatafolder/O/S :TGM4Correction
	LoadWave/H/O/A=crap
	setdatafolder $curfolder

End

Function TGMCorrData(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = getdatafolder(1)
	wave datablock
	
	if(waveexists(datablock)) //if the user is in a raw data directory
		
		NVAR mcorrected

		if(mcorrected!=1)
	
			if(DataFolderExists("root:Packages:DataCorrection:TGM4Correction"))
				Setdatafolder root:Packages:DataCorrection:TGM4Correction
				string selwave
				String waves  =WaveList("*", ";", "" )
				Prompt selwave, "", popup, waves
				Doprompt "SelectvTGM4 Correction Wave", selwave
			
				if(V_flag==0)
					wave TGM4corrwave = $selwave
					TGM4Fluxcorrect(datablock, TGM4corrwave)
					mcorrected=1
				endif
			else
				Doalert 0, "Must load TGM4 Correction wave first"
			
			endif	
		else
			Doalert 0, "Data Already Corrected"
		endif
	else
		DoAlert 0, "Folder Not Data Folder"
	endif
	
	Setdatafolder $curfolder

End

Function TGM4FluxCorrect(datablock,fluxwave) //this function canbe used to normalise CIS data take on the HEG at TGM4 if mirror current has not been measured (mono profile)
wave datablock
wave fluxwave

variable startcorr = fluxwave(dimoffset(datablock,1))
datablock[][][]/=(fluxwave(dimoffset(datablock,1)+q*dimdelta(datablock,1))/startcorr) //normalise the data block, preserving the first intensity and correcting other values relative to i via the fluxwave
			
End

Function LoadECorrWave(ctrlName) : ButtonControl
	String ctrlName
	
	String curfolder =getdatafolder(1)
	NVAR PassEn
	
	Newdatafolder/O/S root:Packages:DataCorrection
	Newdatafolder/O/S :EWinCorrection
	LoadWave/H/O/A=crap
	setdatafolder $curfolder

End

Function LoadAngCorrWave(ctrlName) : ButtonControl
	String ctrlName
	
	String curfolder =getdatafolder(1)
	NVAR PassEn
	
	Newdatafolder/O/S root:Packages:DataCorrection
	Newdatafolder/o/s :PolarAngleCorrection
	
	LoadWave/H/O/A=crap
	setdatafolder $curfolder

End


Function StackSlicesFromDatablock(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR num = root:Packages:ARPESpanelglobs:AddslicesnumVAL
	NVAR centre  = root:Packages:ARPESpanelglobs:AddslicesCentreVAL
	NVAR dir = root:Packages:ARPESPanelGlobs:slicedirbuttonVAL
	
	wave/z datablock
		if(waveexists(datablock))
			Stackslices(datablock, centre, num, dir)
			wave stacked
			displaywave(stacked)
		else
			Doalert 0, "No datablock in this folder"
		endif
End



Function ExecuteLineProfiling(ctrlName) : ButtonControl
	String ctrlName
	
WMCreateImageLineProfileGraph();

End




Macro ARPESPanel() : Panel

	string curfolder = getdatafolder(1)
	
		
	if(CheckName("ARPESpanel", 9,"ARPESpanel"))
		Dowindow/F ARPESpanel
	else
		
		Newdatafolder/O/S root:Packages	
		Newdatafolder/O/S :ARPES
		Newdatafolder/O/S root:Packages:ARPESPanelGlobs
				
				variable/g slicenumVAL=0
				variable/g slicedirbuttonVAL
				variable/g polaroffsetVAL
				variable/g PolintL, PolintR
				variable/g AddSlicesNumVAL
				variable/g AddSlicesCentreVAL
				variable/g spikesmthVAL
				variable/g DBOffsetTheta_VAL
				variable/g DBFlattenDim_VAL

	
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1138,134,1445,748) as "ARPESpanel"
	Dowindow/C ARPESpanel
	ModifyPanel cbRGB=(0,52224,26368)
	SetDrawLayer UserBack
	SetDrawEnv fstyle= 1
	DrawText 10,366,"General Procedures"
	SetDrawEnv linethick= 2
	DrawLine -1,65,311,65
	SetDrawEnv fstyle= 1
	DrawText 8,89,"DataBlock Slicing"
	SetDrawEnv linethick= 2
	DrawLine 0,128,319,128
	SetDrawEnv linethick= 2
	DrawLine 1,344,324,344
	SetDrawEnv fsize= 14,fstyle= 1
	DrawText 6,23,"File I/O"
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 9,498,"Data Correction"
	DrawText 9,430,"E Window Corr"
	DrawText 8,404,"Polar Angle Corr"
	DrawLine 11,508,298,508
	Button buttonLoad,pos={112,24},size={150,30},proc=LoadARPESdata,title="Load ARPES..."
	Button buttonLoad,fSize=18
	SetVariable slicenum,pos={127,74},size={65,16},bodyWidth=35,proc=SliceSelect,title="Index"
	SetVariable slicenum,value= root:Packages:ARPESPanelGlobs:slicenumVAL
	Button button2,pos={106,447},size={90,21},proc=CorrectForMirrorCurrent,title="M. Curr. Correct"
	Button button6,pos={8,194},size={130,21},proc=OffsetThePolarAngle,title="Offset Graph Polar Angle"
	Button button6,help={"Applies an offset in polar angle to the top graph"}
	SetVariable PolarOffset,pos={161,193},size={119,16},title="Theta offset (deg)"
	SetVariable PolarOffset,value= root:Packages:ARPESPanelGlobs:polaroffsetVAL
	Button EndSessionbutton,pos={0,207},size={50,20},disable=1
	Button ReplacePeaksbutton,pos={69,51},size={50,20},disable=1
	SetVariable peakdetectstep,pos={129,51},size={50,20},disable=1
	Button Displaywavebutton,pos={8,229},size={91,19},proc=DisplayWaveInFolder,title="Display Wave"
	SetVariable SliceDirButton,pos={202,74},size={57,16},bodyWidth=35,title="Dim"
	SetVariable SliceDirButton,limits={0,inf,1},value= root:Packages:ARPESPanelGlobs:slicedirbuttonVAL
	Button PolarIntButton,pos={8,137},size={133,21},proc=IntPolarAngles,title="Integrate Theta"
	SetVariable PolintL,pos={145,141},size={67,16},bodyWidth=40,title="From"
	SetVariable PolintL,value= root:Packages:ARPESPanelGlobs:PolintL
	SetVariable PolintR,pos={215,141},size={65,16},bodyWidth=48,title="To"
	SetVariable PolintR,value= root:Packages:ARPESPanelGlobs:PolintR
	CheckBox NewSliceCheck,pos={9,99},size={100,14},title="Gen New Slices?",value= 0
	Button button0,pos={118,380},size={89,23},proc=LoadAngCorrWave,title="Load AngCorr"
	Button button0,fStyle=2
	Button button1,pos={120,413},size={88,23},proc=LoadECorrWave,title="Load ECorr"
	Button button1,fStyle=2
	Button button3,pos={217,382},size={81,22},proc=PolarAngleCalibrateData,title="Angle Correct"
	Button button4,pos={216,413},size={82,23},proc=EnergyCorrectData,title="Energy Correct"
	Button button9,pos={10,34},size={93,22},proc=UpdateHeaderListBox,title="Display Header"
	Button button10,pos={9,446},size={88,23},proc=InitiateFixSpikes,title="Correct Spikes"
	Button button8,pos={8,167},size={130,20},proc=OffsetDataBlockPolarAngle,title="Offset DB Theta"
	SetVariable setvar0,pos={161,170},size={119,16},title="Theta offset (deg)"
	SetVariable setvar0,value= root:Packages:ARPESPanelGlobs:DBOffsetTheta_VAL
	Button LineProfile,pos={104,229},size={85,20},proc=ExecuteLineProfiling,title="Line Profiling"
	Button FlattenDBlockButton,pos={9,258},size={98,20},proc=FlattenDBlock,title="Flatten DataBlock"
	SetVariable setvar1,pos={113,261},size={91,16},title="Dimension"
	SetVariable setvar1,limits={0,2,1},value= root:Packages:ARPESPanelGlobs:DBFlattenDim_VAL
	Button button5,pos={11,290},size={112,21},proc=FixSingleStepError,title="Fix Single Step in DB"
	Setdatafolder $curfolder
	
	endif
	
	
EndMacro


Function FormatSliceWindow(slicenum,windowname)
	variable slicenum
	string windowname

	
	SVAR scantype=:scantype
	string windowtitle
	wave slice
	wave datablock
	
	if(cmpstr(scantype, "Fermi scan")==0) //if scan was an azimuth scan
	
			nvar startKE=:startKE
			nvar estep=:estep
			variable KE = startKE+slicenum*estep
			
			Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0), waveunits(datablock,0),slice
			Setscale/P y, dimoffset(datablock,1),dimdelta(datablock,1),waveunits(datablock,1),slice
			windowtitle = "slice"+"_"+"File"+getdatafolder(0)[1,3]+":"+ "Kinetic Energy ="+num2str(KE)+"eV"
			Label left "Azimuthal Angle (deg)"
			label bottom "Polar Angle (deg)"
			modifygraph/Z wbRGB=(5000,63000,63000 ) //make the window colour
			ModifyImage slice ctab= {*,*,Grays,0} //greyscale image
			
			
			
		endif
		
		if(cmpstr(scantype, "EDC")==0) //if scan was an edc scan
		
			nvar estep
			nvar startKE
			nvar llayers
			variable offset
			offset = startKE-estep*((llayers-1)/2-slicenum) 
			Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0),waveunits(datablock,0),slice
			SetScale/P y,offset,estep,"eV",slice
			windowtitle = windowname
			modifygraph/W=$windowname/Z wbRGB=(5000,40000,20000 ) //make the window colour
			ModifyImage/W=$windowname slice ctab= {*,*,Grays,0} //greyscale image
			label left "Kinetic Energy(eV)"
			label bottom "Polar Angle (deg)"
			
		endif
		
			
		
	dowindow/T $windowname windowtitle
	showinfo
	
	
	
end function



Function/S makeslicewave(datablock,slicenum,direction,owrite) //this function gets a slice from the 3d data block
	variable slicenum
	wave datablock
	variable direction,owrite
	
	variable i = 0
	
	string curnames = WaveList("slice*", ";", "DIMS:2" )
	
		//if(owrite==1) //new slice is to be made. generate new slice names
			//	do
					
				//	if(strsearch(curnames,name,0 )==-1) //if there is no slice called slicei right now take its spot
				//		break
				//	else
				//		i+=1
				//	name="slice"+num2str(i)	
				//	endif
			//	while(1)
	//	endif
	
	
	variable rows= dimsize(datablock,0)
	variable cols=dimsize(datablock,1)
	variable layers = dimsize(datablock,2)
	
	variable  j
	
	if(direction==0) //slice facing x direction
	
	make/O/N=(rows, cols) data
		data[][] = datablock[p][q][slicenum]

	elseif(direction==1) //slice facing y direction
	
	make/O/N=(layers, cols) data
		data[][] = datablock[slicenum][q][p]

	elseif(direction==2) //slice facing z direction
	make/O/N=(rows, layers) data
		data[][] = datablock[p][slicenum][q]
	endif
	
	duplicate/O data, slice
	killwaves data
	

end

Function setslicescaling(varnum, slice)//assumes that a wave called slice exists
variable varnum
wave slice
		
	SVAR  scantype
	NVAR slicedir = root:Packages:ARPESPanelGlobs:slicedirbuttonVAL
	NVAR llayers
	variable startE
	
		
		if(stringmatch(scantype, "Azimuth scan")||stringmatch(scantype, "Fermi scan")||stringmatch(scantype, "Fermi")||stringmatch(scantype, "Azimuth"))
		
			NVAR middleKE
			NVAR Ewinstep
			
			if(slicedir==0) //if slice is x facing
				Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0),"deg", slice
				Setscale/P y, dimoffset(datablock,1),dimdelta(datablock,1),"Az Angle (deg)",slice
				startE = middleKE-dimdelta(datablock,2)*(((dimsize(datablock,2)-1)/2-varnum))
				AddKeyParamToNote(slice,"AzScanEn",num2str(startE))		
			elseif(slicedir==2) //slice is z facing
				Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0),"deg", slice
				Setscale/p y, dimoffset(datablock,2), dimdelta(datablock,2), "KE (eV)",slice
			elseif(slicedir==1) //slice is y facing
				Setscale/P x,dimoffset(datablock,2),dimdelta(datablock,2),"KE (eV)", slice
				Setscale/p y, dimoffset(datablock,1), dimdelta(datablock,1), "Az Angle (deg)",slice
			endif	
		endif
		
		if(cmpstr(scantype, "EDC")==0) //if scan was an edc scan

			NVAR ewinstep
			NVAR startKE
			NVAR KEstep
			NVAR CentralECh
			
			variable startKE2, startKE3
			
				if(slicedir==0) //if slice is x facing
					startKE2 = dimoffset(datablock, 2)+varnum*dimdelta(datablock, 2) 
					Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0),"deg",slice
					SetScale/P y,startKE2,dimdelta(datablock,1),"KE (eV)",slice
				elseif(slicedir==1)//hard to scale this slice, work out later
					Setscale/P x,0, 1, "Energy Ch", slice
					Setscale/P y,0,KEstep,"KE step (eV)",slice
				elseif(slicedir==2)
					startKE3 = (startKE+dimdelta(datablock,1)*varnum)-(ewinstep*(dimsize(datablock,2)-1)/2)
					Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0),"deg", slice
					Setscale/P y, startKE3, dimdelta(datablock,2), "KE (eV)", slice 
				endif
		endif
		
		if(cmpstr(scantype, "CIS")==0)
		
			nvar stepph
			nvar estep
			nvar minKE
		
	
			if(slicedir==0) //if slice is x facing
				Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0),"deg", slice
				SetScale/P y,dimoffset(datablock,1), stepph , "Photon Energy (eV)",slice
				startE = minKE-dimdelta(datablock,2)*((dimsize(datablock,2)-1)/2-varnum)
				Make/o/n=(dimsize(datablock,1)) CisEn
				CISEn[] = startE+p*dimdelta(datablock,1) //create an array of energies to attach to this wave for use in processing
				AttachCISEnergiesToWaveNote(slice,CISen) //atttch the kinetic enegies of the CIS scan to the wave note)
				killwaves/z CisEn
			elseif(slicedir==1) //slice is y facing
				Setscale/P x, dimoffset(datablock,2), dimdelta(datablock,2), "BE (eV)", slice
				Setscale/P y,dimoffset(datablock,1),stepph,"Photon Energy (eV)",slice
			elseif(slicedir==2) //slice is z facing
				Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0),"deg", slice
				Setscale/p y, dimoffset(datablock,2), dimdelta(datablock,2), "BE (eV)", slice
				//Setscale/p y, (minKE+varnum*stepph)-(((dimsize(datablock,2)-1)/2)*estep, estep, slice
			endif
		
		endif
end function




Function RemoveBackground(polyorder)
variable polyorder

	string topimage = StringFromList(0,imagenamelist("",";"),";")
	make/O/N = (dimsize($topimage,0),dimsize($topimage,1)) mask //generate a ROI mask
	mask[][] = 1
	setscale/P x,dimoffset($topimage,0), dimdelta($topimage,0), mask
	setscale/P y,dimoffset($topimage,1), dimdelta($topimage,1), mask
	
	ImageRemovebackground/R =mask/P=(polyorder) $topimage
	wave M_removedBackground
	string newwavename = "p"+num2str(polyorder)+"_"+"Sub"+"_"+(nameofwave($topimage))
	Duplicate/O M_removedbackground $newwavename
	setscale/P x,dimoffset($topimage,0), dimdelta($topimage,0), $newwavename
	setscale/P y,dimoffset($topimage,1), dimdelta($topimage,1), $newwavename
	
	Displaywave($newwavename)
	Killwaves/Z M_removedbackground
	
	

end






Function ShowXYProfiles()

					wave datawave = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
					string windowname = winname(0,1)

					makeline(datawave) //make xline and yline in the current data folder
					wave xlinename = $(nameofwave(datawave)+"_"+"xline")
					wave ylinename = $(nameofwave(datawave)+"_"+"yline")
					AppendtoGraph/W=$windowname/L=yxlaxis xlinename
					AppendToGraph/W=$windowname/B=xylaxis/R=yylaxis ylinename
					ShowInfo 
					Cursor/M/H=1 A
					ModifyGraph margin(right)=62
					ModifyGraph mirror(bottom)=2,mirror(left)=2
					ModifyGraph lblPos(bottom)=69,lblPos(left)=68
					ModifyGraph freePos(yxlaxis)=0
					ModifyGraph freePos(yylaxis)=0
					ModifyGraph freePos(xylaxis)=-100
					ModifyGraph axisEnab(yxlaxis)={0,0.3}
					ModifyGraph axisEnab(bottom)={0,0.7}
					ModifyGraph axisEnab(yylaxis)={0.35,1}
					ModifyGraph axisEnab(xylaxis)={0.75,1}
					ModifyGraph axisEnab(left)={0.35,1}
					CursorDependencyForGraph(windowname)
end


Function MCurrentCorrect(datablock,mirrorCurwave) //this function normalises the data to the mirror current measured at the art of the experiment
wave datablock
wave mirrorCurwave
	
	datablock[][][]/=(mirrorcurwave[q]*1E9) //normalise each datavalue to nominal 1nA of mirror current
				
end function

Function findstars(path) //this function finds the "***" delimeter that seperates the header from the mirror currentand the mirror current from the data
	string path
	
	Variable/G mindex = 0
	variable/G dindex = 0
	variable i=-1,j=-1
		
	
		do
			make/o/T/N=1 find
			i+=1
				if(i>50) 
					break 
				endif
			loadwave/m/J/Q/L={0,i,1,0,1}/B="N=find;"/K=2 path
			wave/Z/T find1
			j=char2num(find1[0])
			killwaves find1
			killwaves find
		
		while(j!=42) //ascii code for *
		
	mindex = i +1
	dindex = i + 4 
end

Function LoadMirrorCurrent(path,startindex)
		string path
		variable startindex
		
			LoadWave/O/M/J/L={0,startindex,1,0,0}/A=mirrorcur/K=1 path
			wave mirrorcur0
			Make/o/n = (dimsize(MirrorCur0,1)) MirrorCurwave
			Mirrorcurwave[] = mirrorCur0[0][p]
			killwaves/z mirrorcur0,mirrorcur1
		
end

Function/S DetermineScantype(path)
	string path	
	
	variable i=-1, match1, match2, match3, match4, match5, match6, match7,match8,match9
	string scantype

	Make/O/T/N=2 scantypewave
		do
			i+=1
				if(i>10) 
				break 
				endif
			
			loadwave/O/M/J/Q/L={0,i,1,0,2}/B="N=scantypewave;"/K=2 path
			scantype = scantypewave[0][0]
			print scantypewave[0][0],scantype,i
			
			match1 =stringmatch(scantype,"CIS")  
			match2 = stringmatch(scantype,"EDC")
			match3 = stringmatch(scantype,"Azimuth Scan")
			match4 = stringmatch(scantype, "CFS")
			match5 = stringmatch(scantype, "LEED")
			match6 = stringmatch(scantype,"Fermi scan")
			match7 = stringmatch(scantype, "Fermi")
			match8 = stringmatch(scantype, "Azimuth")
			
			if((match1==1)||(match2==1)||(match3==1)||(match4==1)||(match5==1)||(match6==1)||(match7==1)||(match8==1))
				break
			
			endif
			while(1)
			
			killwaves/z scantypewave
return Scantype


end 



Function LoadARPESdata(ctrlName) : ButtonControl
	String ctrlName
	
	LoadToroidalData()

End


//Function LoadToroidalData_new()
	
	variable refnum,i
	string line
	string curfolder = getdatafolder(1) //get reference to current data folder. 
	
	Open/R/M="Open ARPES file" refnum //bring up dialog for user to select the file. refnum will be zero if user cancelled load
	string path = S_filename //full path to file
	string filename  = ParseFilePath(3, path, ":",0,0)
	string dfname = filename[0,strsearch(filename, "-",0)-1] //truncated path for folder name
	
	
		if(cmpstr(path, "")==0) //user cancelled
			return -1
		end
		
		if(datafolderexists(dfname))	 // does the datafolder currently exist?
				
			DoAlert 1, "Folder aleady exists. Overwrite current Datablock? (all other waves will remain unchanged)"
				
					if(V_flag==2) //if user clicks no, then exits 
						return -1
					endif
		endif
		
		NewDataFolder/O/S :$dfName			 //create the data folder
		Findstars(path) //find the**** separators which separate the mirror current data from the ARPES data
		NVAR mindex //mirror current row index
		NVAR dindex  //data begins row index  
		
					
		Make/o/t/n=(mindex) HeaderWave
		FSetPos refNum, 0
	
		For(i=0;i<mindex;i+=1) //read all lines of the header from the file into Headerwave
		
			FReadLine/T=num2char(13) refNum, line
			Headerwave[i] = line
		
		endfor
		
		
		
	
	

Function LoadToroidalData()
	
	variable refnum,i
	string line
	string curfolder = getdatafolder(1) //get reference to current data folder. 
	
	Open/R/M="Open ARPES file" refnum //bring up dialog for user to select the file. refnum will be zero if user cancelled load
	string path = S_filename //full path to file
	string filename  = ParseFilePath(3, path, ":",0,0)
	string dfname = filename[0,strsearch(filename, "-",0)-1] //truncated path for folder name
	
		if(cmpstr(path, "")==0) //user cancelled
			return -1
		endif
		
			
		if(datafolderexists(dfname))	 // does the datafolder currently exist?
				
			DoAlert 1, "Folder aleady exists. Overwrite current Datablock? (all other waves will remain unchanged)"
				
					if(V_flag==2) //if user clicks no, then exits 
						return -1
					endif
		endif
						
	NewDataFolder/O/S :$dfName			 //create the data folder

	Findstars(path) //find the**** separators which separate the mirror current data from the ARPES data
	NVAR mindex //mirror current row index
	NVAR dindex  //data begins row index  
			
	Make/o/t/n=(mindex) HeaderWave
	FSetPos refNum, 0
		
		For(i=0;i<mindex;i+=1) //read all lines of the header from the file into Headerwave
		
			FReadLine/T=num2char(13) refNum, line
			Headerwave[i] = line
		
		endfor
		
			LoadMirrorCurrent(path,mindex) //load the mirror current array
			LoadGeneralParams(path) //load and create globals for Pass En, sampleinfo, etc.....
			
			String/g Scantype  = DetermineScantype(path) //this determines the type of scan performed
			variable/g exptime 
			sscanf headerwave[26], "Exposure time:  %f" , exptime
						
				if(cmpstr(scantype,"EDC")==0) //what to do if experiment is an EDC scan
					LoadEDC(path)
				endif
	
				if(cmpstr(scantype,"Fermi scan")==0)
					LoadAzScan(path)
				endif
	
				if(cmpstr(scantype, "Azimuth scan") ==0)
					LoadAzScan(path)
				endif
		
				if(cmpstr(scantype, "Azimuth") ==0)
					LoadAzScan(path)
				endif
		
				if(cmpstr(scantype, "Fermi")==0)
					LoadAzScan(path)
				endif
		
				if(cmpstr(scantype, "CIS") ==0)
					LoadCIS(path)
				endif
							
				variable/g mcorrected=0, AngleCorrected=0, EnergyCorrected=0, expcorrected //set the correction globals
		
	Note Datablock, "Scantype = " + scantype+";"
	killvariables/z mindex,pindex,dindex,mrows,ncols,
	Setdatafolder $curfolder
	
End function



Function LoadGeneralParams(path)
string path

variable i ,match1,match2,match3,match4,match5,match6,match7
string param,val
		
		do
			Make/O/T/N=1 paramtest
			i+=1 //this loop loads further parameters eg: step size in energy window, pass energy etc....
				
					if(i>(50))//give it 40 lines for it to find a start parameter
				
						break 
				
					endif
			
			loadwave/M/J/Q/L={0,i,1,0,1}/B="N=paramtest;"/K=2 path //loads the wave paramtest which will act as a test wave for these params
			wave/T/Z paramtest1
				if(stringmatch(paramtest1, ""))
					param = ""
				else
					param = paramtest1[0]
			
				endif
			killwaves/z paramtest1
			killwaves/z paramtest
			///add more matchs as necessary necessary
			match1 =stringmatch(param,"Energy step size in*")  //searching for energy step size param
			match2 = stringmatch(param,"Pass energy*")
			match3 = stringmatch(param,"Sample Position*")
			match4 = stringmatch(param, "Centre line index*")
			
				if((match1)) //found the energy window step size (energy difference between adjacent channels)
				
					loadwave/M/J/L={0,i,1,2,1}/A=ewinstep/K=2 path
					wave/T ewinstep0
					variable/g ewinstep
					val = ewinstep0[0]
					ewinstep = str2num(val)
					killwaves/Z ewinstep, ewinstep0
					
				endif
				
					
				if((match2)) //found the pass energy
				
					loadwave/M/J/L={0,i,1,2,1}/A=PassEnergy/K=2 path
					wave/T PassEnergy0
					variable/g PassEn
					val = Passenergy0[0]
					PassEn = str2num(val[0,strlen(val)-2])
					killwaves/Z Passenergy, passenergy0
				
				endif
				
				
				if((match3)) //found the sample info
				
					LoadWave/O/J/M/L={0,i,1,0,4} path 
					string ewave = StringfromList(0,S_wavenames)
					duplicate/O $ewave Sampleinfo	
					killwaves wave0
				
				endif
				
				
				if((match4)) //found the central E channel index
				
					loadwave/M/J/L={0,i,1,2,1}/A=CentralEch/K=2 path
					wave/T CentralEch0
					variable/g CentralEch
					val = CentralEch0[0]
					CentralEch = str2num(val)
					killwaves/Z Passenergy, passenergy0
				
				
				endif
			
			while(1)
			
END



Function DetermineParamStartIndex(path) //load the experimental parameters from the file header
		string path
		
		variable i=-1, match1, match2, match3

		string startparam, val

	
		do
			Make/O/T/N=1 paramtest
			i+=1 //this loop loads the file and determines the position of starting parameters 
					if(i>20) //give it 20 lines for it to find a start parameter
				
					break 
				
					endif
			
			loadwave/M/J/L={0,i,1,0,1}/B="N=paramtest;"/K=2 path //loads the wave paramtest which will act as a test wave for start params
			wave/T/Z paramtest1
				if(stringmatch(paramtest1,""))
					startparam=""
				else
					startparam = paramtest1[0]
				endif
			killwaves paramtest1
			killwaves paramtest
			
			match1 =stringmatch(startparam,"Start*")  //later on can insert possible starting lines from earlier files.
			match2 = stringmatch(startparam,"Min*")
			match3 = stringmatch(startparam,"Photon*")
			
				if((match1==1)||(match2==1)||(match3==1))
					break
				
				endif
		
			while(1)
			
return i
  		
end function
	
Function loadEDC(path) //load an EDC experiment
string path


		string ewave
		NVAR  Ewinstep, PassEn, dindex, CentralECh
		Variable paramstart  = DetermineParamStartIndex(path)		
		LoadWave/O/J/M/L={0,paramstart,16,2,1} path // load 9 rows of header info that will contain parameters
		ewave=StringfromList(0,S_wavenames)	//obtain wavename of loaded wave in string ewave
		duplicate/O $ewave expconst //copy the wave into expconst
		killwaves wave0		//kill loaded wave			
						

		variable/G ph=expconst[0],startKE=expconst[1],endKE=expconst[2],numstep=expconst[3], KEstep =expconst[4] , StartBE = expconst[5], endBE = expconst[6], arcspan = expconst[9], arcoffset = expconst[11]  //allocate constants in expconst to variable for use in prog
		killwaves expconst
		LoadWave/O/G/M/D/L={0,dindex,0,0,0}/A=data/K=1 path //load the data
		
		Create3dData() //make 3D datablock 
		wave datablock
		
		variable thetastart = -90 //scaling the polar angle range of the data
		variable thetaend = 90
		setscale/I x,thetastart,thetaend,"deg",datablock
		Setscale/P y,0,KEstep,"eV", datablock //scaling the kinetic energy
		variable ewinstart
		ewinstart = startKE - CentralEch*Ewinstep
		setscale/P z,ewinstart, Ewinstep,"eV",datablock
		
		
end function
		

Function LoadAzScan(path)	//load an azimuthal scan 
	string path

		string ewave
		NVAR  Ewinstep, PassEn, dindex , CentralEch
		Variable paramstart  = DetermineParamStartIndex(path)		
	
  		LoadWave/O/J/M/L={0,paramstart,14,2,1} path // load 9 rows of header info that will contain parameters
		ewave=StringfromList(0,S_wavenames)	//obtain wavename of loaded wave in string ewave
		duplicate/O $ewave expconst //copy the wave into expconst
		killwaves/z wave0		//kill loaded wave			
		wave expconst
		
		Variable/G ph=expconst[0],middleKE=expconst[1],startphi=expconst[3],endphi=expconst[4],numstep=expconst[5],stepsize=expconst[6], arcspan = expconst[10], arcoffset = expconst[12]
		killwaves/z expconst
		LoadWave/O/G/M/D/L={0,dindex,0,0,0}/A=data/K=1 path		//load data slices
	
		Create3dData()
		
		variable thetastart = -(arcspan/2)//-arcoffset
		variable thetaend = (arcspan/2) //-arcoffset
	
		//setscale/I x,thetastart,thetaend,"deg",datablock
		setscale/I x,t-90,90,"deg",datablock
		setscale/P y,0,abs(stepsize),"phi-deg", datablock
		variable ewinstart
		ewinstart = middleKE - CentralEch*Ewinstep
		setscale/P z, ewinstart, Ewinstep, "eV", datablock
	
end function

function LoadCIS(path) //load a CIS experiment
	string path

	
		string ewave
		NVAR  Ewinstep, PassEn, dindex
		Variable paramstart  = DetermineParamStartIndex(path)		
	
  		LoadWave/O/J/M/L={0,paramstart,7,2,1} path // load 9 rows of header info that will contain parameters
		ewave=StringfromList(0,S_wavenames)	//obtain wavename of loaded wave in string ewave
		duplicate/O $ewave expconst //copy the wave into expconst
		killwaves/z wave0		//kill loaded wave			
		wave expconst

		variable/G minph=expconst[0],maxph=expconst[1],minKE=expconst[2],maxKE=expconst[3], stepPh = expconst[5], middleBE=expconst[4],numsteps=expconst[6]
	

		LoadWave/O/G/M/D/L={0,dindex,0,0,0}/A=data/K=1 path // load the data slices
	
		Create3dData() //build up the 3d data block
		wave datablock

		setscale/I x,-90,90,"deg"datablock
		setscale/I y,minph, maxph," photon eV",datablock
	

		variable startBE
		
		startBE = middleBE +(((dimsize(datablock,2)-1)/2*ewinstep))
	
		setscale/P z, startBE, -ewinstep,"BindeV", datablock

end function


Function FlipDataBlock()	 //this function corrects for igors propensity to  load my slices upside down!!!!
	wave datablock
	
	duplicate/O datablock datablock2 //creates a new datablock that is the reverse of the old one. 

	variable i=0, j=0, k=0
	string dfname
	dfname = getdatafolder(1)
	NVAR llayers = $dfname+"llayers"
	NVAR mrows = $dfname+"mrows"
	NVAR ncols = $dfname+"ncols"
	
		for(k=0;k<llayers;k+=1) 
			for(i=0;i<mrows;i+=1)
				for(j=0;j<=ncols;j+=1)
					datablock2[i][ncols-j][k] = datablock[i][j][k] //moves eac column of each page to the symmeterically opposed position
				endfor
			endfor
		endfor
		
	killwaves datablock
	rename datablock2 datablock
		
end

Function Create3dData() 		//this function takes the multi slices and arranges them into a 3d data set.
	

	
	string datawavelist
	string slicename
	string testwave
	variable i = 0, j = 0, k = 0,numwave=0, llayers,mrows, ncols

	datawavelist = wavelist("data*",";","DIMS:2") //gets a list of the currently loaded waves in the folder, which start with "data*"
		do
			slicename = stringfromlist(llayers, datawavelist) //this loop determines the number of slices in the data by looking
														//for the waves named data" something"
		if(strlen(slicename) ==0)
			break
		else 	
			llayers+=1	
		endif
			
	while(1)

	wave sheet = $stringfromlist(0, datawavelist) //this assesses the size of each slice (rows by columns)

	mrows = DimSize(sheet, 0)
	ncols = DimSize(sheet, 1)
	
	Make/o/u/w/n = ((mrows), (ncols), (llayers)) datablock //creates a 3d blank array for loading
	
	for(k=0;k<llayers;k+=1)
		wave sheet = $stringfromlist(k, datawavelist)
		datablock[][][k] = sheet[p][q]
		killwaves sheet
	endfor


end function
	
	


Function CursorDependencyForGraph(windowname)
	String windowname
	
	string graphname=winname(0,1)
	string globfol = "root:WinGlobals:"+windowname
	
	if(strlen(graphname))
		
		String df=GetDataFolder(1) //get current folder
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphname
 		String/G S_CursorAInfo
 		string imagename = stringfromlist(0,imagenamelist(graphname,";"))
 		cursor/I/W= $graphname A $imagename,0,0 
 		Variable/G dependentA
		SetFormula dependentA, "CursorMoved(S_CursorAInfo)"
		SetDataFolder df //set back to original data folder
	endif
		
End



  
Function CursorMoved(info)
	String info
	 

	string curfolder = getdatafolder(1)
	string topgraph=winname(0,1)
	//Setdatafolder root:Winglobals:$topgraph
	//String graphName=StringByKey("GRAPH",info)
	//if(CmpStr(graphName,topgraph)==0 )
		NVAR dependentA
											// If the cursor is being turned off
			 	  							// the trace name will be zero length.
											
		if(cmpstr(Csrwave(A,topgraph), "")!=0) //if the cursor is on the graph
			wave dwave= imagenametowaveref(topgraph, StringfromList(0,ImageNameList(topgraph,";")))
			string destfol = GetWavesDataFolder(dwave,1)
			setdatafolder destfol
			variable vindex =  (vcsr(A)-dimoffset(dwave,1))/dimdelta(dwave,1) //gets the index of the point the cursor is on
			//duplicate $dwave tempdata
			if(exists(nameofwave(dwave)+"_"+"xline")==0) //if the xline ,yline pari has not yet been created in this folder
				Makeline(dwave)
			endif
			Wave yline = $(nameofwave(dwave)+"_"+"yline")
			Wave xline = $(nameofwave(dwave)+"_"+"xline")
					yline[]=dwave(hcsr(A))[p]
					xline[]=dwave[p](vcsr(A))
			
		    
			setdatafolder root:
			NVAR/Z K3
			K3 = vindex
			setdatafolder curfolder
		endif

End





Function SliceSelect(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	wave datablock
		
		if(waveexists(datablock))
			NVAR slicenum =root:Packages:ARPESPanelGlobs:slicenumVAL
			NVAR slicedir =root:Packages:ARPESPanelGlobs:slicedirbuttonVAL
			controlinfo/W = ARPESpanel Newslicecheck //get info on whether slice is to be overwritten
			variable owrite = V_value
			makeslicewave(datablock,slicenum,slicedir,owrite) //create a slice in a particular layer
			wave/z slice //reference the created slice
			String slicename = "slice"+num2str(slicenum)+"_"+num2str(slicedir)+"_"+getdatafolder(0)
			setslicescaling(varnum,slice) //scale it
			Displaywave(slice) //display it
			Dowindow/T kwTopWin, slicename
			
		else
		
		Doalert 0, "No DataBlock In Current Folder"
		
		endif
End



Function CorrectForMirrorCurrent(ctrlName) : ButtonControl
	String ctrlName
	
	wave/z MirrorCurWave //this sholuld exists in the data folder having ben loaded
	wave datablock
	variable direction
	NVAR mcorrected
	
	
		if(numpnts(mirrorcurwave)>1) //if mirror current has actualy been measured
			if(mcorrected==0)
				
							MCurrentCorrect(datablock, mirrorcurwave)
							mcorrected = 1
			else	
				Doalert 0,  "Data Already Normalised to Mirror Current"
			endif
		
		else 
			Doalert 0, "Mirror Current Not Measured For This Experiment"
		endif

	
	

End

Function NormaliseExposureTime(ctrlName) : ButtonControl //function will normalise data to an exposure time of 1ms
	String ctrlName
	
wave/z datablock

	if(waveexists(datablock))
		
		NVAR exptime
		NVAR expcorrected
			
			if(expcorrected==0)
				
				datablock/=exptime
				expcorrected =1
			else
				
				Doalert 0,  "Data Already Normalised to Exposure Time"
			endif
				
	else
	
	DoAlert 2, "No Datablock in current folder"
	
endif
End



Function IntPolarAngles(ctrlName) : ButtonControl
	String ctrlName
	
		string curfol = getdatafolder(1)
		wave data = ImageNameToWaveRef("",StringFromList(0, ImageNameList("", ";" ),";"))
		Setdatafolder $getwavesdatafolder(data,1)
		
		NVAR left = root:Packages:ARPESpanelglobs:PolintL
		NVAR right = root:Packages:ARPESpanelglobs:PolintR
		string wname  = Polarangleintegrate(data, left, right)
		displaywave($wname)
		
		Setdatafolder $curfol
		
End


Function OffsetThePolarAngle(ctrlName) : ButtonControl //adjusts polar angle offset correction in the data
	String ctrlName
	
	
	NVAR offset= root:Packages:ARPESpanelGlobs:polaroffsetVAL //refers to the offset variable
	string curdatafolder=getdatafolder(1)//records the current data folder
	string wlist= imagenamelist("",";") //list of images in the current graph
	wave sourcewave = imagenametowaveref("",stringfromlist(0,wlist,";"))//gets a reference to the image source wave in the active window
	
	offsetpolarangle(sourcewave,offset)// and the current slice 
	
	setdatafolder curdatafolder//sets back to original data folder

End


Function DisplayWaveInFolder(ctrlName) : ButtonControl
	String ctrlName
	
	string wavetoshow
	string waveslist = wavelist("*", ";", "")
	prompt wavetoshow, "", popup, waveslist
	Doprompt "Select Wave Display", wavetoshow //prompt user to select a wave from the current df
	NVAR cancel = V_Flag
	if(V_Flag==0)
		Displaywave($wavetoshow)
	endif
	

End


function Stackslices(datablock, centre, num, direction)
wave datablock
variable  centre, num, direction

variable i

	if(direction==2) //stack slices in the radial direction

			make/o/n = (dimsize(datablock,0), dimsize(datablock,1)) stacked=0
			setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0),stacked
			Setscale/P y,dimoffset(datablock,1), dimdelta(datablock,1), stacked
			for(i=0;i<2*num;i+=1)
				stacked[][]+=datablock[p][q][centre-num+i]
			endfor
			
	elseif(direction==1) //stack slices in the y directoin
		
			make/o/n = (dimsize(datablock,0), dimsize(datablock,2)) stacked=0
			setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0),stacked
			Setscale/P y,dimoffset(datablock,2), dimdelta(datablock,2), stacked
			for(i=0;i<2*num;i+=1)
				stacked[][]+=datablock[p][centre-num+i][q]
			endfor
			
	elseif(direction==0) //stack slices in the theta direction
		
			make/o/n = (dimsize(datablock,2), dimsize(datablock,1)) stacked=0
			setscale/P x,dimoffset(datablock,2), dimdelta(datablock,2),stacked
			Setscale/P y,dimoffset(datablock,1), dimdelta(datablock,1), stacked
			for(i=0;i<2*num;i+=1)
				stacked[][]+=datablock[centre-num+i][p][q]
			endfor
	endif
		
	
end


Function  UpdateHeaderListBox(ctrlName) : ButtonControl
	String ctrlName
	
	//reference the header wave, if it exists, from the current folder
	
	if(WaveExists(headerwave))
	
		string name = ForceStringToBeNice("Header_"+getdatafolder(0))
		
	
	
			if(cmpstr(WinList(name, ";", "WIN:64"),"")==0)
				
				PauseUpdate; Silent 1		// building window...
				NewPanel/k=1/W=(432,112,701,394)
				ModifyPanel cbRGB=(65280,54528,32768)
				Dowindow/C $name
				SetDrawLayer UserBack
				ListBox list0,pos={4,2},size={264,272},frame=4
				ListBox list0,listWave=headerwave
			
			else
			
				Dowindow/F $name
				ListBox list0,listwave=headerwave
				
			endif
	else 
			Doalert 0, "Data not datafolder"	
	endif
			
End

Function InitiateFixSpikes(ctrlName) : ButtonControl
	String ctrlName
	
	string topwin  = winname(0,1) //get name of acvtive window
	wave curdata = ImageNameToWaveRef("", StringFromList(0,ImageNameList("", ";")))

	Duplicate/O curdata SpikeCorr_Undo //create the backup copies of the wave. One for single step unfo, the other for
	Duplicate/O curdata SpikeCorr_Orig

	WMCreateImageLineProfileGraph() //execute the line profile macro....
	
	Dowindow/F $topwin
	
	//add the controls to the active graph
	
	Button Correct,pos={271,18},size={53,17},proc=CorrectSpikes,title="Correct"
	Button UndoLast,pos={428,20},size={71,14},proc=UndoSpikeCorr,title="Undo Last"
	Button Finish,pos={505,20},size={52,18},proc=FinishSpikeCorr,title="Finish"
	Button Revert,pos={428,36},size={71,14},proc=RevertSpikeCorr,title="Revert"
	SetVariable SmthVal,pos={170,18},size={96,16},title="Smooth F"
	SetVariable SmthVal,labelBack=(65280,32512,16384)
	SetVariable SmthVal,limits={-inf,inf,0.01},value= root:Packages:ARPESPanelGlobs:spikesmthVAL
	Button ProfSpikes,pos={82,18},size={78,17},proc=ProfileSpikes,title="Profile Spikes"
	CheckBox UseCsrs,pos={335,21},size={82,14},title="Use Csr Pos?",value= 0
			
		
End


Function ProfileSpikes(ctrlName) : ButtonControl
	String ctrlName
	
	
	NVAR smthfact = root:Packages:ARPESpanelglobs:spikesmthVAL
	wave  profile = root:Packages:WMImProcess:LineProfile:profile
	Interpolate2/t=3/f=(smthfact) profile
	wave profile_SS //the smoothed wave reference in the current folder
	Removefromgraph/Z/W= WMImageLineProfileGraph profile_SS
	Dowindow/F WMImageLineProfileGraph
	Appendtograph/W= WMImageLineProfileGraph profile_SS //add the smoothed wave to the graph
	ModifyGraph rgb(profile_SS)=(16384,28160,65280)
	

End 

Function CorrectSpikes(ctrlName) : ButtonControl
	String ctrlName
	
	wave profile = root:Packages:WMImProcess:LineProfile:profile
	wave profile_ss
	wave spikecorr_Undo
	wave curdata = ImageNameToWaveRef("", StringFromList(0,ImageNameList("", ";"))) //get reference to the currently displayed data
	SpikeCorr_Undo = curdata //make backup of the current data
	
	controlinfo UseCsrs
	
	if(v_value==1) //if using the cursors for the desired range
	
		variable leftindex=  min(pcsr(A), pcsr(B))
		variable rightindex = max(pcsr(A), pcsr(B))
		curdata[leftindex,rightindex][] = curdata[p][q]/(profile[p]/profile_ss(pnt2x(profile,p))) //correct the data
		
	else
		
		curdata[][] = curdata[p][q]/(profile[p]/profile_ss(pnt2x(profile,p))) //correct the data
	
	endif
	
	
			
End

Function UndoSpikeCorr(ctrlName) : ButtonControl
	String ctrlName
	
	wave curdata = ImageNameToWaveRef("", StringFromList(0,ImageNameList("", ";"))) //reference to the displayed wave	
	wave SpikeCorr_Undo //reference to the undo wave
	curdata = SpikeCorr_Undo
	
End


Function RevertSpikeCorr(ctrlName) : ButtonControl
	String ctrlName
	
	wave curdata = ImageNameToWaveRef("", StringFromList(0,ImageNameList("", ";")))
	wave SpikeCorr_Orig //reference to the original backup wave
	Curdata = SpikeCorr_Orig

End

Function FinishSpikeCorr(ctrlName) : ButtonControl
	String ctrlName
	
	Killcontrol Correct
	Killcontrol UndoLast
	Killcontrol Finish
	Killcontrol Revert
	Killcontrol SmthVal
	Killcontrol Profspikes
	killcontrol Usecsrs
	Killwaves/z SpikeCor_Orig, SpikeCorr_Undo
	Execute   "WMImLineProfileRemoveButtonProc(\"remove\")"
	Dowindow/K   WMImageLineProfileGraph
	
	
end

Function FlattenDBlock(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR dimension = root:Packages:ARPESPanelGlobs:DBFlattenDim_VAL
	wave datablock
		
	if(waveexists(datablock))
		
		Flattendatablock(datablock, dimension)
		
	else
	
	DoAlert 0, "No Datablock in current folder!"
	
	endif
		
End


Function FixSingleStepError(ctrlName) : ButtonControl
	String ctrlName
	
wave displaydata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))

string csrongraph = csrinfo(A, winname(0,1))
	if(cmpstr(csrongraph, "")!=0) 

		variable stepindex = qcsr(A, WinName(0, 1))

		wave/z datablock
		if(waveexists(datablock))

			duplicate/O datablock temp
			duplicate displaydata temp2
			datablock[][stepindex][] = (datablock[p][stepindex-1][r]+datablock[p][stepindex+1][r])/2
			displaydata[][stepindex] = (displaydata[p][stepindex-1]+displaydata[p][stepindex+1])/2
			Doupdate/W = $winname(0,1)
			DoAlert 1, "All ok, proceed to fix Datablock? (cant be undone)"
				if(V_flag==1) //yes clicked
					killwaves/z temp, temp2
				else
					datablock = temp
						displaydata = temp2
				killwaves/z temp, temp2
				endif
					
		else 
			Doalert 0, "No datablock in current folder!"
			 
		endif
	else 
		Doalert 0 , "Cursor must be on graph"
	endif



End



	










