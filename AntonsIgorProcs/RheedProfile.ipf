#pragma rtGlobals=1		// Use modern global access method.


Function RemoveTrace(ctrlName) : ButtonControl
	String ctrlName
	
	RemoveFromGraph/Z ytrace vs xtrace

End

Function load(ctrlName) : ButtonControl
	String ctrlName
	
	Variable refnum
	String path= StrVarOrDefault("root:images","")
	if( CmpStr(path,"_current_")==0 )
		Open/R/T="????" refnum
	else
		Open/R/P=$path/T="????" refnum
	endif
	
	if(refnum==0)
		return 0
	endif
	
	FStatus refnum
	string fullpath = S_path+S_fileName
	print "Image load from",fullpath
	variable dotindex = strsearch(S_Filename, ".",0)
	string dfoldername = S_fileName[0,dotindex-1]
	newdatafolder root:$dfoldername
	setdatafolder root:$dfoldername
	ImageLoad/O/T=jpeg fullpath
//	wave/Z datawave = $(S_Filename)
	//Rename datawave $dfoldername
	setdatafolder root:

End

Window ImageOptions() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(465.75,110.75,794.25,311)
	ShowTools
	SetDrawLayer UserBack
	Button AddTrace,pos={10,10},size={80,20},proc=ButtonProc_2,title="AddTrace"
	Button RemoveTrace,pos={10,36},size={80,20},title="RemoveTrace"
	Button ProfileTrace, pos = {10,92}, size = {80,20}, title="ProfileTraceButton"
	SetVariable setvar0 size={90,20},title="SmoothSize",limits={0,20,1},value= K0
	SetVariable setvar1 size={90,20},title="Passes",limits={0,Inf,1},value= K1
	SetVariable setvar2 size={150,20},title="ProfileWidth(Pixels)",limits={0,Inf,1}, value = K3;DelayUpdate
	

Function AddTrace2(ctrlName) : ButtonControl
	String ctrlName

RemoveFromGraph/Z ytrace vs xtrace	
Make/O/N=2   xtrace = {hcsr(A),hcsr(B)}, ytrace = {vcsr(A),vcsr(B)}
AppendToGraph ytrace vs xtrace


End

Function DisplayInfo(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	if  (checked == 1)
	showinfo
	else
	hideinfo
	endif

End

Function ProfileTrace()

	NVAR K0  //smooth box size
	NVAR K1 //smooth box passes
	NVAR K3 //pixel width for profile algorithmstring curwinname =  winname(0,1)[6,20]   
	string imagename= stringfromlist(0,imagenamelist("",";"),";")
	wave imagewave = imagenametowaveref("",imagename)
	string imagewavename=nameofwave(imagewave)

	Make/O/N=2   xtrace = {hcsr(A),hcsr(B)}, ytrace = {vcsr(A),vcsr(B)}
	ImageLineProfile xWave=xtrace, yWave= ytrace, srcwave=imagewave, width = K3
 
	string datafoldername = getdatafolder(0)[1,(strsearch(getdatafolder(0),"'",1))-1]
	WAVE M_ImageLineProfile
	variable i
	Make/O/N=(dimsize(M_Imagelineprofile,0)) Profile
		
		for(i=0;i<dimsize(M_Imagelineprofile,0);i+=1)
			profile[i] = M_Imagelineprofile[i][1]
		endfor
		
	smooth/b=(K0) K1, Profile //smooth the profile
	string windowsname = "Profile"+"_"+datafoldername
	string currentwins = winlist("*",";", "WIN:1")
	variable existing = WhichListItem(windowsname, currentwins,";")
		
		if(existing==-1) //if windw does not exist already displaying the profile, create one
			Display/k=1 Profile 
			ModifyGraph mode(Profile)=2,lsize(Profile)=2, rgb=(16384,28160,65280)
			Dowindow/C $windowsname
			Dowindow/T $windowsname, windowsname
			Setwindow kwtopwin, note = getdatafolder(1), hook = ActivateImageWindow
		else
		
			///removefromgraph/W=$windowsname/Z Profile //remove previous graph
			//Appendtograph/W=$windowsname Profile //add new one
			//ModifyGraph mode(Profile)=2,lsize(Profile)=2, rgb=(16384,28160,65280)
			
			
		
		endif
End

Function Profiletracebutton(ctrlName) : ButtonControl
	String ctrlName 
	
	Profiletrace()
	
end
	
	

Function ActivateImageWindow(infostr) //window hook function to set to the data folder that the waves come from
	string infostr
	
	variable statuscode
	string infostring
	
	string event = StringByKey("EVENT",infoStr)
	string windowstatus = stringfromlist(0,event,";")
	string mousestatus = stringfromlist(1,event,";")
	string shiftkeystat = Stringbykey("MODIFIERS",infostr)
	
		if(stringmatch(windowstatus,"activate")==1)
			getwindow kwtopwin, note
			SVAR datafolder = S_value
			setdatafolder S_Value
			
			
		endif 
		
		if(stringmatch(shiftkeystat,"4")==1)
			Profiletrace()
		endif
		
	//	if(stringmatch(windowstatus,"deactivate")==1)
	//		Setwindow kwtopwin hook = $""
	//	endif
		
	return statuscode
	
end

Function ButtonProc(ctrlName) : ButtonControl
	String ctrlName
	
	string imagename = stringfromlist(0,wavelist("*JPG",";",""),";")
	variable offset = strsearch(imagename, ".",0)
	string imagename2 = "Image"+"_"+imagename[0,offset-1] //get the name minus .jpg
	Display/k=1
	Dowindow/C $imagename2
	Appendimage $imagename
	dowindow/T $imagename2 imagename2
	variable csr  
	setwindow kwtopwin, note  = getdatafolder(1), hook = ActivateImageWindow, hookevents = 1, hookcursor = 1
	showinfo

end
	
	
	
	
