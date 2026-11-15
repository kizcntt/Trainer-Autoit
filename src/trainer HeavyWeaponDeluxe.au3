#NoTrayIcon
#AutoIt3Wrapper_Run_Obfuscator=Y
Opt("GUIOnEventMode", 1)
#include <MetroGUI-UDF\MetroGUI_UDF.au3> ;edit this match your path
#include <MetroGUI-UDF\MetroThemes.au3> ;edit this match your path
#include <MetroGUI-UDF\_GUIDisable.au3> ;edit this match your path
#include <NomadMemory.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

;  OnEvent mode and High DPI for MetroGUI
_Metro_EnableOnEventMode(True)
_Metro_EnableHighDPIScaling()
_SetTheme("DarkOrange")

; ===============================================================================================================================
; 1. (Form - Metro Style)
; ===============================================================================================================================
$Form1 = _Metro_CreateGUI("KLH v1 KTrainer", 340, 485, -1, -1, False)
_Metro_SetGUIOption($Form1, True, False)


; (Close & Minimize)
$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]

; Header & Icon Game
$Label1 = GUICtrlCreateLabel("KTrainer KLH", 43, 34, 240, 24)
GUICtrlSetFont(-1, 14, 800, 0, "Segoe UI")
GUICtrlSetColor(-1, $FontThemeColor)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$Label2 = GUICtrlCreateLabel("Heavy Weapon Deluxe  •  v1.2.1", 43, 58, 240, 18)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xAAAAAA)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

;
$lblStatusBg = GUICtrlCreateLabel("", 20, 92, 300, 26)
GUICtrlSetBkColor(-1, 0x1E242B)
GUICtrlSetState(-1, $GUI_DISABLE)

$Label22 = GUICtrlCreateLabel(" ●  Status: Game not running", 20, 96, 300, 18)
GUICtrlSetFont(-1, 9.5, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFF4D4D)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

