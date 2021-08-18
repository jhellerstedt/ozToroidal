#pragma rtGlobals=1		// Use modern global access method.

// here is an example comment

//#include "Multi-peak fitting 1.4"

Macro PeakDetectionPanel() : Panel

if(CheckName("PeakDetectionPanel", 9,"PeakDetectionPanel"))
		Dowindow/F PeakDetectionpanel
else
	
	string curfolder = getdatafolder(1)
	
		Newdatafolder/O/S root:Packages:PeakDetectionPanelGlobs
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(586,131,922,347) as "ARUPS Peak Detection"
	ModifyPanel cbRGB=(65280,49152,16384)
	Dowindow/C Peakdetectionpanel
	SetDrawLayer UserBack
	SetDrawEnv linethick= 2,arrow= 2
	DrawLine 216,121,216,194
	SetDrawEnv linethick= 2,arrow= 1
	DrawLine 217,194,328,194
	SetDrawEnv linethick= 3,linefgc= (65535,65535,65535),dash= 1,fillpat= 0
	DrawPoly 226,187,1,1,{226,187,232,185,238,180,244,174,248,168,250,162,251,156,254,150,256,144,260,138,266,135,272,136,276,142,277,148,279,154,281,160,283,166,289,168,293,174,299,178}
	DrawPoly/A {305,182}
	SetDrawEnv linefgc= (65280,0,0),fillfgc= (65280,0,0)
	DrawOval 261,131,269,139
	SetDrawEnv linefgc= (65280,0,0),dash= 1
	DrawLine 265,138,265,194
	SetDrawEnv fname= "Times New Roman",fsize= 16,fstyle= 1
	DrawText 6,171,"2d Wave "
	DrawLine 5,221,335,221
	Button button0,pos={7,8},size={120,20},proc=ButtonProc_10,title="Create Results Folder"
	Button button1,pos={9,33},size={87,20},proc=ButtonProc_11,title="Begin Session"
	PopupMenu popup0,pos={5,62},size={180,21},proc=DetectModeSetup,title="Begin Detect"
	PopupMenu popup0,mode=2,popvalue="Manual/Review",value= #"\"Automatic;Manual/Review\""
	Button gobutton,pos={203,63},size={50,20},proc=initialisepeakdetectsession,title="GO!!"
	Button ReplacePeaksbutton,pos={8,92},size={80,20},disable=1,proc=updatepeaks,title="Replace Peaks"
	Button EndSessionButton,pos={144,32},size={80,20},disable=1,proc=endmanualpeaksession,title="End Session"
	CheckBox check0,pos={130,28},size={98,14},disable=1,title="CurveFitUponEst"
	CheckBox check0,value= 1
	Button Endsession,pos={238,28},size={50,20},disable=1
	CheckBox check1,pos={130,46},size={131,14},disable=1,title="StartFromLastGoodRow"
	CheckBox check1,value= 1
	Button button2,pos={7,122},size={100,20},proc=TogglePeakDisplay,title="TogglePeakVisibility"
	SetVariable peakdetectstep,pos={117,122},size={50,20},disable=1
	Button button3,pos={9,90},size={75,20},proc=UpdatePeaks,title="Update Peaks"
	
	setdatafolder $curfolder
	
endif


EndMacro



Function ButtonProc_10(ctrlName) : ButtonControl //creates or replaces the data folder to put the results into
	String ctrlName
	
	string dfolder = getdatafolder(1) //get current data folder to check if it is peak folder, and so sets back to parent folder
		if(strsearch(dfolder,"Peakresults",0)!=-1) //if user is in a peak results folder
			setdatafolder :: //sets directory back to parent folder
		endif
	string wavetofit
	string waveslist = wavelist("*", ";", "")
	prompt wavetofit, "", popup, waveslist
	Doprompt "Select Wave To Fit", wavetofit //prompt user to select a wave from the current df to fit to
	variable cancel = V_flag
	
	if(cancel==0) //if user did NOT cancel the folder creation
		
		string datafolder = ":Peakresults"+"_"+wavetofit
		wave/Z crpwave = $wavetofit
		
			if(Datafolderexists(datafolder)) //if the folder already exists, overwrite it or not?
				Doalert 1, "Overwrite the File?"
					if(V_Flag==1) //if user chose to overwrite the file
						killdatafolder $datafolder
						SetupPeakFolder(crpwave)
					endif
			else	
				SetupPeakFolder(crpwave)	
			endif
						
	endif
						
end

