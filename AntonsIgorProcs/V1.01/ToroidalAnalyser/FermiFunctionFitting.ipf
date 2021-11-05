#pragma rtGlobals=1		// Use modern global access method.

Function LaunchFermiFitPanel(ctrlName) : ButtonControl
	String ctrlName
	
	GenerateFermiFitPanel()

End



Function GenerateFermiFitPanel()

	string curfolder = getdatafolder(1)
	
	if(CheckName("FermiFitPanel", 9,"FermiFitPanel"))
		Dowindow/F Fermifitpanel
	else
		
		Newdatafolder/O/S root:Packages:FermiFitPanelGlobs
		
		variable/g FFPosVAL 
		variable/g FFwidthVAL 
		variable/g FFPolyorderVAL 
		variable/g FFtempVAL
	
	
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(939,69,1256,262)
	Dowindow/C FermiFitPanel
	ModifyPanel cbRGB=(65280,32768,45824)
	ShowTools
	SetDrawLayer UserBack
	SetDrawEnv linethick= 2,fillpat= 0
	DrawRRect 4,10,286,183
	DrawRRect 45,116,47,116
	SetDrawEnv fstyle= 1
	DrawText 18,167,"Fermi Edge Fitting"
	SetDrawEnv gstart
	SetDrawEnv arrow= 2
	DrawLine 156,96,156,168
	SetDrawEnv arrow= 1
	DrawLine 156,168,253,168
	SetDrawEnv linethick= 4,linefgc= (52224,0,0),dash= 2,fillpat= 0
	DrawPoly 169,115,0.818182,0.980392,{250,111,256,108,262,108,268,107,274,112,278,118,279,124,281,130,284,136,287,142,290,148,296,153,302,156,308,157,314,158,320,158,326,158,332,158,338,158}
	SetDrawEnv fstyle= 1
	DrawText 256,175,"E"
	SetDrawEnv gstop
	Button FermiFitButton,pos={14,94},size={119,27},proc=FitFermiFunctionToDisplayedData,title="Fit Fermi Function"
	Button FermiFitButton,fSize=14
	PopupMenu FitType,pos={145,23},size={125,21},proc=FitTypeSelection,title="Fit Type"
	PopupMenu FitType,mode=1,popvalue="Simple Fit",value= #"\"Simple Fit; Linear BG\""
	SetVariable FFTemp,pos={167,66},size={100,16},title="Temp (K)"
	SetVariable FFTemp,value= root:Packages:FermiFitPanelGlobs:FFtempVAL
	CheckBox RangeChk,pos={13,65},size={128,14},title="Use Cursors For Range"
	CheckBox RangeChk,value= 1
	PopupMenu DataType,pos={12,24},size={127,21},title="Data"
	PopupMenu DataType,mode=1,popvalue="Active Graph",value= #"\"Active Graph;Select From Folder;Batch Fit\""


	endif
	
	SetDatafolder $curfolder
	
End Function


Function SimpleFermiFit(w,x) : FitFunc //convolves a gaussian with fermi function and adds linear background
	Wave w // w = W0, W1, ...w0 = Fermi Scaling
	// w0 = Scaler, w1 = offset, w2  Fermi position, w3 =gaussian width, w4 =temperature
	Variable x

	Wave/z Fwave,Gwave
	Fwave =0 ; Gwave = 0
	
	variable erange = (rightx(Fwave)- leftx(Fwave))/2
	variable starte = w[2]-erange
	
	Setscale/P x,starte, deltax(Fwave), Fwave, Gwave
		 //convolution involves extending out the fermi profile and convolving with a gaussian centred at the middle
	
	Fwave[] = 1/(exp((pnt2x(Fwave,p)-w[2])/w[4])+1)
	Gwave[] = Gauss(pnt2x(Gwave,p),w[2],w[3]) //generate the normalised gaussian wave
		
	Convolve/A Gwave,Fwave //convolute the Gaussian through the Fermi function
		
	Fwave[]  = (w[0]*Fwave[p])+w[1]
		
		
	
Return Fwave(x)
End

