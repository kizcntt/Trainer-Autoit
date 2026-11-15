#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico

#AutoIt3Wrapper_UseX64=n ; Must build in x86 because Red alert 2 is 32-bit game
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#RequireAdmin
#cs
    RA2 Trainer - MetroGUI edition
    Only tested in Red Alert 2 v1.0
#ce

#NoTrayIcon
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <NomadMemory.au3>
#include <Array.au3>

#include <MetroGUI-UDF\MetroGUI_UDF.au3>

If @AutoItX64 Then
    MsgBox(16, "Architecture Error", "Please run or compile the script in 32-bit (x86) mode!")
    Exit
EndIf

Opt("GUIOnEventMode", 1)
_Metro_EnableOnEventMode(True)

; =========================
; CONFIG
; =========================
Global Const $g_sProcessName = "game.exe"
Global Const $g_iMoneyAddress = 0x0A1E0C4
Global Const $g_aMoneyOffset[2] = [0x0, 0x24C]
Global Const $g_iMoneyLimit = 10000000
Global Const $g_iDefaultAdd = 30000

Global $g_iPID = 0
Global $g_iCurrentMoney = 0
Global $g_hMemory = 0
Global $g_hMoneyTimer = TimerInit()

; Instant Build ASM Injection Config
Global Const $g_iIB_InjectOffset  = 0x000B942C
Global Const $g_iIB_JneFarOffset  = 0x000B9434
Global Const $g_iIB_RetOffset     = 0x000B9431
Global Const $g_sIB_OrigBytes     = "0x3941247503"

Global $g_bInstantBuildActive = False
Global $g_hInjectProc         = 0
Global $g_pInjectAddr         = 0
Global $g_pNewMem             = 0