Function SetupPeakFolder(somewave) //this function creates a peak fit folder and puts the wavesinto it, also intialsing the peak detection folders within by rnnung buttonproc set etcc..
wave somewave			
			
			string curfol = getdatafolder(1)
			string datafolder = ":Peakresults"+"_"+nameofwave(somewave)
			NewDataFolder $datafolder //overwrite existing datafolder
			
			Duplicate/O somewave $datafolder+":"+nameofwave(somewave)
			setdatafolder $datafolder
			make/O/N=(1,dimsize(somewave,1)) Grandmastercoef //make a 2d wave to store copies of the master coef wave into
			Grandmastercoef = 0
			Setdatafolder ::

end
			
Function/S ButtonProc_11(ctrlName) : ButtonControl //selects previous detection results folder
	String ctrlName
	
	string dfolder = getdatafolder(1) //get current data folder to check if it is peak folder, and so sets back to parent folder
		if(strsearch(dfolder,"Peakresults",0)!=-1) //if user is in a peak results folder
			setdatafolder :: //sets directory back to parent folder
		endif
		
	string destfolder = Userselectfolders("Peakresults")
		
		if(cmpstr(destfolder,"")!=0)

			wave data =  $(getdatafolder(0)[12,strlen(getdatafolder(0))])
			Makeline(data) //make the xline,yline in the new folder of results
			wave xline = $nameofwave(data)+"_"+"xline"
			Displaywave(data)
			string topwin = winname(0,1)
			
				if(waveexists(ypeakarray))	
					AppendToGraph/W=$topwin/L=left/B=bottom ypeakarray vs xpeakarray //put news points on the old row
					ModifyGraph/W=$topwin mode(ypeakarray)=3,marker(ypeakarray)=19,msize(ypeakarray)=2;DelayUpdate
					ModifyGraph/W=$topwin rgb(ypeakarray)=(52428,34958,1)
				endif
			
			Cursor/I/a=1/h=1 A $nameofwave(data), dimoffset(data,0), dimoffset(data,0)
			cursordependencyforgraph(topwin)
			Setuplinedetect(xline)
	

		endif
end

Function InitialisePeakDetectSession(ctrlName) : ButtonControl //this function begins a peak detection sesssion by setting appropriate parameters and bring up the detect graphs. Subsequenty, it either enters manul mode or automode
	String ctrlName
	
	NVAR/Z lastgoodrow //gets the last known good row that was done on an automatic session
	
	string dfolder = getdatafolder(1) //get current data folder to check whether user has selected an existing peak results folder
				
		if(strsearch(dfolder,"Peakresults",0)==-1) //if a peak results folder is not selected
			UserSelectfolders("Peakresults") //allow user to choose one
		endif
			
	string srcwavename =  StringFromList(0, WaveList("*", ";","DIMS:2"),";") ///gets the name of the wave that the folder is based on
	wave srcwave = $srcwavename
	Controlinfo/W= ARUPSpeakdetectionpanel PeakDetectStep
	variable stepnum = V_Value 
	variable numpeaks,dimxpeak=0
		//Need to work in a particular data folder.  Assume that this has been set
	//wavestats/Q xline
