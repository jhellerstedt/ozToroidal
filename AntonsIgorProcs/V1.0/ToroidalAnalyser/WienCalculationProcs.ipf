#pragma rtGlobals=1		// Use modern global access method.

#include "AntonsGeneralRoutines"
#include "CrystalPanel"



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Function GenWienFEdata(ctrlName) : ButtonControl
	String ctrlName
	
	variable mode,i
	NVAR deltak =root:Packages:WienPanelGlobs:DeltakVAL
	NVAR deltaE =root:Packages:WienPanelGlobs:DeltaEVAL
	NVAR KE = root:Packages:WienPanelGlobs:AzScanKEVAL
	NVAR Vo = root:Packages:WienPanelGlobs:CrystalvoVAL
	NVAR size = root:Packages:WienPanelGlobs:ProjsizeVAL
	NVAR Eb = root:Packages:WienPanelGlobs:AzScanBindEnVAL
	SVAR curBSname = root:Packages:WienPanelGlobs:curbsname
	NVAR kmax = root:Packages:WienPanelGlobs:kmaxVAL
	NVAR smth = root:Packages:WienPanelGlobs:smthfactVAL
	
	controlinfo IncBroad //check whether to use a broadening model or not. 
	variable broad = V_value

	variable inband, nearband
	string curfolder = getdatafolder(1) //get path to current folder
	string bandfolder =  "root:Packages:Wien2kCalculations:"+curbsname
	Setdatafolder $bandfolder //get the path to the current BS file 

	string bandlist = WaveList("band*", ";", "DIMS:3" )	//build list of waves called band	
	wave Primvectors	 //get references to the Primvector and Fermi Energies
	NVAR FermiEn //get reference to the Fermi energy
	
	Setdatafolder $curfolder
	Controlinfo/W = CrystalPanel CrystalFace

		
	
	string procfolname = "WienCalc_FE"
	Newdatafolder/o/s :$procfolname	
	Make/O/N = (3,3) CoordsMatrix
	
	//Coordsmatrix = {{-1,1,4},{1,-3,2},{2,2,1}}  //421 surface
	//Coordsmatrix = {{1,1,-4},{-1,-3,-2},{-2,2,-1}}   //-4-2-1 surface
		
		if(stringmatch(S_value,"(100)"))
			
				Coordsmatrix = {{0,0,1},{1,0,0},{0,1,0}}   //421 face
		
		elseif(stringmatch(S_value,"(110)"))
				Coordsmatrix = {{-1,0,1},{1,0,1},{0,1,0}} //if 110 face is selected
		elseif(stringmatch(S_value,"(111)"))
				Coordsmatrix = {{-1,-1,1},{1,-1,1},{0,2,1}} //if (111) face is selected
		endif
			
	// now generate the FE cuts through the bands, using only those bands that intesect at the energy if ineterest
	
variable energy = Eb //the intial state being sampled

				for(i=0;i<ItemsInList(bandlist,";");i+=1) //run through all bands in the Wien Calculation
						
						string path = bandfolder+":"+StringFromList(i, bandlist)
						wave band = $path
						wavestats/Q band
						
							if(energy>=V_min&&energy<=V_max)
								inband=1
							else
								inband=0
							endif
						
							
							if(abs(V_min-energy)<2*deltaE||abs(V_max-energy)<2*deltaE) //ignore band more than 2 times the gaussian width away...the gaussian is too small
								nearband=1
							else
								nearband=0
							endif
												
								if(!broad) //just generating an energy/,omentum conservation based discrete map (ie FE intersection)
								
									wavestats/Q band
									
									if(energy>=V_min&&energy<=V_max) //if the binding energy of interest lies in the band block
											WienHemisphereproject(band,Primvectors, coordsmatrix,KE,Vo,size)
											wave/z XYProjection
											FindFermiLevel(XYprojection, Energy) //find the fermi level contour
											wave/z ProjectionY, ProjectionX
											Duplicate/o ProjectionY, $("ProjectionY"+num2str(i))
											Duplicate/o ProjectionX, $("ProjectionX"+num2str(i))
									endif
									
								else
								
									if(inband||nearband)
									
										GenBroadAzScan(band,Primvectors,coordsmatrix, KE,Vo,size,Eb,kmax,deltak,deltaE,smth)
										wave broadAzplot
										Duplicate/o broadazplot $("BroadAzPlot_"+num2str(i))
										killwaves/z broadazplot
									endif
										
								endif

						
					endfor
			
				string broadlist = WaveList("BroadAzPlot_*", ";", "DIMS:2" )
					if(itemsinlist(broadlist,";")>0)
						Duplicate/O $StringFromList(0, broadlist) array
						array = 0
							for(i=0;i<ItemsInList(broadlist,";");i+=1) 
								wave ref = $StringFromList(i, broadlist)
								array+=ref
							endfor
						Duplicate/O array BroadAzplot
						killwaves/z array
					endif
						
					killwaves/z ProjectionY, ProjectionX, PrimUnitCoords, cosmatrix,M_product, oldcoords, coords, W_Findlevels			
	
			variable/g Kenergy = KE
			variable/g InnerPot=Vo
			variable/g Ebinding = Eb
		
		Setdatafolder $curfolder
			
		
End


Function CalcWienPlanarConstEnSurf(ctrlName) : ButtonControl
	String ctrlName
	
	variable mode,i
	NVAR Vo = root:Packages:WienPanelGlobs:CrystalWFVAL
	NVAR size = root:Packages:WienPanelGlobs:ProjsizeVAL
	NVAR Eb = root:Packages:WienPanelGlobs:BindEnVAL
	NVAR kmax = root:Packages:WienPanelGlobs:kmaxVAL
	NVAR deltak = root:Packages:WienPanelGlobs:deltakVAL
	SVAR curBSname = root:Packages:WienPanelGlobs:curbsname
	controlinfo IncBroad
	variable broad = V_value
	string curfolder = getdatafolder(1), name=""
	
	string bandfolder =  "root:Packages:Wien2kCalculations:"+curbsname
	Setdatafolder $bandfolder //get the path to the current BS file 
	string bandlist = WaveList("band*", ";", "DIMS:3" )	//build list of waves called band	
	wave Primvectors	
	NVAR FermiEn
	
	Setdatafolder $curfolder
	
	controlinfo mode //create name fo the processed folder
		if(v_value==1) //planar cut mode
			controlinfo crystalface
			name+=S_value
			controlinfo Surfdirection
			name+=S_value
		else
			name = "Custom"
		endif
		
	string procfolname = "Wien_PlanarSlice"
	Newdatafolder/o/s :$procfolname	
	
				
			WPanelReadSurfCoordFromGlobals() //create the surcoords wave for planar plotting from the panel globals
			wave/z Surfcoordswave
			
				if(stringmatch(name,"Custom")) //if user is working with a custom direction
					Duplicate/O Surfcoordswave CustomDirection
				endif
				
			variable energy = -Eb

				for(i=0;i<ItemsInList(bandlist,";");i+=1)
						
						string path = bandfolder+":"+StringFromList(i, bandlist)
						wave band = $path
						wavestats/Q band
					
							if(energy>=V_min&&energy<=V_max) //if the binding energy of interest lies in the band block
							
										
									WienPlanarSlice(band,Primvectors,Surfcoordswave,kmax,size)
									wave XYProjection
									FindFermilevel(XYprojection,Energy)
									wave/z ProjectionY, ProjectionX
									Duplicate/o ProjectionY, $("ProjectionY"+num2str(i))
									Duplicate/o ProjectionX, $("ProjectionX"+num2str(i))	
							
							endif
						
				endfor
				killwaves/z ProjectionY, ProjectionX, PrimUnitCoords, cosmatrix,M_product, plane, coords, oldcoords		
				killwaves/z ccoef,Ccoeff,Normcoords,cosmatrix,m_product,coordsmatrix, W_findlevels, surfcoordswave
		
		variable/g BE = energy
		
		Setdatafolder $curfolder
	
End

Function GenNormEmissionEDCData1D(ctrlName) : ButtonControl
	String ctrlName
	
	
	NVAR deltak =root:Packages:WienPanelGlobs:DeltakVAL
	NVAR deltaE =root:Packages:WienPanelGlobs:DeltaEVAL
	NVAR Vo = root:Packages:WienPanelGlobs:CrystalVoVAL
	NVAR hv = root:Packages:WienPanelGlobs:NormEDCstarthvVAL
	NVAR BE_start = root:Packages:WienPanelGlobs:NormEDCstartBEVAL
	NVAR BE_end = root:Packages:WienPanelGlobs:NormEDCendBEVAL
	NVAR estep = root:Packages:WienPanelGlobs:NormedcBEstepVAL
	NVAR WF = root:Packages:WienPanelGlobs:CrystalWFVAL
	SVAR curBSname = root:Packages:WienPanelGlobs:curbsname
	NVAR smth = root:Packages:WienPanelGlobs:smthfactVAL
	 

	string curfolder = getdatafolder(1), name=""
	string bandfolder =  "root:Packages:Wien2kCalculations:"+curbsname
	Setdatafolder $bandfolder //get the path to the current BS file 
	string bandlist = WaveList("band*", ";", "DIMS:3" )	//build list of waves called band	
	Wave Primvectors	
	NVAR FermiEn
	variable i
	variable incs = round((BE_end-BE_start)/estep)
	
	Setdatafolder $curfolder
	string procfolname = "WienCalc_NE_EDC1D"
	Newdatafolder/o/s :$procfolname	
	Make/O/N = (3,3) CoordsMatrix
	Controlinfo/W = CrystalPanel CrystalFace
			

		if(stringmatch(S_value,"(100)"))  //this section uses the panel to determine the selected face.
				Coordsmatrix = {{0,0,1},{1,0,0},{0,1,0}}   //100 crystal face. 
		elseif(stringmatch(S_value,"(110)"))
				Coordsmatrix = {{-1,0,1},{1,0,1},{0,1,0}} //if 110 face is selected
		elseif(stringmatch(S_value,"(111)"))
				Coordsmatrix = {{-1,-1,1},{1,-1,1},{0,2,1}} //if (111) face is selected
		endif
		
		
			for(i=0;i<ItemsInList(bandlist,";");i+=1) //run through all bands in the Wien Calculation
					
						string path = bandfolder+":"+StringFromList(i, bandlist)
						wave band = $path
						wavestats/Q band //gte min and max values of the band
						variable BandBe_min = -V_max
						variable BandBE_max = -V_min
							
							if(BandBe_max<(Be_start+10*deltaE)||bandBe_min<(BE_end-10*deltaE)) //neglect bands which will not contribute at this sleected BE range.  
							
								GenBroadNormalEmissionEDC2(band,Primvectors,coordsmatrix, hv,Vo,BE_start,BE_end, WF, deltak,deltaE, smth, incs)
								wave EDC
								duplicate/o EDC, $("NEEDC"+"_"+nameofwave(band))
								killwaves EDC
								
								
							endif
			endfor
						
							
				string broadlist = WaveList("NEEDC_*", ";", "DIMS:1" )
					if(itemsinlist(broadlist,";")>0)
						Duplicate/O $StringFromList(0, broadlist) array
						array = 0
							for(i=0;i<ItemsInList(broadlist,";");i+=1) 
								wave ref = $StringFromList(i, broadlist)
								array+=ref
							endfor
						Duplicate/O array Broad_NE_EDC_1D
						killwaves/z array
					endif
					
					Plot1DFEFS(0, 6,200, 13, 4.35, hv)

	
	setdatafolder $curfolder

