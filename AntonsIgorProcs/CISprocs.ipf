#pragma rtGlobals=1		// Use modern global access method.

Function ApplyGenCISStyle()


		
	ModifyImage ''#0,ctab= {*,*,Grays,0}
	ModifyGraph margin(left)=72,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(left)=1
	ModifyGraph lblLatPos(left)=12
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={0,0}
	Label left "\\K(0,0,0)\\Z18\\f01k\\B\\F'Symbol'^\\F'Arial'\\M \\Z18( Å\\S-1\\M\\Z18)"
	Label bottom "\\K(0,0,0)\\Z16\\f01k\\B||\\M \\Z18( Å\\S-1\\M\\Z18)"
	
	
end

Function ApplyCIS111GMStyle(BZ)
variable BZ

		
	ModifyImage ''#0,ctab= {*,*,Gold,0}
	ModifyGraph margin(left)=72,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(left)=1
	ModifyGraph lblLatPos(left)=12
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={0,0}
	Label left "\\K(0,0,0)\\Z18\\f01k\\B\\F'Symbol'^\\F'Arial'\\M \\Z18( Å\\S-1\\M\\Z18)"
	Label bottom "\\K(0,0,0)\\Z16\\f01k\\B||\\M \\Z18( Å\\S-1\\M\\Z18)"
	SetAxis left 1.5,6
	SetAxis bottom -4.5,4.5
	ShowTools
	SetDrawLayer UserFront
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 211 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	
	if(BZ)
			SetDrawLayer UserFront
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 211 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 211 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 211 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.76714372634888,3.49862694740295,-1.06030249595642,4.49825143814087
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022095680237,4.49825143814087,-1.06030249595642,4.49825143814087
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022095680237,4.49825143814087,1.76706206798553,2.4990029335022
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022095680237,4.49825143814087,1.76706206798553,5.49787569046021
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,5.49787569046021,1.76706206798553,5.49787569046021
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.76714372634888,3.49862694740295,-3.88758516311646,3.49856925010681
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,2.4990029335022,1.76706206798553,2.4990029335022
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.06030249595642,4.49825143814087,-1.76706182956696,6.4974422454834
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -3.88235294117647,3.49411764705882,-4.51764705882353,5.34705882352941
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.76714372634888,3.49862694740295,-1.06030249595642,1.49937868118286
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022083759308,1.49937856197357,-1.06030249595642,1.49937868118286
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022083759308,1.49937856197357,1.76706206798553,2.4990029335022
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,5.49787569046021,4.59442663192749,3.49862718582153
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -3.88758516311646,6.4974422454834,-1.76706182956696,6.4974422454834
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -3.88235294117647,6.49411764705882,-4.5,5.61176470588235
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -4.59434461593628,2.49906063079834,-3.88758516311646,3.49856925010681
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -4.58823529411765,2.50588235294118,-4.25294117647059,1.51764705882353
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,2.4990029335022,4.59442663192749,3.49862718582153
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88235294117647,2.50588235294118,4.23529411764706,1.5
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 4.59442615509033,6.49749946594238,3.88758540153503,5.49787569046021
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06286913419582,7.47767367025818,1.76971036458827,5.47842516561951

endif
					
end

Function ApplyCIS111GKStyle(BZ)
variable BZ

		
	ModifyImage ''#0,ctab= {*,*,Gold,0}
	ModifyGraph margin(left)=72,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(left)=1
	ModifyGraph lblLatPos(left)=12
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={0,0}
	Label left "\\K(0,0,0)\\Z18\\f01k\\B\\F'Symbol'^\\F'Arial'\\M \\Z18( Å\\S-1\\M\\Z18)"
	Label bottom "\\K(0,0,0)\\Z16\\f01k\\B||\\M \\Z18( Å\\S-1\\M\\Z18)"
	SetAxis left 1.5,6
	SetAxis bottom -4.5,4.5
	ShowTools
	SetDrawLayer UserFront
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 110 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	
end

Function ApplyCIS111GM2Style(BZ)
variable BZ

		
	ModifyImage ''#0,ctab= {*,*,Gold,0}
	ModifyGraph margin(left)=72,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(left)=1
	ModifyGraph lblLatPos(left)=12
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={0,0}
	Label left "\\K(0,0,0)\\Z18\\f01k\\B\\F'Symbol'^\\F'Arial'\\M \\Z18( Å\\S-1\\M\\Z18)"
	Label bottom "\\K(0,0,0)\\Z16\\f01k\\B||\\M \\Z18( Å\\S-1\\M\\Z18)"
	SetAxis left 1.5,6
	SetAxis bottom -4.5,4.5
	ShowTools
	SetDrawLayer UserFront
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 112 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	
	if(BZ)
			SetDrawLayer UserFront
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 211 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 211 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	SetDrawEnv gstart
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 211 ]"
	SetDrawEnv linethick= 2
	DrawLine 0.911764705882353,1.1921568627451,0.931372549019608,1.1921568627451
	SetDrawEnv gstop
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[111]"
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.76714372634888,3.49862694740295,-1.06030249595642,4.49825143814087
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022095680237,4.49825143814087,-1.06030249595642,4.49825143814087
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022095680237,4.49825143814087,1.76706206798553,2.4990029335022
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022095680237,4.49825143814087,1.76706206798553,5.49787569046021
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,5.49787569046021,1.76706206798553,5.49787569046021
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.76714372634888,3.49862694740295,-3.88758516311646,3.49856925010681
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,2.4990029335022,1.76706206798553,2.4990029335022
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.06030249595642,4.49825143814087,-1.76706182956696,6.4974422454834
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -3.88235294117647,3.49411764705882,-4.51764705882353,5.34705882352941
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -1.76714372634888,3.49862694740295,-1.06030249595642,1.49937868118286
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022083759308,1.49937856197357,-1.06030249595642,1.49937868118286
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06022083759308,1.49937856197357,1.76706206798553,2.4990029335022
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,5.49787569046021,4.59442663192749,3.49862718582153
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -3.88758516311646,6.4974422454834,-1.76706182956696,6.4974422454834
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -3.88235294117647,6.49411764705882,-4.5,5.61176470588235
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -4.59434461593628,2.49906063079834,-3.88758516311646,3.49856925010681
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine -4.58823529411765,2.50588235294118,-4.25294117647059,1.51764705882353
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88758540153503,2.4990029335022,4.59442663192749,3.49862718582153
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 3.88235294117647,2.50588235294118,4.23529411764706,1.5
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 4.59442615509033,6.49749946594238,3.88758540153503,5.49787569046021
	SetDrawEnv xcoord= bottom,ycoord= left,linethick= 0.25,linefgc= (32768,54528,65280),dash= 3
	DrawLine 1.06286913419582,7.47767367025818,1.76971036458827,5.47842516561951

endif
					
end