//	Variable MaxTest=V_max
		//Set Y and x data in SetUpPanel for xline and xlcoords which have not been declared in this macro
	string/G root:Packages:WMmpFitting:gXDataName="xlcoords"
	string/g root:Packages:WMmpFitting:gYDataName="xline"
	//String gFitDataName= root:Packages:WMmpFitting:gFitDataName
	//String gResidsName= root:Packages:WMmpFitting:gResidsName
	PopupMenu popupYData,mode=1,value= "xline",win=FitSetupPanel
	PopupMenu popupXData,mode=1,value= "xlcoords",win=FitSetupPanel
		//Display line data
			//Show autofindpanel
	Execute/Z "ShowAutoBP(\"auto\")"
	CreateCustomPeakDetectGraph()	

	
	Execute/Z "ButtonProcSet(\"Set\")" //intialise the first peak guesses
	//Execute/Z "AutofindpeakBP(\"Autoest\")"
	//Execute/Z "AutofindpeakBP(\"Autofind\")"
	Execute/Z "CheckProcDoBaseline(\"checkBL\",1)" //ensure that baseline option is selected
	Execute/Z"DoAutocheck(\'checkauto\",1)" //put autofind peaks on set buttton onto ON
	
	Displaywave(srcwave) //displays the wave that is being peak detected
	string windowname =Namewindow(srcwavename)
		if(waveexists(ypeakarray)) //if someone has  already made some peaks
			AppendToGraph/W=$windowname/L=left/B=bottom ypeakarray vs xpeakarray //put them onto the graph
			ModifyGraph/W=$windowname mode(ypeakarray)=3,marker(ypeakarray)=19,msize(ypeakarray)=2;DelayUpdate
			ModifyGraph/W=$windowname rgb(ypeakarray)=(52428,34958,1)
		endif
	Dowindow/F ARUPSPeakDetectionPanel //Bring detection panel to the front
	Controlinfo popup0 //gets info on what mode is selected for the peak detectstrser
	string currentmode = S_Value
	
		If(cmpstr(currentmode,"Manual/Review")==0)
			
			SetupmanualMode()
			
		elseIf(cmpstr(currentmode,"Automatic")==0) // AUTOMATIC MODE
		
			Setupautomaticmode(windowname)
			variable i	, startindex
				Controlinfo/W=ARUPSpeakdetectionpanel check1
					if(V_Value==1) //if user is starting form last known good row
						 startindex = lastgoodrow
					else 
						startindex = 0 //start form start
					endif
					
				for(i=startindex;i<(dimsize(srcwave,1));i+=1)
					Lastgoodrow = i
					Dowindow/F $windowname //bring data to be plotted on to front
					Controlinfo/W=ARUPSpeakdetectionpanel PeakdetectStep //get the info on the control peak step
					PeakDetectStepChanged("Peakdetectstep",i,num2str(i),"root:K3") //step the stepnum to the next step in the data
					Dowindow/F PeakDetectGraph //bring peak detect graph to the front
					Execute/Z "ButtonProcSet(\"Set\")" //executes the set button, thus allowing auto detect of peaks on each row
					Controlinfo/W=ARUPSpeakdetectionpanel check0	
					Dowindow PeakDetectgraph
						if(V_Value==1) //if user has optioned to fit each step properly, then perform fit. Note that this sometimes ends in matrix errors.
						
							Execute/Z "FitProc(\"DoFitButton\")" //perform the numerical fit
						endif
					DoWindow/F $Windowname //brings the data window to the front so that peaks can be replaced easily
					UpdatePeaks("UpdatepeaksButton") //update the peak storage situation
				endfor
			
			Lastgoodrow = i
			Dowindow/F ARUPSPeakDetectionpanel
			Button gobutton, disable = 0
		
		endif
		
End

Function SetUpAutomaticMode(windowname)
string windowname

			setvariable PeakDetectStep,disable=1 //hides stepping button
			Button ReplacePeaksbutton,disable=1 //hides the replace peaks button
			Button Endsession, disable = 1 
			checkbox check0, disable = 0
			button endsessionbutton, disable = 0 
			movewindow/W=peakdetectgraph 0,0,350,300
			movewindow/W=$windowname 350,0,700,300
			Controlinfo/W=ARUPSpeakdetectionpanel check1 //get status on whether automode starts from last good row
end

Function SetUpManualMode()
				
			setvariable PeakDetectStep,disable=0 //brings up the stepping button
			Button ReplacePeaksbutton,disable=0 //brings up the replace peaks button
			//Button EndSessionbutton, disable = 0// enables the end session button
			checkbox check0, disable = 1
			button endsessionbutton, disable = 0
			
end

Function CreateCustomPeakDetectGraph()			
		
	
		Dowindow PeakdetectGraph
		if(V_Flag==0) //if window exists
			
			Execute/Z "ButtonProcNewGraph(\"graph\")"
			Dowindow/C PeakDetectGraph
		else
		
		
		//Dowindow/K PeakDetectGraph
		Execute/Z "ButtonProcNewGraph(\"graph\")"
		//Dowindow/C PeakDetectGraph
			
		endif
		
End Function

