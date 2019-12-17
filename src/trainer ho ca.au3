#cs
	[CWAutCompFileInfo]
	Company=Lam Han
	Copyright=© KLH
	Description=KLH Trainer
	Version=1.0.0.0
	ProductName=Cheat Insaniquarium Deluxe
	ProductVersion=1.0.0.0
#ce

#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#include <NomadMemoryFix.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("KLH-KTrainer v1.0.0", 298, 364, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Shell = GUICtrlCreateLabel("Shell :", 40, 136, 66, 29)
GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
$ibShell = GUICtrlCreateInput("", 118, 136, 145, 32)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "ibShellChange")
$money = GUICtrlCreateLabel("Money :", 24, 179, 82, 29)
GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
$ibMoney = GUICtrlCreateInput("", 118, 179, 129, 32)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "ibMoneyChange")
$Label1 = GUICtrlCreateLabel("Food :", 42, 226, 66, 29)
GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Food :", 42, 269, 66, 29)
GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
$ibFood = GUICtrlCreateInput("0", 118, 269, 145, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Icon1 = GUICtrlCreateIcon("InsaniquariumDeluxe.exe", -1, 32, 40, 48, 48)
GUICtrlSetOnEvent($Icon1, "Icon1Click")
$Updown1 = GUICtrlCreateUpdown($ibFood)
GUICtrlSetLimit(-1, 15, 1)
GUICtrlSetOnEvent(-1, "Updown1Change")
$Label3 = GUICtrlCreateLabel("KTrainer KLH", 157, 22, 128, 26)
GUICtrlSetFont(-1, 14, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label4 = GUICtrlCreateLabel("Insaniquarium Deluxe", 118, 51, 176, 23)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label8 = GUICtrlCreateLabel("v1.0.0 ® KLH", 208, 78, 78, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$food = GUICtrlCreateCombo("", 120, 228, 145, 25, $CBS_DROPDOWNLIST,$ES_READONLY)
GUICtrlSetData(-1, "Snack|Thức ăn viên|Thuốc")
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
GUICtrlSetOnEvent(-1,"comboSelect")
$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
_GUICtrlStatusBar_SetSimple($StatusBar1)
_GUICtrlStatusBar_SetText($StatusBar1, "   "&@TAB&"Yêu LAMHAN")
_GUICtrlStatusBar_SetMinHeight($StatusBar1, 17)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


Global $value, $iv_Pid, $ah_Handle, $tit
Const $iv_Address = 0x058D630
Dim $offsetTien[3] = [0x00,0x0620,0x03C0]
Dim $offsetShell[5] = [ 0x00 , 0x0798 , 0x08 , 0x00 , 0x070]
$d = 0

getDatafGame()
GUISetState(@SW_DISABLE, $Form1)
MsgBox(64, "About", " __  __     __     ______   " & @CRLF & "/\ \/ /    /\ \   /\___  \  " & @CRLF & "\ \  _\-.  \ \ \  \/_/  /__ " & @CRLF & " \ \_\ \_\  \ \_\   /\_____\" & @CRLF & "  \/_/\/_/   \/_/   \/_____/" & @CRLF & "	" & @CRLF & "Trainer by: nhokKiZ © " & @YEAR & @CRLF & " + èn Lam Hân" & @CRLF & " + Version : 1.0.0" & @CRLF & " + fb.com/troller.oggy" & @CRLF & @TAB & "--== AnbuSystem ==--")
MsgBox(64, "Help","Enter để sửa" &@CRLF& "Yêu em",5)
GUISetState(@SW_ENABLE, $Form1)
WinActivate($Form1)


While 1
	Sleep(2000)
	getDatafGame()
WEnd

Func Form1Close()
	_MemoryClose($ah_Handle)
	Exit
EndFunc
Func getDatafGame()
	If Checkgame() = 1 Then
		GUICtrlSetState($ibMoney, $GUI_ENABLE)
		GUICtrlSetState($ibFood, $GUI_ENABLE)
		GUICtrlSetState($ibShell, $GUI_ENABLE)
		GUICtrlSetState($food, $GUI_ENABLE)
		If WinGetState($Form1) <> 15 Then
		Local $temp = _MemoryPointerRead($iv_Address, $ah_Handle, $offsetTien)
		GUICtrlSetData($ibMoney, $temp[1])
		$temp = _MemoryPointerRead ( $iv_Address, $ah_Handle, $offsetShell)
		GUICtrlSetData($ibShell, $temp[1])
		$temp = _MemoryRead(0x0584658, $ah_Handle)
		GUICtrlSetData($ibFood, $temp)
		$temp = _MemoryRead(0x058D0DC, $ah_Handle)
		comboFood($temp)
		EndIf
		$d = 1
	Else
		GUICtrlSetState($ibMoney, $GUI_DISABLE)
		GUICtrlSetState($ibFood, $GUI_DISABLE)
		GUICtrlSetState($ibShell, $GUI_DISABLE)
		GUICtrlSetState($food, $GUI_DISABLE)
		If $d = 1 Then
		MsgBox($MB_APPLMODAL,"KLH - Insaniquarium Deluxe Trainer","Không tìm thấy game !!",10)
		$d = 2
		EndIf
	EndIf
EndFunc

Func comboFood($x)
		If @error = 0 Then
			Switch $x
				Case 0
					GUICtrlSetData($food,"Snack")
				case 1
					GUICtrlSetData($food,"Thức ăn viên")
				case 2
					GUICtrlSetData($food,"Thuốc")
			EndSwitch
		Else
			MsgBox(16,"Error","Lỗi cực mạnh... Thoát chương trình")
			Exit
		EndIf
EndFunc


Func checkGame()
	if ProcessExists("InsaniquariumDeluxe.exe") Then
		$iv_Pid = ProcessExists("InsaniquariumDeluxe.exe")
		$ah_Handle = _MemoryOpen($iv_Pid)
		_GUICtrlStatusBar_SetText($StatusBar1, "  Yêu LAMHAN --"&@TAB&"Game is running")
		Return 1
	Else
		_MemoryClose($ah_Handle)
		_GUICtrlStatusBar_SetText($StatusBar1, "  Yêu LAMHAN --"&@TAB&"Game not running")
		Sleep(700)
		Return 0
	EndIf
EndFunc

func ibMoneyChange()
	local $value = GUICtrlRead($ibMoney)
	If StringIsDigit($value) And $value < 100000 Then
	_MemoryPointerWrite($iv_Address, $ah_Handle, $offsetTien, $value)
	getDatafGame()
		Else
	MsgBox(16,"Error data type","Only number accepted or value bigger than 100k")
	EndIf
EndFunc

Func ibShellChange()
	local $value = GUICtrlRead($ibShell)
	If StringIsDigit($value) And $value < 100000 Then
	_MemoryPointerWrite($iv_Address, $ah_Handle, $offsetShell, $value)
	getDatafGame()
		Else
	MsgBox(16,"Error data type","Only number accepted or value bigger than 100k")
	EndIf
EndFunc

Func comboSelect()
	local $value
	Switch GUICtrlRead($food)
		Case "Snack"
			$value = 0
		Case "Thức ăn viên"
			$value = 1
		Case "Thuốc"
			$value = 2
	EndSwitch
	_MemoryWrite(0x058D0DC,$ah_Handle,$value)
EndFunc
Func Icon1Click()
	GUISetState(@SW_DISABLE, $Form1)
	If ProcessExists("InsaniquariumDeluxe.exe") Then
		WinActivate("Insaniquarium Deluxe 1.0")
		GUISetState(@SW_ENABLE, $Form1)
	Else
		If FileExists("InsaniquariumDeluxe.exe") Then
			Run("InsaniquariumDeluxe.exe")
			$tit = WinWait("Insaniquarium Deluxe 1.0","",10)
			WinSetTitle($tit,"","KLH - Nuôi cá")
			GUISetState(@SW_ENABLE, $Form1)
			WinActivate($Form1)
			;getDatafGame()
		Else
			MsgBox(16, "Lỗi", "Không tìm thấy game" & @CRLF & " - Hãy copy vào thư mục game" & @CRLF & " - Biểu tượng game sẽ xuất hiện trong trainer", 5)
			GUISetState(@SW_ENABLE, $Form1)
		EndIf
	EndIf
EndFunc

Func Updown1Change()
	$value = GUICtrlRead($ibFood)
	_MemoryWrite(0x0584658, $ah_Handle, $value)
	If $value = 12 Then
		MsgBox(0,"KLH Trainer","Cheat hơi sâu đó em iu <3")
	EndIf
EndFunc