; =========================
; THEME + WINDOW
; =========================
_SetTheme("DarkBlue")
Global $titleWin = "RA2 v1.0 TRAINER - Shu"
Global $hGUI = _Metro_CreateGUI($titleWin, 360, 230, -1, -1, False)
Global $aWindowButtons = _Metro_AddControlButtons(True, False, True, False, False)
$GUI_CLOSE_BUTTON = $aWindowButtons[0]
$GUI_MINIMIZE_BUTTON = $aWindowButtons[3]
_Metro_SetGUIOption($hGUI, True, False)
GUISetFont(9, 400, 0, "Segoe UI")
; =========================
; UI
; =========================
Global $lblWinTitle = GUICtrlCreateLabel($titleWin, 12, 8, 150, 16, -1,$GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont($lblWinTitle, 8, 700, 0, "Segoe UI")
GUICtrlSetColor($lblWinTitle, 0xAAB4C3)


Global $lineTop = GUICtrlCreateLabel("", 1, 31, 360 - 2, 1)
GUICtrlSetBkColor($lineTop, 0x2878D0)
GUICtrlSetState($lineTop, $GUI_DISABLE)


Global $lblTitle = GUICtrlCreateLabel("RED ALERT 2 Trainer - Shu", 18, 34, 324, 24)
GUICtrlSetFont($lblTitle, 13, 700, 0, "Segoe UI")
GUICtrlSetColor($lblTitle, 0xFFFFFF)

Global $lblNote = GUICtrlCreateLabel("Only use for Red Alert 2 ver 1.0 | Offline Mode", 18, 59, 324, 18)
GUICtrlSetFont($lblNote, 8.5, 400, 0, "Segoe UI")
GUICtrlSetColor($lblNote, 0x9AA5B4)

Global $lblStatus = GUICtrlCreateLabel("●  Waiting for game...", 18, 78, 324, 18)
GUICtrlSetFont($lblStatus, 9, 600, 0, "Segoe UI")
GUICtrlSetColor($lblStatus, 0xF0B44D)

Global $lineMid = GUICtrlCreateLabel("", 18, 104, 324, 1)
GUICtrlSetBkColor($lineMid, 0x2F3744)
GUICtrlSetState($lineMid, $GUI_DISABLE)


Global $lblMoneyCaption = GUICtrlCreateLabel("CURRENT MONEY", 18, 118, 110, 18)
GUICtrlSetFont($lblMoneyCaption, 8, 600, 0, "Segoe UI")
GUICtrlSetColor($lblMoneyCaption, 0xAAB4C3)

Global $inpCurrentMoney = GUICtrlCreateInput("--", 132, 114, 210, 24, BitOR($ES_READONLY, $ES_CENTER))
GUICtrlSetFont($inpCurrentMoney, 10, 700, 0, "Segoe UI")
GUICtrlSetColor($inpCurrentMoney, 0x4CD964) ;
GUICtrlSetBkColor($inpCurrentMoney, 0x252B36)
GUICtrlSetState($inpCurrentMoney, $GUI_DISABLE)

Global $lblAmount = GUICtrlCreateLabel("ADD AMOUNT", 18, 151, 110, 18)
GUICtrlSetFont($lblAmount, 8, 600, 0, "Segoe UI")
GUICtrlSetColor($lblAmount, 0xAAB4C3)

Global $inpAmount = GUICtrlCreateInput("30000", 132, 147, 98, 24, $ES_NUMBER)
GUICtrlSetFont($inpAmount, 10, 600, 0, "Segoe UI")
GUICtrlSetColor($inpAmount, 0xFFFFFF)
GUICtrlSetBkColor($inpAmount, 0x252B36)
GUICtrlSetLimit($inpAmount, 8)

Global $btnAddMoney = _Metro_CreateButton("ADD  [=]", 238, 146, 104, 26, 0x2878D0, 0xFFFFFF, "Segoe UI", 8.5, 1)

Global $btnInstantBuildOff = _Metro_CreateButton("INSTANT BUILD", 18, 186, 156, 28, 0x343D4B, 0xFFFFFF, "Segoe UI", 8, 1)
Global $btnInstantBuildOn  = _Metro_CreateButtonEx("INSTANT BUILD", 18, 186, 156, 28, 0x229954, 0xFFFFFF, "Segoe UI", 8, 1)
GUICtrlSetState($btnInstantBuildOn, $GUI_HIDE)

Global $btnExitGame = _Metro_CreateButton("EXIT GAME", 186, 186, 156, 28, 0x343D4B, 0xFFFFFF, "Segoe UI", 8, 1)

; =========================
; EVENTS
; =========================
GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitTrainer", $hGUI)
GUICtrlSetOnEvent($GUI_CLOSE_BUTTON, "_ExitTrainer")
GUICtrlSetOnEvent($GUI_MINIMIZE_BUTTON, "_MinimizeTrainer")
GUICtrlSetOnEvent($btnAddMoney, "_AddMoney")
GUICtrlSetOnEvent($btnInstantBuildOff, "_InstantBuildClick")
GUICtrlSetOnEvent($btnInstantBuildOn, "_InstantBuildClick")
GUICtrlSetOnEvent($btnExitGame, "_ExitGameClick")

GUISetState(@SW_SHOW, $hGUI)
Sleep(1000)

_RefreshProcessState()
AdlibRegister("_PollGame", 500)

While 1
    Sleep(100)
WEnd

; =========================
; PROCESS DETECTION
; =========================
Func _PollGame()
    Local $iFoundPID = ProcessExists($g_sProcessName)

    If $iFoundPID = 0 Then
        If $g_iPID <> 0 Then
            $g_iPID = 0
            GUICtrlSetData($inpCurrentMoney, "--")
            _ResetInstantBuildState()
        EndIf
		HotKeySet("=")
		HotKeySet("-")
        GUICtrlSetData($lblStatus, "●  Game not detected")
        GUICtrlSetColor($lblStatus, 0xF06A6A)
        Return
    EndIf

    If $iFoundPID <> $g_iPID Then
        _ResetInstantBuildState()
        $g_iPID = $iFoundPID
        GUICtrlSetData($lblStatus, "●  Game detected")
        GUICtrlSetColor($lblStatus, 0x65D69A)
        $g_hMoneyTimer = TimerInit()
        _ReadMoney()
		HotKeySet("=", "_MoneyHotKey")
		HotKeySet("-","_InstantBuildClick")
        Return
    EndIf

    If TimerDiff($g_hMoneyTimer) >= 1000 Then
        $g_hMoneyTimer = TimerInit()
        _ReadMoney()
    EndIf
EndFunc

Func _RefreshProcessState()
    _PollGame()
EndFunc

; =========================
; MEMORY
; =========================
Func _ReadMoney()
    If $g_iPID = 0 Then Return False

    $g_hMemory = _MemoryOpen($g_iPID)
    If @error Or $g_hMemory = 0 Then Return False

    Local $aData = _MemoryPointerRead($g_iMoneyAddress, $g_hMemory, $g_aMoneyOffset, "dword")
    Local $iReadError = @error
    Local $bReadOK = IsArray($aData) And ($iReadError = 0)

    If $bReadOK And $aData[1] <> Null Then
        $g_iCurrentMoney = Number($aData[1])
        GUICtrlSetData($inpCurrentMoney, $g_iCurrentMoney)
    EndIf

    _MemoryClose($g_hMemory)
    $g_hMemory = 0
    Return $bReadOK
EndFunc

Func _AddMoney()
    If $g_iPID = 0 Or Not ProcessExists($g_iPID) Then
        GUICtrlSetData($lblStatus, "●  Start the game first")
        GUICtrlSetColor($lblStatus, 0xF0B44D)
        Return
    EndIf

    Local $sAmount = StringStripWS(GUICtrlRead($inpAmount), 3)

    If $sAmount = "" Or Not StringRegExp($sAmount, "^\d+$") Then
        GUICtrlSetData($lblStatus, "●  Enter a valid amount")
        GUICtrlSetColor($lblStatus, 0xF06A6A)
        Return
    EndIf

    _ReadMoney()
    Local $iNewValue = $g_iCurrentMoney + Number($sAmount)

    If $iNewValue > $g_iMoneyLimit Then
        GUICtrlSetData($lblStatus, "●  Money limit is 10,000,000")
        GUICtrlSetColor($lblStatus, 0xF0B44D)
        Return
    EndIf

    $g_hMemory = _MemoryOpen($g_iPID)

    If @error Or $g_hMemory = 0 Then
        GUICtrlSetData($lblStatus, "●  Cannot open game process")
        GUICtrlSetColor($lblStatus, 0xF06A6A)
        Return
    EndIf

    _MemoryPointerWrite($g_iMoneyAddress, $g_hMemory, $g_aMoneyOffset, $iNewValue)
    Local $iWriteError = @error

    _MemoryClose($g_hMemory)
    $g_hMemory = 0

    If $iWriteError Then
        GUICtrlSetData($lblStatus, "●  Failed to write money")
        GUICtrlSetColor($lblStatus, 0xF06A6A)
        Return
    EndIf

    $g_iCurrentMoney = $iNewValue
    GUICtrlSetData($inpCurrentMoney, $g_iCurrentMoney)
    GUICtrlSetData($lblStatus, "●  Money added successfully")
    GUICtrlSetColor($lblStatus, 0x65D69A)
EndFunc

Func _MoneyHotKey()
    _AddMoney()
EndFunc

; =========================
; BUTTON ACTIONS
; =========================
Func _SetInstantBuildUI($bActive)
    If $bActive Then
        GUICtrlSetState($btnInstantBuildOff, $GUI_HIDE)
        GUICtrlSetState($btnInstantBuildOn, $GUI_SHOW)
    Else
        GUICtrlSetState($btnInstantBuildOn, $GUI_HIDE)
        GUICtrlSetState($btnInstantBuildOff, $GUI_SHOW)
    EndIf
EndFunc

Func _InstantBuildClick()
    If $g_iPID = 0 Or Not ProcessExists($g_iPID) Then
        _ResetInstantBuildState()
        GUICtrlSetData($lblStatus, "●  Start the game first")
        GUICtrlSetColor($lblStatus, 0xF0B44D)
        Return
    EndIf

    If Not $g_bInstantBuildActive Then
        If _EnableInstantBuild($g_iPID) Then
            $g_bInstantBuildActive = True
            _SetInstantBuildUI(True)
            GUICtrlSetData($lblStatus, "●  Instant Build: ON")
            GUICtrlSetColor($lblStatus, 0x65D69A)
        Else
            GUICtrlSetData($lblStatus, "●  Failed to enable Instant Build")
            GUICtrlSetColor($lblStatus, 0xF06A6A)
        EndIf
    Else
        _DisableInstantBuild()
        $g_bInstantBuildActive = False
        _SetInstantBuildUI(False)
        GUICtrlSetData($lblStatus, "●  Instant Build: OFF")
        GUICtrlSetColor($lblStatus, 0xF0B44D)
    EndIf
EndFunc

Func _ResetInstantBuildState()
    If $g_hInjectProc <> 0 Then
        _CloseHandle($g_hInjectProc)
    EndIf
    $g_bInstantBuildActive = False
    $g_hInjectProc         = 0
    $g_pInjectAddr         = 0
    $g_pNewMem             = 0
    _SetInstantBuildUI(False)
EndFunc

Func _ExitGameClick()
    If $g_iPID <> 0 And ProcessExists($g_iPID) Then
        If $g_bInstantBuildActive Then
            _DisableInstantBuild()
            $g_bInstantBuildActive = False
            _SetInstantBuildUI(False)
        EndIf
        ProcessClose($g_iPID)
        GUICtrlSetData($lblStatus, "●  Game closed")
        GUICtrlSetColor($lblStatus, 0xF0B44D)
    Else
        GUICtrlSetData($lblStatus, "●  Game is not running")
        GUICtrlSetColor($lblStatus, 0xF0B44D)
    EndIf
EndFunc

Func _ExitTrainer()
    AdlibUnRegister("_PollGame")
    HotKeySet("=")
    If $g_bInstantBuildActive Then _DisableInstantBuild()
    _Metro_GUIDelete($hGUI)
    Exit
EndFunc

Func _MinimizeTrainer()
    GUISetState(@SW_MINIMIZE, $hGUI)
EndFunc

; =========================
; ASM CODE INJECTION MODULE
; =========================
Func _EnableInstantBuild($iPID)
    Local $aOpen = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", 0x0038, "bool", False, "dword", $iPID)
    If @error Or $aOpen[0] = 0 Then Return False
    $g_hInjectProc = $aOpen[0]

    Local $pBaseAddr = _GetModuleBaseAddress($iPID, $g_sProcessName)
    If $pBaseAddr = 0 Then
        _CloseHandle($g_hInjectProc)
        $g_hInjectProc = 0
        Return False
    EndIf

    $g_pInjectAddr = $pBaseAddr + $g_iIB_InjectOffset
    Local $pJneDest = $pBaseAddr + $g_iIB_JneFarOffset
    Local $pRetDest = $pBaseAddr + $g_iIB_RetOffset

    Local $aAlloc = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $g_hInjectProc, "ptr", 0, "ulong_ptr", 0x1000, "dword", 0x3000, "dword", 0x40)
    If @error Or $aAlloc[0] = 0 Then
        _CloseHandle($g_hInjectProc)
        $g_hInjectProc = 0
        Return False
    EndIf
    $g_pNewMem = Number($aAlloc[0])

    Local $iRelJne1 = $pJneDest - ($g_pNewMem + 0x29)
    Local $iRelRet1 = $pRetDest - ($g_pNewMem + 0x2E)
    Local $iRelJne2 = $pJneDest - ($g_pNewMem + 0x37)
    Local $iRelRet2 = $pRetDest - ($g_pNewMem + 0x3C)

    Local $sShellcode = "0x" & _
        "53" & _
        "8B5968" & _
        "837B3000" & _
        "5B" & _
        "7523" & _
        "0F1F4000" & _
        "81792433000000" & _
        "7F16" & _
        "0F1F4000" & _
        "C7412434000000" & _
        "0F85" & _Int32ToLittleEndianHex($iRelJne1) & _
        "E9" & _Int32ToLittleEndianHex($iRelRet1) & _
        "394124" & _
        "0F85" & _Int32ToLittleEndianHex($iRelJne2) & _
        "E9" & _Int32ToLittleEndianHex($iRelRet2)

    If BinaryLen(Binary($sShellcode)) <> 60 Or Not _WriteHexBytes($g_hInjectProc, $g_pNewMem, $sShellcode) Then
        _DisableInstantBuild()
        Return False
    EndIf

    Local $iRelJmpHook = $g_pNewMem - ($g_pInjectAddr + 5)
    Local $sHookBytes = "0xE9" & _Int32ToLittleEndianHex($iRelJmpHook)

    If BinaryLen(Binary($sHookBytes)) <> 5 Or Not _WriteHexBytes($g_hInjectProc, $g_pInjectAddr, $sHookBytes) Then
        _DisableInstantBuild()
        Return False
    EndIf

    Return True
