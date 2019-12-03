#pragma rtGlobals=1		// Use modern global access method.


Function FitLinearFunctionToBand()

string currentfolder = getdatafolder(1)
wave data = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
string destfolder = GetWavesDataFolder(data, 1)
setdatafolder $destfolder
variable startE = min(qcsr(A), qcsr(b))
variable endE



End 

Function FitLorentziantoFS(num, smth, direction)
variable num //number of profiles arounf
variable direction, smth

string currentfolder = getdatafolder(1)
variable kradius, startangle, endangle, i , delta_x, delta_y, angle, F_radius, F_radius_Conf
variable originx = hcsr(A)
variable originy = vcsr(A)
wave data = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
string destfolder = GetWavesDataFolder(data, 1)
setdatafolder $destfolder
make/o/n= 0 LorFSx, LorFSy, LorFSw, LorFS, LorFs_Conf
make/o/n= 2 xpoints, ypoints

kradius = sqrt((hcsr(A)-hcsr(B))^2+(vcsr(A)-vcsr(B))^2)
startangle  = atan2(vcsr(B)-vcsr(A),hcsr(B)-hcsr(A))
endangle = atan2(-vcsr(B)-vcsr(A), hcsr(B)-hcsr(A))
variable anglerange, deltaangle
	
	if(direction<0)
		anglerange  = 2*startangle
		deltaangle = -1*anglerange/(num-1)
	else
		anglerange  = (2*pi) - 2*startangle
		deltaangle = anglerange/(num-1)
	endif

	for(i=0;i<(num);i+=1)
	
		angle  = startangle +i*deltaangle
		delta_x = kradius*cos(angle)
		delta_y = kradius*sin(angle)
		xpoints = {originx, originx+delta_x}
		ypoints = {originy, originy+delta_y}
		ImageLineProfile   xWave=xpoints, yWave=ypoints, srcwave=data
		wave/z W_imagelineProfile
		Smooth  (smth), W_ImagelineProfile
		CurveFit/M=2/Q/W=0 lor, W_imagelineprofile/F={0.95, 4}
		wave/z  W_coef
		wave/z  W_ParamConfidenceInterval 
		F_radius = (W_coef[2]/(numpnts(W_imagelineprofile)))*kradius
		F_radius_Conf = (W_ParamConfidenceInterval[2])/(numpnts(W_imagelineprofile))*kradius
		
			if((F_radius>0)&&(F_radius<0.5*kradius)&&(F_radius_conf<0.5*F_radius)) //if the peak fit result is along the line chosen and error is less than 50% of the actual value
			
				InsertPoints 0, 1, LorFSx, LorFSy, LorFSw, LorFS, LorFS_Conf
				LorFSx[0] = originx + F_radius*cos(angle)
				LorFSy[0] = originy+F_radius*sin(angle)
				LorFSw[0] = 2*sqrt(W_coef[3])/(numpnts(W_imagelineprofile))*kradius
				LorFS[0] = F_radius
				LorFS_Conf[0] = F_radius_Conf
			
			endif
		
	endfor
	
wavestats LorFS
variable/g FS_rad_avg = V_avg //generates the average radius of the FS. This can be used to calculate teh carrier density. 
variable/g FS_rad_sigma = V_sdev
variable/g FS_rad_3sigma = 3*FS_rad_Sigma
wavestats LorFSw
variable/g FS_w_avg = V_avg
wavestats LorFS_Conf
variable/g FS_Conf_Avg = V_avg

//for(i=0;i<num;i+=1) ///this will generate the circle representing the average FS, if reuiqred for plotting purposes
	

	
setdatafolder $currentfolder


	
end

Function FitLorentziantoFS_2(num)
variable num //number of profiles arounf

