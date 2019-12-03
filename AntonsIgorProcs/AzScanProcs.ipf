#pragma rtGlobals=1		// Use modern global access method.

Macro AzScanpanel() : Panel

if(CheckName("AzScanPanel", 9,"AzScanPanel"))
		Dowindow/F AzScanPanel
else
	string curfolder = getdatafolder(1)
			
			Newdatafolder/O/S root:Packages
			Newdatafolder/O/S root:Packages:AzPanelGlobs
				
				variable/g ratiochangeVAL=0
				variable/g AzScanKEVAL
				variable/g KincrementsVAL=0
				variable/g StartPhiVAL=0
				variable/g EndPhiVAL=0
				variable/g rkmaxVAL=0
				variable/g AzScanDegCorrVAL=0
				variable/g azscanrotVAL=0
				variable/g CalcFEstartEVAL=0
				variable/g CalcFEendEval=0
				variable/g CalcFESmthVAL=0
				variable/g AzdataEVAL=0
				variable/g PEDnumsliceVAL=0
				variable/g PEDcentreVAL=0
				variable/g stepVAL = 0
				variable/g winwidthVAL = 0

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1245,54,1581,692) as "AzScanPanel"
	Dowindow/C AzScanPanel
	ModifyPanel cbRGB=(0,43520,65280)
	SetDrawLayer UserBack
	SetDrawEnv linethick= 2,linebgc= (32768,54528,65280),fillpat= 0
	DrawRRect 333,293,7,577
	SetDrawEnv fstyle= 1
	DrawText 12,568,"Az Scan Data Extraction"
	SetDrawEnv linefgc= (0,65280,65280),fillpat= 0
	DrawRRect 12,544,317,461
	SetDrawEnv linethick= 2,fillpat= 0
	DrawRRect 7,8,332,283
	SetDrawEnv fstyle= 1
	DrawText 18,270,"Az Scan Processing"
	SetDrawEnv linefgc= (0,65280,65280),fillpat= 0
	DrawRRect 14,300,318,457
	DrawLine 91,313,91,449
	DrawLine 205,316,205,450
	DrawText 109,450,"FEW Extraction"
	DrawText 27,450,"Basic FE"
	Button AzPLotButton,pos={12,22},size={120,20},proc=ProcessAzScan,title="Create K Plot"
	SetVariable AzParam2,pos={20,122},size={117,16},bodyWidth=45,title="Kinetic Energy"
	SetVariable AzParam2,limits={-inf,inf,0.1},value= root:Packages:AzPanelGlobs:AzScanKEVAL
	SetVariable AzParam1,pos={15,100},size={122,16},bodyWidth=45,title="Plot Increments"
	SetVariable AzParam1,value= root:Packages:AzPanelGlobs:KincrementsVAL
	SetVariable AzParam3,pos={26,145},size={111,16},bodyWidth=45,title="Start Azimuth"
	SetVariable AzParam3,value= root:Packages:AzPanelGlobs:StartPhiVAL
	SetVariable AzParam4,pos={29,166},size={108,16},bodyWidth=45,title="End Azimuth"
	SetVariable AzParam4,value= root:Packages:AzPanelGlobs:EndPhiVAL
	SetVariable AzParam5,pos={214,99},size={74,16},bodyWidth=45,title="kmax"
	SetVariable AzParam5,value= root:Packages:AzPanelGlobs:rkmaxVAL
	SetVariable AzParam7,pos={162,143},size={126,16},bodyWidth=45,title="Deg/Phi Az Corr"
	SetVariable AzParam7,limits={-inf,inf,0.1},value= root:Packages:AzPanelGlobs:AzScanDegCorrVAL
	SetVariable AzParam6,pos={157,121},size={131,16},bodyWidth=45,title="PlotRotation(deg)"
	SetVariable AzParam6,value= root:Packages:AzPanelGlobs:azscanrotVAL
	PopupMenu AzParam10,pos={13,51},size={168,21},bodyWidth=168
	PopupMenu AzParam10,mode=3,popvalue="Use Positive Polar Angles",value= #"\"Use Both Halves;Use Negative Polar Angles;Use Positive Polar Angles\""
	CheckBox AzParam8,pos={208,51},size={77,14},proc=ShowPhiNorm,title="Symmetrise?"
	CheckBox AzParam8,value= 0
	Button ExtractAzDataButton,pos={20,479},size={100,20},proc=GetAzScanData,title="Get AzScan Data"
	Button DiffPlotButton,pos={145,22},size={114,20},proc=ProcessAzScan,title="Create Diffraction Plot"
	SetVariable CalcFEstartR,pos={223,339},size={84,16},title="StartE"
	SetVariable CalcFEstartR,value= root:Packages:AzPanelGlobs:CalcFEstartEVAL
	SetVariable CalcFEsmthF,pos={214,315},size={93,16},title="Smooth F"
	SetVariable CalcFEsmthF,value= root:Packages:AzPanelGlobs:CalcFESmthVAL
	SetVariable CalcFEendE,pos={227,364},size={80,16},title="EndE"
	SetVariable CalcFEendE,value= root:Packages:AzPanelGlobs:CalcFEendEval
	Button CalcFEW,pos={22,345},size={61,22},proc=CalcFEAzScan,title="Calc FE"
	SetVariable AzScanE,pos={16,513},size={104,16},bodyWidth=45,title="Energy (eV)"
	SetVariable AzScanE,limits={-inf,inf,0.01},value= root:Packages:AzPanelGlobs:AzdataEVAL
	CheckBox AzParam9,pos={208,71},size={64,14},disable=2,title="PhiNorm?",value= 0
	Button button0,pos={13,200},size={75,20},proc=SaveFPlotSettings,title="Save Settings"
	Button button1,pos={96,200},size={75,20},proc=GetFPlotSettings,title="Get Settings"
	PopupMenu GetAzDataMode,pos={131,479},size={94,21},title="Mode"
	PopupMenu GetAzDataMode,mode=1,popvalue="Abs KE",value= #"\"Abs KE;FE Rel;FEW Rel\""
	Button GenPhiIntbutton,pos={22,316},size={60,21},proc=GenPhiIntForFitting,title="Gen Plot"
	CheckBox Usecsrchk,pos={215,393},size={66,14},title="Use Csrs?",value= 1
	CheckBox showimage,pos={215,417},size={91,14},title="show image(s)?",value= 1
	Button CalcFEwbutton,pos={109,317},size={76,23},proc=AutoCalcFEWAzScan,title="CalcFEWAuto"
	Button CalcFEWbutton2,pos={109,346},size={76,21},proc=CalcFEAzScanStep,title="CalcFE"
	SetVariable Step,pos={103,377},size={82,16},proc=AzScanStep,title="AzStep"
	SetVariable Step,limits={0,inf,1},value= root:Packages:AzPanelGlobs:stepVAL
	SetVariable WinWidth,pos={127,513},size={97,16},title="Width(eV)"
	SetVariable WinWidth,value= root:Packages:AzPanelGlobs:winwidthVAL
	Button button2,pos={14,591},size={100,20},proc=Generate_AzScan_Volume,title="Generate Volume K"
	Button button3,pos={124,591},size={100,20},proc=DisplayVolumeK,title="Display Volume K"
	SetWindow kwTopWin,hook=ActivateGeneralwindow,hookevents=1,hookcursor=1

endif
	

EndMacro



Function AzimuthallyNormXPD(data, smthval, normrange)
wave data
variable smthval, normrange

string name = nameofwave(data)+"_AzNorm"
duplicate/O data data2

make/o/n = (dimsize(data, 1)) column
make/o/n=(dimsize(data, 0)) IO
variable i, j, total

	for(i=0; i<dimsize(data, 0);i+=1)
		column[] = data[i][p]
		
			if(normrange==0)
				total = (sum(column)/dimsize(data, 1))
			else
				total = (sum(column, 0, normrange)/normrange)
			endif
		
			IO[i] = total
	endfor
	
