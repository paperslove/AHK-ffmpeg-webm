#NoEnv
;#Warn ;gotta push this to release state lol
#SingleInstance, Force
#Persistent
SetBatchLines -1
SendMode Input
DetectHiddenWindows, on
SetWorkingDir %A_ScriptDir%
IfNotExist, %A_ScriptDir%/~settings.tmp
Gosub initm8
null = 
origin = file goes here
StartTime = %null%
EndTime = %null%
croppingS = %null%
croppingE = %null%


FileRead ffmpeg, ~settings.tmp

Gui 1:Add, Edit, r1 w275 y10 vFilenamedisplay, abcdefghijklmnopqrstuvwxyz0123456789 %origin%
Gui 1:Add, Button, w+75 y10 gSelectFile, Choose file...
Gui 1:Add, Checkbox, x15 gCropbox vDoUWant2Crop, Converting only a part
Gui 1:Add, Edit, x15 w80 +ReadOnly r1 vStartTime, 00:00:01
Gui 1:Add, Text, y+-18 x+5, Start cut. hh:mm:ss[.xxx]
Gui 1:Add, Edit, x15 w80 +ReadOnly r1 vEndTime, 00:00:10
Gui 1:Add, Text, y+-18 x+5, End cut. hh:mm:ss[.xxx]

Gui 1:Add, Edit, x15 w80
Gui 1:Add, UpDown, vQuality Range1-63, 4
Gui 1:Add, Text, y+-18 x+5, Quality. 12 for gifs, 4 for video
Gui 1:Add, Edit, x15 w80
Gui 1:Add, UpDown, vRate Range1-3000, 1000
Gui 1:Add, Text, y+-18 x+5, Rate. 500 for gifs, 1500 for video
Gui 1:Add, Checkbox, x15 y+15 gSizebox vDoUWant2Size, Resize by width
Gui 1:Add, Edit, x15 w80
Gui 1:Add, UpDown, vWidth Range2-2048, 720

Gui 1:Add, Checkbox, x15 y+30 gSoundCheck vGoingon4chan, Enable sound

Gui 1:Add, Button, x15 y+20 gConvert, Convert

GuiControl, Text, Filenamedisplay, %origin%
Gui 1:Show,,oh wow you cant be this lazy
Return

SoundCheck:
GuiControlGet, Soundchecked,, Goingon4chan
if Soundchecked = 0
	{
		sound = -an
	} else 
	sound = %null%
Return

Sizebox:
GuiControlGet, Sizechecked,, DoUWant2Size
if Sizechecked = 0
	{
		GuiControl, +ReadOnly, DoUWant2Size
	} Else
	GuiControl, -ReadOnly, DoUWant2Size
Return

; Jesus fuck this is horrible, don't tell anyone you saw this
DisableEditOnResize:
GuiControl, +ReadOnly, DoUWant2Size
Return

EnableEditOnResize:
GuiControl, -ReadOnly, DoUWant2Size
Return

Cropbox:
GuiControlGet, Cropchecked,, DoUWant2Crop
if Cropchecked = 0
	{
		Gosub DisableEditsOnCrop
	} Else
	Gosub EnableEditsOnCrop
Return

; Jesus fuck this is horrible, don't tell anyone you saw this
DisableEditsOnCrop:
GuiControl, +ReadOnly, StartTime
GuiControl, +ReadOnly, EndTime
croppingS = %null%
croppingE = %null%
Return

EnableEditsOnCrop:
GuiControl, -ReadOnly, StartTime
GuiControl, -ReadOnly, EndTime
Gui 1:Submit, NoHide
croppingS = -ss %StartTime%
croppingE = -to %EndTime%
Return

SelectFile:
	FileSelectFile, origin,,,Select file to use
	GuiControl, Text, Filenamedisplay, %origin%
Return

initm8:
	FileSelectFile, location,,,Select ffmpeg.exe
	if location =
	Gosub ErrorExit
	else
	FileAppend, %location%, ~settings.tmp
Return

Convert:
Gosub SoundCheck
Gui 1:Submit, NoHide
gosub cropfix
Run %ffmpeg% -i "%origin%" %croppingS% %croppingE% -c:v libvpx -crf %quality% -b:v %rate%K -vf scale=%width%:-1  %sound% output.webm
;Run %location% -i %origin% 
Return

cropfix:
GuiControlGet, Cropchecked,, DoUWant2Crop
if Cropchecked = 0
Gosub IMBAD
Else
gosub IMBAD1
Return

IMBAD:
Sleep 10
gosub EnableEditsOnCrop
gosub DisableEditsOnCrop
Return

IMBAD1:
Sleep 10
gosub DisableEditsOnCrop
gosub EnableEditsOnCrop
Return


ErrorExit:
MsgBox, You didn't select a folder!
Reload
Return

GuiClose:
Quit:
ExitApp