End

Function AddSimpleBackgroundToEDC(EDC,factor)
wave EDC
variable factor

variable i

duplicate/O EDC BG
variable BGtotal = 0

	for(i=0;i<numpnts(EDC);i+=1)
		BGtotal+= factor*EDC[i]
		BG[i] = BGtotal
	endfor

end
	

	


Function GenNormEmissionEDCData2D(ctrlName) : ButtonControl
	String ctrlName
	
	
	NVAR deltak =root:Packages:WienPanelGlobs:DeltakVAL
	NVAR deltaE =root:Packages:WienPanelGlobs:DeltaEVAL
	NVAR Vo = root:Packages:WienPanelGlobs:CrystalVoVAL
	NVAR hv_start = root:Packages:WienPanelGlobs:NormEDCstarthvVAL
	NVAR hv_end = root:Packages:WienPanelGlobs:NormEDCendhvVAL
	NVAR BE_start = root:Packages:WienPanelGlobs:NormEDCstartBEVAL
	NVAR BE_end = root:Packages:WienPanelGlobs:NormEDCendBEVAL
	NVAR estep = root:Packages:WienPanelGlobs:NormedcBEstepVAL
	NVAR kstep = root:Packages:WienPanelGlobs:NormedcKstepVAL
	NVAR WF = root:Packages:WienPanelGlobs:CrystalWFVAL
	SVAR curBSname = root:Packages:WienPanelGlobs:curbsname
	NVAR smth = root:Packages:WienPanelGlobs:smthfactVAL
	 
	controlinfo IncBroad //check whether to use a broadening model or not. 
	variable broad = V_value, i

	string curfolder = getdatafolder(1), name=""
	string bandfolder =  "root:Packages:Wien2kCalculations:"+curbsname
	Setdatafolder $bandfolder //get the path to the current BS file 
	string bandlist = WaveList("band*", ";", "DIMS:3" )	//build list of waves called band	
	Wave Primvectors	
	NVAR FermiEn
	
	Setdatafolder $curfolder
	string procfolname = "WienCalc_NE_EDC2D"
	Newdatafolder/o/s :$procfolname	
	
	Make/O/N = (3,3) CoordsMatrix
	Controlinfo/W = CrystalPanel CrystalFace
			

		if(stringmatch(S_value,"(100)"))  //this section uses the panel to determine the selected face.
				Coordsmatrix = {{0,0,1},{1,0,0},{0,1,0}}   //100 crystal face. 
		elseif(stringmatch(S_value,"(110)"))
				Coordsmatrix = {{-1,0,1},{1,0,1},{0,1,0}} //if 110 face is selected
		elseif(stringmatch(S_value,"(111)"))
				Coordsmatrix = {{-1,-1,1},{1,-1,1},{0,2,1}} //if (111) face is selected
		endif
		
		
			for(i=0;i<ItemsInList(bandlist,";");i+=1) //run through all bands in the Wien Calculation
					
						string path = bandfolder+":"+StringFromList(i, bandlist)
						wave band = $path
						wavestats/Q band //gte min and max values of the band
						variable BandBe_min = -V_max
						variable BandBE_max = -V_min
							
							if(BandBe_max<(Be_start+10*deltaE)||bandBe_min<(BE_end-10*deltaE)) //neglect bands which will not contribute at this sleected BE range.  
							
								GenBroadNormalEmissionEDC(band,Primvectors,coordsmatrix, hv_start,hv_end,Vo,BE_start,BE_end, WF, deltak,deltaE, smth, kstep, estep)
								wave kplot
								duplicate/o kplot, $("NEEDC"+"_"+nameofwave(band))
								killwaves kplot
								
							endif
			endfor
						
							
				string broadlist = WaveList("NEEDC_*", ";", "DIMS:2" )
					if(itemsinlist(broadlist,";")>0)
						Duplicate/O $StringFromList(0, broadlist) array
						array = 0
							for(i=0;i<ItemsInList(broadlist,";");i+=1) 
								wave ref = $StringFromList(i, broadlist)
								array+=ref
							endfor
						Duplicate/O array Broad_NE_EDC
						killwaves/z array
					endif
					

End



Function GenWienCISData(ctrlName) : ButtonControl //this function generates CIS data based on a chosen BE, KE range and or photon energy+work function rrange. Choises are eitjer simple cut through intial sytate, or broadening model of final and intial states
	String ctrlName
	
	variable mode,i,startKE,endKE
	NVAR Vo = root:Packages:WienPanelGlobs:CrystalVoVAL
	NVAR size = root:Packages:WienPanelGlobs:ProjsizeVAL
	NVAR Eb = root:Packages:WienPanelGlobs:BindEnVAL
	NVAR kmax = root:Packages:WienPanelGlobs:kmaxVAL
	NVAR deltak = root:Packages:WienPanelGlobs:deltakVAL
	NVAR deltaE = root:Packages:WienPanelGlobs:deltaEVAL
	NVAR startE = root:Packages:WienPanelGlobs:CISstartEVAL
	NVAR endE = root:Packages:WienPanelGlobs:CISendEVAL
	SVAR curBSname = root:Packages:WienPanelGlobs:curbsname
	NVAR WF = root:Packages:WienPanelGlobs:crystalWFVAL
	NVAR smth = root:Packages:WienPanelGlobs:smthfactVAL
	
	controlinfo IncBroad //check whether to use a broadening model or not. 
	variable broad = V_value
	variable inband, nearband
	string curfolder = getdatafolder(1), name=""
	
	string bandfolder =  "root:Packages:Wien2kCalculations:"+curbsname
	Setdatafolder $bandfolder //get the path to the current BS file 
	string bandlist = WaveList("band*", ";", "DIMS:3" )	//build list of waves called band	
	wave Primvectors	
	NVAR FermiEn
	
	Setdatafolder $curfolder
	string procfolname = "WienCalc_CIS"
	Newdatafolder/o/s :$procfolname	
				
	WPanelReadSurfCoordFromGlobals() //create the surcoords wave for planar plotting from the panel globals
	wave/z Surfcoordswave
	
	Make/o/n=3 Xaxis				///create a right handed coordinate system fro coordinate transforms
	Make/o/n=3 Yaxis
	Make/o/n=(3,3) Plane
	Make/o/n=(3,3) Normcoords
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}	
	Xaxis[] = SurfCoordswave[0][p]
	Yaxis[] = Surfcoordswave[1][p]
	Cross Xaxis, Yaxis 
	wave W_cross
	plane[0][] = SurfCoordswave[0][q]
	plane[1][] = SurfCoordswave[1][q]
	plane[2][] = W_cross[q] //generate the z axis which sticks out the plane defined by the surf corrd wave
	killwaves/z Xaxis,Yaxis,W_Cross, normcoords

	GenCosMatrix(Normcoords, plane) //generate the direction cosine conversion matrix
	wave/z cosmatrix
		
			
	Controlinfo CISmode //check what mode (KE or hv) the user is unsing
		if(V_value==1) //working with photon energies and work functions
			startKE = startE-WF-Eb
			endKE = endE-WF-Eb
		elseif(V_value==2) //working with kinetic energies
			startKE =startE
			endKE = endE
		endif
				
	variable energy = Eb //the intial state being sampled

				for(i=0;i<ItemsInList(bandlist,";");i+=1) //run through all bands in the Wien Calculation
						
						string path = bandfolder+":"+StringFromList(i, bandlist)
						wave band = $path
						wavestats/Q band
						
							if(energy>=V_min&&energy<=V_max)
								inband=1
							else
								inband=0
							endif
						
							
							if(abs(V_min-energy)<2*deltaE||abs(V_max-energy)<2*deltaE)
								nearband=1
							else
								nearband=0
							endif
								
						
								
								if(!broad) //just generating an energy/,omentum conservation based discrete map (ie FE intersection)
								
									wavestats/Q band
									
									if(energy>=V_min&&energy<=V_max) //if the binding energy of interest lies in the band block
										GenNormalCISplot(band,cosmatrix,Eb,startKE,endKE,Vo,size)
									endif
									
								else
								
									if(inband||nearband)
									GenBroadCISplot(band,Primvectors, cosmatrix,Eb,startKE,endKE,Vo,kmax,size,deltak,deltaE,smth)
										//GenBroadCISplot2(band,Primvectors,surfcoordswave,Eb,startKE,endKE,Vo,kmax,size, 0.2,smth)
										wave broadCISplot
										duplicate/o broadCISplot, $("BroadCIS"+"_"+nameofwave(band))
										killwaves BroadCISplot
									endif
									
									
																		
								endif
							
						
				endfor
				
				string broadlist = WaveList("BroadCIS_*", ";", "DIMS:2" )
					if(itemsinlist(broadlist,";")>0)
						Duplicate/O $StringFromList(0, broadlist) array
						array = 0
							for(i=0;i<ItemsInList(broadlist,";");i+=1) 
								wave ref = $StringFromList(i, broadlist)
								array+=ref
							endfor
						Duplicate/O array BroadCIS
						killwaves/z array
					endif
						
				
				killwaves/z ProjectionY, ProjectionX, PrimUnitCoords, cosmatrix,M_product, plane, coords, oldcoords
				killwaves/z ccoef,Ccoeff,Normcoords,cosmatrix,m_product,coordsmatrix, W_findlevels, surfcoordswave
				
				variable/g BE = Eb
				
		Setdatafolder $curfolder
	