;Nuke, Shield, Lives
$Label3 = GUICtrlCreateLabel("Nuke Bomb (Max 7)", 20, 136, 150, 22)
GUICtrlSetFont(-1, 10, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$ipNuke = GUICtrlCreateInput("0", 190, 134, 130, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetFont(-1, 10, 700, 0, "Segoe UI")
$udNuke = GUICtrlCreateUpdown($ipNuke)
GUICtrlSetLimit(-1, 7, 0)

$Label4 = GUICtrlCreateLabel("Shield Level (Max 4)", 20, 172, 150, 22)
GUICtrlSetFont(-1, 10, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$ipShield = GUICtrlCreateInput("0", 190, 170, 130, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetFont(-1, 10, 700, 0, "Segoe UI")
$udShield = GUICtrlCreateUpdown($ipShield)
GUICtrlSetLimit(-1, 4, 0)

$Label5 = GUICtrlCreateLabel("Extra Lives (Max 2)", 20, 208, 150, 22)
GUICtrlSetFont(-1, 10, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$ipLive = GUICtrlCreateInput("0", 190, 206, 130, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetFont(-1, 10, 700, 0, "Segoe UI")
$udLive = GUICtrlCreateUpdown($ipLive)
GUICtrlSetLimit(-1, 2, 0)

$Label6 = GUICtrlCreateLabel("Target Score (Click Set or Numpad +):", 20, 246, 300, 20)
GUICtrlSetFont(-1, 9.5, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, $FontThemeColor)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$Input4 = GUICtrlCreateInput("NONE", 20, 270, 225, 26)
GUICtrlSetFont(-1, 10, 700, 0, "Segoe UI")
GUICtrlSetLimit(-1, 8)

$btnSetScore = _Metro_CreateButtonEx("Set", 252, 269, 68, 28)


$lblQuickTitle = GUICtrlCreateLabel("Quick Actions (TKL / Hotkeys):", 20, 308, 300, 18)
GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xAAAAAA)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$btnQuickFull = _Metro_CreateButtonEx2("Full All", 20, 330, 94, 34)
$btnQuickShield = _Metro_CreateButtonEx2("Inf Shield", 123, 330, 94, 34)
$btnQuickSuper = _Metro_CreateButtonEx2("Super Wpn", 226, 330, 94, 34)

;  Armory Skill & About
$Skill = _Metro_CreateButtonEx2("Armory Skill", 20, 376, 145, 40)
$btnHelp = _Metro_CreateButtonEx2("About / Help", 175, 376, 145, 40)

;  Start Game
$btnStart = _Metro_CreateButtonEx("Launch / Focus Game", 20, 426, 300, 44)

; ===============================================================================================================================
; 2. Events & HOTKEYS
; ===============================================================================================================================
HotKeySet("{NUMPAD3}", "superWeapon")
HotKeySet("{=}", "invinHack")
HotKeySet("{NUMPAD1}", "setFull")
HotKeySet("{NUMPADADD}", "setScore")

GUISetOnEvent($GUI_EVENT_CLOSE, "_MainControlEvent")
GUICtrlSetOnEvent($GUI_CLOSE_BUTTON, "_MainControlEvent")
GUICtrlSetOnEvent($GUI_MINIMIZE_BUTTON, "_MainControlEvent")

GUICtrlSetOnEvent($udNuke, "Updown1Change")
GUICtrlSetOnEvent($udShield, "Updown2Change")
GUICtrlSetOnEvent($udLive, "Updown3Change")
GUICtrlSetOnEvent($btnSetScore, "_TriggerSetScore")

GUICtrlSetOnEvent($btnQuickFull, "setFull")
GUICtrlSetOnEvent($btnQuickShield, "invinHack")
GUICtrlSetOnEvent($btnQuickSuper, "superWeapon")

GUICtrlSetOnEvent($Skill, "SkillClick")
GUICtrlSetOnEvent($btnHelp, "_ModernAboutClick")
GUICtrlSetOnEvent($btnStart, "StartClick")

Global $checkStart, $Form2
Global $value, $iv_Pid, $iv_Address, $ah_Handle, $tit
Global $click = 0
Global $processName = "HeavyWeapon.exe"

GUISetState(@SW_SHOW, $Form1)
getDatafGame()

While 1
	getDatafGame()
	Sleep(200)
	If Mod($click,2) = 1 Then
		If ProcessExists($iv_Pid) Then
			_MemoryWrite(0x056BB0C, $ah_Handle, 5)
		Else
			; Tự tắt nếu game thoát
			$bInvinActive = False
		EndIf
		$hTimerInvin = TimerInit()
	EndIf
	Sleep(700)
WEnd


Func _MainControlEvent()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
			Form1Close()
		Case $GUI_MINIMIZE_BUTTON
			GUISetState(@SW_MINIMIZE, $Form1)
	EndSwitch
EndFunc   ;==>_MainControlEvent

Func _TriggerSetScore()
	WinActivate($Form1)
	setScore()
EndFunc   ;==>_TriggerSetScore

Func _ModernAboutClick()
	_GUIDisable($Form1, 0, 30)
	_Metro_MsgBox(0, "About KTrainer KLH", _
			" __ __  __  ______   " & @CRLF & "/\ \/ /    /\ \   /\___  \  " & @CRLF & "\ \  _\-.  \ \ \  \/_/  /__ " & @CRLF & " \ \_\ \_\  \ \_\   /\_____\" & @CRLF & "  \/_/\/_/   \/_/   \/_____/" & @CRLF & @CRLF & @CRLF & _
			"Trainer by: Shu © " & @YEAR & " + " & @CRLF & _
			"Version: 1.2.1  |  --== AnbuSystem ==--" & @CRLF & @CRLF & _
			"• Full All [NUM1]: Full Nuke, Shield & Lives" & @CRLF & _
			"• Inf Shield [NUM2]: Toggle Infinite Shield" & @CRLF & _
			"• Super Wpn [NUM3]: Instant Super Weapon" & @CRLF & _
			"• Set [NUM+]: Update score", 420, 11, $Form1)
	_GUIDisable($Form1)
EndFunc   ;==>_ModernAboutClick


Func Checkgame()
	If WinGetProcess("Heavy Weapon Deluxe 1.0") = -1 Then
		GUICtrlSetData($Label22, "  ●  Status: Game not running")
		GUICtrlSetColor($Label22, 0xFF3333)
		$ah_Handle = _MemoryOpen($iv_Pid)
		_MemoryClose($ah_Handle)
		Return 0
	Else
		$iv_Pid = WinGetProcess("Heavy Weapon Deluxe 1.0")
		$ah_Handle = _MemoryOpen($iv_Pid)
		GUICtrlSetData($Label22, "  ●  Status: game is running")
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

Func StartClick()
	GUISetState(@SW_DISABLE, $Form1)
	If WinExists("Heavy Weapon Deluxe 1.0") Then
		ConsoleWrite("detected")
		WinActivate("Heavy Weapon Deluxe 1.0")
		GUISetState(@SW_ENABLE, $Form1)
		$checkStart = 1
	Else
		If FileExists($processName) Then
			Run($processName)
			$tit = WinWait("Heavy Weapon Deluxe 1.0", "", 10)
			WinSetTitle($tit, "", "Heavy Weapon Deluxe - KLH")
			GUISetState(@SW_ENABLE, $Form1)
			WinActivate($Form1)
			getDatafGame()
		Else
			MsgBox(16, "Error", "Game not found" & @CRLF & " - Please copy the trainer into the game directory" & @CRLF & " - The game icon will appear in the trainer", 5)
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
	If FileExists($processName) Then
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
		$text8 = GUICtrlCreateLabel("Wait until the game reaches the Armory screen", 240, 120, 148, 17)
		GUICtrlSetColor(-1, 0xFFFFFF)
		$text9 = GUICtrlCreateLabel("- Only upgrade unlocked skills", 240, 140, 148, 17)
		GUICtrlSetColor(-1, 0xFFFFFF)
		$text9a = GUICtrlCreateLabel("to avoid crashing the game", 240, 152, 148, 17)
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUISetState(@SW_DISABLE, $Form1)
		GUISetState(@SW_SHOW, $Form2)
		Sleep(250)
		readArmory()
	Else
		Sleep(200)
		MsgBox(48, "Error", "Please copy the trainer into the game directory to use this feature!")
	EndIf
EndFunc   ;==>SkillClick
Func setScore()
	If WinGetState($Form1) == 15 Then
		$value = GUICtrlRead($Input4)
		If StringIsDigit($value) Then
			_MemoryWrite(0x056BAFC, $ah_Handle, $value)
		Else
			MsgBox(16, "Error data type", "Only number accepted")
			Local $temp = _MemoryRead(0x056BAFC, $ah_Handle)
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
	GUICtrlSetData($text1, $res)
	$res = _MemoryRead(0x056BB24, $ah_Handle)
	GUICtrlSetData($text2, $res)
	$res = _MemoryRead(0x056BB28, $ah_Handle)
	GUICtrlSetData($text3, $res)
	$res = _MemoryRead(0x056BB2C, $ah_Handle)
	GUICtrlSetData($text4, $res)
	$res = _MemoryRead(0x056BB30, $ah_Handle)
	GUICtrlSetData($text5, $res)
	$res = _MemoryRead(0x056BB34, $ah_Handle)
	GUICtrlSetData($text6, $res)
EndFunc   ;==>readArmory
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
Func btnAdd1Click()
	Local $x = GUICtrlRead($text1)
	If $x < 3 Then
		$x += 1
		GUICtrlSetData($text1, $x)
		csArmory($x, 1)
	EndIf
EndFunc   ;==>btnAdd1Click
Func btnAdd2Click()
	Local $x = GUICtrlRead($text2)
	If $x < 3 Then
		$x += 1
		GUICtrlSetData($text2, $x)
		csArmory($x, 2)
	EndIf
EndFunc   ;==>btnAdd2Click
Func btnAdd3Click()
	Local $x = GUICtrlRead($text3)
	If $x < 3 Then
		$x += 1
		GUICtrlSetData($text3, $x)
		csArmory($x, 3)
	EndIf
EndFunc   ;==>btnAdd3Click
Func btnAdd4Click()
	Local $x = GUICtrlRead($text4)
	If $x < 3 Then
		$x += 1
		GUICtrlSetData($text4, $x)
		csArmory($x, 4)
	EndIf
EndFunc   ;==>btnAdd4Click
Func btnAdd5Click()
	Local $x = GUICtrlRead($text5)
	If $x < 3 Then
		$x += 1
		GUICtrlSetData($text5, $x)
		csArmory($x, 5)
	EndIf
EndFunc   ;==>btnAdd5Click
Func btnAdd6Click()
	Local $x = GUICtrlRead($text6)
	If $x < 3 Then
		$x += 1
		GUICtrlSetData($text6, $x)
		csArmory($x, 6)
	EndIf
EndFunc   ;==>btnAdd6Click
Func btnSub1Click()
	Local $x = GUICtrlRead($text1)
	If $x > 0 Then
		$x -= 1
		GUICtrlSetData($text1, $x)
		csArmory($x, 1)
	EndIf
EndFunc   ;==>btnSub1Click
Func btnSub2Click()
	Local $x = GUICtrlRead($text2)
	If $x > 0 Then
		$x -= 1
		GUICtrlSetData($text2, $x)
		csArmory($x, 2)
	EndIf
EndFunc   ;==>btnSub2Click
Func btnSub3Click()
	Local $x = GUICtrlRead($text3)
	If $x > 0 Then
		$x -= 1
		GUICtrlSetData($text3, $x)
		csArmory($x, 3)
	EndIf
EndFunc   ;==>btnSub3Click
Func btnSub4Click()
	Local $x = GUICtrlRead($text4)
	If $x > 0 Then
		$x -= 1
		GUICtrlSetData($text4, $x)
		csArmory($x, 4)
	EndIf
EndFunc   ;==>btnSub4Click
Func btnSub5Click()
	Local $x = GUICtrlRead($text5)
	If $x > 0 Then
		$x -= 1
		GUICtrlSetData($text5, $x)
		csArmory($x, 5)
	EndIf
EndFunc   ;==>btnSub5Click
Func btnSub6Click()
	Local $x = GUICtrlRead($text6)
	If $x > 0 Then
		$x -= 1
		GUICtrlSetData($text6, $x)
		csArmory($x, 6)
	EndIf
EndFunc   ;==>btnSub6Click
Func Form2Close()
	GUIDelete($Form2)
	GUISetState(@SW_ENABLE, $Form1)
EndFunc   ;==>Form2Close
Func setFull()
	_MemoryWrite(0x056BB08, $ah_Handle, 10)
	_MemoryWrite(0x056BB0C, $ah_Handle, 4)
	_MemoryWrite(0x056BB04, $ah_Handle, 2)
	_MemoryWrite(0x056BB1C, $ah_Handle, 4)
	_MemoryWrite(0x056BB18, $ah_Handle, 4)
	If _MemoryRead(0x056BB14, $ah_Handle) < 4 Then
		_MemoryWrite(0x056BB14, $ah_Handle, 4)
	EndIf
	If _MemoryRead(0x056BB10, $ah_Handle) < 5 Then
		_MemoryWrite(0x056BB10, $ah_Handle, 5)
	EndIf
EndFunc   ;==>setFull
Func invinHack()
	$click += 1
	If $click = 4 Then
		$click = 0
EndIf

	_MemoryWrite(0x056BB0C, $ah_Handle, 5)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $click = ' & $click & @CRLF & '>Error code: ' & @error & @CRLF)
	Sleep(500)
EndFunc   ;==>testF
Func superWeapon()
	Local $x = Int(_MemoryRead(0x056BAFC, $ah_Handle)), $i
	Local $iv_Address = 0x056BAC0
	If $x > 0 Then
		For $i = 0 To 3 Step 1
			Local $av_Offset[2] = [0x00, 0x01A8]
			_MemoryPointerWrite($iv_Address, $ah_Handle, $av_Offset, $i)
			Sleep(220)
		Next
		Local $av_Offset[2] = [0x00, 0x012C]
		_MemoryPointerWrite($iv_Address, $ah_Handle, $av_Offset, 3000)
		Local $av_Offset[2] = [0x00, 0x01A8]
		_MemoryPointerWrite($iv_Address, $ah_Handle, $av_Offset, 0)
	EndIf
EndFunc   ;==>superWeapon