Function ApplyCIS100GMStyle(BZ)
variable BZ


	ModifyImage ''#0 ctab= {*,100,Gold,0}
	ModifyGraph margin(left)=72,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	ModifyGraph gbRGB=(30464,30464,30464)
	ModifyGraph mode=2
	ModifyGraph lSize=0
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(left)=1
	ModifyGraph lblLatPos(left)=12
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={0,0}
	Label left "\\K(0,0,0)\\Z18\\f01k\\B\\F'Symbol'^\\F'Arial'\\M \\Z18( Å\\S-1\\M\\Z18)"
	Label bottom "\\K(0,0,0)\\Z16\\f01k\\B||\\M \\Z18( Å\\S-1\\M\\Z18)"
	SetAxis left 1.5,6
	SetAxis bottom -4.5,4.5
	ShowTools
	SetDrawLayer UserFront
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 011 ]"
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[100]"
	
	if(BZ)
		ModifyGraph gbRGB=(30464,30464,30464)
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.612071633338928,5.19409990310669,0.612071633338928,5.19409990310669
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.612071633338928,5.19409990310669,-1.8363561630249,3.46280002593994
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.612071633338928,1.73140001296997,-1.8363561630249,3.46280002593994
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.612071633338928,1.73140001296997,0.612071633338928,1.73140001296997
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.8363561630249,3.46280002593994,0.612071633338928,1.73140001296997
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.8363561630249,3.46280002593994,0.612071633338928,5.19409990310669
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -1.8363561630249,3.46280002593994,-3.06064105033875,3.46280002593994
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -4.26727887882906,5.15880578545963,-3.04299399151522,3.42750590829288
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -4.28492593765259,1.73140001296997,-3.06064105033875,3.46280002593994
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.8363561630249,3.46280002593994,3.06064105033875,3.46280002593994
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 4.28492593765259,5.19409990310669,3.06064105033875,3.46280002593994
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 4.28492593765259,1.73140001296997,3.06064105033875,3.46280002593994
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.6,1.74705882352941,-0.794117647058823,1.46470588235294
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 0.935294117647059,1.32352941176471,0.635294117647059,1.72941176470588
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -3.98823529411765,1.34117647058824,-4.28823529411765,1.74705882352941
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 4.28823529411765,1.72941176470588,4.09411764705882,1.44705882352941
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.616585013445688,5.15691767299877,-1.84086954313166,6.88821755016551
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -3.02971869216246,6.88821755016551,-4.25400322184843,5.15691767299877
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 4.27165028067196,5.20985884946935,3.04736575098599,6.9411587266361
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.84086954313166,6.90586460898904,0.616585013445686,5.1745647318223
		DrawOval 0.490196078431373,0.549019607843137,0.507843137254902,0.584313725490196
		SetDrawEnv fname= "Symbol",fstyle= 1,textrgb= (65535,65535,65535)
		DrawText 0.490196078431372,0.662745098039216,"G"
		SetDrawEnv fsize= 10,fstyle= 1,textrgb= (65535,65535,65535)
		DrawText 0.507843137254902,0.686274509803922,"100"
	endif


					
end

Function ApplyCIS100GXStyle(BZ)
variable BZ

		

	ModifyImage ''#0 ctab= {*,100,Gold,0}
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=72,margin(bottom)=60,width={perUnit,42.5197,bottom},height={perUnit,42.5197,left}
	
	ModifyGraph mode=2
	ModifyGraph lSize=0
	ModifyGraph mirror=0
	ModifyGraph fSize=16
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(left)=1
	ModifyGraph lblLatPos(left)=12
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={0,0}
	Label left "\\K(0,0,0)\\Z18\\f01k\\B\\F'Symbol'^\\F'Arial'\\M \\Z18( Å\\S-1\\M\\Z18)"
	Label bottom "\\K(0,0,0)\\Z16\\f01k\\B||\\M \\Z18( Å\\S-1\\M\\Z18)"
	SetAxis left 1.5,6
	SetAxis bottom -4.5,4.5
	SetDrawLayer UserFront
	SetDrawEnv arrow= 1
	DrawLine 0.747058823529412,1.24705882352941,0.866666666666667,1.24705882352941
	SetDrawEnv fsize= 16
	DrawText 0.888235294117647,1.29019607843137,"[ 010 ]"
	SetDrawEnv arrow= 1
	DrawLine -0.143137254901961,0.301960784313725,-0.143137254901961,0.0980392156862745
	SetDrawEnv fsize= 16
	DrawText -0.188235294117647,0.0745098039215686,"[100]"
	
	if(BZ)
		ModifyGraph gbRGB=(30464,30464,30464)
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.73140001296997,2.59710001945496,1.73140001296997,4.32849979400635
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 0.865700006484985,5.19409990310669,1.73140001296997,4.32849979400635
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 0.865700006484985,5.19409990310669,-0.865700006484985,5.19409990310669
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -1.73140001296997,4.32849979400635,-0.865700006484985,5.19409990310669
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -1.73140001296997,4.32849979400635,-1.73140001296997,2.59710001945496
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.865700006484985,1.73140001296997,-1.73140001296997,2.59710001945496
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -0.865700006484985,1.73140001296997,0.865700006484985,1.73140001296997
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.73140001296997,2.59710001945496,0.865700006484985,1.73140001296997
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 2.59710001945496,5.19409990310669,1.73140001296997,4.32849979400635
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 2.59710001945496,5.19409990310669,4.32849979400635,5.19409990310669
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 2.59710001945496,1.73140001296997,4.32849979400635,1.73140001296997
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 2.59710001945496,1.73140001296997,1.73140001296997,2.59710001945496
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -1.73140001296997,2.59710001945496,-2.59710001945496,1.73140001296997
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -1.73140001296997,4.32849979400635,-2.59710001945496,5.19409990310669
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -4.32849979400635,5.19409990310669,-2.59710001945496,5.19409990310669
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -4.32849979400635,1.73140001296997,-2.59710001945496,1.73140001296997
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -1.72841764057384,6.02351166781257,-0.862717634088852,5.15791155871223
			SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 0.862717634088849,5.17555861753576,1.72841764057384,6.0411587266361
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -1.73140001296997,0.852029205771055,-0.865700006484986,1.71762931487139
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
			DrawLine 0.862717634088849,5.17555861753576,1.72841764057384,6.0411587266361
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 2.34705882352941,1.37647058823529,2.61176470588235,1.72941176470588
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.74805294766146,6.05880578545963,2.61375295414644,5.19320567635929
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -2.57845883649939,5.19320567635929,-1.7127588300144,6.05880578545963
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -5.15194705233854,6.02351166781257,-4.28624704585356,5.15791155871223
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 4.32452353589675,5.19409990310669,5.19022354238174,4.32849979400635
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
			DrawLine 1.72742351644179,0.887323323418113,0.861723509956809,1.75292343251845
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine 1.72742351644179,0.887323323418113,0.861723509956809,1.75292343251845
		SetDrawEnv xcoord= bottom,ycoord= left,linefgc= (65535,65535,65535),dash= 1
		DrawLine -2.34705882352941,1.48235294117647,-2.59411764705882,1.74705882352941
		DrawOval 0.490196078431373,0.549019607843137,0.507843137254902,0.584313725490196
		SetDrawEnv fname= "Symbol",fstyle= 1,textrgb= (65535,65535,65535)
		DrawText 0.490196078431372,0.662745098039216,"G"
		SetDrawEnv fsize= 10,fstyle= 1,textrgb= (65535,65535,65535)
		DrawText 0.507843137254902,0.686274509803922,"100"
	endif
	
End
	
Function SaveKplaneSettings(ctrlName) : ButtonControl
	String ctrlName
	
	doalert 1, "Save Current Settings?"
		if(V_flag==1)
		
			string curfol = getdatafolder(1)
			wave data = ImageNameToWaveRef("",StringFromList(0, ImageNameList("", ";"),";")) //get ref to the wave in the top graph
			string info =  ExtractSpecificControlList("cisparam","CISpanel")
			AddKeyParamToNote(data,"KPParams",info)
			
		endif

End