End

Function GenWienEDCData(ctrlName) : ButtonControl //this function generates CIS data based on a chosen BE, KE range and or photon energy+work function rrange. Choises are eitjer simple cut through intial sytate, or broadening model of final and intial states
	String ctrlName
	
	variable mode,i
	NVAR Vo = root:Packages:WienPanelGlobs:CrystalWFVAL
	NVAR size = root:Packages:WienPanelGlobs:ProjsizeVAL
	NVAR Eb = root:Packages:WienPanelGlobs:BindEnVAL
	NVAR deltak = root:Packages:WienPanelGlobs:deltakVAL
	NVAR deltaE = root:Packages:WienPanelGlobs:deltaEVAL
	NVAR startKE = root:Packages:WienPanelGlobs:EDCstartKEVAL
	NVAR endKE = root:Packages:WienPanelGlobs:EDCendKEVAL
	NVAR startBE = root:Packages:WienPanelGlobs:EDCstartBEVAL
	NVAR endBE = root:Packages:WienPanelGlobs:EDCendBEVAL
	SVAR curBSname = root:Packages:WienPanelGlobs:curbsname
	NVAR WF = root:Packages:WienPanelGlobs:crystalWFVAL
	NVAR smthfact = root:Packages:WienPanelGlobs:smthfactVAL
	NVAR estep = root:Packages:WienPanelGlobs:EDCBEstepVAL
	NVAR kmax = root:Packages:WienPanelGlobs:kmaxVAL
	
	controlinfo IncBroad //check whether to use a broadening model or not. 
	variable broad = V_value
	string curfolder = getdatafolder(1), name=""
	
	string bandfolder =  "root:Packages:Wien2kCalculations:"+curbsname
	Setdatafolder $bandfolder //get the path to the current BS file 
	string bandlist = WaveList("band*", ";", "DIMS:3" )	//build list of waves called band	
	wave Primvectors	
	NVAR FermiEn
	
	Setdatafolder $curfolder
	
	string procfolname = "WienCalc_EDC"
	Newdatafolder/o/s :$procfolname	
		
	WPanelReadSurfCoordFromGlobals() //create the surcoords wave for planar plotting from the panel globals
	wave/z Surfcoordswave
	

				for(i=0;i<ItemsInList(bandlist,";");i+=1) //run through all bands in the Wien Calculation
						
						string path = bandfolder+":"+StringFromList(i, bandlist)
						wave band = $path
						wavestats/Q band
					
								if(!broad)
										
									GenEDCplot(band,Primvectors,surfcoordswave,startKE,endKE,startBE,endBE,Vo,size,smthfact)
									wave EDClociX, EDCLociY
									Duplicate/O EDClociX, $("EDCLociX_"+nameofwave(band))
									Duplicate/O EDClociY, $("EDCLociY_"+nameofwave(band))
					
								else
								
									GenBroadEDCplot(band,Primvectors,surfcoordswave,startBE,endBE,startKE,endKE,estep,Vo,size,kmax,deltak,deltaE)
									wave broadEDCplot
									duplicate/o broadEDCplot, $("BroadEDC"+num2str(i))
									killwaves BroadEDCplot
																		
								endif
							
						
				endfor
				
				killwaves/z ProjectionY, ProjectionX, PrimUnitCoords, cosmatrix,M_product, plane, coords, oldcoords		
				killwaves/z ccoef,Ccoeff,Normcoords,cosmatrix,m_product,coordsmatrix, W_findlevels, surfcoordswave
				
		
				
		Setdatafolder $curfolder
	
End


Function GenEDCplot(band,Primvectors,planematrix,startKE,endKE,startBE,endBE,Vo,size,smthfact)
wave band,Primvectors,planematrix
variable startKE,endKE,startBE,endBE,Vo,size,smthfact

	variable deltaE,i,j,BE,KE,r,x
	
	Make/o/n = 0 EDCLociX, EDClociY
	
	Make/o/n=(3,3) plane
	Make/o/n=3 Xaxis				///create a right handed coordinate system fro coordinate transforms
	Make/o/n=3 Yaxis
	Xaxis[] = planematrix[0][p]
	Yaxis[] = planematrix[1][p]
	Cross Xaxis, Yaxis 
	wave W_cross
	plane[0][] = planematrix[0][q]
	plane[1][] = planematrix[1][q]
	plane[2][] = W_cross[q]
	Make/o/n=(3,3) Normcoords
	Make/O/N = (3,3) CoordsMatrix
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}			
	GenCosMatrix(Normcoords, plane) //generate the direction cosine conversion matrix
	wave/z cosmatrix
	killwaves/z Xaxis,Yaxis,W_Cross, normcoords
	
	
	deltaE = (startBE-endBE)/(size-1)
	
		for(i=0;i<size;i+=1)
	
			BE = -(startBE-i*deltaE)
			KE = startKE+i*deltaE
			r = 0.511*sqrt(KE+Vo)
			GetFEProfileOfBand(KE,Vo,band,Primvectors,cosmatrix)
			wave FEProfile
			interpolate2/f=(smthfact)/t=3/j=0 FEProfile
			wave FEProfile_SS
			FindLevels/Q FEProfile_SS, BE //detect transitions at this BE
			wave W_findlevels
			
				if(V_flag==1) //if any crossing were found
					
					for(j=0;j<numpnts(W_findlevels);j+=1)
						x = r*cos(W_findlevels[j]) //get the k paraleel componenets of the transition
						insertpoints 0,1,EDCLociX,EDCLociY
						EDClociX[0] = x
						EDClociY[0] = -BE
					endfor
				endif
		endfor


End

Function WienHemisphereproject(band,Primvectors,coordsmatrix,Ek,Vo,s)
wave  band,Primvectors,coordsmatrix //teh se of calculatin gcoeffs for the fs..could be cu or Cu3AU
variable Ek,Vo,s // s is the size of the projected array, a is the lattice constant. ek the measured kinetic energy, Vo the inner potential

	Make/o/n=(3,3) Normcoords
	
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}	
	GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix
	wave/z cosmatrix
	killwaves/z normcoords
	
	variable r //the radius ofthe fre electron final state in inverse angstroms
	r = 0.511*sqrt(Ek+Vo) //calculate radius of free electron final state. 
	variable i,j,k,x,y,z, value

	make/O/N =(s+1,s+1) XYProjection
	Setscale/I x,-r,r, XYprojection
	Setscale/I y,-r,r, XYprojection

		
			for(i=0;i<(s+1);i+=1) 
				for(j=0;j<(s+1);j+=1)
		
					x = dimoffset(XYprojection,0)+i*dimdelta(XYprojection,0)
					y = dimoffset(XYprojection,1)+j*dimdelta(XYprojection,1)
			
						
							z = sqrt(r^2-(x^2+y^2))
					
		
					Transcoord(cosmatrix,x,y,z) //converrt point in the hemisphere frame to one in the normal fram
					wave/z M_Product
		
				if(z>=0.511*sqrt(Vo)) //if k point is higher than the photoemission "horizon"
					value = ReturnEatK(band, Primvectors, M_product)
				else 
					value = Nan
				endif

				XYprojection[i][j][k] = value //calculates the Calcres function at each point on the free electron final state sphere
		
				endfor
			endfor
		

			
end

Static Function FindFermiLevel(matrix,level) //this finds the zero value in the matrix ad creates two wave of the coordinates of the FS contour
wave matrix
variable level //the value to look for at the fermi level


Make/O/N =(0) ProjectionX , ProjectionY
Make/O/N =(dimsize(matrix,0)) onedrow
Setscale/P x,dimoffset(Xyprojection,0),dimdelta(Xyprojection,0), onedrow
variable i,j,k,num
//ratser across in x direction
for(j=0;j<=dimsize(matrix,2);j+=1)
	for(i=0;i<(dimsize(matrix,0));i+=1) //
		
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
//raster accross	
	for(i=0;i<(dimsize(matrix,0));i+=1) //
		
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

Function SetBSFile(ctrlName) : ButtonControl
	String ctrlName
	
	variable i
	SVAR curBSname = root:Packages:WienPanelglobs:CurBSname
	SVAR curBS = root:Packages:WienPanelglobs:CurBS
	string curfolder = getdatafolder(1)
	string dflist=""
	Setdatafolder root:Packages:Wien2kcalculations	
	
		for(i=0;i<CountObjects("", 4);i+=1) //list all currently loaded BS files
			dflist+=GetIndexedObjName("", 4, i)+";"
		endfor
		
	
	string destwienfol, destfol
		
		Prompt destwienfol, "WienFolder", popup, dflist
		Doprompt "Select Wien Results Folder", destwienfol

			If(V_flag==0)
				Setdatafolder :$destwienfol
				CurBSname  = getdatafolder(0)
				
			endif
			
		setdatafolder $curfolder

End

Macro WienPanel() : Panel


