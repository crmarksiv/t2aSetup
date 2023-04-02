#Requires Autohotkey v2.0+
#SingleInstance force
;~ Script to setup or modify  your choices for your ancestry.com tree, root person and the hotkeys to be used with the T2A script. You must run this script before running T2A.ahk
;~ Definitions
 ;~ URL -For this script it will be the address of your Ansestry.com tree. When you are in Ancestry looking at your tree it will be at the top and look something like this
 ;~ ancestry.com/family-tree/person/tree/189057133/person/412456048842/facts
 ;~ Focus Person
                ;~ This is the name of a person in TMG that you wish to view in Ancestry.
;~ Tree Search
                ;~ When in Ancestry you will see two boxes just below the Ancestry logo, the second being “Tree Search”. When pressed a popup window appears and you can place a name in the input field and YOUR tree will be search for this person.  Note this is not the same as the two “Search” items on the page, one searches for a new person and the other searches for information about a  person
 ;~ Root Person
;~ This is any name you pick in your Ancestry tree. It is the starting point to be able to do the Tree Search for the  focus person.
;~ Hotkeys
            ;~ This it as set of two or more keys that will be used in T2A to Select a Focus person in TMG and trigger the action to go to Ancestry and enable you to find the Focus Person in your tree
;
;~ What the script does:
 ;~ The first time you use the script it will help you get the URL of your Root Person and define.
 ;~ your hot keys. The script will store this information into the file T2A.ini and EXIT
;~ You may use this script if you wish to change the information
;~ Outline:
;~ If t2a.ini exit
     ;~ read and report
     ;~ Ask if you wish to you change URL or Hotkeys
     ;~ if not - exit
     ;~ else
        ;~ Ask if you wish to change url
            ;~ get url and save to ini
        ;~ Ask if you wish to change hot key
            ;~ Get hotkeys and save to ini
            ;~ get new
   ;~ If it does not exits
      ;~ Get url and save to ini
      ;~ Get hotkeys and save to ini
; Release 1.0 14 Mar 2023
; rev 1.0a  add Hotkeyname to show modifies as names





Setupdone := FileExist("t2a.ini")
;setupdone := ''
;msgbox("setupdone =>" setupdone "<")
If ( setupdone = "A")
	{
		; Msgbox "read the setup"
		  hotkey1    := IniRead("t2a.ini", "main","hotkey")
		  hotkeyname := Iniread("t2a.ini","main", "hotkeyname")
		  url        := IniRead("t2a.ini","main", "url")
		  rp         := Iniread("t2a.ini","main", "RootPerson")
		  date       := Iniread("t2a.ini","info", "date")
		  path       := Iniread("t2a.ini","info", "path")
		 MsgBox "You haved defined your choices for the T2A script on " date "`nFor the Root person:" rp "`nUsing Ancestry.com tree:" url "`nAnd a your hotkeys are > " hotkeyname " <"
		 change :=  InputBox("Do you to change the Tree and/or the hotkeys, enter Y if yes", "Request to Change",,"Y")
		;MsgBox 'you said ok' change.value
		if (change.value = "Y")
			{
				url := Inputbox("Do you wish to change the ancestry tree(url), enter Y if yes", "Request to change URL",, "Y")
				;MsgBox 'you said ' url.value
				If (url.value = "Y")
				{
					;msgbox 'change url'
					xx := GetUrl(url.value)
				}
				key := InputBox("Do you wish to change your hotkeys, enter y or pess Ok if yes", "Requestg to change Hotkeys",,"Y")
				;MsgBox 'you said you want to change url' key.value
				If (key.value = "y")
				{
					;MsgBox 'change hokkey'
						GuiName		 := "Step1"
						Guisize 	 :=  "s20"
						alt :=
						Win := 0
						Ctrl := 0
						ctrlprefix := ""
						Altprefix  := ""
						Winprefix  := ""
						get := "new"
						get := Gethotkey(alt)
				}
			}

	 }