Function GetKplaneSettings(ctrlName) : ButtonControl
	String ctrlName
	
	GetPlotSettings("KPParams","CISpanel")

End


Macro CISpanel() : Panel



if(CheckName("CISpanel", 9,"CISpanel"))
		Dowindow/F CISpanel
else

	string curfolder = getdatafolder(1)

			Newdatafolder/O/S root:Packages
			Newdatafolder/O/S root:Packages:CISPanelGlobs
				
				variable/g CISVoVAL=0
				variable/g CISincsVAL=0
				variable/g CalcFEstartEVAL
				variable/g CalcFEendEVAL
				variable/g CalcFESplsmthVAL
				variable/g CISstepVAL
				variable/g KEVAL=0
				variable/g CISscanBEVAL
				variable/g winwidthVAL

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(549,105,835,599) as "CISPanel"
	Dowindow/C CISpanel
	ModifyPanel cbRGB=(16384,65280,65280)
	SetDrawLayer UserBack
	SetDrawEnv gstart
	SetDrawEnv dash= 1
	DrawLine 188,168,254,168
	SetDrawEnv dash= 6
	DrawLine 188,154,254,154
	DrawLine 188,219,252,219
	SetDrawEnv linethick= 2,linefgc= (0,0,65280),arrow= 1
	DrawLine 202,219,202,168
	SetDrawEnv linethick= 2,linefgc= (0,15872,65280),arrow= 1
	DrawLine 221,219,221,154
	SetDrawEnv dash= 3
	DrawLine 188,147,254,147
	SetDrawEnv linethick= 2,linefgc= (0,15872,65280),arrow= 1
	DrawLine 239,219,239,147
	SetDrawEnv gstop
	SetDrawEnv linethick= 2,fillpat= 0
	DrawRRect 279,268,5,487
	SetDrawEnv fstyle= 1
	DrawText 10,479,"CIS Scan Data Extraction"
	SetDrawEnv linethick= 2,fillpat= 0
	DrawRRect 282,5,3,251
	SetDrawEnv fstyle= 1
	DrawText 14,243,"CIS Scan Processing"
	SetDrawEnv linefgc= (0,15872,65280),fillpat= 0,fillfgc= (0,15872,65280)
	DrawRRect 261,377,8,455
	Button CISfixButton,pos={14,387},size={61,21},proc=GetCISdata,title="Extract CIS"
	Button CISSetUpButton,pos={13,116},size={100,20},proc=JoinCISData,title="Join CIS Sets"
	Button ProcessCISButton,pos={9,13},size={75,20},proc=ProcessCISscan,title="Process CIS"
	SetVariable cisparam1,pos={181,37},size={96,16},title="Inner Pot"
	SetVariable cisparam1,value= root:Packages:CISPanelGlobs:CISVoVAL
	SetVariable cisparam0,pos={183,13},size={95,16},title="K incs/A"
	SetVariable cisparam0,limits={0,inf,1},value= root:Packages:CISPanelGlobs:CISincsVAL
	Button button0,pos={13,87},size={75,20},proc=SaveKplaneSettings,title="Save Settings"
	Button button1,pos={98,87},size={65,20},proc=GetKplaneSettings,title="Get Settings"
	SetVariable CalcFESplSmth,pos={149,280},size={107,16},title="Spline Smth"
	SetVariable CalcFESplSmth,value= root:Packages:CISPanelGlobs:CalcFESplSmthVAL
	SetVariable CalcFEstartE,pos={153,303},size={103,16},title="StartE"
	SetVariable CalcFEstartE,value= root:Packages:CISPanelGlobs:CalcFEstartEVAL
	SetVariable CalcFEEndE,pos={153,327},size={103,16},title="EndE"
	SetVariable CalcFEEndE,value= root:Packages:CISPanelGlobs:CalcFEendEVAL
	Button CalcFEwbutton,pos={12,278},size={76,23},proc=AutoCalcFEWCIS,title="CalcFEWAuto"
	SetVariable CISscanBE,pos={15,419},size={89,16},title="Eb (eV)"
	SetVariable CISscanBE,value= root:Packages:CISPanelGlobs:cisscanBEval
	SetVariable CISStep,pos={12,347},size={90,16},proc=CisDetectStep,title="CISstep"
	SetVariable CISStep,limits={0,inf,1},value= root:Packages:CISPanelGlobs:CISstepVAL
	Button CalcFEWbutton2,pos={12,312},size={76,21},proc=CalcFE,title="CalcFE"
	PopupMenu GetCISdatamode,pos={82,388},size={148,21},title="Extract Mode"
	PopupMenu GetCISdatamode,mode=2,popvalue="FEW Rel",value= #"\"Abs BE;FEW Rel;FE Rel\""
	PopupMenu CISDispStyle,pos={11,47},size={158,21},title="Disp Style"
	PopupMenu CISDispStyle,mode=2,popvalue="BlackOnWhite",value= #"\"None;BlackOnWhite;WhiteOnBlack\""
	Button FEFSplotbutton,pos={15,156},size={58,18},proc=PlotFEFS,title="Plot FEFS"
	SetVariable setvar0,pos={83,157},size={63,16},title="KE"
	SetVariable setvar0,value= root:Packages:CISPanelGlobs:KEVAL
	CheckBox UseCsrsCheck,pos={197,348},size={60,14},title="Use Csrs",value= 1
	CheckBox showCisStep,pos={109,347},size={81,14},title="Show cisstep",value= 0
	SetVariable WinWidth,pos={131,419},size={97,16},title="Width(eV)"
	SetVariable WinWidth,value= root:Packages:CISPanelGlobs:winwidthVAL



Setdatafolder $curfolder

endif
	
	
EndMacro


Function PlotFEFS2(ctrlName) : ButtonControl //plots a Free Electron Final State on top o the active window
	String ctrlName
	
	string topwin = winname(0,1)
	NVAR Vo= root:Packages:CISPanelGlobs:CISVoVAL
	NVAR KE =root:Packages:CISPanelGlobs:KEVAL
	variable radius, startx, starty, endx, endy, startangle, endangle, deltaangle, i, angle, x, y
	
	Make/o/n = 1000 FEFSwaveX, FEFSwavey
	
	radius =sqrt((KE+Vo)/3.84)
	startx = sqrt(radius^2-(0.511*sqrt(vo))^2)
	starty = 0.511*sqrt(Vo)
	endx = -startx
	endy = starty
	
	startangle = atan(starty/startx)*180/pi
	endangle = 180+ atan(endy/endx)*180/pi	
	
	deltaangle = (endangle-startangle)/1000
	
	for(i=0;i<1000;i+=1)
		angle = startangle + i*deltaangle
		x = radius*cos(angle*pi/180)
		y= radius*sin(angle*pi/180)
		FEFSwaveX[i] = x
		FEFSwaveY[i] = y
	endfor
	
	

	


End