string curfolder = getdatafolder(1)

	Execute "CrystalPanel()" //ensure the crystal panel is loaded
	
	if(CheckName("Wienpanel", 9,"Wienpanel"))
		Dowindow/F Wienpanel
	else
		
			Newdatafolder/O/S root:Packages
			Newdatafolder/O/S root:Packages:WienPanelGlobs
			Newdatafolder/O root:Packages:Wien2kCalculations
			
			string/g CurBS, CurBSname
			variable/g AzScanKEVAL
			variable/g CrystalWFVAL
			variable/g CrystalVoVAL
			variable/g ProjsizeVAL
			variable/g DeltaKVAL
			variable/g deltaEVAL
			variable/g kmaxVAL
			variable/g FS3dnVAL
			variable/g FS3dsizeVAL
			variable/g CISBindEnVal=0
			variable/g AzScanBindENVAL
			variable/g crystalWFVAL
			
			variable/g SurfX1VAL, SurfX2VAL, SurfX3VAL
			variable/g SurfY1VAL, SurfY2VAL, SurfY3VAL
			variable/g kstartXVAL,kstartYVAL,kstartZVAL, kendXVAL,kendYVAL,kendZVAL
			variable/g smthfactVAL
			variable/g NormXVAL,NormYVAL,NormZVAL //the global variable for the crystal normal direction
			
			variable/g CISstartEVAL
			variable/g CISendEVAL
			variable/g EDCstartKEVAL
			variable/g EDCendKEVAL
			Variable/g EDCphotonEVAL
			variable/g EDCendBEVAL
			Variable/g EDCstartBEVAL
			variable/g EDCBEstepVAL
			

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(376,80,887,688)
	Dowindow/C WienPanel
	ModifyPanel cbRGB=(48896,65280,57344)
	SetDrawLayer UserBack
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 22,439,"CIS Calculation"
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 504,62,9,488
	DrawRRect 1,52,0,53
	DrawLine -1.7100704908371,0.483646303415298,-1.02600967884064,1.45105445384979
	DrawLine -1.7100704908371,0.483646303415298,-1.02600967884064,1.45105445384979
	DrawLine -1.7100704908371,0.483646303415298,-1.02600967884064,1.45105445384979
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 505,4,7,56
	SetDrawEnv fname= "Times New Roman",fsize= 16,fstyle= 1,textrgb= (65280,0,0)
	DrawText 15,37," File I/O"
	DrawLine 23,159,488,159
	DrawLine 24,372,488,372
	SetDrawEnv fname= "Times New Roman",fsize= 16,fstyle= 1,textrgb= (65280,0,0)
	DrawText 25,591,"Miscellaneous Cuts"
	DrawLine 23,211,483,211
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 17,93,"General Parameters"
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 21,193,"K Broad Parameters"
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 20,277,"AzScan Calculation"
	DrawLine 24,282,482,282
	SetDrawEnv fname= "Times New Roman",fsize= 14,fstyle= 1
	DrawText 22,364,"EDC Calculation"
	DrawLine 23,447,487,447
	SetDrawEnv fname= "Times New Roman",fsize= 16,fstyle= 1,textrgb= (65280,0,0)
	DrawText 21,474,"Free Electron Final State Calculation"
	SetDrawEnv linethick= 3,fillpat= 0
	DrawRRect 8,601,505,494
	SetVariable AzScanBE,pos={237,227},size={148,16},title="Binding Energy (eV)"
	SetVariable AzScanBE,value= root:Packages:WienPanelGlobs:AzScanBindEnVAL
	SetVariable Vo,pos={227,76},size={146,16},title="Inner Potential (eV)"
	SetVariable Vo,value= root:Packages:WienPanelGlobs:CrystalVoVAL
	SetVariable ProjSize,pos={392,75},size={92,16},title="Plot Incs"
	SetVariable ProjSize,limits={0,inf,50},value= root:Packages:WienPanelGlobs:ProjsizeVAL
	SetVariable kmax,pos={392,98},size={91,16},title="kmax"
	SetVariable kmax,value= root:Packages:WienPanelGlobs:kmaxVAL
	SetVariable DeltaK,pos={222,179},size={122,16},title="Final State dk"
	SetVariable DeltaK,limits={0,inf,0.01},value= root:Packages:WienPanelGlobs:DeltaKVAL
	SetVariable CISBindEn,pos={212,410},size={154,16},title=" Binding Energy (eV)"
	SetVariable CISBindEn,limits={-inf,inf,0.05},value= root:Packages:WienPanelGlobs:CISBindEnVal
	Button LoadWienButton,pos={111,18},size={75,20},proc=LoadWien2k,title="Load Wien2k"
	Button SelectBSbutton,pos={201,18},size={70,20},proc=SetBSFile,title="Set BS File"
	SetVariable CurBS,pos={282,17},size={213,16},disable=2,title="Current BS File"
	SetVariable CurBS,value= root:Packages:WienPanelGlobs:curbsname,bodyWidth= 139
	Button button3,pos={25,510},size={107,20},proc=Calculate1dBands,title="Calc Band Profile"
	Button FECutButton,pos={25,223},size={90,20},proc=GenWienFEdata,title="Calculate  FE Cut"
	Button Planarcutbutton,pos={24,545},size={110,19},proc=CalcWienPlanarConstEnSurf,title="Calculate Planar Cut"
	SetVariable Smth,pos={370,123},size={113,16},title="Spline Smth"
	SetVariable Smth,value= root:Packages:WienPanelGlobs:smthfactVAL
	SetVariable kstartX,pos={247,510},size={102,19},title=" kstart",fSize=14
	SetVariable kstartX,fStyle=0
	SetVariable kstartX,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:kstartXVAL
	SetVariable kstartY,pos={355,509},size={68,19},title=" ",fSize=14,fStyle=0
	SetVariable kstartY,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:kstartYVAL
	SetVariable kstartZ,pos={426,509},size={67,19},title=" "
	SetVariable kstartZ,labelBack=(52224,52224,52224),fSize=14,fStyle=0
	SetVariable kstartZ,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:kstartZVAL
	SetVariable kendX,pos={247,532},size={102,19},title=" kend",fSize=14,fStyle=0
	SetVariable kendX,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:kendXVAL
	SetVariable kendZ,pos={356,533},size={67,19},title=" ",fSize=14,fStyle=0
	SetVariable kendZ,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:kendYVAL
	SetVariable NormX6,pos={427,533},size={66,19},title=" ",fSize=14,fStyle=0
	SetVariable NormX6,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:kendZVAL
	CheckBox IncBroad,pos={262,124},size={101,14},title="Inc Kperp Broad?",value= 0
	SetVariable deltaE,pos={361,179},size={122,16},title="Intitial State dE"
	SetVariable deltaE,value= root:Packages:WienPanelGlobs:deltaEVAL
	Button button0,pos={24,384},size={86,21},proc=GenWienCISData,title="Calculate CIS"
	SetVariable CISstartE,pos={392,386},size={93,16},title="start KE"
	SetVariable CISstartE,value= root:Packages:WienPanelGlobs:CisstartEVAL
	SetVariable CISendE,pos={394,411},size={91,16},title="end KE"
	SetVariable CISendE,value= root:Packages:WienPanelGlobs:CISendEVAL
	PopupMenu plottingMode,pos={290,564},size={122,21},proc=ChangeBSPlotMode,title="Mode"
	PopupMenu plottingMode,mode=2,popvalue="From Plane",value= #"\"Abs Coords;From Plane\""
	CheckBox Usecsrchk,pos={425,564},size={66,14},title="Use Csrs?",value= 0
	Button button1,pos={24,304},size={63,19},proc=GenWienEDCData,title="Calc EDC"
	SetVariable CrystalWF,pos={257,98},size={116,16},title="Crystal Work F"
	SetVariable CrystalWF,value= root:Packages:WienPanelGlobs:crystalWFVAL
	SetVariable EDCPhotonE,pos={401,300},size={82,16},proc=EDCParamschanged,title="hf"
	SetVariable EDCPhotonE,value= root:Packages:WienPanelGlobs:EDCphotonEVAL
	PopupMenu CISmode,pos={198,384},size={167,21},proc=CISparammodechanged,title="ParamMode"
	PopupMenu CISmode,mode=2,popvalue="Kinetic Energy",value= #"\"Photon Energy;Kinetic Energy\""
	SetVariable EDCstartBE,pos={287,300},size={83,16},proc=EDCParamschanged,title="startBE"
	SetVariable EDCstartBE,value= root:Packages:WienPanelGlobs:EDCstartBEVAL
	SetVariable EDCendBE,pos={287,321},size={83,16},proc=EDCParamschanged,title="endBE"
	SetVariable EDCendBE,value= root:Packages:WienPanelGlobs:EDCendBEVAL
	SetVariable EDCstartKE,pos={193,301},size={83,16},disable=2,proc=EDCBEchanged,title="startKE"
	SetVariable EDCstartKE,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:EDCstartKEVAL
	SetVariable EDCendKE,pos={193,320},size={83,16},disable=2,title="endKE"
	SetVariable EDCendKE,limits={-inf,inf,0},value= root:Packages:WienPanelGlobs:EDCendKEVAL
	SetVariable edcBEstep,pos={380,321},size={102,16},title="step (eV)"
	SetVariable edcBEstep,value= root:Packages:WienPanelGlobs:EDCBEstepVAL
	SetVariable KE1,pos={394,227},size={88,16},title="KE (eV)"
	SetVariable KE1,value= root:Packages:WienPanelGlobs:AzScanKEVAL


	SetDatafolder $curfolder
	
	endif

End



Function WienPlanarSlice(band,Primvectors,planematrix,kmax,s)
variable kmax,s
wave planematrix, band, Primvectors

	Make/O/N = (s+1,s+1) XYprojection
	Setscale/I x,-kmax,kmax,XYprojection
	Setscale/I y,-kmax,kmax,XYprojection
	variable x,y,z,i,j,value

	Make/o/n=(3,3) plane
	Make/o/n=3 Xaxis				///create a right handed coordinate system fro coordinate transforms
	Make/o/n=3 Yaxis
	Xaxis[] = planematrix[0][p]
	Yaxis[] = planematrix[1][p]
	Cross Xaxis, Yaxis 
	wave W_cross
		
	plane[0][] = planematrix[0][q]
	plane[1][] = planematrix[1][q]
	plane[2][] = W_cross[q]
	killwaves/z Xaxis,Yaxis,W_Cross, normcoords
	Make/o/n=(3,3) Normcoords
	Make/O/N = (3,3) CoordsMatrix
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}			
	GenCosMatrix(Normcoords, plane) //generate the direction cosine conversion matrix
	wave/z cosmatrix
	
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
		
		
end	

	

Function ReturnEatK(band, Primvectors, k)
wave k, Primvectors, band

variable energy
		
		MapktoPrimUnit(k,PrimVectors)
		wave/z Primunitcoords
		
		energy = Antons3dinterpfix(band,PrimUNitcoords[0],Primunitcoords[1],Primunitcoords[2])
		//killwaves/z Primunitcoords

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
	variable i
	
	Primunitcoords[] = coords[p]-floor(coords[p])
			
	
End

Function CreateKwave(kstart,kend,num) //this function returns a wave of ktriplets extending from kstart to kend
wave kstart
wave kend
variable num

	make/o/n=(num,3) kwave
	kwave[][] = kstart[q]+p*(kend[q]-kstart[q])/(num-1)
	
End

Function Getlinearbandprofile(band,primvectors,kstart, kend,num) //this function returns a profile of the band form kstart to kend
wave band
wave primvectors
wave kstart
wave kend
variable num
	
	variable i

	CreateKwave(kstart,kend,num) //create a wave joining kstart to kend
	wave kwave

	make/o/n=(dimsize(kwave,0)) bandwave
	make/o/n=3 k
		for(i=0;i<dimsize(kwave,0);i+=1)
			k[] = kwave[i][p]
			bandwave[i]  = ReturnEatK(band, Primvectors, k)
		endfor
		
	//killwaves/z Primunitcoords, coords,kwave,k