//Function FermiConvolve2(w,x): FitFunc
//wave w // wave will consists of coefficients of two poly fits (same order) follwed by the width and position of the fermi edge. 
variable x

	NVAR start
	NVAR delta 
	NVAR temp = root:Packages:FermiFitPanelglobs:FFtempVAL
	variable Et = (temp/298)*0.025
	
	wave/z Fwave,Gwave
	variable nc =((numpnts(w)-2))/2
	Make/o/n=(nc) Lpolyc, Rpolyc
	Lpolyc[] = w[p]
	Rpolyc[] = w[nc+p]
	variable starte = w[dimsize(w,0)-2]-(numpnts(Fwave)/2)*delta
	Setscale/P x,starte, delta, Fwave, Gwave
	// convolution involves extending out the fermi profile and convolving with a gaussian centred at the middle
	Fwave[] = 1/(exp((pnt2x(Fwave,p)-w[dimsize(w,0)-2])/Et)+1)
	
	Gwave[]= (1/(sqrt(pi)*w[numpnts(w)-1]))*exp(-((pnt2x(Gwave,p)-w[numpnts(w)-2])/w[numpnts(w)-1])^2)
	Convolve/A Gwave, Fwave
	Fwave[] = poly(Lpolyc,pnt2x(Fwave,p))*Fwave[p]+(1-Fwave[p])*poly(Rpolyc,pnt2x(Fwave,p))
	//Print w[0]
	//Print w[1]
	
	
Return Fwave(x)

End


Function FitFermiFunctionToDisplayedData(ctrlName) : ButtonControl
	String ctrlName
	
	
	
	variable leftbound, rightbound
	NVAR temperature = root:Packages:FermiFitPanelGlobs:FFtempVAL //reference to the supplied temperature. 
	variable Et = 0.025 *((temperature)/298) //the value of kT in eV. 
	
	Controlinfo/W = FermiFitpanel FitType //which fit type has been selected
	variable fittype = v_value
	Controlinfo RangeChk //check if using full displayed range or using cursor position
				
		if(V_value==0) //If using the full range of a displayed wave
			
			wave data = waverefindexed(winname(0,1),0,1)   
			leftbound = leftx(data)
			rightbound = rightx(data)
			
		else //using the cursor range.
			
			string dataA =CsrWave(A)  
			string dataB = CsrWave(B)
				
				if(cmpstr(dataA,dataB)==-1)
					abort "Cursors Not On Graph"		
				endif
			
			wave data = CsrWaveRef(A)
			leftbound = min(hcsr(A), hcsr(B))
			rightbound = max(hcsr(A), hcsr(B))
			
		endif
		
		
	string curfolder = getdatafolder(1)
	string destfol = GetWavesDataFolder(data,1)
	string fitfolder = nameofwave(data)+"_"+"FFit"
	setdatafolder $destfol //set to the data fodler from where the displayed wave comes from
	Newdatafolder/O/S :$fitfolder //sets the data fodler to the fit folder. creates from new if not already created,. 
	Duplicate/O data, wavetofit
			
	if(fittype ==1) //simepl (no linear BG) Fermi Fitting
	
			Make/o/n=5 Coeff //this is the coefficient wave. The initial guesses for the fit will be diaplyed here
			
			variable offset, scaling
			Controlinfo RangeChk 
				
				if(V_value==1) 
					offset = min(vcsr(A), vcsr(B))
					scaling  = abs(vcsr(A)-vcsr(B))
				else
					wavestats data
					offset = V_min
					scaling = V_max - V_min
				endif
				
			
			//the section below differentiates the derivative function, and fits a gaussian to the result, in order to get a handle on the 
			variable position, width
			Differentiate data /D =DIFF //differentiate the data
			smooth 1, DIFF //smooth the differential
			DIFF = abs(diff)
			
		
			CurveFit gauss  DIFF (leftbound, rightbound)
			wave W_coef //use the values from the gauss curve fit to the derivative to aid the inital guesses. 
			position = W_coef[2]
			width = W_coef[3]

			coeff = {scaling, offset, position, width, Et} //fill out the initial guess coefficient wave
			
			FitSimpleFermiFunction(data,leftbound,rightbound,coeff)	//perform the fit
			coeff[3] *= 1.664
			//NVAR/z root:Packages:FermiFitPanelGlobs:FFposVAL = coeff[2]
			//NVAR/z root:Packages:EDCPanelGlobs:FFwidthVAL = coeff[3] 

			// as FWHM different from normal Gaussian width factor
			Controlupdate/A  //update the results in the panel
			string fitwavename = "fit_"+nameofwave(data)
			
			string tagname  = "FermiTag_"+nameofwave(data)
			tag/k/n= $tagname
			tag/Y=20/X=20/N=$tagname, $fitwavename,coeff[2],"FE ="+"  "+num2str(coeff[2])+"eV"+"\r"+"Width = "+num2str(coeff[3])+"eV"
			
			
	elseif(fittype==2) //linear background
	
	
	////// yet to put this code in
	
	endif	
			
	Setdatafolder $curfolder //return to the origina data folder you were working in		

End