Function UpdatePeaks(ctrlName) : ButtonControl
	String ctrlName

	string folder = getdatafolder(0) //get current datafolder, which will be the "CURRENT" folder if a fit has been done
		if(cmpstr(folder,"Current")==0) //if a fit has been done set back the dfolder to the peak folder
			setdatafolder :::
		endif
	folder = getdatafolder(1) //get full path to the current folder
	string path = folder+"WMPeakFits:Current:"
	wave data = $(StringFromList(0, wavelist("*",";","DIMS:2"),";")) //get a wave ref to the wave to be detected
	string windowname = Namewindow(nameofwave(data))
	wave Grandmastercoef //the current array of peak positions, ready to be updated. This array will have been sorted. It may or may not exist
	wave  coefs =:WMPeakFits:Current:Mastercoef //reference to the master coefficient wave
	NVAR numpeaks = root:Packages:WMmpFitting:gNumPeaks
	variable i, j, stepnum, peakval
	
	stepnum = (vcsr(A,windowname)-dimoffset(data,1))/dimdelta(data,1)
	make/O/N=(numpeaks) xpeaks,ypeaks
					
					Grandmastercoef[][stepnum] = 0 //r zero the grand master coef file, ready for new values
							
						if(dimsize(coefs,0)>dimsize(Grandmastercoef,0)) //if the size of the master coefficient file is longer than the Grand ONe. redimension the grand one
							Redimension/N=(dimsize(coefs,0),dimsize(Grandmastercoef,1)) Grandmastercoef
						endif
						
					Grandmastercoef[][stepnum]=coefs[p] //update the grandmastercoef array
					
					make/o/n = 0 xpeakarray, ypeakarray
					
					for(i=0;i<dimsize(data,1);i+=1)
						j=0
						do
							peakval = Grandmastercoef[7+4*j][i]
								if(peakval!=0&&(7+4*j)<dimsize(Grandmastercoef,0))
									insertpoints 0,1,xpeakarray, ypeakarray
									xpeakarray[0] = peakval
									ypeakarray[0] = dimoffset(data,1)+i*dimdelta(data,1)
								else
									break
								endif
						j+=1
						while(1)
					endfor
					
					Sort ypeakarray, xpeakarray, ypeakarray
					
					
					if(Findlistitem("ypeakarray",Tracenamelist(windowname,";",1))!=-1)//if ypeakarray is on the grpah
						removefromgraph/W=$windowname ypeakarray //remove old displayed points
					endif
					
					
				AppendToGraph/W=$windowname/L=left/B=bottom ypeakarray vs xpeakarray //put news points on the old row
				ModifyGraph/W=$windowname mode(ypeakarray)=3,marker(ypeakarray)=19,msize(ypeakarray)=2;DelayUpdate
				ModifyGraph/W=$windowname rgb(ypeakarray)=(52428,34958,1)
				
				killwaves/z xpeaks, ypeaks
				
end function

Function TogglePeakDisplay(ctrlName) : ButtonControl
	String ctrlName
	
	
	string windowname = winname(0,1) //get top windowname
	
	
	if(cmpstr(wavename("",2,1),"ypeakarray")==0) //if ypeakarray is on the graph
		RemovefromGraph/W=$windowname ypeakarray //put news points on the old row
		
	else
		AppendToGraph/W=$windowname/L=left/B=bottom ypeakarray vs xpeakarray //put news points on the old row
		ModifyGraph/W=$windowname mode(ypeakarray)=3,marker(ypeakarray)=19,msize(ypeakarray)=2;DelayUpdate
		ModifyGraph/W=$windowname rgb(ypeakarray)=(52428,34958,1)
	endif
		

End