end


	
	

Function GetArbitrarybandprofile(band,primvectors,points) //this function returns a profile of the band form kstart to kend
wave band
wave primvectors
wave points //array of points to sample in absolute k space

variable i	
make/o/n=3 k

	

	make/o/n=(dimsize(points,0)) bandwave
		for(i=0;i<dimsize(points,0);i+=1)
			k = points[i][p]
			bandwave[i]  = ReturnEatK(band, Primvectors,k)
		endfor
		
	killwaves/z Primunitcoords, coords,kwave,k

end


Function LoadBS()
	variable refnum
	variable err
	string buffer
	variable curpos
	
	string curfolder = getdatafolder(1)
	variable v1, v2,v3, v4, v5, v6, i,j,k,b, nbands,bandindex
	
	open/R/Z=2 refnum

	Err = V_Flag

	if (err == -1)
		return -1			// User cancelled.
	endif
	
	if (err != 0)
		return err
	endif
	
	Fstatus refnum
	
	Newdatafolder/O/S :$S_filename
	variable FermiEn
	Make/o/n = (3,3) PrimVectors
	
	Freadline/t = (num2char(10)) refnum, buffer //read the fermi energy
	sscanf buffer, "%f", FermiEn
	
	FermiEn   = 13.6*FermiEn
	
	for(j=0;j<3;j+=1) //read the primtive translation vectors// note that the vectors are written downwards!
		
		Freadline/t = (num2char(10)) refnum, buffer
		sscanf buffer,"%f %f %f", v1, v2, v3
		Primvectors[0][j] = v1
		Primvectors[1][j] = v2
		Primvectors[2][j] = v3
		
	endfor
	
	Primvectors[] = 2*pi*1.8904*Primvectors //convert bohr^-1 to A^-1, then scale lengths by 2pi since recip space
	Freadline/t = (num2char(10)) refnum, buffer //read the fermi energy
	sscanf buffer,"%f %f %f %f", v1, v2, v3, v4 //read how many bands are there, and how many k points sampled along each prim vector direction
	
	nbands = v1
	variable bandsizex = v2
	variable bandsizey = v3
	variable bandsizez = v4
	

	For(b=0;b<nbands;b+=1)
		Make/o/n=(bandsizex,bandsizey,bandsizez) band
		for(i=0;i<bandsizex;i+=1)
			for(j=0;j<bandsizey;j+=1)
				for(k=0;k<bandsizez;k+=1)
				
				Freadline/t = (num2char(10)) refnum, buffer
				sscanf buffer,"%f %f %f %f %f", v1, v2, v3, v4, v5 //read each abdn index, cooords, and energy
				band[i][j][k] = (v5*13.6)-FermiEn //insert the energy data into thecurrent band cube, converting to eV. 
		
				endfor
			endfor
		endfor
		
	Duplicate/o band tempband
	insertpoints bandsizex,1,band
	insertpoints/M=1 bandsizey,1,band
	insertpoints/M=2 bandsizez,1,band
	band[bandsizex][][] = tempband[0][q][r]
	band[][bandsizey][] = tempband[p][0][r]
	band[][][bandsizez] = tempband[p][q][0]
	Setscale/I x, 0,1, band
	Setscale/I y, 0,1, band
	Setscale/I z, 0,1, band
	
	string name = "band"+num2str(b)
	Duplicate/O band, $name
		
	endfor
	
	close refnum
	killwaves band, tempband
	
	Setdatafolder $curfolder
	
	
	
End

Function LoadBS2()
	variable refnum
	variable err
	string buffer
	variable curpos
	
	string curfolder = getdatafolder(1)
	variable v1, v2,v3, v4, v5, v6, i,j,k,b, nbands,bandindex
	
	open/R/Z=2 refnum

	Err = V_Flag

	if (err == -1)
		return -1			// User cancelled.
	endif
	
	if (err != 0)
		return err
	endif
	
	Fstatus refnum
	
	Newdatafolder/O/S :$S_filename
	variable FermiEn
	Make/o/n = (3,3) PrimVectors
	
	Freadline/t = (num2char(10)) refnum, buffer //read the fermi energy
	sscanf buffer, "%f", FermiEn
	
	FermiEn   = 13.6*2*FermiEn
	
	for(j=0;j<3;j+=1) //read the primtive translation vectors// note that the vectors are written downwards!
		
		Freadline/t = (num2char(10)) refnum, buffer
		sscanf buffer,"%f %f %f", v1, v2, v3
		Primvectors[0][j] = v1
		Primvectors[1][j] = v2
		Primvectors[2][j] = v3
		
	endfor
	
	Primvectors[] = 2*pi*1.8904*Primvectors //convert bohr^-1 to A^-1, then scale lengths by 2pi since recip space
	Freadline/t = (num2char(10)) refnum, buffer //read the fermi energy
	sscanf buffer,"%f %f %f %f", v1, v2, v3, v4 //read how many bands are there, and how many k points sampled along each prim vector direction
	
	nbands = v1
	variable bandsizex = v2
	variable bandsizey = v3
	variable bandsizez = v4
	

	For(b=0;b<nbands;b+=1)
	
		Make/o/n=(20,20,20) band
		
		for(i=0;i<bandsizex;i+=1)
			for(j=0;j<bandsizey;j+=1)
				for(k=0;k<bandsizez;k+=1)
				
				Freadline/t = (num2char(10)) refnum, buffer
				sscanf buffer,"%f %f %f %f %f", v1, v2, v3, v4, v5 //read each abdn index, cooords, and energy
				
				band[v2][v3][v4] = (v5*2*13.6)-FermiEn //insert the energy data into the current band cube, converting to eV. 
			

				endfor
			endfor
		endfor
		
	
	insertpoints/M=0 20,1,band
	insertpoints/M=1 20,1,band
	insertpoints/M=2 20,1,band
	
	insertpoints/M=0 0,1,band
	insertpoints/M=1 0,1,band
	insertpoints/M=2 0,1,band
	
	band[0][][] = band[20][q][r]
	band[21][][] = band[1][q][r]
	
	band[][0][] = band[p][20][r]
	band[][21][] = band[p][1][r]
	
	band[][][0] = band[p][q][20]
	band[][][21] = band[p][q][1]
	

	Setscale/I x,-0.5,19.5,band
	Setscale/I y,-0.5,19.5,band
	Setscale/I z,-0.5,19.5,band

	Make/o/n = (20,20,20) bandadj
	
	bandadj[][][] = Interp3d(band,p, q, r)
	

	Setscale/I x, 0,1, bandadj
	Setscale/I y, 0,1, bandadj
	Setscale/I z, 0,1, bandadj
	
	string name = "band"+num2str(b)
	Duplicate/O bandadj, $name
	killwaves band
	
	endfor
	
	close refnum
	killwaves/z band,bandadj,tempband	
	
	Setdatafolder $curfolder
	
	
	
End