Function FitFermiFunction_LinBG(wavetofit,leftbound,rightbound,coeff) //THIS NEEDS TO BE MODIFIED
wave wavetofit
wave coeff
variable leftbound
variable rightbound
variable type
	
	
		variable/g start = leftx(wavetofit)
		variable/g ende = rightx(wavetofit)
		variable/g num = numpnts(wavetofit)
		variable/g delta = deltax(wavetofit)
		
		variable Frange = 5*(ende - start) //will make the fermi and guassian 5 waves defined over 5 * wider than the region being fitted
		
		variable Flen = round(Frange/(0.5*delta)) //determine the number of points to be used for the Fwave and Gwave. Delta values in E is half the data spacing
		
		make/o/n= (Flen) Fwave,Gwave
	//	variable starte = coeff[2] -(numpnts(Fwave)/2)*delta
		Setscale/I x, -Frange/2, Frange/2, Fwave, Gwave
		
			if(type==1)
			
				FuncFit/Q/N Fermiconvolve2, coeff, wavetofit(leftbound,rightbound)/D //  poly fitting
				
			elseif(type==2) //simple Fermi function fit
			
				FuncFit/Q/N/H="00001" SimpleFermiFit, coeff, wavetofit(leftbound,rightbound)/D //1 line fitting.
				
			endif
		
End



Function FitSimpleFermiFunction(wavetofit,leftbound,rightbound,coeff) //this function fits a convoluted Fermifunction with Gaussian to a wave
wave wavetofit
wave coeff
variable leftbound
variable rightbound

	
	
		variable start = leftx(wavetofit)
		variable ende = rightx(wavetofit)
		variable num = numpnts(wavetofit)
		variable delta = deltax(wavetofit)
		
		variable Frange = 5*(ende - start) //will make the fermi and guassian 5 waves defined over 5 * wider than the region being fitted
		
		variable Flen = round(Frange/(0.5*delta)) //determine the number of points to be used for the Fwave and Gwave. Delta values in E is half the data spacing
		
		make/o/n= (Flen) Fwave,Gwave
	//	variable starte = coeff[2] -(numpnts(Fwave)/2)*delta
		Setscale/I x, -Frange/2, Frange/2, Fwave, Gwave
		
		FuncFit/Q/N/H="00001" SimpleFermiFit, coeff, wavetofit(leftbound,rightbound)/D //1 line fitting.
				
		
		
End


Function SetLinBGInitialGuess(ctrlName) : ButtonControl //this function executes an initial guess for the fermi fit function. it creates a wave of the guess, coeff 
	String ctrlName
	
	NVAR pos = root:Packages:FermiFitPanelglobs:FFposVAL
	NVAR width =root:Packages:FermiFitPanelglobs:FFwidthVAL
	string curfolder = getdatafolder(1) //get path to current folder
	string curwindow = winname(0,1)
	wave data = WaveRefIndexed(curwindow, 0, 1)
	string df = GetWavesDataFolder(data,1)
	string fitfolder = nameofwave(data)+"_"+"FFit"
	//Setdatafolder $df //go to the folder the data comes from
	Controlinfo/W = FermiFitpanel linfitsel
			if(V_value==1) //poly fitting
				setdatafolder $df
				if(datafolderexists(fitfolder))
					setdatafolder :$fitfolder
						
						if(!waveexists(Lcoef)||!waveexists(Rcoef)) //if one of each line hasnt been fitted
							Doalert 0, "Set left and right Poly Contributions"
						else
							wave/z Lcoef
							wave/z Rcoef
							make/o/n=2 coeff
							coeff = {pos,width}
							Insertpoints 0,dimsize(Rcoef,0), coeff
							coeff[0,dimsize(Rcoef,0)-1] = Rcoef[p]
							Insertpoints 0,dimsize(Lcoef,0),coeff
							coeff[0,dimsize(Lcoef,0)-1] = Lcoef[p]
						
							Button FermiFitbutton disable = 0 //allow user to make fit
						endif
				else
					Doalert 0, "Set left and right linear contributions"
				endif
	
			elseif(V_value==2) //1 component fitttnig
						string apres, bpres
						apres = CsrWave(A,curwindow)
						bpres=CsrWave(B,curwindow)
						
							if(cmpstr(apres+bpres,"")!=0) //if there is a cursor in the graph
								variable m,c
								setdatafolder $df
								Newdatafolder/O/S :$fitfolder
								removefromgraph/w=$curwindow/z Lfit,Rfit //remove any previous traces
								m = (vcsr(A)-vcsr(B))/(hcsr(A)-hcsr(B))
								c  = vcsr(B)-m*hcsr(B)
								make/o/n = 100 linwave
								Setscale/I x,leftx(data),rightx(data), linwave
								linwave[] = pnt2x(linwave,p)*m+c
								if(strsearch(TraceNameList("",";",1),"linwave",0)==-1) //if leftwave is not on the graph
										appendtograph/W=$curwindow/C=(0,0,60000) linwave
										Modifygraph lsize(linwave)=4
								endif
								variable/g leftbound = leftx(data)
								variable/g rightbound=Rightx(data)
								wavestats/Q data
								variable dilate = V_max-linwave[0]
								
								make/o/n=5 coeff={m,c,dilate, pos,width} 
								Button FermiFitbutton disable = 0 //allow user to make fit
							else
								doalert 0, "Use cursors to estimate linear background"
							endif
			endif
	
	Setdatafolder $curfolder