Else
 {
	 msgbox 'created the ini file'
	 xx := GetUrl(setupdone)
	 GuiName := "Step1"
	Guisize 	 :=  "s20"
	alt :=
	Win := 0
	Ctrl := 0
	ctrlprefix := ""
	Altprefix  := ""
	Winprefix  := ""
	get := "new"
	get := Gethotkey(alt)

 }

;****************************************************************************************
GetUrl(*)
{
	;*****************************************************************
	; Get Url
	MsgBox "Please logon to Ancestrey.com and select a Tree (but don't select a person yet)"
	SetTitleMatchMode 2

	run  "https://www.ancestry.com"
	sleep 2000

	WinActivate "Genealogy"   ; <<<<<<<<<<<<<<<<<<<<<<<????????????????
	;sleep 5000
	Title1 := WinGetTitle("A")
	;MsgBox("the active window is>" title1 "<")
	pos := InStr(title1,"Genealogy, Family")
	;msgbox("found at>" pos )
	If (pos != 1)
		{
			MsgBox("you went to" Title "`nPlease logon to ancestry.com and try again")
			EXIT
		}
	Msgbox("I am going to get the URL of your Ancstry.com tree `nYou should see somthing like this after you select a person in your tree`nhtps://www.ancestry.com/family-tree/person/tree/183803988/person/322420122728/facts")
	select:
	obj := InputBox("Select any person in your tree `nSo that I can get the URL `nThenSelect OK")

	Sleep 500
	;WinActivate "Genealogy"
	Title := WinGetTitle("A")
	;MsgBox("the active window is>" title "<")
	If (title = title1)
	  {
		  Msgbox("You did not select a person.nPlease select any person in your tree","Get Url","T60")
		  goto select
	  }
	winactive title
	send "^l"
	sleep 1000
	send "^c"
	sleep  500
	URL  := A_Clipboard
	;msgbox(" I got the URL of your tree, it is `," URL )
	Title3 := WinGetTitle("A")
	;Msgbox("`n The person is" TITLE3)
	parts := StrSplit(Title3,"-")
	MsgBox("`nThe root person for the Treee Search will be " parts[1] "`nAnd the URL is `n " URL)
	; Write "url"   key to "main" section of "t2a.ini"
	IniWrite url , "t2a.ini", "main", "url"

	Iniwrite  parts[1], "t2a.ini","main", "Rootperson"
	Iniwrite A_ScriptName ,"t2a.ini","info", "Script"
	IniWrite A_WorkingDir , "t2a.ini","info", "path"
	Iniwrite A_Now , "t2a.ini","info", "date"
	msgbox("Your data was saved to file t2a.ini in the diretory " A_WorkingDir )
}
;******************************************************************************************************************************
gethotkey(xxx)
{

	MsgBox("On the next screen Please define the Hotkey to use with this script `n`nPick a single key and one to three Prefixes `nThe Prefix keys are the alt key,the ctrl key and the Win key(Windows logo key)`n`nIf you use the Win key prefix alone you may not use the keys `nB, D, E, F, H, I, K, L, P, R, S ,T, W,or X `n`nIf you use the ctrl key prefix alone you can only use  keys`nF,G,J,Q,W,or Z`n`nIf you use the alt Key prefix alone you may not use the keys `nA,B,E,F,H,R or T")
	win := 0
	ctrl := 0
	letter :=""
	OK := "OK"
	win := 0
	ctrl := 0
	letter :=""
	GuiName		 := "Step1"
	Guisize 	 :=  "s20"
	GuiName	 := Gui(,GuiName)
	;set the size of the text
	GuiName.SetFont(GuiSize)
	GuiName.Add("Text", "x0","Input a Key")  ;
	GuiName.Add("Edit", "vLetter x+10 yp-5 w25 Center Limit1")
	Guiname.Add("Text"," x10 y+30","Select at Least one prefix")
	GuiName.Add("Checkbox","vAlt  x+20 yp", "Alt")
	GuiName.Add("Checkbox","vWin  x+10 yp", "Win")
	GuiName.Add("Checkbox","vctrl x+10 yp", "Ctrl")
	GuiName.Add("Button","x+10 y+30 Default ","OK").OnEvent("Click", ButtonOK)
	GuiName.Show()


	ButtonOK(*)
	{
		global get
		get := "befor buttton"
		saved := Guiname.Submit()
		letter := StrUpper(saved.letter)
		alt :=  saved.alt
		Win := saved.win
		ctrl := saved.ctrl
		ctrlprefix := ""
		Altprefix  := ""
		Winprefix  := ""

		;MsgBox(" i got to button ok letter, alt,win and ctrl are>" letter "<>" alt "<> " win "<> " ctrl "<")

		If ( letter = "")
		{
			MsgBox "you did not enter a Key, please try agin"

			GuiName.Show()
		}


		if ( (alt = 0) and ( win = 0 ) and (Ctrl = 0)  )
		{
			Msgbox " You must pick at least one Prefix, Please try again"
			GuiName.Show()
		}

	  hotkey := letter



		if (Alt = 1)
		{
				;  MsgBox "i got here 111"
				altprefix :=  "!"
				Altname := "Alt "
				 ;MsgBox(" i got to button ok letter, alt,win and ctrl are>" letter "<>" alt "<> " win "<> " ctrl "<")

				if ( (ctrl =0) and (Win = 0 ) )
					{

					;MsgBox "i got to " A_LineNumber
					foundPos := RegExMatch(letter,"i)A|B|E|F|H|R|T")
					;MsgBox ("found pos is ",foundpos)
					If (FoundPOs != 0)
						{
							msgbox("The Key combination of the Alt key and " Letter "  is a reseverd Hotkey `nIf you use the alt prefix alone you can only use may not use keys the leter keys A, B, E, F, H, R, or T`nPlease pick a new hotkey")
							GuiName.Show()
						}

					}
			}



		if (Ctrl =1)
			{
			Ctrlprefix := "^"
			Ctrlname := "Ctrl"
			if ( (alt =0) and (Win = 0 ) )
				{
				 ;MsgBox "i got to " A_LineNumber
				 ; if letter contains \,A,B,C,D,E,H,I,K,L,M,N,O,P,R,S,T,U,V,X,Y
				foundPos := RegExMatch(letter,"i)A|B|C|D|E|H|I|K|M|O|P|R|S|T|U|V|X|Y")
				;MsgBox ("found pos is ",foundpos)
				If (FoundPOs != 0)
					{
						msgbox("The Key combination of the Ctrl key and " Letter  "  is a reseverd Hotkey `nIf you use the ctrl prefix alone you can only use keys F, G, J, Q, W,or Z`nPlease pick a new hotkey")
						;Gui, Destroy
						 GuiName.Show()
					}

				}
			}


		if (Win = 1)
			{
				;MsgBox "i got to " A_LineNumber
			   Winprefix := "#"
			   Winname := "Win"
			 if  ( (alt = 0) and (ctrl = 0 ) )
			  {

				;MsgBox "i got to " A_LineNumber
				;MsgBox "winprefix is " winprefix
				;MsgBox(" i got to button ok letter, alt,win and ctrl are>" letter "<>" alt "<> " win "<> " ctrl "<")
				;if letter  contains B,D,E,F,H,I,K,L,P,R,S,T,W,X
				 foundPos := RegExMatch(letter,"i)B|D|E|F|H|I|K|L|P|R|S|W|X")
				;MsgBox ("found pos is ",foundpos)
				If (FoundPOs != 0)
					{

						Msgbox("The Keys combination of the Win key and " letter " is a reserved hotkey, `n The reserved letters are `n B, D, E, F, H, I, K, L, P, R, S, T, W, X `nPlease pick a new hotkey")
						;Gui, Destroy
						 GuiName.Show()
					}
				}
		}


	Hotkeyname := ctrlname . Altname . WinName . letter
	Hotkey := ctrlprefix . Altprefix . Winprefix . letter
	Iniwrite Hotkey, "t2a.ini","main", "Hotkey"
	Iniwrite Hotkeyname, "t2a.ini","main", "Hotkeyname"
	msgbox('Your hotkey >'  hotkeyname '< was saved to file t2a.ini in the diretory ' A_WorkingDir '`nYour are ready to run T2A')
	}
}