Function LoadWien2k(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = getdatafolder(1)
	Setdatafolder root:Packages:Wien2kCalculations
		LoadBS()
	Setdatafolder $curfolder

End

Function Calculate1dBands(ctrlName) : ButtonControl
	String ctrlName
	
	string curfolder = getdatafolder(1)
	variable i
	SVAR curbsname = root:Packages:WIenPanelGlobs:curbsname //get ref to current file
	
	NVAR kstartx =  root:Packages:WIenPanelGlobs:kstartxVAL
	NVAR kstarty =  root:Packages:WIenPanelGlobs:kstartyVAL
	NVAR kstartz =  root:Packages:WIenPanelGlobs:kstartzVAL
	NVAR kendx =  root:Packages:WIenPanelGlobs:kendxVAL
	NVAR kendy =  root:Packages:WIenPanelGlobs:kendyVAL
	NVAR kendz =  root:Packages:WIenPanelGlobs:kendzVAL
	NVAR smthfact= root:Packages:WIenPanelGlobs:smthfactVAL
	
	string bandfolder = "root:Packages:Wien2kCalculations:"+curbsname
	Setdatafolder bandfolder
	string bandlist = WaveList("band*", ";", "DIMS:3" )	//build list of waves called band	
	variable PrimSize = dimsize($StringFromList(0, bandlist,";"),0)
	wave Primvectors	 //get references to the Primvector and Fermi Energies
	
	Setdatafolder $curfolder

	Controlinfo Usecsrchk //check whether the user is wanting to use csr positions from the ctive graph as the k values
	
		if(v_value)
			if(stringmatch(CsrWave(A),"")||stringmatch(csrwave(B),"")) //if either of the cursors is not on the graph
				Doalert 0, "Cursors must be on graph"
				return 0
			else
				kstartX = hcsr(A) ;kstartY = vcsr(A) ; kstartZ = 0
				kendX = hcsr(B) ; kendY = vcsr(B) ; kendZ = 0
			endif
		endif
		
	string bandfolname = "Wien_BandProfile"
	Newdatafolder/o/s  $bandfolname
	
	Make/o/n=3 kstart
	Make/o/n=3 kend
		
	Controlinfo PlottingMode
	
		if(V_value==2) //if using Planar mode
		
			WPanelReadSurfCoordFromGlobals() //read the current surfcoord wave (nned to have chosen this)
			wave/z Surfcoordswave
			Make/o/n= (3,3) Normcoords
			Normcoords = {{1,0,0},{0,1,0},{0,0,1}}
			GenCosMatrix(Normcoords, Surfcoordswave)
			TransCoord(Cosmatrix,kstartX,kstartY,0)
			wave M_Product
			kstart  = M_Product[p]
			TransCoord(Cosmatrix,kendX,kendY,0)
			kend  =M_Product[p]
			
		elseif(V_value==1) //using absolute coords
	
			kstart = {kstartx,kstarty,kstartz}
			kend = {kendx,kendy,kendz}
			
		endif
	
		variable linelength = sqrt((kend[0]-kstart[0])^2+(kend[1]-kstart[1])^2+(kend[2]-kstart[2])^2)
		variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
		variable num = round(2*linelength/primlength*Primsize)
		
		For(i=0;i<ItemsInList(bandlist,";");i+=1)
		
			string wavepath = bandfolder+":"+stringfromlist(i,bandlist,";")
			wave band =$wavepath
			GetlinearbandProfile(band,primvectors,kstart, kend,num)
			wave bandwave
			interpolate2/f=(smthfact)/t=3/j=0 bandwave
			wave bandwave_SS
			bandwave_ss = -bandwave_ss //this part inverts the ebergy scale such that occupied bands are positive binding energy, ne
			Setscale/I x,0,linelength,bandwave_SS
			Duplicate/O bandwave_SS, $("BandPlot_"+nameofwave(band))
			
		endfor
	
	killwaves/z kstart,kend,bandwave,bandwave_SS,oldcoords,cosmatrix,M_Product,k,kwave,Primunitcoords,coords,normcoords,surfcoordswave
	setdatafolder $curfolder
			
End

Function ChangeBSPlotMode(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	If(popnum==1) //absolute mode
		checkbox usecsrchk value=0
		checkbox UseCsrChk disable =2
	elseif(popnum==2) //lpanar mode
		checkbox UseCsrChk disable =0
		variable/g root:Packages:WienPanelGlobs:kstartZVAL=0
		variable/g root:Packages:WienPanelGlobs:kendZVAL =0
	endif
		

End



Function MakeKperpInPlot2(size,kmax,Glength,planematrix,energy,primvectors)
variable size,kmax,energy,Glength
	wave planematrix,primvectors
	
	string bandlist = WaveList("band*", ";", "DIMS:3")
	variable i
	Make/o/n=(size,size) FSProjTotal
	Setscale/I x,-kmax,kmax, FSProjTotal
	Setscale/I y,-kmax,kmax, FSProjTotal
	
	for(i=0;i<ItemsInList(bandlist, ";");i+=1)

		wave band =  $StringFromList(i, bandlist)
		
			 MakeKperpIntPlot(size,kmax,Glength,planematrix,energy,band,primvectors)
			 wave FSProj
			 FSProjTotal[][]+=FSProj[p][q]
			 
	endfor
	
End
	

Function MakeKperpIntPlot(size,kmax,Glength,planematrix,energy,band,primvectors)
	variable size,kmax,energy,Glength
	wave planematrix,primvectors,band
	
	Make/o/n=(3,3) Normcoords
	Make/O/N = (3,3) CoordsMatrix
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}			
	GenCosMatrix(Normcoords, planematrix) //generate the direction cosine conversion matrix
	wave cosmatrix
	
	Make/o/n=(size,size) FSProj
	Setscale/I x,-kmax,kmax, FSProj
	Setscale/I y,-kmax,kmax, FSProj
	variable i,j,k,val,total,x,y,z,grad
	make/o/n=3 kstart,kend
	
	variable Primsize = dimsize(band,0)
	variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
	variable num = 20//round(2*glength/primlength*Primsize)
	
	for(i=0;i<size;i+=1)
		x = dimoffset(FSProj,0)+i*dimdelta(FSProj,0)
		print x
			for(j=0;j<size;j+=1)
				y = dimoffset(FSProj,1)+j*dimdelta(FSProj,1)
					
					grad = 0
					TransCoord(Cosmatrix,x,y,0)
					wave M_product
					kstart = M_Product
					Transcoord(cosmatrix,x,y,glength)
					kend = M_Product
					GetlinearbandProfile(band,primvectors,kstart, kend,num)
					wave bandwave
					interpolate2/f=0/t=3/j=0 bandwave
					wave bandwave_SS

					FindLevels/Q bandwave_SS, energy
					wave w_findlevels
						if(V_Flag==1) //if one or more crossing of Ef are found
							
							Differentiate bandwave_SS/D=diffwave
							
								for(k=0;k<numpnts(W_findlevels);k+=1)
									grad+=1/(abs(diffwave(W_findlevels[k])))
								endfor
						endif
						
					FSProj[i][j] = grad	
			endfor
	endfor
							
							
							
End

Function GenBroadCISplot(band,Primvectors, cosmatrix,BE,startKE,endKE,Vo,kmax,s,wk,wE,smth)
wave band
wave cosmatrix, Primvectors
variable kmax,startKE,endKE,Vo,s,wk,wE,BE,smth

	variable startR = 0.511*sqrt(startKE+Vo) //calculate the radii of the free elestron final state (annulus)
	variable endR = 0.511*sqrt(endKE+Vo)
	variable horizon = 0.511*sqrt(Vo)
	variable i,j,x,y,k,total,yc,start,ende,l,LorEval,LorkVAL
	
	variable ysize = round(s*(kmax-horizon)/(2*kmax))
	Make/o/n=3 kstart, kend
	Make/o/n = (s,ysize) BroadCISPlot=0
	setscale/I x,-kmax, kmax, BroadCISplot
	setscale/I y, horizon,kmax,BroadCISplot
	
	variable Primsize = dimsize(band,0)
	variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
	variable num = round(2*((kmax-horizon)+40*wk)/primlength*Primsize) //create an appropropriate number if interpolation points to avoid interpolation noise

	variable lordim = 1000
	make/o/n=(lordim) Lorentzian
	Setscale/I x,-20*wk, 20*wk, Lorentzian
	lorentzian[] = ((wk/2)/((pnt2x(lorentzian,p)-0)^2+(wk/2)^2))*1/pi 
	
	make/o/n=(lordim) Product

	for(i=0;i<s;i+=1)
	
		x = dimoffset(broadcisplot,0)+i*dimdelta(broadcisplot,0)
		TransCoord(Cosmatrix,x,horizon-20*wk,0)
				wave M_product
				kstart = M_Product
				Transcoord(cosmatrix,x,kmax+20*wk,0)
				kend = M_Product
				GetlinearbandProfile(band,primvectors,kstart, kend,num) //get a profile of the band along kperp ,centred at the point of interest and with width 10 times the lorenztian widfth to allow for the tail to die off sifficiently either side
				wave bandwave
				interpolate2/f=(smth)/t=3/j=0/n=(num) bandwave
				wave bandwave_SS
				Setscale/I x,horizon-20*wk,kmax+20*wk,bandwave_ss
				Setscale/I x,horizon-20*wk,kmax+20*wk,bandwave
				
		
				
				for(j=0;j<s/2;j+=1)
				
				y = dimoffset(broadcisplot,1)+j*dimdelta(broadcisplot,1)
				Setscale/I x,y-20*wk,y+20*wk, Lorentzian
				
				
			
	
						if(sqrt(x^2+y^2)<endR&&sqrt(x^2+y^2)>startR) //point lies within free electron annulus  and is greater in kperp than horizon
						
						
						product[] = Lorentzian[p]*(Gauss(bandwave_SS(pnt2x(lorentzian,p)),BE,wE/2)/(exp(BE-bandwave_SS(pnt2x(lorentzian,p)))/0.026+1))
						Integrate product/D=product_INT
						total = product_Int[lordim-1]/lordim
					
						else
							total = Nan
						endif
						
						BroadCISplot[i][j] = total			
				endfor
		endfor
	
	
end	

Function GenBroadCISplot2(band,Primvectors,planematrix,BE,startKE,endKE,Vo,kmax,s,res,smth)
wave band
wave Primvectors
wave planematrix
variable kmax,startKE,endKE,Vo,s,res,BE,smth

	variable startR = 0.511*sqrt(startKE+Vo) //calculate the radii of the free elestron final state (annulus)
	variable endR = 0.511*sqrt(endKE+Vo)
	variable horizon = 0.511*sqrt(Vo)
	variable i,j,x,y,k,total,yc,start,ende,l,LorEval,LorkVAL, num
	
	variable ysize = round(s*(kmax-horizon)/(2*kmax))
	Make/o/n=3 kstart, kend
	Make/o/n = (s,ysize) BroadCISPlot=0
	setscale/I x,-kmax, kmax, BroadCISplot
	setscale/I y, horizon,kmax,BroadCISplot
	
	Make/o/n=(3,3) plane
	Make/o/n=3 Xaxis				///create a right handed coordinate system fro coordinate transforms
	Make/o/n=3 Yaxis
	Xaxis[] = planematrix[0][p]
	Yaxis[] = planematrix[1][p]
	Cross Xaxis, Yaxis 
	wave W_cross
	variable maxkwidth = 	 (1/(0.13056*horizon))*0.065*(endKE+4.9)
	
	variable Primsize = dimsize(band,0)
	variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
	
	variable Ekin
	variable wE, width, area1, wK

		
	plane[0][] = planematrix[0][q]
	plane[1][] = planematrix[1][q]
	plane[2][] = W_cross[q]
	killwaves/z Xaxis,Yaxis,W_Cross, normcoords
	Make/o/n=(3,3) Normcoords
	Make/O/N = (3,3) CoordsMatrix
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}			
	GenCosMatrix(Normcoords, plane) //generate the direction cosine conversion matrix
	wave/z cosmatrix
	variable lordim = 501
	variable gaussdim = 501
	make/o/n=(lordim) Ak, Ah, product
	make/o/n=(Gaussdim) Elor
	make/o/n=(gaussdim) Gaussian
	
	make/o/n=(lordim) Product
	
	

	variable wkmax = (0.13056/horizon)*0.065*(endKE+4.9) //gen max kperp broadval
	
	num = round(2*((kmax-horizon)+40*wkmax)/primlength*Primsize) //create an appropropriate number if interpolation points to avoid interpolation noise

	

	for(i=0;i<s;i+=1)
	
		x = dimoffset(broadcisplot,0)+i*dimdelta(broadcisplot,0)
		
				TransCoord(Cosmatrix,x,horizon-20*wkmax,0) //need comments!!!!
				wave M_product
				kstart = M_Product
				Transcoord(cosmatrix,x,kmax+20*wkmax,0)
				kend = M_Product
				GetlinearbandProfile(band,primvectors,kstart, kend,num) //get a profile of the band along kperp ,centred at the point of interest and with width 10 times the lorenztian widfth to allow for the tail to die off sifficiently either side
				wave bandwave
				interpolate2/f=(smth)/t=3/j=0/n=(num) bandwave
				wave bandwave_SS
				Setscale/I x,horizon-20*wkmax,kmax+20*wkmax,bandwave_ss
				Setscale/I x,horizon-20*wkmax,kmax+20*wkmax,bandwave
		
				
				
				for(j=0;j<s/2;j+=1)
				
					y = dimoffset(broadcisplot,1)+j*dimdelta(broadcisplot,1)
					
				
						if(sqrt(x^2+y^2)<endR&&sqrt(x^2+y^2)>startR) //point lies within free electron annulus  and is greater in kperp than horizon
							
							
							Ekin = 3.829*(x^2+y^2)-Vo
				
							wk = (0.13056/y)*0.065*(Ekin+4.9)
							
							Setscale/I x,-20*wkmax, 20*wkmax, Ak //rescale the lorenztian wave 
							Ak[] = ((wk/2)/((pnt2x(Ak,p)-0)^2+(wk/2)^2))*1/pi  //generate the lorentizian wave
							Setscale/I x,y-20*wkmax, y+20*wkmax, Ak
					
						
							for(k=0;k<numpnts(Ak);k+=1)
								
								wE = 0.012*(bandwave_SS(pnt2x(Ak,k))-BE)^2+0.04		///from Matzdorf 1998 article p168
								width = wE+res
								Setscale/I x, -20*width, 20*width, Elor
								Setscale/I x,-20*width, 20*width, Gaussian
								
								Elor[] =((wE/2)/((pnt2x(Elor,p)-0)^2+(wE/2)^2))*1/pi  		//calc the lorentzian
								Gaussian[] = Gauss(pnt2x(Gaussian,p),0,res)
								
								convolve/A Gaussian, Elor //convolute the gaussian resolution function with the lorentzian
								area1 = area(Elor)
								Elor/=area1 //normalise the convoluted lorentzian
							
								Setscale/I x,bandwave_SS(pnt2x(Ak,k))-20*width,bandwave_SS(pnt2x(Ak,k))+20*width, Elor 
								
								Ah[k] =  Elor(BE)/(exp(0-bandwave_SS(pnt2x(Ak,k)))/0.026+1) //calc val of convoluted lorentzian modulated by the Fermi Function
							
							endfor
						
						product[] =Ak[p]*Ah[p]
						Integrate product/D=product_INT
						total = product_Int[lordim-1]/lordim
							
					
						else
							total = Nan
						endif
						
						BroadCISplot[i][j] = total			
				endfor
		endfor
	
	