string currentfolder = getdatafolder(1)
variable kradius, startangle, endangle, i , delta_x, delta_y, angle, F_radius
variable originx = hcsr(A)
variable originy = vcsr(A)
wave data = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
string destfolder = GetWavesDataFolder(data, 1)
setdatafolder $destfolder
make/o/n= (2*num) LorFSx, LorFSy, LorFSw, LorFS
make/o/n= 2 xpoints, ypoints
kradius = sqrt((hcsr(A)-hcsr(B))^2+(vcsr(A)-vcsr(B))^2)
startangle  = 0
endangle = pi
variable deltaangle = pi/(num-1)

	for(i=0;i<(num);i+=2)
		angle  = startangle +i*deltaangle
		delta_x = kradius*cos(angle)
		delta_y = kradius*sin(angle)
		
		xpoints = {originx, originx+delta_x}
		ypoints = {originy, originy+delta_y}
		ImageLineProfile   xWave=xpoints, yWave=ypoints, srcwave=data
		wave/z W_imagelineProfile
		CurveFit/M=2/Q/W=0 lor, W_imagelineprofile
		wave/z  W_coef
		F_radius = (W_coef[2]/(numpnts(W_imagelineprofile)))*kradius
		LorFSx[i] = originx + F_radius*cos(angle)
		LorFSy[i] = originy+F_radius*sin(angle)
		LorFSw[i] = 2*sqrt(W_coef[3])/(numpnts(W_imagelineprofile))*kradius
		LorFS[i] = F_radius
		

		xpoints = {originx, originx-delta_x}
		ypoints = {originy, originy-delta_y}
		ImageLineProfile   xWave=xpoints, yWave=ypoints, srcwave=data
		wave/z W_imagelineProfile
		CurveFit/M=2/Q/W=0 lor, W_imagelineprofile
		wave/z  W_coef
		F_radius = (W_coef[2]/(numpnts(W_imagelineprofile)))*kradius
		LorFSx[i+1] = originx - F_radius*cos(angle)
		LorFSy[i+1] = originy - F_radius*sin(angle)
		LorFSw[i+1] = 2*sqrt(W_coef[3])/(numpnts(W_imagelineprofile))*kradius
		LorFS[i+1] = F_radius
		
	endfor
	
wavestats LorFS
variable/g FS_rad_avg = V_avg //generates the average radius of the FS. This can be used to calculate teh carrier density. 
wavestats LorFSw
variable/g FS_w_avg = V_avg

//for(i=0;i<num;i+=1) ///this will generate the circle representing the average FS, if reuiqred for plotting purposes
	

	
setdatafolder $currentfolder


	
end

Function ApplyFSAxesandSizeProfile()

	ModifyGraph margin(left)=86,margin(bottom)=60,width=283.465,height=283.465
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph fSize=14
	ModifyGraph lblPosMode=3
	ModifyGraph lblPos(left)=65,lblPos(bottom)=50
	ModifyGraph btLen=4
	Label left "\\u#2 \\F'Arial'\\Z16k\\By \\M\\Z16(Å\\S-1\\M\\Z16)"
	Label bottom "\\u#2 \\F'Arial'\\Z16k\\Bx \\M\\Z16(Å\\S-1\\M\\Z16)"
	SetAxis left -0.15,0.15
	SetAxis bottom -0.15,0.15
	ModifyGraph fStyle=0
	
end

Function ApplyEDCAxesandSizeStyle()

	ModifyGraph width={Aspect,1},height={Aspect,1}
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph nticks(left)=4,nticks(bottom)=20
	ModifyGraph font="Arial"
	ModifyGraph minor(left)=1
	ModifyGraph sep=10
	ModifyGraph fSize=14
	ModifyGraph lblMargin(left)=3
	ModifyGraph axOffset(left)=0.666667
	ModifyGraph lblPosMode=3
	ModifyGraph lblPos(left)=50,lblPos(bottom)=45
	ModifyGraph btLen=4
	ModifyGraph btThick(bottom)=1
	ModifyGraph stLen=1.5
	ModifyGraph tickEnab(bottom)={-0.4,0.4}
	Label left "\\u#2\\Z16E - E\\BF\\M \\Z16(eV)"
	Label bottom "\\u#2 \\F'Arial'\\Z16k\\Bx \\M\\Z16(Å\\S-1\\M\\Z16)"
	SetAxis left -1.5,0.2
	SetAxis bottom -0.4,0.4
	SetDrawEnv xcoord= bottom,ycoord= left
	SetDrawEnv dash= 3,linethick= 2.00
	DrawLine 0,-1.5,0,0.2
	
	
end





