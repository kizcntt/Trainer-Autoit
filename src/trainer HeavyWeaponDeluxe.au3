#cs
	[CWAutCompFileInfo]
	Company=KLH Trainer
	Copyright=@ 2019
	Description=v1.0.2
	Version=1.0.2
	ProductName=KLH Trainer
	ProductVersion=1.0.2
#ce




#NoTrayIcon
#AutoIt3Wrapper_Run_Obfuscator=Y
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <NomadMemory.au3>
#include <ConsoleIT\ConsoleIT.au3>

Opt("GUIOnEventMode", 1)
Dim $checkStart, $Form2

HotKeySet("{NUMPAD3}","superWeapon")
HotKeySet("{NUMPAD2}","testF")
HotKeySet("{NUMPAD1}","setFull")

#Region ### START Koda GUI section ###
$Form1 = GUICreate("KLH v1 KTrainer > Heavy Weapon Deluxe", 257, 417, 192, 124)
GUISetBkColor(0x383838)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$ipNuke = GUICtrlCreateInput("0", 123, 120, 116, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetColor(-1, 0xE20005)
GUICtrlSetBkColor(-1, 0xC0C0C0)
$Updown1 = GUICtrlCreateUpdown($ipNuke)
GUICtrlSetLimit(-1, 7, 0)
GUICtrlSetOnEvent(-1, "Updown1Change")
$ipShield = GUICtrlCreateInput("0", 123, 150, 116, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetColor(-1, 0xE20005)
GUICtrlSetBkColor(-1, 0xC0C0C0)
$Updown2 = GUICtrlCreateUpdown($ipShield)
GUICtrlSetLimit(-1, 4, 0)
GUICtrlSetOnEvent(-1, "Updown2Change")
$Icon1 = GUICtrlCreateIcon("Heavy Weapon Deluxe.exe", -0, 8, 16, 48, 48)
$ipLive = GUICtrlCreateInput("0", 123, 180, 115, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetColor(-1, 0xE20005)
GUICtrlSetBkColor(-1, 0xC0C0C0)
$Updown3 = GUICtrlCreateUpdown($ipLive)
GUICtrlSetLimit(-1, 2, 0)
GUICtrlSetOnEvent(-1, "Updown3Change")
$Label1 = GUICtrlCreateLabel("KTrainer KLH", 127, 16, 128, 26)
GUICtrlSetFont(-1, 14, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label2 = GUICtrlCreateLabel("Heavy Weapon Deluxe", 70, 45, 176, 23)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label3 = GUICtrlCreateLabel("Nuke bomb", 8, 120, 94, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label4 = GUICtrlCreateLabel("Shield", 8, 150, 54, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label5 = GUICtrlCreateLabel("Lives", 8, 180, 34, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$Input4 = GUICtrlCreateInput("", 8, 248, 233, 24)
GUICtrlSetFont(-1, 10, 800, 2, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetLimit(-1, 8)
$Label6 = GUICtrlCreateLabel("Score :", 8, 220, 61, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$Skill = GUICtrlCreateButton("Skill", 8, 288, 121, 49)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "SkillClick")
$Button1 = GUICtrlCreateButton("About", 139, 288, 105, 49)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Button1Click")
$Button2 = GUICtrlCreateButton("Start game", 8, 344, 236, 41)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Button2Click")
$Label8 = GUICtrlCreateLabel("v1.0.2 ® KLH", 165, 72, 102, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label22 = GUICtrlCreateLabel("game not running", 128, 392, 112, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFF3333)
#EndRegion ### END Koda GUI section ###
GUISetState(@SW_SHOW)
Global $value, $iv_Pid, $iv_Address, $ah_Handle, $tit, $click
getDatafGame()

HotKeySet("{NUMPADADD}", setScore)

While 1
	Sleep(3500)
	;Checkgame()
	getDatafGame()
WEnd



Func Checkgame()
	If WinGetProcess("Heavy Weapon Deluxe 1.0") = -1 Then
		GUICtrlSetData($Label22, "game not running")
		GUICtrlSetColor($Label22, 0xFF3333)
		$ah_Handle = _MemoryOpen($iv_Pid)
		_MemoryClose($ah_Handle)
		Return 0
	Else
		$iv_Pid = WinGetProcess("Heavy Weapon Deluxe 1.0")
		$ah_Handle = _MemoryOpen($iv_Pid)
		GUICtrlSetData($Label22, "game is running")
		GUICtrlSetColor($Label22, 0x00C914)
		Return 1
	EndIf
EndFunc   ;==>Checkgame
Func getDatafGame()
	If Checkgame() = 1 Then
		Local $temp = _MemoryRead(0x056BB08, $ah_Handle)
		GUICtrlSetData($ipNuke, $temp)
		$temp = _MemoryRead(0x056BB04, $ah_Handle)
		GUICtrlSetData($ipLive, $temp)
		$temp = _MemoryRead(0x056BB0C, $ah_Handle)
		GUICtrlSetData($ipShield, $temp)
		If WinGetState($Form1) <> 15 Then
			$temp = _MemoryRead(0x056BAFC, $ah_Handle)
			GUICtrlSetData($Input4, $temp)
		EndIf
		GUICtrlSetState($ipNuke, $GUI_ENABLE)
		GUICtrlSetState($ipLive, $GUI_ENABLE)
		GUICtrlSetState($ipShield, $GUI_ENABLE)
		GUICtrlSetState($Input4, $GUI_ENABLE)
	Else
		GUICtrlSetData($ipNuke, "0")
		GUICtrlSetData($ipLive, "0")
		GUICtrlSetData($ipShield, "0")
		GUICtrlSetData($Input4, "NONE")
		GUICtrlSetState($ipNuke, $GUI_DISABLE)
		GUICtrlSetState($ipLive, $GUI_DISABLE)
		GUICtrlSetState($ipShield, $GUI_DISABLE)
		GUICtrlSetState($Input4, $GUI_DISABLE)
	EndIf
EndFunc   ;==>getDatafGame
Func Button1Click()
	GUISetState(@SW_DISABLE, $Form1)
	MsgBox(64, "About", " __  __     __     ______   " & @CRLF & "/\ \/ /    /\ \   /\___  \  " & @CRLF & "\ \  _\-.  \ \ \  \/_/  /__ " & @CRLF & " \ \_\ \_\  \ \_\   /\_____\" & @CRLF & "  \/_/\/_/   \/_/   \/_____/" & @CRLF & "	" & @CRLF & "Trainer by: nhokKiZ © " & @YEAR & @CRLF & " + èn Lam Hân" & @CRLF & " + Version : 1.0.2" & @CRLF & " + fb.com/troller.oggy" & @CRLF & @TAB & "--== AnbuSystem ==--")
	MsgBox(0, "Hướng dẫn", "Để sử dụng hack điểm : " & @CRLF & " - Nhập điểm vào ô điểm sau đó bấm nút cộng '+' bên numpad" & @CRLF & @CRLF & "Hotkey :"& @CRLF &"- numpad 1: Full bom , shield , life"&@CRLF&"- numpad 2: Inf Shield" &@CRLF& "- numpad 3: Instant super weapon", 10)
	GUISetState(@SW_ENABLE, $Form1)
	WinActivate($Form1)
EndFunc   ;==>Button1Click
Func Button2Click()
	GUISetState(@SW_DISABLE, $Form1)
	If ProcessExists("Heavy Weapon Deluxe.exe") Then
		WinActivate("Heavy Weapon Deluxe 1.0")
		GUISetState(@SW_ENABLE, $Form1)
		$checkStart = 1
	Else
		If FileExists("Heavy Weapon Deluxe.exe") Then
			Run("Heavy Weapon Deluxe.exe")
			$tit = WinWait("Heavy Weapon Deluxe 1.0","",10)
			WinSetTitle($tit,"","Heavy Weapon Deluxe - KLH")
			GUISetState(@SW_ENABLE, $Form1)
			WinActivate($Form1)
			getDatafGame()
		Else
			MsgBox(16, "Lỗi", "Không tìm thấy game" & @CRLF & " - Hãy copy vào thư mục game" & @CRLF & " - Biểu tượng game sẽ xuất hiện trong trainer", 5)
			GUISetState(@SW_ENABLE, $Form1)
			$checkStart = 0
		EndIf
	EndIf
EndFunc   ;==>Button2Click
Func Form1Close()
	_MemoryClose($ah_Handle)
	Exit
EndFunc   ;==>Form1Close
Func SkillClick()
	If FileExists("Heavy Weapon Deluxe.exe") Then
		$Form2 = GUICreate("Armory Cheat > KLH v1 KTrainer ", 625, 450, 182, 125, $WS_SYSMENU, -1, $Form1)
		GUISetBkColor(0x000000)
		GUISetOnEvent($GUI_EVENT_CLOSE, "Form2Close")
		$Pic1 = GUICtrlCreatePic("Images\armory.jpg", 0, 0, 625, 449)
		GUICtrlSetState(-1, $GUI_DISABLE)
		Global $text1 = GUICtrlCreateLabel("0", 32, 40, 14, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFF00)
		Global $text2 = GUICtrlCreateLabel("0", 31, 133, 14, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFF00)
		Global $text3 = GUICtrlCreateLabel("0", 31, 229, 14, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFF00)
		Global $text4 = GUICtrlCreateLabel("0", 580, 43, 14, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFF00)
		Global $text5 = GUICtrlCreateLabel("0", 578, 135, 14, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFF00)
		Global $text6 = GUICtrlCreateLabel("0", 580, 228, 14, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFF00)
		$btnAdd1 = GUICtrlCreateLabel(" ", 144, 32, 30, 22)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetOnEvent(-1, "btnAdd1Click")
		$btnSub1 = GUICtrlCreateLabel(" ", 144, 58, 30, 22)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetOnEvent(-1, "btnSub1Click")
		$btnAdd2 = GUICtrlCreateLabel(" ", 144, 123, 28, 25)
		GUICtrlSetOnEvent(-1, "btnAdd2Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnSub2 = GUICtrlCreateLabel(" ", 144, 152, 28, 25)
		GUICtrlSetOnEvent(-1, "btnSub2Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnAdd3 = GUICtrlCreateLabel(" ", 144, 216, 28, 25)
		GUICtrlSetOnEvent(-1, "btnAdd3Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnSub3 = GUICtrlCreateLabel(" ", 144, 244, 28, 25)
		GUICtrlSetOnEvent(-1, "btnSub3Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnAdd4 = GUICtrlCreateLabel("", 452, 32, 30, 22)
		GUICtrlSetOnEvent(-1, "btnAdd4Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnSub4 = GUICtrlCreateLabel("", 452, 58, 30, 22)
		GUICtrlSetOnEvent(-1, "btnSub4Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnAdd5 = GUICtrlCreateLabel("", 453, 125, 30, 22)
		GUICtrlSetOnEvent(-1, "btnAdd5Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnSub5 = GUICtrlCreateLabel("", 453, 152, 30, 22)
		GUICtrlSetOnEvent(-1, "btnSub5Click")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$btnAdd6 = GUICtrlCreateLabel("", 453, 219, 30, 22)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetOnEvent(-1, "btnAdd6Click")
		$btnSub6 = GUICtrlCreateLabel("", 453, 245, 30, 22)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetOnEvent(-1, "btnSub6Click")
		$text7 = GUICtrlCreateLabel("Skill cheat :", 240, 88, 111, 28)
		GUICtrlSetFont(-1, 14, 800, 4, "MS Sans Serif")
		GUICtrlSetColor(-1, 0xFFFFFF)
		$text8 = GUICtrlCreateLabel("Đợi game vào màn hình Armory", 240, 120, 148, 17)
    GUICtrlSetColor(-1, 0xFFFFFF)
    $text9 = GUICtrlCreateLabel("- Chỉ nâng khi đã mở skill", 240, 140, 148, 17)
    GUICtrlSetColor(-1, 0xFFFFFF)
    $text9a = GUICtrlCreateLabel("để tránh crash game", 240, 152, 148, 17)
    GUICtrlSetColor(-1, 0xFFFFFF)
		GUISetState(@SW_DISABLE, $Form1)
    GUISetState(@SW_SHOW, $Form2)
    Sleep(250)
    readArmory()
	Else
		Sleep(200)
			MsgBox(48,"Error","Copy vào thư mục game để sử dụng chức năng này !!")
	EndIf
EndFunc   ;==>SkillClick
Func setScore()
	If WinGetState($Form1) == 15 Then
		$value = GUICtrlRead($Input4)
		If StringIsDigit($value) Then
		_MemoryWrite(0x056BAFC, $ah_Handle, $value)
		Else
		MsgBox(16,"Error data type","Only number accepted")
		local $temp = _MemoryRead(0x056BAFC, $ah_Handle)
		GUICtrlSetData($Input4, $temp)
		EndIf
	EndIf
EndFunc   ;==>setScore
Func Updown1Change()
	$value = GUICtrlRead($ipNuke)
	_MemoryWrite(0x056BB08, $ah_Handle, $value)
EndFunc   ;==>Updown1Change
Func Updown2Change()
	$value = GUICtrlRead($ipShield)
	_MemoryWrite(0x056BB0C, $ah_Handle, $value)
EndFunc   ;==>Updown2Change
Func Updown3Change()
	$value = GUICtrlRead($ipLive)
	_MemoryWrite(0x056BB04, $ah_Handle, $value)
EndFunc   ;==>Updown3Change
Func readArmory()
  Local $res = _MemoryRead(0x056BB20, $ah_Handle)
  GUICtrlSetData($text1,$res)
  $res = _MemoryRead(0x056BB24, $ah_Handle)
  GUICtrlSetData($text2,$res)
  $res = _MemoryRead(0x056BB28, $ah_Handle)
  GUICtrlSetData($text3,$res)
  $res = _MemoryRead(0x056BB2C, $ah_Handle)
  GUICtrlSetData($text4,$res)
  $res = _MemoryRead(0x056BB30, $ah_Handle)
  GUICtrlSetData($text5,$res)
  $res = _MemoryRead(0x056BB34, $ah_Handle)
  GUICtrlSetData($text6,$res)
EndFunc
Func csArmory($x, $y)
	If $x <= 3 Then
		Switch $y
			Case 1
				_MemoryWrite(0x056BB20, $ah_Handle, $x)
				Sleep(100)
			Case 2
				_MemoryWrite(0x056BB24, $ah_Handle, $x)
				Sleep(100)
			Case 3
				_MemoryWrite(0x056BB28, $ah_Handle, $x)
				Sleep(100)
			Case 4
				_MemoryWrite(0x056BB2C, $ah_Handle, $x)
				Sleep(100)
			Case 5
				_MemoryWrite(0x056BB30, $ah_Handle, $x)
				Sleep(100)
			Case 6
				_MemoryWrite(0x056BB34, $ah_Handle, $x)
				Sleep(100)
			Case Else
				MsgBox(16, "Error !!!", "Error from game : 0x298D2149", 5)
				Form2Close()
    EndSwitch
      readArmory()
	Else
		MsgBox(16, "Error data: 0x00" & Random(19, 100000, 1) & "", "Wrong data in game", 3)
		Form2Close()
	EndIf
EndFunc   ;==>csArmory
#Region button form 2
Func btnAdd1Click()
	local $x = GUICtrlRead($text1)
	If $x < 3 Then
    $x += 1
		GUICtrlSetData($text1,$x)
    csArmory($x,1)
	EndIf
EndFunc   ;==>btnAdd1Click
Func btnAdd2Click()
	local $x = GUICtrlRead($text2)
	If $x < 3 Then
    $x += 1
		GUICtrlSetData($text2,$x)
    csArmory($x,2)
  EndIf
EndFunc   ;==>btnAdd2Click
Func btnAdd3Click()
  local $x = GUICtrlRead($text3)
	If $x < 3 Then
    $x += 1
		GUICtrlSetData($text3,$x)
    csArmory($x,3)
  EndIf
EndFunc   ;==>btnAdd3Click
Func btnAdd4Click()
	local $x = GUICtrlRead($text4)
	If $x < 3 Then
    $x += 1
		GUICtrlSetData($text4,$x)
    csArmory($x,4)
  EndIf
EndFunc   ;==>btnAdd4Click
Func btnAdd5Click()
	local $x = GUICtrlRead($text5)
	If $x < 3 Then
    $x += 1
		GUICtrlSetData($text5,$x)
    csArmory($x,5)
  EndIf
EndFunc   ;==>btnAdd5Click
Func btnAdd6Click()
	local $x = GUICtrlRead($text6)
	If $x < 3 Then
    $x += 1
		GUICtrlSetData($text6,$x)
    csArmory($x,6)
  EndIf
EndFunc   ;==>btnAdd6Click
Func btnSub1Click()
  local $x = GUICtrlRead($text1)
	If $x > 0 Then
    $x -= 1
		GUICtrlSetData($text1,$x)
    csArmory($x,1)
	EndIf
EndFunc   ;==>btnSub1Click
Func btnSub2Click()
  local $x = GUICtrlRead($text2)
	If $x > 0 Then
    $x -= 1
		GUICtrlSetData($text2,$x)
    csArmory($x,2)
	EndIf
EndFunc   ;==>btnSub2Click
Func btnSub3Click()
	local $x = GUICtrlRead($text3)
	If $x > 0 Then
    $x -= 1
		GUICtrlSetData($text3,$x)
    csArmory($x,3)
  EndIf
EndFunc
Func btnSub4Click()
	local $x = GUICtrlRead($text4)
	If $x > 0 Then
    $x -= 1
		GUICtrlSetData($text4,$x)
    csArmory($x,4)
  EndIf
EndFunc   ;==>btnSub4Click
Func btnSub5Click()
	local $x = GUICtrlRead($text5)
	If $x > 0 Then
    $x -= 1
		GUICtrlSetData($text5,$x)
    csArmory($x,5)
  EndIf
EndFunc   ;==>btnSub5Click
Func btnSub6Click()
	local $x = GUICtrlRead($text6)
	If $x > 0 Then
    $x -= 1
		GUICtrlSetData($text6,$x)
    csArmory($x,6)
  EndIf
EndFunc   ;==>btnSub6Click

Func Form2Close()
	GUIDelete($Form2)
  GUISetState(@SW_ENABLE, $Form1)
EndFunc   ;==>Form2Close
#EndRegion button form 2

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
Func setFull()
	;Nuke set
	_MemoryWrite(0x056BB08, $ah_Handle, 10)
	;Shield set
	_MemoryWrite(0x056BB0C, $ah_Handle, 4)
	;Live set
	_MemoryWrite(0x056BB04, $ah_Handle, 2)
	;Spread set
	_MemoryWrite(0x056BB1C, $ah_Handle, 4)
	;Rapid fire set
	_MemoryWrite(0x056BB18, $ah_Handle, 4)
	;Power set
	If _MemoryRead(0x056BB14,$ah_Handle) < 4 Then
	_MemoryWrite(0x056BB14, $ah_Handle, 4)
	EndIf
	;Speed set
	If _MemoryRead(0x056BB10,$ah_Handle) < 5 Then
	_MemoryWrite(0x056BB10, $ah_Handle, 5)
	EndIf
EndFunc
Func testF()
	$click += 1
	If $click = 3 Then
		$click = 1
	EndIf
		While ProcessExists("Heavy Weapon Deluxe.exe")
		_MemoryWrite(0x056BB0C, $ah_Handle, 5)
		Sleep(200)
		If $click = 2 Then ExitLoop
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $click = ' & $click & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WEnd
	Sleep(500)

EndFunc
Func superWeapon()
	local $x = Int(_MemoryRead(0x056BAFC, $ah_Handle)),$i
	local $iv_Address = 0x056BAC0
	If $x > 0 Then
		For $i = 0 To 3 Step 1
		local  $av_Offset[2] = [0x00,0x01A8]
		_MemoryPointerWrite($iv_Address, $ah_Handle, $av_Offset, $i)
		Sleep(220)
		Next
		local  $av_Offset[2] = [0x00,0x012C]
		_MemoryPointerWrite($iv_Address, $ah_Handle, $av_Offset, 3000)
		local  $av_Offset[2] = [0x00,0x01A8]
		_MemoryPointerWrite($iv_Address, $ah_Handle, $av_Offset, 0)
	EndIf
EndFunc