end	


Function GenBroadEDCplot(band,Primvectors,planematrix,startBE,endBE,startKE,endKE,estep,Vo,s,kmax,wk,wE)
wave band
wave Primvectors
wave planematrix
variable startKE,endKE,Vo,s,wk,wE,startBE,endBE,kmax,estep

	variable i,j,kpara,kperp,KE,BE,k,total,yc,start,ende,l,LorEval,LorkVAL,kparamax
	Make/o/n=3 kstart, kend
	variable BEsteps = round((endKE-startKE)/estep)+1
	Make/o/n = (s,BEsteps) BroadEDCPlot=0

	setscale/I x,-kmax, kmax, BroadEDCplot
	setscale/I y, startBE,endBE,BroadEDCplot

	Make/o/n=(3,3) plane
	Make/o/n=3 Xaxis				///create a right handed coordinate system from coordinate transforms
	Make/o/n=3 Yaxis
	Xaxis[] = planematrix[0][p]
	Yaxis[] = planematrix[1][p]
	Cross Xaxis, Yaxis 
	wave W_cross
	
	variable Primsize = dimsize(band,0)
	variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
	variable num = round(2*(2*kmax+40*wk)/primlength*Primsize) //create an appropropriate number if interpolation points to avoid interpolation noise
		
	plane[0][] = planematrix[0][q]
	plane[1][] = planematrix[1][q]
	plane[2][] = W_cross[q]
	killwaves/z Xaxis,Yaxis,W_Cross, normcoords
	Make/o/n=(3,3) Normcoords
	Make/O/N = (3,3) CoordsMatrix
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}			
	GenCosMatrix(Normcoords, plane) //generate the direction cosine conversion matrix
	wave/z cosmatrix

	for(j=0;j<BEsteps;j+=1) //run through the rows of the broadened EDC plot
	
				BE = dimoffset(broadEDCplot,1)+j*dimdelta(BroadEDCplot,1)
				KE = (BE-startBE)/(endBE-startBE)*(endKE-startKE)+startKE
				kparamax = 0.511*sqrt(KE)
		
			for(i=0;i<s;i+=1)
			
				kpara = dimoffset(BroadEDCplot,0)+i*dimdelta(BroadEDCplot,0)
				kperp  = sqrt(0.261*(KE+Vo)-kpara^2)
				total =0
				
				if(!(abs(kpara)>kparamax))
					
					TransCoord(Cosmatrix,kpara,kperp-20*wk,0)
					wave M_product
					kstart = M_Product
					Transcoord(cosmatrix,kpara,kperp+20*wk,0)
					kend = M_Product
					GetlinearbandProfile(band,primvectors,kstart, kend,num) //get a profile of the band along kperp ,centred at the point of interest and with width 10 times the lorenztian widfth to allow for the tail to die off sifficiently either side
					wave bandwave
					interpolate2/f=0.05/t=3/j=0/N=500 bandwave
					wave bandwave_SS
					bandwave_SS[] = -bandwave_SS[p]
					Setscale/I x,kperp-20*wk,kperp+20*wk,bandwave_ss
							 
						for(l=0;l<numpnts(bandwave_SS);l+=1)
								
								if(bandwave_SS[l]<(-0.5*wE))
									LorEval = 0 //negating those tails of the energy centred lorenztians that fall above the Fermi Level
								else
									LorEVAL = Gauss(bandwave_SS[l],BE,wE/2)
								endif
							
								LorKVAL = ((wk/2)/((pnt2x(bandwave_SS,l)-kperp)^2+(wk/2)^2))*1/pi 
								total+=(lorEval*lorkVAL)
								
						endfor			
				else	
					total = NaN		
				endif
						
					BroadEDCplot[i][j] = total			
			endfor
	endfor
	
end	



Function GetFEProfileOfBand(KE,Vo,band,Primvectors,cosmatrix)
wave band,Primvectors,cosmatrix
variable KE,Vo

variable length, num,primsize,Primlength,theta1,theta2,r,thetadec,i,theta,x,y


			theta1 = atan(sqrt(Vo/KE))
			theta2 = pi-theta1
			r = 0.511*sqrt(KE+Vo) //get radiua of FEFS
			Primsize = dimsize(band,0)
			PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
			length = 0.511*sqrt(KE+Vo)*(pi-2*theta1) //get length of arc of FEFS
			num = round(((2*length)/primlength*Primsize)) //get an appropriate number of points to avoid interpolation noise
			thetadec = (theta2-theta1)/(num-1)
			Make/o/n=(num,3) CircCoords //create an array to put the coordinates of the free electron  radisu into
	
				for(i=0;i<num;i+=1)
					theta = theta1+i*thetadec
					x = r*cos(theta)
					y = r*sin(theta)
					CircCoords[i][0] = x
					CircCoords[i][1] = y
					CircCoords[i][2] = 0
				endfor
	
			TransformCoordArray(Cosmatrix,Circcoords)
			wave transcoordarray
			GetArbitrarybandprofile(band,primvectors,transcoordarray)
			wave bandwave
			Setscale/I x,theta1,theta2,bandwave
			Duplicate/O bandwave FEProfile
			killwaves/z bandwave
			
End


Function GenNormalCISplot(band,cosmatrix,BE,startKE,endKE,Vo,size) //this function will generate a CIs plot from a given BE based on given KE range and inner potential. Just the loci are calculated
wave band
wave Cosmatrix
variable startKE,endKE,Vo,BE,size

	variable i,j,x,y,k,total,yc,startR,endR,l,KE,deltaKE,r,kmax
	startR = 0.511*sqrt(startKE+Vo)
	endR = 0.511*sqrt(endKE+Vo)
	variable horizon = 0.511*sqrt(Vo)
	
	Make/o/n=3 kstart, kend
	Make/o/n=(3,3) plane
	Make/o/n=0 CISlociX, CISLociY
	
	kmax = endR+0.5 //get radius of FEFS,add 0.5 for good measure
	WienPlanarSlice(band,Primvectors,planematrix,kmax,size)
	wave XYProjection
	FindFermilevel(XYprojection,BE)
	wave/z ProjectionY, ProjectionX
	
		for(i=0;i<numpnts(ProjectionY);i+=1)
			
			x = ProjectionX[i]
			y = ProjectionY[i]
			r = sqrt(x^2+y^2)
			
				if(r>=startR&&r<=endR&&y>=horizon)
					
					insertpoints 0,1,CISlociX,CISlociY
					CISlociX[0] = x
					CISlociY[0] = y
					
				endif
		endfor
	
	killwaves/Z ProjectionX,ProjectionY,XYProjection
	
end	

Function MaskBroadCisplot(plot,KEstart,KEend,Vo) //this function restricts a CIS calculation to only that region covered  by a CIS scan
wave plot
variable KEstart, KEend,Vo

variable i,j,k
variable radius,startR,endR,x,y,dist

startR = 0.511*sqrt(KEstart+Vo)
endR = 0.511*sqrt(KEend+Vo)
variable horizon = 0.511*sqrt(vo)
variable size = dimsize(plot,0)

	for(i=0;i<size;i+=1)
		x = dimoffset(plot,0)+i*dimdelta(plot,0)
		for(j=0;j<size;j+=1)
			y = dimoffset(plot,1)+j*dimdelta(plot,1)
				
				dist = sqrt(x^2+y^2)
					
					if(y<horizon)
						plot[i][j] = Nan
					elseif(dist>endR||dist<startR)
						plot[i][j]=Nan
					endif
		endfor
	endfor
end