Function PlotFEFS(ctrlName) : ButtonControl //plots a Free Electron Final State on top o the active window
	String ctrlName
	
	string topwin = winname(0,1)
	NVAR Vo= root:Packages:CISPanelGlobs:CISVoVAL
	NVAR KE =root:Packages:CISPanelGlobs:KEVAL
	variable radius =sqrt((KE+Vo)/3.84)
	variable miny, maxy, maxx,startx,starty, startangle, endangle,xint, minx,endx, endy, startx2
	
	//SetDrawlayer/W=$topwin/K Progfront
	SetDrawEnv/W=$topwin dash = 0, linefgc= (0,0,0),xcoord=bottom,ycoord = left, linethick =1,fillpat=0,linefgc= (65280,0,26112)
	SetDrawlayer/W=$topwin Progfront
	GetAxis/Q bottom
	maxx = V_max
	minx = V_min
	Getaxis/Q left
	maxy = V_max
	miny = V_min
	
	startx = sqrt(radius^2-(0.511*sqrt(vo))^2)

	
	if(startx<maxx)
		
		starty = 0.511*sqrt(Vo)
		
	else
	
		startx = maxx
		starty = sqrt(radius^2-startx^2)
		
	endif

	startangle = atan(starty/startx)*180/pi
	
	if(-startx>minx)
	
		endx = -startx2
		endy = 0.511*sqrt(Vo)
	else
	
		endx =minx
		endy = sqrt(radius^2-endx^2)
	
	endif
	
	endangle = 180+ atan(endy/endx)*180/pi	
	
	DrawArc/W=$topwin/X 0, 0, Radius, startAngle, endAngle

End

Function/S GenerateCISKEString(CisEnwave) //this function takes a wave of CIS KE's and converts it into a string suitable for attaching onto the wave as a key param
wave CISEnWave

string enstring = ""
variable i
	
	for(i=0;i<numpnts(CisEnWave);i+=1)
		enstring+=num2str(CisEnwave[i])+";"
	endfor
	
return enstring

End

Function AttachCISEnergiesToWaveNote(data,enwave)
wave data
wave enwave	

	AddKeyParamToNote(data,"CisKE",GenerateCISKEString(enwave))

End


Function GetCISdata(ctrlName) : ButtonControl //this function goes to the data block and extracts data occuring at a given binding energy, or relative to manually detected Fermi wave (eg TGM4)
	String ctrlName
	
	wave/z datablock
	
	NVAR minKE, stepph,middleBE
	NVAR FermiEnCalc
	string name,selwave,mode
	NVAR BE=  root:Packages:CISPanelGlobs:CISscanBEVAL
	NVAR width = root:Packages:CISPanelGlobs:winwidthVAL
	variable pres,i,j,val
	variable innerBE = middleBE-((dimsize(datablock,2)-1)/2)*dimdelta(datablock,2)
	variable outerBE = middleBE+((dimsize(datablock,2)-1)/2)*dimdelta(datablock,2)
	make/o/n=(dimsize(datablock,2)) line
	Setscale/P x,dimoffset(datablock,2) ,dimdelta(datablock,2),line
	Controlinfo/W=CISpanel GetCISdatamode
	
	mode = S_value
	
	strswitch(mode)
	
	case "Abs BE":
	case "FE Rel":
	
		

		
			if((BE>innerBE)||(BE<outerBE))
				Doalert 0, "BE is outside of data"
				break
			endif
		
				name = "cis"+num2str(BE)
				make/o/n=(dimsize(datablock,0),dimsize(datablock,2)) sheet
				setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet
				Setscale/P y,dimoffset(datablock,2), dimdelta(datablock,2), sheet
				make/o/n=(dimsize(datablock,0),dimsize(datablock,1)) cis
				Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0), "deg", cis
				Setscale/P y, dimoffset(datablock,1),dimdelta(datablock,1), "Photon Energy", cis
							
						for(j=0;j<dimsize(datablock,1);j+=1)
							sheet[][] = datablock[p][j][q]
								for(i=0;i<dimsize(sheet,0);i+=1)
									line[] =sheet[i][p]
										
										if(width>0)
											cis[i][j] = area(line, BE-width/2, BE+width/2)
										else
											cis[i][j] =line(BE)
										endif
								endfor
						endfor
							
					variable startKE = minKE-((dimsize(datablock,2)-1)/2)*dimdelta(datablock,2)-(BE-dimoffset(datablock,2))
					Make/o/n=(dimsize(datablock,1)) CisEn
					CISEn[] = startKE+p*dimdelta(datablock,1) //create an array of energies to attach to this wave for use in processing
					AttachCISEnergiesToWaveNote(cis,CISen) //atttch the kinetic enegies of the CIS scan to the wave note)
					Duplicate/O cis, $name
					killwaves/z sheet, cis, CisEn
					Displaywave($name)
				
			Break
			
			
	case "FEW Rel":

			name = "FEcis"+num2str(BE)
			
				string waveslist = wavelist("*", ";", "")
				prompt selwave,"", popup, waveslist
				Doprompt "Select FEW", selwave //prompt user to select a wave from the current df
					
					if(V_flag==0)
						Duplicate/o $selwave, Fwave
						ExtractFEWCIS(FWave,BE,width,datablock)  //extract the data from the datablock
						wave CISenergies
						wave cis
						Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0), "deg", cis
						Setscale/P y, dimoffset(datablock,1), dimdelta(datablock,1),"Photon Energy (eV)", cis
						AttachCISEnergiesToWaveNote(cis,CISenergies) //attach the (now non linear) spaced KE values to the wave note
						duplicate/O cis $name
						killwaves/z CISenergies, cis,Fwave
						Displaywave($name)
					else
						break
					endif
	endswitch
				
		
End

Function SmoothFW(FW,order) //this function smooths a FW copy for use in the extract CIS algorithm
wave FW
variable order

	variable i
	Make/o/n = (dimsize(FW,0)) onedwave
		for(i=0;i<dimsize(FW,1);i+=1)
			onedwave[] = FW[p][i]
			Smooth/B  order, onedwave
			FW[][i] = onedwave[p]
		endfor
	
	killwaves onedwave
	
end
			



	
Function ExtractFEWCIS(FedgewaveCIS,BE,width,datablock) //this function takes a pre-computed wave of fermi level positions in a CIS scan (binding energies) and extracs form the data set the data correspondint ot he desired BE
wave fedgewaveCIS
wave datablock
variable BE //the binding energy rel to the fermi level
variable width

	variable i,j,num
	NVAR minKE
	NVAR stepPh

	
	Make/o/n = (dimsize(datablock,0), dimsize(datablock,2)) sheet
	Make/o/n = (dimsize(datablock,0),dimsize(datablock,1)) cis
	make/o/n = (dimsize(datablock,1)) cisenergies
	make/o/n=(dimsize(datablock,2)) line
	
	Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet,cis
	Setscale/P y,dimoffset(datablock,2), dimdelta(datablock,2), sheet
	Setscale/P x,dimoffset(datablock,2), dimdelta(datablock,2), line
	
		for(j=0;j<dimsize(datablock,1);j+=1)
			sheet[][] = datablock[p][j][q]
				for(i=0;i<dimsize(sheet,0);i+=1)
					line[] =sheet[i][p]
						if(width>0)
							cis[i][j] =area(line,FedgewaveCIS[j]+BE-width/2,FedgewaveCIS[j]+BE+width/2)
								
						else
							cis[i][j] =line(FedgewaveCIS[j]+BE)
						endif
				endfor
			cisenergies[j]= (minKE-((dimsize(datablock,2)-1)/2)*dimdelta(datablock,2))-((FedgewaveCIS[j]+BE)-dimoffset(datablock,2))+j*dimdelta(datablock,1)//calc the kinetic enegy at the fermi levle for ts point in the routine
		endfor	
		
End