EndFunc

Func _DisableInstantBuild()
    If $g_hInjectProc <> 0 Then
        If $g_pInjectAddr <> 0 And ProcessExists($g_iPID) Then
            _WriteHexBytes($g_hInjectProc, $g_pInjectAddr, $g_sIB_OrigBytes)
        EndIf
        If $g_pNewMem <> 0 And ProcessExists($g_iPID) Then
            DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $g_hInjectProc, "ptr", $g_pNewMem, "ulong_ptr", 0, "dword", 0x8000)
        EndIf
        _CloseHandle($g_hInjectProc)
    EndIf
    $g_hInjectProc = 0
    $g_pInjectAddr = 0
    $g_pNewMem     = 0
	_ResetInstantBuildState()
EndFunc

Func _WriteHexBytes($hProcess, $pAddress, $sHexString)
    Local $bData = Binary($sHexString)
    Local $iSize = BinaryLen($bData)
    Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
    DllStructSetData($tBuffer, 1, $bData)

    Local $tOldProtect = DllStructCreate("dword")
    DllCall("kernel32.dll", "bool", "VirtualProtectEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", 0x40, "ptr", DllStructGetPtr($tOldProtect))

    Local $tWritten = DllStructCreate("ulong_ptr")
    Local $aWrite = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", $hProcess, "ptr", $pAddress, "ptr", DllStructGetPtr($tBuffer), "ulong_ptr", $iSize, "ptr", DllStructGetPtr($tWritten))

    DllCall("kernel32.dll", "bool", "VirtualProtectEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", DllStructGetData($tOldProtect, 1), "ptr", DllStructGetPtr($tOldProtect))

    Return (Not @error And $aWrite[0] And DllStructGetData($tWritten, 1) = $iSize)