Function DetectModeSetup(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Controlinfo popup0 //gets info on what mode is selected for the peak detectstrser
	string currentmode = S_Value
	
	if(cmpstr(currentmode,"Automatic")==0) // AUTOMATIC MODE
	
	checkbox check1, disable =0
	checkbox check0, disable = 0
	
	elseif(cmpstr(currentmode,"Manual/Review")==0)
	checkbox check0, disable = 1
	checkbox check1, disable =1
	
				
	endif

End

Function PeakDetectStepChanged(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	string curfolder = getdatafolder(	1)
	string dataname = StringFromList(0,wavelist("*",";","DIMS:2"),";") //get datawave under consideration
	//Updateline($dataname,Varnum) //update xline and yline in the current folder
	string windowname = Namewindow(dataname) //get the name of the active window so that te cursor can be move on it
	Cursor/I/P/W=$windowname A, $dataname, (dimsize($dataname,0))/2, Varnum
	Controlinfo/W=ARUPSpeakdetectionpanel PeakdetectStep
	string dfolder = S_datafolder
	setdatafolder dfolder
	NVAR/Z K3
	K3 = varnum
	setdatafolder curfolder
End


Function EndManualPeakSession(ctrlName) : ButtonControl
	String ctrlName
	

	Button Gobutton, disable = 0
	Dowindow PeakdetectGraph
	
		if(V_flag==1) //if peak detect window is open
			Dowindow/K PeakDetectGraph//kill it
		endif
	
	string windowname = Namewindow(stringfromlist(0,wavelist("*",";","DIMS:2"),";")) //gets the nameof the window showing the full data set
	string windowlist = winlist(windowname,";","WIN:1")
	Dowindow $windowname
	
		If(V_Flag==1)
			Dowindow/K $windowname
		endif
	
	Button EndSessionbutton, disable = 1
	Button ReplacePeaksbutton, disable = 1
	Setvariable peakdetectstep, disable=1
	Setdatafolder ::
	 //sets back to the parent data folder. Hopefully currrntly you will be  at the CISpeaks folder!!

End

Function SetupLineDetect(line)
wave line 

		Dowindow/F Fitsetuppanel
		controlupdate popupydata //update the wave selectors
		controlupdate popupxdata
		string wlist = WaveList("*",";","") //get names of all waves in the peak dectio folder
		
		string LineY = nameofwave(line)
		string LineX= "_calculated_"
		variable Xnum = 0
		variable Ynum = WhichListItem(LineY,wlist)
		popupmenu popupydata mode = Ynum+1
		popupmenu popupxdata mode = 1
		string topgraph = winname(0,1)

		Execute/Z "ButtonProcSet(\"Set\")"
		Execute/Z "ButtonProcNewGraph(\"graph\")"
		Execute/Z"ShowAutoBP(\"buttonAuto\")"
	
		variable i
		string names = TraceNameList(topgraph, ";", 1)
		for(i=0;i<(ItemsInList(names,";"));i+=1)
			if(Strsearch(stringfromlist(i,names,";"),"Peak",0)!=-1)
			
				removefromgraph/W=$topgraph $stringfromlist(i,names,";")
			endif
		endfor
			
end function

Function GenerateGaussIntensityPlot() //this function generates an intensity plot representing the detected peaks as plotted gaussians
	
	wave/Z GaussPeakImage
	Killwaves/z GaussPeakImage //kill the previous image
	string destfolder
	Variable numxpnts
	string curfolder = getdatafolder(1)
	string totallist = datafolderdir(1)[8,strlen(datafolderdir(1))] //list all datafolders in the current directory
		variable i
		string validlist =""
		string teststring
			for(i=0;i<itemsinlist(totallist, ",");i+=1) //step throuhg the list and pick out the datafolder names that begin with :peakresults
				teststring = stringfromlist(i,totallist,",")
				if(strsearch(teststring, "Peakresults", 0)!=-1)
					validlist+=teststring+";"
				endif
			endfor
	
			if(cmpstr(validlist,"")!=0) //if search found folders with approprites names
		
				prompt destfolder, "Peak Folder", popup, validlist //prompt user to select the data and the dimension of the plot in x tobe made
				prompt numxpnts, "Number of X points"
				doprompt "Choose Folder and X pnts", destfolder, numxpnts
					if(V_Flag==1)
						destfolder = ""
					else
						setdatafolder :$destfolder
					endif
				if(waveexists(totalpeakarray))
					
					Wave/Z totalpeakarray
					Wave Data = $stringfromlist(0,wavelist("*",";","DIMS:2"),";") //get a reference to the detected wave underconsideration
					make/O/N = (numxpnts,dimsize(data,1)) GaussPeakImage
					Setscale/P x,dimoffset(data,0),((dimsize(data,0)*dimdelta(data,0))/numxpnts), GaussPeakImage; Setscale/P y,dimoffset(data,1),dimdelta(data,1), GaussPeakImage
					make/O/N = (4) Peakparams //make temp wave to store individual peak parameters
					variable numpeaks,j,k,x,totalvalue
						for(i=0;i<dimsize(GaussPeakimage,1);i+=1) //begin at firsst column of data (row of the graph)
						numpeaks = totalpeakarray[0][i] //get the number of peaks in the row
							for(j=0;j<numxpnts;j+=1) //step through the rows of the array (columns of the graph)
							x = dimoffset(GaussPeakImage,0)+j*dimdelta(GaussPeakimage,0) //get the x value of the point under question
							
								for(k=0;k<numpeaks;k+=1)
									
									Peakparams = totalpeakarray[(1+4*k)+p][i] //update the temp peakparam arrray with peak params from the totalpeakarray
									totalvalue+= peakparams[0]*exp(-1*(((x-peakparams[1])/peakparams[2]))^2) //calulate the intensity at the point due to all the peaks
								endfor
								GaussPeakImage[j][i] = totalvalue
								totalvalue=0
							endfor
							print "ENDROW"
						endfor
						
				MoveWave GaussPeakImage, curfolder //moes the wave to the parent folder
				Setdatafolder curfolder
						
				else
					Setdatafolder curfolder
					Print "No peak data to plot"
				endif
								
					
			endif
end

Function CalculateGauss(paramarray,x)
	wave paramarray //the peak param array
	variable x //the element under consideration
	
	variable value 
	//print paramarray[0]
	//print paramarray[1]
	//print paramarray[2]
	value = paramarray[0]*exp(-1*(((x-paramarray[1])/paramarray[2]))^2)
	return value
	
end