Interpolate2/T=3/N=(numpnts(IO))/F=(smthval)/Y=IO_SS IO

wave IO_SS

data2[][] = (data[p][q] - IO_SS[p])/IO_SS[p]

duplicate/O data2, $name
killwaves/Z data2

end
		


Function GetFPlotSettings(ctrlName) : ButtonControl
	String ctrlName
	
	GetPlotSettings("FPParams","AzScanpanel") //read control values from the wavenote and apply them to the controls in the azscan panel

End

Function GenPhiIntForFitting(ctrlName) : ButtonControl
	String ctrlName
	
	wave datablock
	
	NVAR left = root:Packages:ARUPSPanelGlobs:PolintL
	NVAR right = root:Packages:ARUPSPanelGlobs:PolintR
	
	
	Stackslices(datablock, (dimsize(datablock,1)-1)/2,  (dimsize(datablock,1)-1)/2, 1)
	wave stacked
	duplicate/O  stacked, Phiint
	Setscale/P x,dimoffset(stacked,0), dimdelta(stacked,0), "deg", Phiint
	Setscale/P y, dimoffset(stacked,1), dimdelta(stacked,1), "KE (eV)", Phiint
	killwaves stacked
	controlinfo showimage
		if(v_value) //if user wants to display the phi int image
			Displaywave(Phiint)
		endif
	wave int = $PolarAngleIntegrate(Phiint,left,right)
	Displaywave(int)

End

Function CalcFEAzScan(ctrlName) : ButtonControl //this function finds the fermipage similary to the cisfix process. It returns the data at the fermi energy
	String ctrlName
	
	Wave datablock
	NVAR middleKE
	variable/g FermiEn
	variable FermiCh
	NVAR startE = root:Packages:AzPanelGlobs:CalcFEstartEVAL
	NVAR smthfact= root:Packages:AzPanelGlobs:CalcFEsmthVAL
	NVAR endE = root:Packages:AzPanelGlobs:CalcFEendEVAL
	
	string curfolder = getdatafolder(1)
	
	Wave int =WaveRefIndexed("", 0, 3)
		
			if(cmpstr(nameofwave(int),"Phiint_angleint")==0)
				Setdatafolder  $GetWavesDataFolder(int, 1)
				variable/g FermiEn
					variable startEn, EndEn
					Controlinfo UsecsrChk
						if(V_value==1)
							
							if(stringmatch(Csrwave(A),"")||stringmatch(csrwave(B),""))
								doalert 0, "Cursors need to be on graph"
								return 1
							else
								startEn = min(hcsr(A),hcsr(B))
								endEn = max(hcsr(A),hcsr(B))
							endif
							
						else
							startEn = startE
							EndEn = EndE
						endif
			else
				Doalert 0, "Active graph must be Phiint graph. Generate Using Gen Plot"
			endif
			
		Interpolate2/T=3/N=200/F=(smthfact) int
				wave int_SS = $nameofwave(int)+"_SS"
				Removefromgraph/Z int_SS
				Appendtograph int_SS
				Duplicate/O int_SS, fit
				Differentiate fit/D=fit
				FindPeak/N/R=(starten,enden) fit
				
				FermiEn = V_peakloc
				tag/k/n=FermiTag
				tag/Y=0/X=-35/N=fermiTag  $nameofwave(int)+"_SS",Fermien,"FE ="+"  "+num2str(FermiEn)+"eV"
	
	Setdatafolder $curfolder	
			
End



Function GetAzScanData(ctrlName) : ButtonControl //this function finds the fermipage similary to the cisfix process. It returns the data at the fermi energy
	String ctrlName
	
	wave/z datablock, Fedgewave
	NVAR FermiEn
	NVAR middleKE

	NVAR E = root:Packages:Azpanelglobs:AzdataEval
	NVAR width = root:Packages:Azpanelglobs:winwidthVAL
	string name
	variable layer ,KE,valid=1,i,j,k
	string mode
	variable innerKE = middleKE-((dimsize(datablock,2)-1)/2)*dimdelta(datablock,2)
	variable outerKE = middleKE+((dimsize(datablock,2)-1)/2)*dimdelta(datablock,2)
	Controlinfo GetAzDatamode
	mode= S_value
	
	strswitch(mode)
	
	case "Full-Win Simple BG":
	
	
	case "Abs KE": //abs KE extraction
	
				KE = E
				name = "AzScan"+num2str(E)
				
				break
				
	case "FE Rel": //Fe relative extraction
			
			if(!NVAR_exists(FermiEn))
				valid=0
			endif
			KE = FermiEn-E
			name = "fermi"+num2str(E)
			
			break
			
	case "FEW Rel": //FEW relative extraction
			
			if(!waveexists(FEWMan)&&!waveexists(FEWauto))
				valid=0
			endif
			
			name = "fermi"+num2str(E)
			
			break

	endswitch		
	
	if(!valid)
		Doalert 0,"Need to Find FE or FEW first"
		return 0
	endif
	
	strswitch(mode)
	
	case "Abs KE":
	case "FE Rel":

		if((KE<innerKE)||(KE>outerKE))
			Doalert 0, "KE is outside of data"
			return 0 
		endif
				make/o/n = (dimsize(datablock,0), dimsize(datablock,1)) fermi
				setscale/P x, dimoffset(datablock,0),dimdelta(datablock,0), "deg", fermi
				setscale/P y, dimoffset(datablock,1), dimdelta(datablock, 1),"Azimuthal Angle (deg)",  fermi
				
				Make/o/n = (dimsize(datablock,0), dimsize(datablock,2)) sheet
				
				make/o/n=(dimsize(datablock,2)) line
				Setscale/P x,dimoffset(datablock,2), dimdelta(datablock,2), line	
					
					
						for(j=0;j<dimsize(datablock,1);j+=1)
							sheet[][] = datablock[p][j][q]
								for(i=0;i<dimsize(sheet,0);i+=1)
									line[] =sheet[i][p]
										if(width>0)
											
											fermi[i][j] =sum(line,KE-width/2,KE+width/2)
										else
											fermi[i][j] =line(KE)
										endif
								endfor
						endfor
						
					
				AddKeyParamToNote(fermi,"AzScanEn",num2str(KE)) //add the kinetic energyy to the note param list
				duplicate/O fermi, $name
				killwaves fermi,sheet,line
				displaywave($name)
		
		
		break
	
	case "FEW Rel":
	
		string waveslist = wavelist("*", ";", "")
		string selwave
				prompt selwave,"", popup, waveslist
				Doprompt "Select FEW", selwave //prompt user to select a wave from the current df
					
					if(V_flag==0)
						Duplicate/o $selwave, FEW
						ExtractFEWAzScan(FEW,E,width,datablock)  //extract the data from the datablock
						wave fermi
						KE  = mean(FEW,0,numpnts(FEW)-1)
						Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0), "deg", fermi
						Setscale/P y, dimoffset(datablock,1), dimdelta(datablock,1),"Azimuthal Angle (deg)", fermi
						AddKeyParamToNote(fermi,"AzScanEn",num2str(KE)) //add the kinetic energyy to the note param list
						duplicate/O fermi $name
						killwaves/z fermi, FEW
						Displaywave($name)
					else
						break
					endif

	
	case "Full-Win Simple BG": //integrates the area under the radial profile and subtratcs a background based on the average of the two end values. 
	
				make/o/n = (dimsize(datablock,0), dimsize(datablock,1)) fermi
				setscale/P x, dimoffset(datablock,0),dimdelta(datablock,0), "deg", fermi
				setscale/P y, dimoffset(datablock,1), dimdelta(datablock, 1),"Azimuthal Angle (deg)",  fermi
				variable rch = dimsize(datablock,2), startval, BGlevel, endval
				Make/o/n = (dimsize(datablock,0), rch) sheet
				
				make/o/n=(rch) line
				Setscale/P x,dimoffset(datablock,2), dimdelta(datablock,2), line	
					
					
						for(j=0;j<dimsize(datablock,1);j+=1)
							sheet[][] = datablock[p][j][q]
								for(i=0;i<dimsize(sheet,0);i+=1)
									
									line[] =sheet[i][p]
									startval = line[0]
									endval = line[rch-1]
									BGlevel = (startval + endval)/2
									fermi[i][j] =sum(line)-(rch*BGlevel)	
										
								endfor
						endfor
	
	
		endswitch
	
	