Function CalcFE(ctrlName) : ButtonControl  //function allows user to step through the CIS step by step. At each step
String ctrlName										// the user can detect the position of the Fermi edge

		NVAR step = root:Packages:CISPanelGlobs:CISstepVAL
		wave datablock
		NVAR startE = root:Packages:CISPanelGlobs:CalcFEStartEVAL
		NVAR smthfact= root:Packages:CISPanelGlobs:CalcFEsplsmthVAL
		NVAR endE = root:Packages:CISPanelGlobs:CalcFEendEVAL
		NVAR minKE
		NVAR stepph
	
		 
		string curfolder =  getdatafolder(1)          
		variable startEn, EndEn
		Wave int =WaveRefIndexed("", 0, 3)
		setdatafolder $getwavesdatafolder(int,1)
		variable/g FermiEnCalc
		
			if(cmpstr(nameofwave(int),"CISstep_angleint")==0)
				
				controlinfo UsecsrsCheck
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
				Interpolate2/T=3/N=200/F=(smthfact) CISstep_angleint
				wave CiSstep_angleint_SS
				Removefromgraph/Z CISstep_angleint_SS
				Appendtograph CISstep_angleint_SS
				Duplicate/O CISstep_angleint_SS, fit
				Differentiate fit/D=fit
				FindPeak/R=(starten,enden) fit
				
				FermiEnCalc = V_peakloc
				tag/k/n=FermiTag
				tag/Y=0/X=-35/N=fermiTag CISstep_angleint_SS,FermienCalc,"FE ="+"  "+num2str(FermiEnCalc)+"eV"
	
			else
				Doalert 0, "Active graph not CISstep"
				return 0
			endif
		
		setdatafolder $curfolder
			
End