EndFunc

Func _Int32ToLittleEndianHex($iVal)
    Local $tInt = DllStructCreate("int")
    DllStructSetData($tInt, 1, $iVal)
    Local $tBytes = DllStructCreate("byte[4]", DllStructGetPtr($tInt))
    Local $sHex = ""
    For $i = 1 To 4
        $sHex &= Hex(DllStructGetData($tBytes, 1, $i), 2)
    Next
    Return $sHex
EndFunc

Func _GetModuleBaseAddress($iPID, $sModuleName)
    Local $aSnap = DllCall("kernel32.dll", "handle", "CreateToolhelp32Snapshot", "dword", 0x00000018, "dword", $iPID)
    If @error Or $aSnap[0] = -1 Then Return 0

    Local $tEntry = DllStructCreate("dword Size;dword th32ModuleID;dword th32ProcessID;dword GlblcntUsage;dword ProccntUsage;ptr modBaseAddr;dword modBaseSize;handle hModule;wchar szModule[256];wchar szExePath[260]")
    DllStructSetData($tEntry, "Size", DllStructGetSize($tEntry))

    Local $aRet = DllCall("kernel32.dll", "bool", "Module32FirstW", "handle", $aSnap[0], "ptr", DllStructGetPtr($tEntry))
    Local $pBase = 0
    While Not @error And $aRet[0]
        If StringLower(DllStructGetData($tEntry, "szModule")) = StringLower($sModuleName) Then
            $pBase = Number(DllStructGetData($tEntry, "modBaseAddr"))
            ExitLoop
        EndIf
        $aRet = DllCall("kernel32.dll", "bool", "Module32NextW", "handle", $aSnap[0], "ptr", DllStructGetPtr($tEntry))
    WEnd

    _CloseHandle($aSnap[0])
    Return $pBase
EndFunc

Func _CloseHandle($hHandle)
    DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hHandle)
EndFunc