end

Function ShowPhiNorm(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	Controlinfo AzParam8
	if(V_Value==1)
	
		checkbox AzParam9 disable =0
	else
		checkbox AzParam9 disable =2
	endif
		

End

Function ProcessAzScan(ctrlName) : ButtonControl //calculates the projected fermi surface for az scan data
	String ctrlName
	

	variable type, phicorrect, symm,normi, raddiff
	string curfolder = getdatafolder(1),procdatatype
	NVAR kincrements = root:Packages:AzPanelGlobs:KincrementsVAL //get info on all the current parameter for the plot from the az scan panel
	NVAR kmax = root:Packages:AzpanelGlobs:rkmaxVAL
	NVAR KE = root:Packages:AzPanelGlobs:azscankeVAL
	NVAR startphi = root:Packages:AzPanelGlobs:startphiVAl
	NVAR endphi = root:Packages:AzpanelGlobs:endphiVAL
	NVAR rotation = root:Packages:AzpanelGlobs:azscanrotVAL
	NVAR phicorr = root:Packages:Azpanelglobs:AzScanDegCorrVAL
	NVAR radch = root:Packages:ARUPSpanelGlobs:slicenumVAL
	
	wave/z Fedgewave
	Controlinfo/W = AzScanpanel AzParam10
	type =V_Value
	Controlinfo/W= AzScanpanel AzParam8
	symm =V_Value
	Controlinfo/W=AzScanpanel AzParam9
	Normi=V_Value
	wave displayeddata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	
		string srcfol = GetWavesDataFolder(displayeddata,1) //find the data folder where the plot/data comes from
		string name = nameofwave(displayeddata) //get the name of the displayed data
		string procname
		string curnote = note(displayeddata) //get any note attached to the data
		setdatafolder $srcfol
		variable show
	
		if(cmpstr(ctrlname,"DiffPlotbutton")==0)
			procdatatype = "DPlot"
		elseif(cmpstr(ctrlname,"AzPlotbutton")==0)
			procdatatype = "FPlot"
		endif
	
			
			if(strsearch(name,procdatatype,0)!=-1) //if the top graph contains processed data from an az scan
			
				variable offset = strsearch(name,"_",0)
				string realdata = name[offset+1,strlen(name)] //get refeence to the raw data that made the scan
				wave data = $realdata //get local reference to the raw data that supplies the processed plot
				Procname =procdatatype+num2str(type)+"_"+nameofwave(data)
					if(waveexists($procname)) //if the processed version of the wave exists, back up the note
						curnote = note($Procname)
					endif	
					
					if(stringmatch(name,Procname)) //if the displayed processed data is the same as what will be made now
						show  = 0
					else
						show = 1
					endif
				//Procname = name
				
			else //displayed data is raw data
					wave data = displayeddata
					Procname =procdatatype+num2str(type)+"_"+nameofwave(data)
					if(waveexists($procname)) //if the processed version of the wave exists, back up the note
						curnote = note($Procname)
					endif	
					show=1	
			endif
		
			
//process the data
		
			if(cmpstr(ctrlname,"AzPlotbutton")==0)	
			
				string enstr =GetKeyParamFromNote("AzScanEn",data)
					if(cmpstr(enstr,"")!=0) //if data has an associated KE in the wave note
						KE = str2num(enstr)	
					endif
		
				FermiMap(data,kincrements, kmax, startphi, endphi, KE,symm, phicorr,rotation, type,normi)//transform an azimuthal wave in the current data folder into a new wave, Fermiplot
				wave Fermiplot
				duplicate/o Fermiplot $Procname
					
					if(show) //if data is raw data will need to display the results of processing
						Displaywave($Procname)
						ApplyAzscanstyle(2) //style the displayed graph
					endif
					
				killwaves Fermiplot
			
				
			elseif(cmpstr(ctrlname,"DiffPlotbutton")==0)
				
				DIFFMap(data,kincrements, startphi, endphi,symm, normi, phicorr,rotation,type)
				wave DiffractionPlot
				duplicate/o Diffractionplot $Procname
				
					if(show) //if we neeed to bring up a window
						Displaywave($Procname)
					endif
				killwaves Diffractionplot

			endif
			
			Note $Procname, curnote
			Setdatafolder $curfolder
end 

Function SaveFPlotSettings(ctrlName) : ButtonControl
	String ctrlName
	
	doalert 1, "Save Current Settings?"
		if(V_flag==1)
		
			string curfol = getdatafolder(1)
			wave data = ImageNameToWaveRef("",StringFromList(0, ImageNameList("", ";"),";")) //get ref to the wave in the top graph
			
			string info =  ExtractSpecificControlList("","AzScanPanel")
			
			AddKeyParamToNote(data,"FPParams",info)
			
		endif

End

Function ApplyAzScanStyle(mode) //thie functoin applies futher styles to the az scan process data
variable mode

		if(mode==3)
				ModifyGraph fStyle=1,fSize=16
				ModifyGraph axRGB=(65535,65535,65535),tlblRGB=(65535,65535,65535);DelayUpdate
				ModifyGraph alblRGB=(65535,65535,65535)
				ModifyGraph standoff=0
				ModifyGraph mirror=0
				ModifyGraph wbRGB=(0,0,0)
				label bottom "\Z22\f01\K(65535,65535,65535)k\Bx\M \Z22( Å\S-1\M \Z22)"
				label left "\Z22\f01\K(65535,65535,65535)k\By\M \Z22( Å\S-1\M \Z22)"
				modifygraph margin(left) = 60
				modifygraph margin(bottom) = 60
				ModifyGraph width={perUnit,30,bottom}
				ModifyGraph height={perUnit,30,left}
				
		elseif(mode==2)
		
				ModifyGraph fStyle=1,fSize=16
				ModifyGraph axRGB=(0,0,0),tlblRGB=(0,0,0);DelayUpdate
				ModifyGraph alblRGB=(0,0,0)
				ModifyGraph standoff=1
				ModifyGraph mirror=0
				ModifyGraph wbRGB=(0,0,0)
				label bottom "\Z18\f01\K(0,0,0)k\Bx\M \Z18( Å\S-1\M \Z18)"
				label left "\Z18\f01\K(0,0,0)k\By\M \Z18( Å\S-1\M \Z18)"
				modifygraph margin(left) = 60
				modifygraph margin(bottom) = 60
				modifygraph wbRGB = (65535,65535,65535)
					ModifyGraph width={perUnit,30,bottom}
				ModifyGraph height={perUnit,30,left}
		endif				

End

Function ApplyAzScan100Style() //thie functoin applies futher styles to the az scan process data
variable mode
		
				
	ModifyImage ''#0,ctab= {*,*,Gold,0}
	ModifyGraph margin(left)=60,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	Label left "\\Z18\\f01\\K(0,0,0)k\\By\\M \\Z18( Å\\S-1\\M \\Z18)"
	Label bottom "\\Z18\\f01\\K(0,0,0)k\\Bx\\M \\Z18( Å\\S-1\\M \\Z18)"
	SetDrawLayer UserFront
	SetDrawEnv fsize= 16
	DrawText 0.903083700440529,1.15859030837004,"[010]"
	SetDrawEnv arrow= 1
	DrawLine 0.713656387665198,1.13656387665198,0.881057268722467,1.13656387665198
	SetDrawEnv arrow= 1
	DrawLine -0.123348017621145,0.288546255506608,-0.123348017621145,0.140969162995595
	SetDrawEnv fsize= 16,textrot= 90
	DrawText -0.149779735682819,0.105726872246696,"[001]"		

End

Function ApplyAzScan111Style(mode) //thie functoin applies futher styles to the az scan process data
variable mode
		
	
if(mode==1)			
	ModifyImage ''#0 ctab= {*,*,Gold,0}
	ModifyGraph margin(left)=60,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	Label left "\\Z18\\f01\\K(0,0,0)k\\By\\M \\Z18( Å\\S-1\\M \\Z18)"
	Label bottom "\\Z18\\f01\\K(0,0,0)k\\Bx\\M \\Z18( Å\\S-1\\M \\Z18)"
	ShowTools
	SetDrawLayer UserFront
	SetDrawEnv fsize= 16
	DrawText 0.903083700440529,1.15859030837004,"[110]"
	SetDrawEnv arrow= 1
	DrawLine 0.713656387665198,1.13656387665198,0.881057268722467,1.13656387665198
	SetDrawEnv arrow= 1
	DrawLine -0.123348017621145,0.288546255506608,-0.123348017621145,0.140969162995595
	SetDrawEnv fsize= 16,textrot= 90
	DrawText -0.149779735682819,0.105726872246696,"[112]"
	SetDrawEnv linethick= 2
	DrawLine 0.918502202643172,1.1057268722467,0.940528634361233,1.1057268722467
	SetDrawEnv linethick= 2
	DrawLine -0.151982378854626,0.0484581497797357,-0.151982378854626,0.0903083700440529

endif

if(mode==2)

	ModifyImage ''#0 ctab= {*,*,Gold,0}
	ModifyGraph margin(left)=43,margin(bottom)=43,width=170,height=170
	ModifyGraph mirror=1
	ModifyGraph font="Calibri"
	ModifyGraph fSize=11
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(left)=5,lblMargin(bottom)=3
	ModifyGraph standoff=0
	ModifyGraph lblLatPos=1
	ModifyGraph btLen=3
	Label left "\\Z12\\f01\\K(0,0,0)k\\By\\M \\Z12( Å\\S-1\\M \\Z12)"
	Label bottom "\\Z12\\f01\\K(0,0,0)k\\Bx\\M \\Z12( Å\\S-1\\M \\Z12)"
	
	


endif

End


Function/S FermiMap(data,kincrements, kmax, startphi, endphi, KE,symm,phicorrect,rot,type,normi)//converts an azimuthal set of data into a stereo projected plot of emssion intensity
	wave data
	variable kincrements, kmax, KE, type, startphi, endphi, symm, phicorrect ,rot,normi
 // whter pos polar, neg polar or all polar anlges are being used
	//phicorrect = 1
	 	
		Variable i, j, kx, ky, phi, theta, thetaindex, phiindex, magn, phi2,xindex,yindex
		variable lefttheta = dimoffset(data,0)
		variable righttheta  = dimoffset(data,0)+dimsize(data,0)*dimdelta(data,0)
		
		Make/O/W/N = (kincrements+1, kincrements+1) Fermiplot
	
			If(normi==1) //if symmetrising normalisation is in effect
				wave normwave =  $(Polarangleintegrate(data, lefttheta, righttheta))
				Smooth/b=100 5, normwave 
			endif
				
			for (j = 0; j<=kincrements; j+=1)
				ky = -kmax + j*(2*kmax/kincrements)
				
					for (i=0;i<=kincrements;i+=1)

						kx=-kmax+ i*(2*kmax/kincrements)
						phi = (atan(ky/kx))*180/pi
						magn = 1.96*sqrt((kx^2+ky^2)/KE) //calculate the magnitude of the vacuum wavevector
						theta = asin(magn)*180/pi
						
						if(theta>lefttheta && theta <righttheta)

							if(type==1) //if both polar angle halves are used
							
								if(phi<0)
									phi = phi+180	
								endif

								if(kx<0&&ky<=0)
									theta = -1*theta
									
								endif
							
								if(kx>=0&&ky< 0)
									theta = -1*theta
									
								endif
							
							xindex = i
							yindex = j
								
							elseif(type==2) //if negative angles are used
								
								if((kx<0))
									phi = 180+phi
								endif
								
								if(kx>=0&&ky<0)
									phi =360+phi
								endif
								
								xindex = kincrements-i
								yindex = kincrements-j
								
								theta = -theta
								
							elseif(type==3) //if positive angles are used
								
								if((kx<0))
									phi = 180+phi
								endif
								
								if(kx>=0&&ky<0)
									phi =360+phi
								endif
								
								yindex = j
								xindex = i
							endif
							
								if(symm==0) //non symmetrised data
									
									if((startphi+phi)>endphi)
										FermiPlot[xindex][yindex] = NAN
									else
										FermiPlot[xindex][yindex] = data((theta)+(phicorrect*phi))(startphi+phi)
									endif
								
								elseif(symm==1)
								
									if(phi>(endphi-startphi))
										phi = phi-(trunc(phi/(endphi-startphi))*(endphi-startphi))
									endif
										if(normi==1)
											FermiPlot[xindex][yindex] = data((theta)+(phicorrect*phi))(startphi+phi)/normwave(startphi+phi)
										else
											FermiPlot[xindex][yindex] = data((theta)+(phicorrect*phi))(startphi+phi)
										endif
											
								endif
								
								if(magn>1) 
								
									Fermiplot[xindex][yindex] = Nan //to make sure all intensity when theta = Nan is zero. 
								
								endif
								
						else
							Fermiplot[i][j] = Nan
						endif
								
							
					endfor
			endfor


	
	
	SetScale/I x, -kmax, kmax, FermiPlot
	SetScale/I y, -kmax, +kmax, FermiPlot //this final step then mirrors the y direction, yielding the correct emission distribution 
	
	if(rot!=0)
			rotatematrix(rot,Fermiplot)
	endif

end function





Function/S DIFFMap(data,kincrements, startphi, endphi,symm, normi, phicorrect, rot, type)//converts an azimuthal set of data into a stereogrpahic projection of polar emission angle versus azimuthal angle
	wave data
	variable kincrements, type, startphi, endphi, symm, phicorrect,normi,rot
 // whter pos polar, neg polar or all polar anlges are being used
	
			
		Variable i, j, x, y,rfract, phi, theta, xindex, yindex, magn, startI, endI
		Make/O/N = (kincrements+1, kincrements+1) Diffractionplot
		Setscale/I x, -1.005,1.005,Diffractionplot
		Setscale/I y,-1.005, 1.005, Diffractionplot
		
		If(normi==1) //if symmetrising normalisation is in effect good only for linear intenisty drift for syemmtrised sections
				if(type==1)
					wave normwave =  $(Polarangleintegrate(data, -90, 90))
				elseif(type==2)
					wave normwave =  $(Polarangleintegrate(data, -90, 0))
				elseif(type==3)
					wave normwave =  $(Polarangleintegrate(data, 0, 90))
				endif
				
				duplicate/O normwave normwave2
				startI = normwave[0] //normalise to this intensity
				endI = normwave[numpnts(normwave)-1]
				normwave2[] = (((endI-startI)/(endphi-startphi))*p+startI)/startI
				
		endif
			
			for (j = 0; j<=kincrements; j+=1)
			
			y= dimoffset(Diffractionplot,0)+j*dimdelta(diffractionplot,0)
				
				for (i = 0; i<=kincrements; i+=1)
					
					x= dimoffset(Diffractionplot,0)+i*dimdelta(diffractionplot,0)
					
					rfract = sqrt(x^2+y^2)
					phi =  (atan(y/x))*180/pi
					theta = acos((1-rfract^2)/(1+rfract^2))*180/pi
					
						if(type==1) //if both polar angle halves are used
							
								if(phi<0)
									phi = phi+180	
								endif

								if(x<0&&y<=0)
									theta = -1*theta
									
								endif
							
								if(x>=0&&y< 0)
									theta = -1*theta		
								endif
							
							xindex = i
							yindex = j
								
						elseif(type==2) //if negative angles are used
								
								if((x<0))
									phi = 180+phi
								endif
								
								if(x>=0&&y<0)
									phi =360+phi
								endif
								
								xindex = kincrements-i
								yindex = kincrements-j
								
								theta = -theta
								
						elseif(type==3) //if positive angles are used
								
								if((x<0))
									phi = 180+phi
								endif
								
								if(x>=0&&y<0)
									phi =360+phi
								endif
								
								yindex = j
								xindex = i
						endif
							
						if(symm==0) //non symmetrised data. This correctly does the phi selecting, as is the most recent version. I should update the Fermi map procedure. 
									
							if(phi>endphi||phi<startphi) //if the calculated phi angle lies outside the desired processing range, set value to Nan
									Diffractionplot[xindex][yindex] = NAN
							elseif(abs(theta)>90) //ignore values of theta outside 90 degrees from Normal emission
									Diffractionplot[xindex][yindex] = NAN
							else
									DiffractionPlot[xindex][yindex] = data((theta)+(phicorrect*phi))(phi)
							endif
							
					
						elseif(symm==1) //this will need fixing, i have already fixed the correct phi sampling for non symetrised data (above)
								
							if(phi>(endphi-startphi))
								phi = phi-(trunc(phi/(endphi-startphi))*(endphi-startphi))
							endif
						
							if(normi==1)
								DiffractionPlot[i][j] = data((theta)+(phicorrect*phi))(startphi+phi)/normwave2(startphi+phi)
							else
								DiffractionPlot[i][j] = data((theta)+(phicorrect*phi))(startphi+phi)
							endif
											
						endif
								
						if(rfract>=1) 
							
							DiffractionPlot[i][j] =Nan //to make sure all intensity when theta = Nan is zero. 
								
						endif
								
			endfor
		endfor					
					
	Duplicate/O DiffractionPlot DiffractionPlot2
	DiffractionPlot[][] = DiffractionPlot2[p][kincrements-1-q]	

		if(rot!=0)
			rotatematrix(rot,Diffractionplot)
		endif
	
	killwaves/z diffractionplot2

end function

Function FindFLVSTheta(data, polyorder, hwidth, begin, finish) //this function is designed to take a fermi edge data slice and find the position of the fermi edge as a function of  polar anlge, creating a wave that stores the results
wave data 
variable polyorder
variable hwidth
variable begin, finish
variable origfin = finish

variable pos,a
variable finish2 = finish

	Make/o/n = (dimsize(data,0)) FedgeWave
	Setscale/P x,dimoffset(data,0), dimdelta(data,0), Fedgewave
	Make/o/n=(dimsize(data,1)) Prof
	variable angles = dimsize(data,0)
	Variable i,j,k
		for(i=0;i<angles;i+=1)
			Prof = 0
			for(j=-hwidth;j<(hwidth);j+=1)
				if((i+j)<0) //if the selected profile lies outside the data, take the one closest to the edge. 
					a = -i
				elseif((i+j)>angles)
					a = angles-i
				else
					 a = j
				endif
					Prof[]+=Data[i+a][p]
			endfor
			
			pos = PolyFermiFit(Prof,polyorder, begin, finish)
			//begin = pos-2 //narrow the regio where the fermi level will be found (assuming Ef does not jump by more than  some ch per angle channel sampe
			//finish = pos+2
		
		//	if(finish>origfin)
		//		finish = origfin
		//	endif
		//	
			Fedgewave[i] = pos //scale the results in terms of energy
		endfor
	
		
end

//Function FindFLVSTheta2(data,hwidth,coeffwave)  //fermi fitting functn used when photon energy is making sudden jumps
wave data 
wave coeffwave



variable hwidth
variable begin, finish
variable pos,a,i,j,k, maxi, diff
variable  leftbound


	Make/o/n=(dimsize(data,1)) Prof
	Setscale/P x,dimoffset(data,1), dimdelta(data,1), Prof
	variable angles = dimsize(data,0)
	make/o/n=(dimsize(coeffwave,0)) coeff

			for(i=0;i<angles;i+=1)
				coeff[] = coeffwave[p][i]
				Prof[] = 0
				 //insert the intial guess for coeff from the coeffwave
				//Duplicate/O coeff, coeff2
					for(j=-hwidth;j<(hwidth);j+=1)
						if((i+j)<0) //if the selected profile lies outside the data, take the one closest to the edge. 
							a = -i
						elseif((i+j)>angles)
							a = angles-i
						else
							 a = j
						endif
							Prof[]+=Data[i+a][p]
					endfor
				wavestats/Q Prof
				leftbound = V_maxloc //set the start of fitting as the maximum
				//coeff[0] = 0 //set slop == 0 for left hand linear
				//Coeff[1] = V_max
				variable/g start = leftx(Prof)
				variable/g ende = rightx(Prof)
				variable/g num = dimsize(Prof,0)
				variable/g delta= deltax(Prof)
				FitFermiFunction(Prof,leftbound,rightx(Prof),coeff,2)
				coeffwave[][i] = coeff[p] //update the coeffwave
			endfor
	
		
end


Function CorrectAzScanDrift()
	
	wave data = ImageNameToWaveRef("",StringFromList(0, ImageNameList("", ";"),";"))
	string bpres = csrwave(B)
	string apres = csrwave(A)
	if(cmpstr(apres+bpres,"")!=0)	//if both cursors are on the graph
		variable left = min(hcsr(A), hcsr(B))
		variable right = max(hcsr(A), hcsr(B))
		TrackSurfState(data, left,right)
	endif
	wave/z centrewave
	CorrPolarAngleByStep(data,centrewave)
	
End




Function OverlayXPDscan(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR numslices = root:packages:Azpanelglobs:PEDnumsliceVAL
	NVAR centre = root:Packages:Azpanelglobs:PEDcentreVAL
	Controlinfo XPDaddpopup
	if(V_value==1)
			wave corrY, CorrX
				if(waveexists(CorrY)==0)
				
					DetermineChoffsets(Datablock)
					
				endif
				
			wave CorrY, CorrX
	variable correct = 0 //later on insert corrrct here when all pass energies Ecorr Profiles have been taken care of
				
			OverlaySlices(datablock,corrY, numslices,centre)
			wave overlay
			Displaywave(overlay)
			
	else
	
		Stackslices(datablock, centre, numslices,2)
		wave stacked
		Displaywave(stacked)
	endif
		


End

Function AutoCalcFEWAzScan(ctrlName) : ButtonControl 
String ctrlName
	
		wave datablock
		variable pos1, pos2, i, j,change,FermiEn,FermiEnold
		NVAR endE = root:Packages:Azpanelglobs:CalcFEendEVAL
		NVAR startE = root:Packages:Azpanelglobs:CalcFEstartEVAL
		NVAR smthfact = root:Packages:AzPanelGlobs:CalcFESmthVAL
		variable startEn,endEn
		
		controlinfo UsecsrChk
					
					if(V_value==1)
						startEn = min(hcsr(A),hcsr(B))
						endEn = max(hcsr(A),hcsr(B))
					else
						startEn = startE
						EndEn = EndE
					endif
			
		Make/o/n = (dimsize(datablock,1)) FEWAuto
		Make/o/n = (dimsize(datablock,0),dimsize(datablock,2)) sheet
		Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet
		Setscale/P y, dimoffset(datablock,2), dimdelta(datablock,2), sheet
		
		
		sheet[][]  =datablock[p][0][q]
		polarangleintegrate(sheet, -90,90)
		wave sheet_angleint
		
		Interpolate2/T=3/N=200/F=(smthfact) sheet_angleint
		wave sheet_angleint_SS
		Differentiate sheet_angleint_SS
		FindPeak/N/R=(startEn,endEn) sheet_angleint_SS
		FermiEnOld = V_peakloc
		
				for(j=0;j<dimsize(datablock,1);j+=1) //run through all photon steps
					sheet[][]  =datablock[p][j][q]
					polarangleintegrate(sheet, -90,90)
					Interpolate2/T=3/N=200/F=(smthfact) sheet_angleint
					Differentiate sheet_angleint_SS
					FindPeak/N/R=(startEn+change,endEn+change) sheet_angleint_SS
					Fermien = V_peakloc
					FEWauto[j] =V_peakloc
					change = FermiEn-FermiEnold
					FermiEnold = Fermien
				endfor	
				
		Displaywave(FEWauto)
		killwaves/z sheet, sheet_angleint,  sheet_angleint_SS		
End

Function AzScanStep(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	NVAR left = root:Packages:ARUPSPanelGlobs:PolintL
	NVAR right = root:Packages:ARUPSPanelGlobs:PolintR
	 
	wave datablock
	NVAR curstep = root:Packages:AzPanelGlobs:stepVAL
	
	Make/o/n=(dimsize(datablock,0),dimsize(datablock,2)) step
	step[][] =datablock[p][curstep][q]
	Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0), step
	Setscale/P y,dimoffset(datablock,2), dimdelta(datablock,2), step
	wave int = $(Polarangleintegrate(step,left,right))
	controlinfo showimage
		if(v_value)
			Displaywave(step) //display it
		endif
	 
	if(!Displaywave(int))

		ModifyGraph wbRGB=(65000,65000,65000),cbRGB=(16384,65280,65280)
		ModifyGraph mode=3
		ModifyGraph marker=8
		ModifyGraph rgb=(65280,16384,35840)
		ModifyGraph msize=2
		ModifyGraph useMrkStrokeRGB=1
		ModifyGraph mrkStrokeRGB=(65280,0,0)
		ControlBar 35
		Button AcceptVal1,pos={54,11},size={109,18},proc=InsertFEIntoManFEW,title="Insert Man FEW"
		Button AcceptVal1,labelBack=(0,0,0),fStyle=1,fColor=(48896,65280,65280)
		CheckBox usecsrforFE,pos={291,11},size={80,14},title="Use csr A?",fStyle=1,value= 0
		Button AcceptVal2,pos={170,11},size={109,18},proc=InsertFEIntoAutoFEW,title="Insert Auto FEW"
		Button AcceptVal2,labelBack=(0,0,0),fStyle=1,fColor=(48896,65280,65280)
		killvariables/z FermiEnCalc
	endif
	Removefromgraph/z step_angleint_SS
	tag/k/n=FermiTag

End

Function CalcFEAzScanStep(ctrlName) : ButtonControl  //function allows user to step through the CIS step by step. At each step
String ctrlName										// the user can detect the position of the Fermi edge

		NVAR step = root:Packages:AzPanelGlobs:stepVAL
		wave datablock
		NVAR startE = root:Packages:AzPanelGlobs:CalcFEStartEVAL
		NVAR smthfact= root:Packages:AzPanelGlobs:CalcFEsmthVAL
		NVAR endE = root:Packages:AzPanelGlobs:CalcFEendEVAL
		NVAR minKE
		NVAR stepph
	
		 
		string curfolder =  getdatafolder(1)          
		variable startEn, EndEn
		Wave int =WaveRefIndexed("", 0, 3)
		setdatafolder $getwavesdatafolder(int,1)
		variable/g FermiEnCalc
		
			if(cmpstr(nameofwave(int),"step_angleint")==0)
				
				controlinfo UsecsrChk
					if(V_value==1)
						if(stringmatch(CsrWave(A),"")||stringmatch(csrwave(B),""))
							doalert 0, "Both Cursors must be on Graph"
							return 0 
						else
							startEn = min(hcsr(A),hcsr(B))
							endEn = max(hcsr(A),hcsr(B))
						endif
						
					else
						startEn = startE
						EndEn = EndE
					endif
			
				//FermiEnCalc  = PolyFermiFit(int,smthfact, startEn, endEn)
				//wave fit_CIStep_angleint
				Interpolate2/T=3/N=200/F=(smthfact) step_angleint
				wave step_angleint_SS
				Removefromgraph/Z step_angleint_SS
				Appendtograph step_angleint_SS
				Duplicate/O step_angleint_SS, fit
				Differentiate fit/D=fit
				FindPeak/N/R=(starten,enden) fit
				
				FermiEnCalc = V_peakloc
				tag/k/n=FermiTag
				tag/Y=0/X=-35/N=fermiTag step_angleint_SS,FermienCalc,"FE ="+"  "+num2str(FermiEnCalc)+"eV"
	
			else
				Doalert 0, "Active graph not an Azscan step"
				return 0
			endif
		
		setdatafolder $curfolder
			
End



Function InsertFEIntoManFEW(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR step = root:Packages:AzPanelGlobs:stepVAL
	wave datablock
	NVAR Fermiencalc
	wave/z FEWman
	
	controlinfo usecsrforFE 
	variable usecsr = V_value
	
	switch(usecsr)
	
		case 1:
		
			if(stringmatch(csrwave(A),""))
				Doalert 0, "Cursor A not on graph"
				return 0
			else
				Doalert 1, "User Csr A Pos as FE?"
					if(V_flag==1)
						FermienCalc = hcsr(A)
						FEWman[step] = FermiEnCalc
						tag/k/n=FermiTag
						tag/Y=10/X=10/N=FermiTag bottom,FermienCalc,"FE ="+"  "+num2str(FermiEnCalc)+"eV"
					else
						return 0 
					endif
			endif
		break
		 
		case 0:
			
				if(NVAR_Exists(FermiEnCalc))
					Doalert 1, "Insert Fermi Fit results into manual-detect AzScan wave?"
			
					If(V_flag==1) //if user clicked ok
			 
						If(waveexists(FEman)!=1)
							Make/o/n = (dimsize(datablock,1)) FEWman
						endif
		
						FEWman[step] = FermiEnCalc	
						
						tag/k/n=FermiTag
						tag/Y=10/X=10/N=FermiTag step_angleint_SS,FermienCalc,"FE ="+"  "+num2str(FermiEnCalc)+"eV"
					endif
	
				else
					Doalert 0, "Must Calc Fermi Energy First "
					return 0
				endif
		break	
		
		endswitch	
					
End


Function  InsertFEIntoAutoFEW(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR step = root:Packages:AzPanelGlobs:stepVAL
	wave datablock
	NVAR FermiEnCalc
	wave/z FEWauto


	controlinfo usecsrforFE
	variable usecsr = v_value
	
	switch(usecsr)
	case 0:
	
	if(NVAR_Exists(FermiEnCalc))
		Doalert 1, "Overwrite FEWauto results at this step??"
			
					If(V_flag==1) //if user clicked ok
			
						If(waveexists(FEWauto)!=1)
							Doalert 0, "Auto FEW does not exist"
							return 0 
						else						
							FEWauto[step] = FermiEnCalc	
						endif
					else
						return 0
					endif
	else
		Doalert 0, "Must Calc Fermi Energy First "
		return 0
	endif
	
	break
	
	case 1:
	
			if(stringmatch(csrwave(A),""))
				Doalert 0, "Cursor A not on graph"
				return 0
			else
				Doalert 1, "Overwrite FEauto using Csr A pos as FE?"
					if(V_flag==1)
						FermienCalc = hcsr(A)
						FEWauto[step] = Fermiencalc
					else
						return 0 
					endif
			endif
	break	
	endswitch	
	
	tag/k/n=FermiTag
	tag/Y=0/X=-35/N=fermiTag step_angleint_SS,FermienCalc,"FE ="+"  "+num2str(FermiEnCalc)+"eV"
					
	

End

Function ExtractFEWAzScan(FEW,BE,width,datablock) //this function takes a pre-computed wave of fermi level positions in a CIS scan (binding energies) and extracs form the data set the data correspondint ot he desired BE
wave FEW
wave datablock
variable BE //the binding energy rel to the fermi level
variable width

	variable i,j,num
	NVAR middleKE
	
	Make/o/n = (dimsize(datablock,0), dimsize(datablock,2)) sheet
	Make/o/n = (dimsize(datablock,0),dimsize(datablock,1)) fermi
	make/o/n = (dimsize(datablock,1)) azscanenergies
	make/o/n=(dimsize(datablock,2)) line
	
	Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet,fermi
	Setscale/P y,dimoffset(datablock,2), dimdelta(datablock,2), sheet
	Setscale/P x,dimoffset(datablock,2), dimdelta(datablock,2), line
	
		for(j=0;j<dimsize(datablock,1);j+=1)
			sheet[][] = datablock[p][j][q]
				for(i=0;i<dimsize(sheet,0);i+=1)
					line[] =sheet[i][p]
						if(width>0)
							fermi[i][j] =area(line,FEW[j]-BE+width/2,FEW-BE-width/2)
						else
							fermi[i][j] =line(FEW[j]-BE)
						endif
				endfor
			////
		endfor	
		
End

Function XPDDiff(wave1, wave2)
wave wave1, wave2

variable i, j, num
duplicate/O wave1 diff


	for(i=0;i<(dimsize(wave1, 0));i+=1)
		for(j=0;j<(dimsize(wave1, 1));j+=1)
			num  = wave1[i][j] - wave2[i][j]
				if(num<0)
					num = 0
				endif
			
			diff[i][j] = num
				
		endfor
	endfor
	
end

Function DisplayVolumeK(ctrlName) : ButtonControl
	String ctrlName
	
	DisplayVolume_Azscan()

End

Function DisplayVolume_Azscan()

wave/z VolumeAzscan

	if(WaveExists(VolumeAzscan)) //if there is a VolumeAzscan in the current folder
	
		string windowname = Namewindow("VolumeAzscan")
		String windowtitle  = "VolumeAzScan"+"_"+Getdatafolder(0)
		string wlist = winlist(windowname,";","WIN:1")
		NVAR CentralECh
		NVAR middleKE
		NVAR VolAzScanindex
		
			if(stringmatch(wlist,"")==1) //if window does not exist

				variable minKe = dimoffset(volumeazscan,2)
				variable maxKE = dimoffset(volumeazscan, 2) + dimdelta(volumeazscan,2)*(dimsize(volumeazscan,2)-1)
				variable KEstep = dimdelta(volumeazscan, 2)
				Make/o/n = (dimsize(VolumeAzScan, 0), dimsize(volumeazscan, 1)) DisplayedAzSlice
				DisplayedAzSlice[][] = volumeazscan[p][q][CentralEch]
				Setscale/P x, dimoffset(volumeazscan,0), dimdelta(volumeazscan, 0), DisplayedAzSlice
				Setscale/P y, dimoffset(volumeazscan,1), dimdelta(volumeazscan, 1) , DisplayedAzSlice
				Display /W=(450.75,90.5,988.5,683) /K=1
				Dowindow/C $windowname
				Dowindow/T $windowname, windowtitle
				AppendImage DisplayedAzSlice
				ModifyGraph width={Aspect,1},height={Aspect,1},cbRGB=(0,43520,65280)
				ModifyGraph mirror=1
				ModifyGraph nticks=10
				ModifyGraph minor=1
				ModifyGraph fSize=12
				ModifyGraph standoff=0
				ModifyGraph tkLblRot(left)=90
				ModifyGraph btLen=3
				ModifyGraph tlOffset=-2
				SetAxis/A/R left
				
				ControlBar 91
				Slider slider0,pos={249,3},size={300,52},proc=AzvolumeSliderProc,fSize=12
				Slider slider0,fStyle=1,valueColor=(0,0,0)
				Slider slider0, limits={minKE,maxKE, KEstep},value=middleKE,vert= 0, fsize = 12,  ticks=10, variable = :VolAzScanEnergy				
				
				SetVariable setvar0,pos={8,8},size={238,20},proc=AzVolumeEnProc,title="Const En (eV)", variable = :VolAzScanEnergy	
				SetVariable setvar0,fSize=14,fStyle=1
				SetVariable setvar0,fStyle=1, limits={minKE,maxKE, KEstep}	
				
				PopupMenu VolAzProfPopUp,pos={135,58},size={100,21}, disable = 2, proc=VolAzScanCsrProfileStyle,title="Mode"
				PopupMenu VolAzProfPopUp,mode=1,popvalue="H Cursor",value= #"\"H Cursor;V Cursor; Csr - Csr\""
				
				CheckBox check0,pos={7,60},size={116,16},proc=ShowAzScanEDC,title="Show EDC Cut"
				CheckBox check0,fSize=14,fStyle=1,value= 0
				
				Button SaveVAzProf,pos={244,58},size={78,21}, disable = 2, proc=SaveVolZEDC,title="Save EDC Cut"
				
				SetVariable VAzEDCName,pos={333,60},size={200,16},title="Name"
				SetVariable VAzEDCName,disable = 2, value= :VolAzScanEDCname
				SetWindow kwTopWin,hook(MyHook)=VolumeAzCursorHook
				ShowInfo
				
				SetWindow $winname(0,1), hook(MyHook) = VolumeAzCursorHook
				
				
		else
			Dowindow/F $windowname
		endif
	else
	
		Doalert 0, "No Volume Azscan in this directory (may still need to be generated)"
	
	endif
	 
EndMacro

Function VolumeAzCursorHook(s)
	STRUCT WMWinHookStruct &s
	
	Variable hookResult = 0	// 0 if we do not handle event, 1 if we handle it.
	

	if(s.eventCode==7) //cursor moved
		if(cmpstr(csrinfo(A),"")==0) //is cursor A on the graph?
			return -1
		else
		
			string curfolder = getdatafolder(1)
			wave curdata = csrwaveref(A)
			variable csrindex
			setdatafolder getwavesdatafolder(curdata,1)	
			wave/z VolumeAzscan
			wave/Z VolumeAzScanEDC
			Controlinfo VolAzProfPopUp
			
				if(V_value==1) //horizontal profile
				
					if(dimsize(VolumeAzScanEDC, 0)==dimsize(VolumeAzScan, 0))
						csrindex = qcsr(A)
						VolumeAzScanEDC[][] = VolumeAzScan[p][csrindex][q]
					else
					
						make/o/n = (dimsize(volumeazscan,1), dimsize(volumeazscan, 2)) VolumeAzScanEDC
						Setscale/P x, dimoffset(Volumeazscan,0), dimdelta(volumeazscan, 1), "Å\S-1", VolumeAzscanEDC
						Setscale/P y, dimoffset(volumeAzscan, 2), dimdelta(volumeazscan, 2) , "KE (eV)", VolumeAzscanEDC
						
						csrindex = qcsr(A)
						VolumeAzScanEDC[][] = VolumeAzScan[p][csrindex][q]
						
					endif	
				
				elseif(V_value==2) //vertical profile
				
					if(dimsize(VolumeAzScanEDC, 0)==dimsize(VolumeAzScan, 0))
						csrindex = pcsr(A)
						VolumeAzScanEDC[][] = VolumeAzScan[csrindex][p][q]
					else
					
						make/o/n = (dimsize(volumeazscan,1), dimsize(volumeazscan, 2)) VolumeAzScanEDC
						Setscale/P x, dimoffset(Volumeazscan,0), dimdelta(volumeazscan, 1), "Å\S-1", VolumeAzscanEDC
						Setscale/P y, dimoffset(volumeAzscan, 2), dimdelta(volumeazscan, 2) , "KE (eV)", VolumeAzscanEDC
						
						csrindex = pcsr(A)
						VolumeAzScanEDC[][] = VolumeAzScan[csrindex][p][q]
					
					endif
				
				elseif(V_value==3)
						
						variable csrdist = round(sqrt((pcsr(A)-pcsr(B))^2+(qcsr(A)-qcsr(B))^2))
						variable j,x,y
						variable xo = pcsr(A)
						variable yo = qcsr(A)
						variable xdelta = pcsr(B)-pcsr(A)
						variable ydelta = qcsr(B)-qcsr(A)
						make/o/n= (csrdist,2) csrcoords
							for(j=0;j<=csrdist;j+=1)
								x = round(xo+ (j/csrdist)*xdelta)
								y = round(yo+ (j/csrdist)*ydelta)
								csrcoords[j][0] = x ; csrcoords[j][1] = y
							endfor
							
						make/o/n = (csrdist, dimsize(volumeazscanEDC, 1)) VolumeAzscanEDC
							for(j=0;j<=csrdist;j+=1)
								VolumeAzscanEDC[j][] = VolumeAzscan[csrcoords[j][0]][csrcoords[j][1]][q]
							endfor
								Setscale/P y, dimoffset(volumeAzscan, 2), dimdelta(volumeazscan, 2) , "KE (eV)", VolumeAzscanEDC
								variable k_dist = csrdist*dimdelta(volumeAzScan,0)
								Setscale/I x, 0, k_dist, "Å\S-1", VolumeAzscanEDC
							
						
				endif
		
		endif
	endif
	
	return hookResult	// If non-zero, we handled event and Igor will ignore it.
End


Function AzVolumeSliderProc(ctrlName,sliderValue,event) : SliderControl
	String ctrlName
	Variable sliderValue
	Variable event	// bit field: bit 0: value set, 1: mouse down, 2: mouse up, 3: mouse moved

	wave Displaydata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	string curfolder = GetDataFolder(1) //get reference to current datafolder
	string destfolder  = GetWavesDataFolder(displaydata, 1) //get reference to folder containing the displayed Azscan data,
	SetDataFolder $destfolder
	wave/z Volumeazscan
	variable sliceindex = round((slidervalue - dimoffset(volumeazscan,2))/dimdelta(volumeazscan, 2))
	Displaydata[][] = Volumeazscan[p][q][sliceindex]
	Doupdate/W = $winname(0,1)  
	Setdatafolder $curfolder
	

End

Function AzVolumeEnProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName

	wave Displaydata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	string curfolder = GetDataFolder(1) //get reference to current datafolder
	string destfolder  = GetWavesDataFolder(displaydata, 1) //get reference to folder containing the displayed Azscan data,
	SetDataFolder $destfolder
	wave/z Volumeazscan
	variable sliceindex = round((varNum - dimoffset(volumeazscan,2))/dimdelta(volumeazscan, 2))
	Displaydata[][] = Volumeazscan[p][q][sliceindex]
	Doupdate/W = $winname(0,1)  
	Setdatafolder $curfolder
	
	
End

Function Generate_AzScan_Volume(ctrlName) : ButtonControl
	String ctrlName
	

SVAR/Z Scantype

	if(cmpstr(Scantype, "Azimuth")==0) //if the scantype is an azscan
	
		wave/z datablock
		variable/g VolAzScanEnergy
		String/g VolAzScanEDCname
		NVAR increments = root:Packages:AzPanelGlobs:KincrementsVAL 
		NVAR rotation = root:Packages:AzpanelGlobs:azscanrotVAL
		NVAR startphi
		NVAR endphi
		NVAR middleKE
		NVAR ewinstep
		variable phirange = endphi - startphi
		variable i,KE
		variable layers = dimsize(datablock,2)
		variable MaxKE = dimoffset(datablock, 2)+ewinstep*(dimsize(datablock, 2)-1) //calucluate the maximum kinetic energy correspondng to the va
		variable kmax = 0.511*sqrt(MaxKE)
		make/o/w/n = (increments, increments, dimsize(datablock,2)) VolumeAzScan
		Setscale/I x, -kmax, kmax,  VolumeAzScan
		Setscale/I y, -kmax, kmax, VolumeAzScan
		Setscale/P z, dimoffset(datablock,2), dimdelta(datablock, 2), "KE (eV)", VolumeAzscan
		make/o/w/n = (dimsize(datablock, 0), dimsize(datablock,1)) data
		setscale/P x, dimoffset(datablock, 0), dimdelta(datablock,0), data
		setscale/I y, 0, phirange, data

			for(i=0;i<layers;i+=1)
			
				KE = dimoffset(datablock, 2) + i*dimdelta(datablock,2)
				data[][] = datablock[p][q][i]
				FermiMap(data,increments, kmax, 0, phirange, KE,0,0,rotation,1,0)
				wave Fermiplot
				VolumeAzScan[][][i] = Fermiplot[p][q]
				
			endfor
		killwaves/z data
		make/o/n = (dimsize(volumeazscan,1), dimsize(volumeazscan, 2)) VolumeAzScanEDC
		Setscale/P x, dimoffset(Volumeazscan,0), dimdelta(volumeazscan, 1), "Å\S-1", VolumeAzscanEDC
		Setscale/P y, dimoffset(volumeAzscan, 2), dimdelta(volumeazscan, 2) , "KE (eV)", VolumeAzscanEDC
		
		DisplayVolume_Azscan() //display the volume Azscan
	
	else

		Doalert 0, "Current folder does not contain an Az Scan Datablock, procedure aborted"

	endif


End	

Function ShowAzScanEDC(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	wave Displaydata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	string curfolder = GetDataFolder(1) //get reference to current datafolder
	string destfolder  = GetWavesDataFolder(displaydata, 1) //get reference to folder containing the displayed Azscan data,
	SetDataFolder $destfolder
	Wave/z VolumeAzScanEDC
	
	string imagename = StringFromList(0, ImageNameList(winname(0,1), ";"), ";") 

if(checked)

	PopupMenu VolAzProfPopUp disable = 0
	button SaveVAzProf disable = 0
	setvariable VAzEDCname disable = 0
	Controlinfo VolAzProfPopUp
		if(V_value==1)//horizontal
			Execute "VolAzScanCsrProfileStyle(\"VolAzProfPopUp\",1,\"H Cursor\")"
		elseif(V_value==2)
			Execute "VolAzScanCsrProfileStyle(\"VolAzProfPopUp\",2,\"V Cursor\")"
		elseif(V_value==3)
			Execute "VolAzScanCsrProfileStyle(\"VolAzProfPopUp\",3,\"Csr - Csr\")"
		endif
	Displaywave(VolumeAzscanEDC)
	Setdatafolder $curfolder
	
else	
	PopupMenu VolAzProfPopUp disable = 2
	button SaveVAzProf disable = 2
	setvariable VAzEDCname disable = 2
	cursor/K A
	Cursor/K B
	
	Displaywave(VolumeAzscanEDC) //bring volumeazedc to front
	killwindow $winname(0,1)
	
	
endif

End



Function VolAzScanCsrProfileStyle(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	string imagename = StringFromList(0, ImageNameList(winname(0,1), ";"), ";")
	
	if(popNum==1) ///if doing a horizontal profile
		cursor/I/H=3 A $imagename 0,0
		Cursor/K B 
	elseif(popNum==2) //if doing a vertical profile
		cursor/I/H=2 A $imagename 0,0
		Cursor/K B 
	elseif(popNum==3)
			cursor/I/H=0 B $imagename 0,0
		cursor/I/H=0 A $imagename 0,0
	
	endif
		

End

Function SaveVolZEDC(ctrlName) : ButtonControl
	String ctrlName
	
	wave Displaydata = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	string curfolder = GetDataFolder(1) //get reference to current datafolder
	string destfolder  = GetWavesDataFolder(displaydata, 1) //get reference to folder containing the displayed Azscan data,
	SetDataFolder $destfolder
	wave/z VolumeAzScanEDC
	
	SVAR/Z VolAzScanEDCname
	string newname = VolAzScanEDCname
	
	Duplicate/O VolumeAzScanEDC, $VolAzScanEDCname	
	setdatafolder $curfolder
	
	

End