Function GenBroadAzScan(band,Primvectors,coordsmatrix, Ek,Vo,s,BE,kmax,wk,wE, smth)
wave  band,Primvectors,coordsmatrix
variable Ek,Vo,s,wk,wE,kmax,BE, smth // s is the size of the projected array, a is the lattice constant. ek the measured kinetic energy, 


	Make/o/n=(3,3) Normcoords
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}	
	make/o/n=3 kstart,kend
	GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix
	wave/z cosmatrix
	killwaves/z normcoords

	variable r,total,i,j,k,z,x,y,l,lorEval,lorkVAL//the radius ofthe fre electron final state in inverse angstroms
	variable Primsize = dimsize(band,0)
	variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
	variable num = round(2*40*wk/primlength*Primsize)
	
		r = 0.511*sqrt(Ek+Vo) //calculate radius of free electron final state. 
		variable horizon = 0.511*sqrt(Vo)

	Make/o/n=(s,s) BroadAzPlot
	Setscale/I x,-kmax,kmax, BroadAzplot
	Setscale/I y,-kmax,kmax, Broadazplot
	
		

	
	wave/z cosmatrix
	variable lordim = 501
	make/o/n=(lordim) Lorentzian, Product
	Setscale/I x,-20*wk, 20*wk, Lorentzian
	lorentzian[] = ((wk/2)/((pnt2x(lorentzian,p)-0)^2+(wk/2)^2))*1/pi 
	
	for(i=0;i<s;i+=1) 
				
				x = dimoffset(Broadazplot,0)+i*dimdelta(broadazplot,0)
				
				for(j=0;j<s;j+=1)
	
					y = dimoffset(broadazplot,1)+j*dimdelta(broadazplot,1)
					z = sqrt(r^2-(x^2+y^2))
				
					total = 0
	
					if(z>=horizon) 							 //if k point is higher than the photoemission "horizon"
					
								
						Transcoord(cosmatrix,x,y,z-20*wk) //converrt point in the hemisphere frame to one in the normal fram
						wave/z M_Product
						kstart = M_product
						Transcoord(cosmatrix,x,y,z+20*wk) 
						kend[]  =M_Product
						GetlinearbandProfile(band,primvectors,kstart, kend,num) //get profile of the band along kperp line centres at kerp  = z
						wave bandwave
						interpolate2/f=(smth)/t=3/j=0 bandwave
						wave bandwave_SS
					
						Setscale/I x,z-20*wk,z+20*wk,bandwave_SS, bandwave ,Lorentzian
					
						
						product[] = Lorentzian[p]*(Gauss(bandwave_SS(pnt2x(lorentzian,p)),BE,wE/2)/(exp(BE-bandwave_SS(pnt2x(lorentzian,p)))/0.026+1))
						Integrate product/D=product_INT
						total = product_Int[lordim-1]/lordim
					
					else
						total = Nan
					endif
						
					BroadAzplot[i][j] = total		
						
					
						
				endfor
				
	endfor
	
End

Function GenBroadNormalEmissionEDC2(band,Primvectors,coordsmatrix, hv,Vo,BE_start,BE_end, WF, wk,wE, smth, incs)  //this function  generates a single hv EDC for broanded transitions from a single band using the FEFS
wave  band,Primvectors,coordsmatrix
variable hv,Vo,BE_start,BE_end, WF, wk,wE, smth, incs

	Make/o/n=(3,3) Normcoords
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}	
	make/o/n=3 kstart,kend
	GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix for coordinate conversion from 
	wave/z cosmatrix
	killwaves/z normcoords
	
	make/o/n=(incs) EDC
	Setscale/I x, BE_start, BE_end, EDC
	
	variable r,total,i,j,k,z,x,y,l//the radius ofthe fre electron final state in inverse angstroms
	variable Primsize = dimsize(band,0)
	variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
	variable num = round(2*40*wk/primlength*Primsize)
	variable Ek_max = hv-WF-BE_start
	variable Ek_min = hv - WF-BE_end
	variable k_min = sqrt(0.26*(Ek_min+Vo))
	variable k_max = sqrt(0.26*(Ek_max+Vo))
	variable BE, KE, k_perp
	
	
	variable lordim = 1000 //generate the Lorentzian function which represents the final state spectral function. 
	make/o/n=(lordim) Lorentzian, Product
	Setscale/I x,-20*wk, 20*wk, Lorentzian
	lorentzian[] = ((wk/2)/((pnt2x(lorentzian,p)-0)^2+(wk/2)^2))*1/pi //populate the lorentzian function 
	
	TransCoord(Cosmatrix,0,k_min-20*wk,0) //this function obtains the band profile along kperp for a suitable k range
	wave M_product
	kstart = M_Product
	Transcoord(cosmatrix,0,k_max+20*wk,0)
	kend = M_Product
	GetlinearbandProfile(band,primvectors,kstart, kend,num) //get a profile of the band from 
	wave bandwave
	interpolate2/f=0.05/t=3/j=0/N=500 bandwave
	wave bandwave_SS
	bandwave_SS[] = -bandwave_SS[p]
	Setscale/I x,k_min-20*wk,k_max+20*wk,bandwave_ss
	
	for(i=0;i<incs;i+=1)
		
		BE = leftx(EDC)+i*deltax(EDC) //the current binding energy
		KE = hv - BE-Wf //the kinetic energy
		k_perp = sqrt(0.26*(KE+Vo)) //the value of the FEFS k
		Setscale/I x,k_perp-20*wk,k_perp+20*wk,Lorentzian //scale the lorenztian function. 
		
		product[] = Lorentzian[p]*(Gauss(bandwave_SS(pnt2x(lorentzian,p)),BE,wE/2))/(exp((-1*BE)/0.026)+1)
		Integrate product/D=product_INT
		total = product_Int[lordim-1]/lordim
		EDC[i] = total
		
	endfor
					

end

Function Plot1DFEFS(kstart, kend,incs, Vo, WF, hv)
variable kstart, kend,incs, Vo, WF, hv

	make/o/n = (incs) FEFS_1d, FEFS_1d_hv
	setscale/I x, kstart, kend, FEFS_1d, FEFS_1d_hv
	FEFS_1d[] = -(3.829*(pnt2x(FEFS_1d, p))^2-Vo+Wf)
	FEFS_1d_hv = FEFS_1d+hv
	
end

Function GenBroadNormalEmissionEDC(band,Primvectors,coordsmatrix, hv_start,hv_end,Vo,BE_start,BE_end, WF, wk,wE, smth, kstep, estep) //this is a simple function which assuems a fixed delta k and delta E. It takes an input the wien output from S Holmolya 2004
wave  band,Primvectors,coordsmatrix
variable hv_start,hv_end,Vo,BE_start,BE_end, WF, wk,wE, smth, kstep, estep // s is the size of the projected array, a is the lattice constant. ek the measured kinetic energy, 

	//currently this function uses a fixed energy and momentum broadening wE and wk. Future upgrades may input a variable for these./ 
	Make/o/n=(3,3) Normcoords
	Normcoords = {{1,0,0},{0,1,0},{0,0,1}}	
	make/o/n=3 kstart,kend
	GenCosMatrix(Normcoords, Coordsmatrix) //generate the direction cosine conversion matrix for coordinate conversion from 
	wave/z cosmatrix
	killwaves/z normcoords

	variable r,total,i,j,k,z,x,y,l//the radius ofthe fre electron final state in inverse angstroms
	variable Primsize = dimsize(band,0)
	variable PrimLength = sqrt(Primvectors[0][0]^2+Primvectors[1][0]^2+Primvectors[2][0]^2)
	variable num = round(2*40*wk/primlength*Primsize)
	variable E_binding, Ek_min, Ek_max, kmin, kmax, k_perp
	
	variable Glob_Ek_max = hv_end-WF-BE_start
	variable Glob_Ek_min = hv_start -WF-BE_end
	variable Glob_k_min = sqrt(0.26*(Glob_Ek_min+Vo))
	variable Glob_k_max = sqrt(0.26*(Glob_Ek_max+Vo))
	
	TransCoord(Cosmatrix,0,Glob_k_min-20*wk,0) //this function obtains the band profile along kperp for a suitable k range before Glob k min and after Glob k max
	wave M_product
	kstart = M_Product
	Transcoord(cosmatrix,0,Glob_k_max+20*wk,0)
	kend = M_Product
	GetlinearbandProfile(band,primvectors,kstart, kend,num) //get a profile of the band from 
	wave bandwave
	interpolate2/f=0.05/t=3/j=0/N=500 bandwave
	wave bandwave_SS
	bandwave_SS[] = -bandwave_SS[p]
	Setscale/I x,Glob_k_min-20*wk,Glob_k_max+20*wk,bandwave_ss
	
	variable lordim = 1000
	make/o/n=(lordim) Lorentzian, Product
	Setscale/I x,-20*wk, 20*wk, Lorentzian
	lorentzian[] = ((wk/2)/((pnt2x(lorentzian,p)-0)^2+(wk/2)^2))*1/pi 
	
	variable ksize = round(((Glob_k_max)-(Glob_k_min))/kstep)
	variable esize = abs(round((BE_start-BE_end)/estep))
	Make/o/n=(ksize, esize) kplot
	Setscale/I x, Glob_k_min, Glob_k_max, kplot
	Setscale/I y, BE_start, Be_end, kplot
	

	for(i=0;i<Esize;i+=1)
		
		E_binding = dimoffset(kplot,1)+i*dimdelta(kplot,1)
		//print E_binding
		Ek_min = hv_start-WF-E_binding  //calculate the min and max range of k swept by the FEFS at this binding energy
		Ek_max = hv_end-WF-E_binding
		kmin = sqrt(0.26*(Ek_min+Vo))
		kmax = sqrt(0.26*(Ek_max+Vo))
			
		wE = wE /// later on insert function for calculatinfg the iniital state broadening
		wk = wk //later on insert function for calculating the mean free path 
			
			for(j=0;j<ksize;j+=1)
			
				k_perp = dimoffset(kplot,0)+j*dimdelta(kplot,0)
				
				Setscale/I x,k_perp-20*wk,k_perp+20*wk,Lorentzian //rescale the lorentztian and bandwaves

					if(k_perp>=kmin&&k_perp<=kmax) //if k_perp is within the range of kperp swept by the FEFS at this binding energy
						
					
						product[] = Lorentzian[p]*(Gauss(bandwave_SS(pnt2x(lorentzian,p)),E_binding,wE/2))/(exp((-1*E_binding)/0.026)+1)
						Integrate product/D=product_INT
						total = product_Int[lordim-1]/lordim
						kplot[j][i] = total
					
					else
						kplot[j][i] = nan
					endif
			endfor					
	endfor
	
	
End




Function CISparammodechanged(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	if(popnum==1) //photon energy mode
	
	Setvariable  CISstartE title = "start hf"
	Setvariable CISendE title = "end hf"
	
	elseif(popnum==2) //kinetic energy mode
	
	Setvariable  CISstartE title = "start KE"
	Setvariable CISendE title = "end KE"

	endif
		

End



Function EDCParamschanged(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	NVAR hv = root:Packages:WienPanelGlobs:EDCphotonEVAL
	NVAR endBE = root:Packages:WienPanelGlobs:EDCendBEVAL
	NVAR startBE = root:Packages:WienPanelGlobs:EDCstartBEVAL
	NVAR WF = root:Packages:WienPanelGlobs:crystalWFVAL
	NVAR startKE = root:Packages:WienPanelGlobs:EDCstartKEVAL
	NVAR endKE = root:Packages:WienPanelGlobs:EDCendKEVAL

	startKE = hv-Wf-startBE
	endKE = hv-Wf-endBE


End
						



				

		