Function AcceptFermiValueManFEW(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR step = root:Packages:CISPanelGlobs:CISstepVAL
	wave datablock
	NVAR Fermiencalc
	wave/z FEcisman
	
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
						Fermiencalc = hcsr(A)
					else
						return 0 
					endif
			endif
		break
		 
		case 0:
			
				if(NVAR_Exists(FermiEnCalc))
					Doalert 1, "Insert Fermi Fit results into manual-detect CIS wave?"
			
					If(V_flag==1) //if user clicked ok
			 
						If(waveexists(FECISman)!=1)
							Make/o/n = (dimsize(datablock,1)) FECISman
						endif
		
						FECISman[step] = FermiEnCalc	
					endif
	
				else
					Doalert 0, "Must Calc Fermi Energy First "
					return 0
				endif
		break	
		
		endswitch	
			
	tag/k/n=FermiTag
	tag/Y=0/X=-35/N=fermiTag CISstep_angleint_SS,FermienCalc,"FE ="+"  "+num2str(FermiEnCalc)+"eV"
					
	

End

Function OverwriteFermiValueAutoFEW(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR step = root:Packages:CISPanelGlobs:CISstepVAL
	wave datablock
	NVAR FermiEnCalc
	wave/z FEcisauto


	controlinfo usecsrforFE
	variable usecsr = v_value
	
	switch(usecsr)
	case 0:
	
	if(NVAR_Exists(FermiEnCalc))
		Doalert 1, "Overwrite FEcisauto results at this step??"
			
					If(V_flag==1) //if user clicked ok
			
						If(waveexists(FECISauto)!=1)
							Doalert 0, "Auto FEW does not exist"
							return 0 
						else						
							FECISauto[step] = FermiEnCalc	
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
				Doalert 1, "Overwrite FEcisauto using Csr A pos as FE?"
					if(V_flag==1)
						
						FECISauto[step] = hcsr(A)
					else
						return 0 
					endif
			endif
	break	
	endswitch	
	tag/k/n=FermiTag
	tag/Y=0/X=-35/N=fermiTag CISstep_angleint_SS,FermienCalc,"FE ="+"  "+num2str(FermiEnCalc)+"eV"
					
	

End

Function AcceptCsrPosForFermi(ctrlName) : ButtonControl
	String ctrlName
	
	NVAR step = root:Packages:CISPanelGlobs:CISstepVAL
	wave datablock
	variable csrFermiEn
	
	Doalert 1, "Use csr(A) pos for Fermi Val in CIS wave?"
	
	If(V_flag==1) //if user clicked ok
		if(cmpstr(CsrWave(A),"")!=0)
		csrFermiEn= hcsr(A)
					
						If(waveexists(FECISman)!=1)
							Make/o/n = (dimsize(datablock,1)) FECISman
						endif
		
						FECISman[step] = csrFermiEn	
			
		tag/k/n=FermiTag
		tag/Y=0/X=-35/N=fermiTag $csrwave(A), csrFermiEn,"FE ="+"  "+num2str(csrFermiEn)+"eV"
		else
			Doalert 0, "Cursor not on graph"
		endif
	endif
					

End


Function CisDetectStep(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	NVAR left = root:Packages:ARUPSPanelGlobs:PolintL
	NVAR right = root:Packages:ARUPSPanelGlobs:PolintR
	 
	wave datablock
	NVAR step = root:Packages:CISPanelGlobs:CISstepVAL
	
	Make/o/n=(dimsize(datablock,0),dimsize(datablock,2)) CISstep
	CISstep[][] =datablock[p][step][q]
	Setscale/P x,dimoffset(datablock,0),dimdelta(datablock,0), "Polar Angle (deg)", CIsstep
	Setscale/P y,dimoffset(datablock,2), dimdelta(datablock,2), "BE (eV)", CISstep
	wave int = $(Polarangleintegrate(CISstep,left,right))
	controlinfo showCisStep
		if(v_value)
			Displaywave(CISstep) //display it
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
		Button AcceptVal1,pos={54,11},size={109,18},proc=AcceptFermiValueManFEW,title="Insert Man FEW"
		Button AcceptVal1,labelBack=(0,0,0),fStyle=1,fColor=(48896,65280,65280)
		CheckBox usecsrforFE,pos={291,11},size={80,14},title="Use csr A?",fStyle=1,value= 0
		Button AcceptVal2,pos={170,11},size={109,18},proc=OverwriteFermiValueAutoFEW,title="Insert Auto FEW"
		Button AcceptVal2,labelBack=(0,0,0),fStyle=1,fColor=(48896,65280,65280)
		killvariables/z FermiEnCalc
	endif
	Removefromgraph/z CISstep_angleint_SS

End
				



Function AutoCalcFEWCIS(ctrlName) : ButtonControl 
String ctrlName
	
		wave datablock
		variable pos1, pos2, i, j,change,FermiEn,FermiEnold
		NVAR endE = root:Packages:CISpanelglobs:CalcFEendEVAL
		NVAR startE = root:Packages:CISpanelglobs:CalcFEstartEVAL
		NVAR smthfact = root:Packages:CISPanelGlobs:CalcFESplSmthVAL
		variable startEn,endEn
		controlinfo UsecsrsCheck
					if(V_value==1)
						startEn = min(hcsr(A),hcsr(B))
						endEn = max(hcsr(A),hcsr(B))
					else
						startEn = startE
						EndEn = EndE
					endif
			
		Make/o/n = (dimsize(datablock,1)) FECISauto
		Make/o/n = (dimsize(datablock,0),dimsize(datablock,2)) sheet
		Setscale/P x,dimoffset(datablock,0), dimdelta(datablock,0), sheet
		Setscale/P y, dimoffset(datablock,2), dimdelta(datablock,2), sheet
		
		
		sheet[][]  =datablock[p][0][q]
		polarangleintegrate(sheet, -90,90)
		wave sheet_angleint
		
		Interpolate2/T=3/N=200/F=(smthfact) sheet_angleint
		wave sheet_angleint_SS
		Differentiate sheet_angleint_SS
		FindPeak/R=(startEn,endEn) sheet_angleint_SS
		FermiEnOld = V_peakloc
		
				for(j=0;j<dimsize(datablock,1);j+=1) //run through all photon steps
					sheet[][]  =datablock[p][j][q]
					polarangleintegrate(sheet, -90,90)
					Interpolate2/T=3/N=200/F=(smthfact) sheet_angleint
					Differentiate sheet_angleint_SS
					FindPeak/R=(startEn+change,endEn+change) sheet_angleint_SS
					Fermien = V_peakloc
					FECISauto[j] =V_peakloc
					change = FermiEn-FermiEnold
					FermiEnold = Fermien
				endfor	
				
		Displaywave(FECISauto)
		killwaves/z sheet, sheet_angleint,  sheet_angleint_SS		
End

Function IsDataValidCIS(data)
wave data
	
	variable valid
	GetCISenergiesfromwavenote(data)
	wave cisenergies
		if(numpnts(cisenergies)==0)
			valid=0
		else
			valid =1
		endif

return valid

end
	

Function BuildCISdatareferencelist(topfolder) ///this function builds a list of references to the CIS data to be joined
string topfolder

	String folderlist, teststring,totalist="",curfolder,name,ref,datalist,dataname,folder,selectedwaves=""
	Variable  i//this is the folder that the processed CIS data and the combined raw data will be stored
	

	curfolder = getdatafolder(1)
	Setdatafolder $topfolder //set the data folder to the one desired. 
	
			Folderlist = datafolderdir(1)[8,strlen(datafolderdir(1))] //get all names of the folders in the current directory
		
				for(i=0;i<itemsinlist(folderlist,",");i+=1)//make foldernames separated with semi colons
					teststring = stringfromlist(i,folderlist,",")
					totalist+= teststring+";" 
				endfor
		
			i=0
			Do
				prompt folder, "Folder", popup, totalist
				doprompt "Select Data folder", folder
			
					if(V_Flag==0) //if user did not cancel and selected a folder
						
						Setdatafolder $folder
						datalist = WaveList("*", ";", "DIMS:2") //get list of all waves in current folder 
						Prompt dataname, "Data", popup, datalist
						Doprompt "Select Data ", dataname
				
							if(V_Flag==0) //user selected a data
								
								if(IsDataValidCIS($dataname)) //check if the data is proper cis data with enegies in the wave note
									ref = GetWavesDataFolder($nameofwave($dataname), 2)
										if(FindListItem(ref, selectedwaves, ";")==-1) //if selected wave is not in the list already,add it
											selectedwaves+=ref+";"
										else
											Doalert 0, "Wave Already Selected"
										endif
								else
									Doalert 0, "Data is not valid cis data"
								endif
					
							endif
						setdatafolder $topfolder
					endif
				
				Doalert 1, "Select Another?" //select another folder to use from
						
					if(V_Flag==2)
						Setdatafolder $topfolder //go back to the start toplevel folder. 
						break
					endif
				while(1)
				
		make/o/t/n=(ItemsInList(selectedwaves, ";")) refarray
		refarray[] = StringFromList(p, selectedwaves, ";")
		Setdatafolder $curfolder
End

Function SetupJoinedCISProcessFolder(folname) //this function allows the user to create a Process Folder which will contain a combined CIS data set using chosen ranges from various sets of data contained within the top level folder
string folname
	
	wave data	
			if(datafolderexists(folname)) //if the data folder exists, kill it and start again
					Killdatafolder folname
			endif	
			
			Newdatafolder/O $folname		
		
			 // build array of desired waves to join together
End

Function JoinCISwavestogether(refarray)
wave/T refarray	

	variable i	
	variable minPh=1000000, maxPh = 0,stepph=100000, steptheta=1000000
	make/o/n=(numpnts(refarray)) arrange
			
			for(i=0;i<numpnts(refarray);i+=1) //arrange the cis data references in order of energy
				wave data = $refarray[i]
				arrange[i] = dimoffset(data,1)
			endfor
		
			Sort arrange, refarray
			killwaves/z arrange
			minPh = DimOffset($refarray[0], 1)
			maxPh = DImoffset($refarray[numpnts(refarray)-1],1)+(dimsize($refarray[numpnts(refarray)-1],1)-1)*dimdelta($refarray[numpnts(refarray)-1],1)
			
			for(i=0;i<numpnts(refarray);i+=1) //determine the smallest step size in both ph and theta for the scans
				wave data = $refarray[i]
				stepph = min(dimdelta(data,1),stepph)
				steptheta = min(dimdelta(data,0),steptheta)
				GetCISenergiesfromwavenote(data)
				wave cisenergies
				Duplicate/O cisenergies, $("En"+num2str(i)) //make copies of the waves and the cis energies inside the proces folder
				duplicate/O data, $("data"+num2str(i))
			endfor
			
			killwaves/z  CISenergies
					
			string datawaves = wavelist("data*",";","") //get references to the duplicate copies
			string enwaves = wavelist("En*",";","")
			variable factor
			
			for(i=0;i<itemsinlist(datawaves)-1;i+=1) //normalising the waves relative to each other
				wave data1 = $StringFromList(i,datawaves,";")
				wave data2 = $StringFromList(i+1, datawaves,";")
				wave data1inc = $PolarAngleIntegrate(data1,dimoffset(data1,0),dimoffset(data1,0)+(dimsize(data1,0)-1)*dimdelta(data1,0))
				wave data2inc = $PolarAngleIntegrate(data2,dimoffset(data2,0),dimoffset(data2,0)+(dimsize(data2,0)-1)*dimdelta(data2,0))
				factor = DetermineNormalisingFactor(data1inc,data2inc)
				data2/=factor
				killwaves/z data1inc,data2inc
			endfor
			
			variable Phsteps = round((maxph-minph)/stepph)+1
		
			variable thetasteps = round(180/steptheta)+1
			
			Make/o/n = (thetasteps,Phsteps) combcis //create the blank joined data set scaled to the overall min/max photon energies
			Make/o/n = (Phsteps) CombCisEn
			Setscale/I x,-90,90,"deg", Combcis
			Setscale/P y,minPh, stepph, "Photon Energy (eV)", Combcis
			
			variable j,k,z,datatotal	,entotal,ph,theta,val	
		
			for(j=0;j<dimsize(combcis,1);j+=1) //step through the blank joined array and obtain (theta,ph) points to extract from the data
					ph = dimoffset(Combcis,1)+j*dimdelta(Combcis,1)
					Make/o/n=0 KEarray=0
						for(i=0;i<dimsize(Combcis,0);i+=1)
							theta = dimoffset(Combcis,0)+i*dimdelta(Combcis,0)
								z=0
								datatotal=0
								entotal=0
									
									for(k=0;k<itemsinlist(datawaves);k+=1) //step through all the data waves
										
										wave data = $StringFromList(k,datawaves)
										wave en = $Stringfromlist(k,enwaves)
											if(inarray(data,theta,ph)) //check if the point is in the data array
												val = interp2d(data,theta,ph) //interpolate the value from the data
												entotal+=en(ph)
													if(numtype(val)==2) //takes care of bugs in interp2d (edge effect bug)
														datatotal+=data(theta)(ph)
													else
														datatotal+=val
													endif	
												z+=1 //add to the averaging factor z
											endif		
											
									endfor
									
									if(z==0)	//if point was not in any of the data sets	
										datatotal=nan
									else	
										combcis[i][j] = datatotal/z //fill in the intensity //average the intensity according to how many data data sets were used in filling (theta,ph)
										insertpoints 0,1,KEarray
										KEarray[0] = entotal/z
									endif
						endfor
					wavestats/Q KEarray
					Combcisen[j]=v_avg
			endfor	
			
			AttachCISEnergiesToWaveNote(CombCis,CombCISen)
			killwaves/z combcisen
			killwaves/z KEarray
			for(i=0;i<itemsinlist(datawaves);i+=1)
				killwaves/z	$StringFromList(i,datawaves,";")
				killwaves	/z $StringFromList(i,enwaves,";")
			endfor
					
End

Function DetermineNormalisingFactor(wave1,wave2) ///this function normalises one wave relative to the other via the overlapping section in the y direction in the array
wave wave1
wave wave2

variable left,right,total1,total2,factor
			
			left = leftx(wave2)
			right =  pnt2x(wave1,numpnts(wave1)-1)
		
			total1 = area(wave1, left,right)
			total2 = area(wave2,left,right)
		
			factor = total2/total1
return factor

end
		
	
	
		
			
	
//Function CombineICISDataInFolder()		/////
			
			variable numfol = countobjects("",4) //get the number of folders that have been created
		
			if(numfol>0)			
				make/o/n=(numfol) left
				make/o/t/n=(numfol) Folders //a wave of folder strings
						for(j=0;j<numfol;j+=1) //thi code will sort the folders into order according to energy so that E can be correctly placed inbetween two scans
							name = GetIndexedObjName("", 4,j)
							left[j] = getbound("left",name)
							Folders[j] = name
						endfor
							Sort  left, folders //sort the folders in order of increasing energy
					
				GlobalL = getbound("left", folders[0])
				GlobalR = getbound("right", folders[dimsize(folders,0)])
				killwaves left
				//now combine the raw data into one larger data set.
				esteps = round((endE-startE)/minstep) //get an approximate number of the energy steps in the experiment
				Make/N=(((180/anglestep)+1),esteps) CombCIS //create the combined data set
				Setscale/P x,-90,anglestep,CombCIS
				Setscale/P y,startE,minstep,CombCIS
			
				for(i=0;i<dimsize(CombCIS,1);i+=1)
				E = dimoffset(CombCIS,1)+i*dimdelta(CombCIS,1) //current energy (KE)
					if((GlobalL<=E)&&(E<=GlobalR)) //if energy lies in the right range
						goodfolders = FindfolderswithE(E,folders,stitch) //find the data folders with E in them (the good folders)
				
							for(j=0;j<dimsize(CombCIS,0);j+=1) //go through all polar angles at that energy
								theta = dimoffset(CombCIS,0)+j*dimdelta(CombCIS,0)	 
								total=0
								for(k=0;k<ItemsInList(goodfolders,";");k+=1)//go through all appropriate folders and add the intensitys of all of that energy 
									folder = StringFromList(k,goodfolders,";")
									total+=Getintensityfromdata(folder,theta,E) //obtain the combined intensity from all valid folder at this (E,theta) point
								endfor
						
								CombCIS[j][i] = total/(ItemsInList(goodfolders,";")) //insert the normalised intensity into the  array
							endfor
					endif
					
				endfor
				
				Controlinfo/W=CISpanel Ynorm
					if(V_value==1) //if normalisation is to occu
						NormaliseinY(CombCIS)
					endif
				
				For(i=0;i<numfol;i+=1)
					killdatafolder :$folders[i]
				endfor
				
				killwaves folders

			endif
			
	else
	 	DoAlert 0, "Folder is a data folder!!!"
	endif

End function


Function CisMap(data,energies,kdensity,Vo) //i dont know what this does yet. sounds good. Makes a large CIS array. 
	variable Vo //the inner potential
	variable kdensity //the number of kvalues per inverse angstrom
	wave data  ///raw CIS data scaled only to experiment step
	wave energies //the kinetic energies corresponding to each step of the CIS experiment

	variable endE = energies[numpnts(energies)-1]
	variable startE  =energies[0]
	
	variable kperpmax, kparamax,i,j,kpara,kperp,E,theta,ph
	kperpmax = sqrt((endE+Vo)/3.84) //gets the maximum k perendicular value in inverse angstroms
	kperpmax+=1 //adds one for good measure
	Kparamax = kperpmax
	Make/O/N = ((2*kparamax*kdensity)+1,(kperpmax*kdensity)+1) cisplot //create the kspace slice. Fill in its values using interpolation scheme
	Setscale/I x,-kparamax,kparamax,cisplot
	Setscale/I y,0,kperpmax,cisplot
	string folder
	
		for(i=0;i<dimsize(cisplot,0);i+=1) //step through kpara direction
			
			kpara = dimoffset(cisplot,0)+i*dimdelta(cisplot,0)
			
			for(j=0;j<dimsize(cisplot,1);j+=1) //step through kperp direction
				
				kperp = dimoffset(cisplot,1)+j*dimdelta(cisplot,1) //calculate the value of kpara and kperp you are at
				E = 3.84*((kpara)^2+(kperp)^2)-Vo //calculate the kinetic energy form the data set
				theta = sign(kpara)*(180/pi)*(asin(sqrt(((E+Vo)/3.84)-kperp^2)/(0.511*sqrt(E))))//calculate the polar emission angle from the data set
				FindLevel/Q/P energies, E
				ph=V_levelX	
				
					if(inarray(data,theta,ph)==0)
						cisplot[i][j] = Nan
					elseif(numtype(theta)==2)
						cisplot[i][j] = Nan
					else
						cisplot[i][j] = Interp2D(data,theta,ph) 
					endif
			endfor
			
		endfor

End 


Function GetIntensityFromData(folder,theta,E)
variable theta,E
string folder //the destination folder

	variable intensity

	setdatafolder  :$folder //go to the folder
	wave/Z cisensubset,cissubset
	Findlevel/Q cisensubset, E //find the non integer index value of the energy from the cisensubset array
	intensity =  Interp2D(Cissubset,theta,V_levelX)
	setdatafolder ::
	return intensity
	
end function

Function DetermineMaxKE(folderlist) //this function goes to the CIS plots folder and reads the file names an determines the maximum kinetic enrgy selected
	string folderlist
	
	variable i=0
	variable KE=0
	variable maxKE=0
	
		for(i=0;i<countobjects(getdatafolder(1),4);i+=1) //find the folder containing the energy needed
			KE = Getbound("right",stringfromlist(i,folderlist,","))
				if(KE>maxKE)
					maxKE = KE
				endif
		endfor
	return maxKE
	
end function

//Function DetermineminStep(folderlist) //this function goes to the CIS plots folder  and goes to each sub folder and get sht eminimum st
	string folderlist
	
	variable i=0
	variable KE=0
	variable maxKE=0
	
		for(i=0;i<countobjects(getdatafolder(1),4);i+=1) //find the folder containing the energy needed
			KE = Getbound("right",stringfromlist(i,folderlist,","))
				if(KE>maxKE)
					maxKE = KE
				endif
		endfor
	return maxKE
	
end function
			

Function DetermineMinKE(folderlist)
string folderlist

variable i=0
variable KE=0
variable minKE=1000 //somehow wil never get higher than this!


	for(i=0;i<countobjects(getdatafolder(1),4);i+=1) //find the folder containing the energy needed
			KE = Getbound("left",stringfromlist(i,folderlist,","))
				if(KE<minKE)
					minKE = KE
				endif
		endfor
	return minKE
	
End function

	


Function Normalise2dWave(rawwave)

wave rawwave
wavestats/Q rawwave
NVAR maxi= V_Max
rawwave = rawwave/maxi
return rawwave

end


Function/S FindFoldersWithE(energy,folders,stitch) //this function returns a list of all folders having the energy E in them. In the case of scans not overlapping, stitch is a flag that will allow interpolation between 2 adjacent scans
Variable energy
wave/t folders	
variable stitch
		
		variable i = 0, lbound, rbound,inside,globalL, globalR
		string goodfolders	= "",name,name2
		variable numfol
		
	numfol =dimsize(folders,0)
	
	
		for(i=0;i<numfol;i+=1) //find the folder containing the energy needed
		
			name = folders[i]
			name2 = folders[i+1]
			lbound = getbound("left",name)
			rbound = getbound("right",name)	
			
				if((lbound<=energy)&&(energy<=rbound)) //if the given energy lies in the range of the current folder "name"
					goodfolders+=name+";"
				elseif((stitch==1)&&(i!=numfol-1))
					lbound = getbound("left",name) //check whether the energy is lying between this folder and the next one. 
					rbound = getbound("left",name2)
						if((lbound<=energy)&&(energy<=rbound))
							goodfolders+=name+";"+name2+";"
						endif
				endif
		endfor
	
	
Return goodfolders

End

Function Getbound(side,strnum) //this fuction returns the left or right number of a string containing lnum_rnum
	string side //the lefft or rigth side of the str  num you want
	string strnum
	
	variable sepindex = strsearch(strnum,"_",0) //get the index of the separator
	variable rbound = str2num(strnum[(sepindex+1),strlen(strnum)-1])
	variable lbound = str2num(strnum[0,sepindex])
	
	
	if(cmpstr(side,"left")==0)
	return lbound
	elseif(cmpstr(side,"right")==0)
	return rbound
	endif
	
end
	
Function JoinCISData(ctrlName) : ButtonControl
	String ctrlName
		
	string curfolder = getdatafolder(1)
	string foldername
	prompt foldername,  "Process Folder Name"
	Doprompt "Enter name for CIS joining folder", foldername

		if(V_flag==0)
		
			SetUpjoinedCisProcessFolder(foldername) //create desired joining process folder
			BuildCISdatareferencelist(getdatafolder(1)) //build list of waves that are being used to join together
			wave/t refarray
			Setdatafolder :$foldername
			JoinCISwavestogether(refarray) //create the joined CIS wave inside the processed folder
			killwaves/z refarray
			wave/z Combcis
			DisplayWave(Combcis)  //display the joined wave
			Setdatafolder $curfolder
			
		endif
	
end

Function ProcessCISscan(ctrlName) : ButtonControl
	String ctrlName
	
	
	NVAR kdensity = root:Packages:CISPanelGlobs:CISincsVAL
	NVAR Vo = root:Packages:CISPanelGlobs:CISVoVAL
	string curfolder = getdatafolder(1)

	wave data = imagenametowaveref("",stringfromlist(0,imagenamelist("",";")))
	string srcfol = GetWavesDataFolder(data,1) //find the data folder where the plot/data comes from
	setdatafolder $srcfol
	
	string name = nameofwave(data) //get the name of the displayed data
	string curnote = note(data) //get any note attached to the data
	
	String Procname
	
		if(strsearch(name,"CISPlot",0)!=-1) //if the top graph contains processed data from a CIS scan
			
			variable offset = strsearch(name,"_",0)
			string realdata = name[offset+1,strlen(name)]
			wave data = $realdata //get local reference to the raw data that supplies the processed plot
			Procname = name
			GetCISenergiesfromwavenote(data)
			wave CISenergies
			
			Duplicate/O Data, data2
			Setscale/p y,0,1,data2 //give unit scaling to the duplicate wave for use in CISmap
			CISMap(data2,Cisenergies,kdensity,Vo)
			wave/z cisplot
			duplicate/o cisplot $Procname
			
		else //displayed data is raw ata
		
			Procname = "CISPlot"+"_"+nameofwave(data)
				
				if(waveexists($Procname)) //if the processed version of the wave exists, back up the note
					curnote = note($Procname)
				endif
				
			Duplicate/O Data, data2
			Setscale/p y,0,1,data2 //give unit scaling to the duplicate wave for use in CISmap
			GetCISenergiesfromwavenote(data)
			wave CISenergies
			CISMap(data2,Cisenergies,kdensity,Vo)
			wave/z cisplot
			duplicate/o cisplot $Procname
			Displaywave($Procname)
			ApplyGenCISStyle()
			
		endif
		
	
	killwaves cisplot, data2, cisenergies
	Note $Procname, curnote
	Setdatafolder $curfolder

end

Function GetCISenergiesfromwavenote(data) //this function creates a wave of cisenergies from data containgin CIS energy informatio in the wavnote
wave data

string CISenstr = GetKeyParamFromNote("CisKE",data)
string returnstring
	
		make/o/n=(ItemsInList(CISenstr,";")) CISenergies
		CISenergies[] = str2num(StringFromList(p, CISenstr,";"))
		Setscale/P x,dimoffset(data,1), dimdelta(data,1), cisenergies
End

Function RemoveCISReflectionBackground(data,BG,radindexes,smth) //this function removes  the background due to the reflection from the whole datablcok. Note that the//wave BG must exist in the folder for it to work. 
wave data //the raw data to be corrected
wave BG, radindexes
variable smth

	string dataname = nameofwave(data)+"_"+"RefSUB"
	make/O/N=(dimsize(datablock,0)) singleline,fitline
	make/O/N=3 Reffitcoeff
	reffitcoeff = {1,1,0}
	variable i,j
	variable/g RadChan

	smooth/b=(smth) 5,fitline
	Duplicate/O fitline fitlinecopy
	Duplicate/O data, data2

	variable allless=1
	
		for(i=0;i<dimsize(datablock,1);i+=1) //go up thru the data block (columns dimension)
	
			fitline[]  = BG[p][round(dimsize(BG,1)*(radindexes[i]/radindexes[(dimsize(radindexes,0)-1)]))] //take out an appropriate background reflection fit in acccordance with the radal position of the cis energy
			Singleline[] = data[p][i]		//take out a single line from the data block. ( along angle channel direction at a certain radius (depth) and column (height)	
			FuncFit/Q/H="000" FitProfile, RefFitcoeff, Singleline  //fit the reflection prfile as best as possible t the line
			fitline[] = reffitcoeff[0]*fitline[p-reffitcoeff[1]]+reffitcoeff[2]//
			allless=1
		
				Do //this loop makes sure that the backgrnd is less than the wave at all points by compressng it by a little bit each iteration until all points are less
		
					for(j=0;j<dimsize(Singleline,0);j+=1)
					
						if(fitline[j]>singleline[j]) //first value it comes across that is greater that singleline
							allless=0
						endif
				
					endfor
				
						if(allless==1)
							break
						endif
				
					fitline*=0.95
					allless=1
		
				while(1)
			
			Data2[][i] = singleline[p]-fitline[p] //replace the line in the data with the subtracted version
			fitline = fitlinecopy
		
			reffitcoeff = {1,1,0}
			Duplicate/O data2, $dataname
			Killwaves data2
endfor

End




	
	
	
	
		


	
	
	
	


