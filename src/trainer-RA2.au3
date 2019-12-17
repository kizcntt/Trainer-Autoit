#cs
	[CWAutCompFileInfo]
	Company=
	Copyright=NhokKiZ
	Description=Trainer Cheat
	Version=1
	ProductName=
	ProductVersion=1
#ce
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <NomadMemory.au3>
#include<Array.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Hack money RA2 By Kiz", 345, 163, 871, 484)
GUISetFont(8, 800, 0, "MS Sans Serif")
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
$txtMoney = GUICtrlCreateInput("", 24, 72, 289, 21)
GUICtrlSetLimit(-1, 8)
$Label1 = GUICtrlCreateLabel("Hack money Red Alert 2", 16, 8, 245, 28)
GUICtrlSetFont(-1, 16, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFF0000)
$btnTest = GUICtrlCreateButton("Exit Game", 196, 104, 120, 49, $WS_GROUP)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "btnTestClick")
$btnHack = GUICtrlCreateButton("Add", 24, 104, 161, 49, $WS_GROUP)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "btnHackClick")
$Input1 = GUICtrlCreateInput("", 24, 39, 289, 21)
GUICtrlSetBkColor(-1, 0xA6CAF0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $value, $iv_Pid , $ah_Handle , $x
Const $av_Offset[2] = [0x0,0x24C]
Const $iv_Address = 0x0A1E0C4 ;0x00531EDC
Global $k

checkGame()
HotKeySet("{NUMPADADD}","hotKey")


While 1
	Sleep(1000)
	If checkGame() == 1 Then
		If WinGetState($Form1_1) == 15 Then
			readMemory()
		EndIf
	EndIf
WEnd

Func hotKey()
   GUICtrlSetData($txtMoney,"30000")
   btnHackClick()
EndFunc

Func btnHackClick()
	checkGame()
	hackMemory()
    readMemory()
EndFunc

Func btnTestClick()
	ProcessClose("game.exe")
EndFunc


Func Form1_1Close()
	  Exit
EndFunc


Func checkGame()
	if ProcessExists("game.exe") Then
		$iv_Pid = ProcessExists("game.exe")
		If  GUICtrlRead($Input1) == '' Then
		readMemory()
		EndIf
		Return 1
	Else
		$k = MsgBox(5,"Không tìm thấy game","Bấm retry để chờ game chạy trong 5s" ,5)
			if $k == 4 Then
			Sleep(5000)
			checkGame()
			Else
				MsgBox(16,"Lỗi","Không tìm thấy game" ,2)
				Exit
			EndIf
		EndIf
EndFunc

Func readMemory()
		    $ah_Handle = _MemoryOpen($iv_Pid)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ah_Handle = ' & $ah_Handle & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			local $data = _MemoryPointerRead($iv_Address, $ah_Handle, $av_Offset ,"dword")
			If $data[1] <> Null Then
					GUICtrlSetData($Input1,$data[1])
			EndIf
			;local $data = _MemoryRead($iv_Address,$ah_Handle)
			_MemoryClose($ah_Handle)
EndFunc

Func hackMemory()
	$ah_Handle = _MemoryOpen($iv_Pid)
    $value = GUICtrlRead($txtMoney) + GUICtrlRead($Input1)
    if $value < 10000000 then
    _MemoryPointerWrite ($iv_Address, $ah_Handle, $av_Offset, $value)
    _MemoryClose($ah_Handle)
	EndIf
EndFunc