End



Function SetBGPolycomps(ctrlName) : ButtonControl //this function sets thepoly bg components for the BG fitting
	String ctrlName

	string curfolder = getdatafolder(1) //get path to current folder
	string curwindow = winname(0,1)
	Removefromgraph/z linwave
	wave data = CsrWaveRef(A,"")
	string df = GetWavesDataFolder(data,1) //get data foder where waves are from
	Setdatafolder $df
	NVAR polyorder = root:Packages:FermiFitPanelglobs:FFpolyorderVAL
	variable m, c
	string fitfolder = nameofwave(data)+"_"+"FFit"
		if(datafolderexists(fitfolder)!=1) //if the FFfit folder is not htere, create it. 
			newdatafolder :$fitfolder
		endif
	Setdatafolder :$fitfolder	
			if(cmpstr(ctrlname,"LLin")==0) //left line fit button has been pressed
				
				
				
					if(polyorder!=2)
						Curvefit/N/Q/L=100 poly polyorder, data(min(hcsr(A),hcsr(B)), max(hcsr(A), hcsr(B))) /D 
					else
						Curvefit/N/Q/L=100 line, data(min(hcsr(A),hcsr(B)), max(hcsr(A), hcsr(B))) /D 
					endif
						
				wave/Z fit = $("fit_"+nameofwave(data))
				wave/z W_coef
				Removefromgraph/W=$curwindow/Z $nameofwave(fit), LFit
				Duplicate/O fit, LFit
				Appendtograph/W=$curwindow/C=(0,0,60000) LFit
				ModifyGraph lsize(LFit)=4
				make/o/n=(dimsize(W_coef,0)) Lcoef
				variable/g leftbound = min(hcsr(A),hcsr(B))
				Lcoef = W_coef
				killwaves/z W_coef,fit
				
			
			elseif(cmpstr(ctrlname,"RLin")==0)
				
				Controlinfo LinFitSel
					if(polyorder!=2)
						Curvefit/N/Q/L=100 poly polyorder, data(min(hcsr(A),hcsr(B)), max(hcsr(A), hcsr(B))) /D 
					else
						Curvefit/N/Q/L=100 line, data(min(hcsr(A),hcsr(B)), max(hcsr(A), hcsr(B))) /D 
					endif
					
				wave/Z fit = $("fit_"+nameofwave(data))
				wave/z W_coef
				Removefromgraph/W=$curwindow/Z $nameofwave(fit), RFit
				Duplicate/O fit, RFit
				Appendtograph/W=$curwindow/C=(0,60000,20000) RFit
				ModifyGraph lsize(RFit)=4
				make/o/n=(dimsize(W_coef,0)) Rcoef
				variable/g rightbound = max(hcsr(A),hcsr(B))
				Rcoef = W_coef
				killwaves/z W_coef,fit
			
			endif
			
		Setdatafolder $curfolder

End


Function CalcPointOfInflexionUsingSpline(ctrlName) : ButtonControl
	String ctrlName
	
	Controlinfo UsecsrChk
	nVAR startE = root:Packages:FermiFitPanelGlobs:CalcFEstartEVAL
	NVAr endE = root:Packages:FermiFitPanelGlobs:CalcFEendEVAL
	NVAR smth = root:Packages:FermiFitPanelGlobs:CalcFESplSmthVAL
	variable startEn, endEn,FermiEn
	Wave/z int =WaveRefIndexed("", 0, 3)	
	
	wave/z int_SS = $nameofwave(int)+"_SS"
	Removefromgraph/Z $nameofwave(int_SS)
	controlinfo usecsrscheck	
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
			
		Interpolate2/T=3/N=200/F=(smth) int
		
		Appendtograph int_SS
		Duplicate/O int_SS, fit
		Differentiate fit/D=fit
		FindPeak/N/R=(starten,enden) fit
				
		FermiEn = V_peakloc
		tag/k/n=FermiTag
		tag/Y=0/X=-35/N=fermiTag  $nameofwave(int)+"_SS",Fermien,"FE ="+"  "+num2str(FermiEn)+"eV"

End






