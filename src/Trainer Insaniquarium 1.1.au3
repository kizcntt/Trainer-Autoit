#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n 
#AutoIt3Wrapper_Res_Description=Insaniquarium Deluxe Trainer (MetroGUI)
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=KLH & Shu © 2026
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#NoTrayIcon
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <NomadMemory.au3>

; MetroGUI Framework
#include "MetroGUI_UDF.au3"

If @AutoItX64 Then
    MsgBox(16, "Architecture Error", "Vui lòng chạy hoặc biên dịch script ở chế độ 32-bit (x86)!")
    Exit
EndIf

Opt("GUIOnEventMode", 1)
_Metro_EnableOnEventMode(True)

; ==============================================================================
; CONFIG & OFFSETS (Insaniquarium Deluxe 1.1)
; ==============================================================================
Global Const $g_sProcessName = "Insaniquarium.exe"
Global Const $g_sWindowTitle = "Insaniquarium Deluxe 1.1"

; Module Base Offset (Game non-ASLR base default: 0x00400000)
; "Insaniquarium.exe" + 0x001E8A80 = 0x005E8A80
Global Const $g_iBaseAddressMoney = 0x005E8A80

; Multi-level Pointer Chain for In-Game Money:
; Base -> [[[[Base] + 0x68] + 0x730] + 0x1C] + 0x3EC
Global Const $g_aOffsetMoney[5] = [0, 0x68, 0x730, 0x1C, 0x3EC]

; Static Addresses for Food:
; "Insaniquarium.exe" + 0x1DF58C = 0x005DF58C
Global Const $g_iAddrFoodCount = 0x005DF58C

; "Insaniquarium.exe" + 0x1E89DC = 0x005E89DC
Global Const $g_iAddrFoodType  = 0x005E89DC

; Globals Runtime
Global $g_iPID = 0
Global $g_hMemory = 0
Global $g_bGameRunning = False
Global $g_bUpdatingUI = False ; Tránh vòng lặp sự kiện khi cập nhật dữ liệu tự động

; Non-blocking Status Hold Timer
Global $g_hStatusHoldTimer = 0
Global $g_iStatusHoldMs    = 0

; ==============================================================================
; METRO GUI INITIALIZATION
; ==============================================================================
_SetTheme("DarkOrange")

Global $sWinTitle = "INSANIQUARIUM v1.1 - STP TRAINER"
Global $hGUI = _Metro_CreateGUI($sWinTitle, 290, 310, -1, -1, False)
Global $aWindowButtons = _Metro_AddControlButtons(True, False, True, False, False)
Global $GUI_CLOSE_BUTTON = $aWindowButtons[0]
Global $GUI_MINIMIZE_BUTTON = $aWindowButtons[3]

_Metro_SetGUIOption($hGUI, True, False)
GUISetFont(9, 400, 0, "Segoe UI")

; Top Drag Title
Global $lblWinTitle = GUICtrlCreateLabel("STP - INSANIQUARIUM DELUXE", 15, 10, 195, 16, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont($lblWinTitle, 8, 700, 0, "Segoe UI")
GUICtrlSetColor($lblWinTitle, 0xAAB4C3)

; Header separator
Global $lineTop = GUICtrlCreateLabel("", 1, 31, 288, 1)
GUICtrlSetBkColor($lineTop, 0xC76810)
GUICtrlSetState($lineTop, $GUI_DISABLE)

; Title & Status
Global $lblTitle = GUICtrlCreateLabel("Insaniquarium Deluxe 1.1", 16, 38, 258, 24)
GUICtrlSetFont($lblTitle, 12, 700, 0, "Segoe UI")
GUICtrlSetColor($lblTitle, 0xFFFFFF)

Global $lblStatus = GUICtrlCreateLabel("●  Đang chờ mở game...", 16, 65, 258, 18)
GUICtrlSetFont($lblStatus, 8.5, 600, 0, "Segoe UI")
GUICtrlSetColor($lblStatus, 0xF0B44D)

Global $lineMid = GUICtrlCreateLabel("", 16, 90, 258, 1)
GUICtrlSetBkColor($lineMid, 0x242B47)
GUICtrlSetState($lineMid, $GUI_DISABLE)

; ------------------------------------------------------------------------------
; CONTROLS SECTION (Slim GUI - Bấm Enter để áp dụng)
; ------------------------------------------------------------------------------
; 1. In-game Money
Global $lblMoneyCap = GUICtrlCreateLabel("TIỀN TRONG VÁN", 16, 106, 115, 18)
GUICtrlSetFont($lblMoneyCap, 8, 600, 0, "Segoe UI")
GUICtrlSetColor($lblMoneyCap, 0xAAB4C3)

Global $inpMoney = GUICtrlCreateInput("--", 136, 102, 138, 25, BitOR($ES_NUMBER, $ES_CENTER))
GUICtrlSetFont($inpMoney, 10, 700, 0, "Segoe UI")
GUICtrlSetColor($inpMoney, 0x4CD964)
GUICtrlSetBkColor($inpMoney, 0x1E2530)

; 2. Food Type (Chọn là đổi ngay lập tức)
Global $lblFoodTypeCap = GUICtrlCreateLabel("LOẠI THỨC ĂN", 16, 146, 115, 18)
GUICtrlSetFont($lblFoodTypeCap, 8, 600, 0, "Segoe UI")
GUICtrlSetColor($lblFoodTypeCap, 0xAAB4C3)

Global $cmbFoodType = GUICtrlCreateCombo("", 136, 142, 138, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData($cmbFoodType, "Snack|Thức ăn viên|Thuốc viên", "Snack")
GUICtrlSetFont($cmbFoodType, 9, 500, 0, "Segoe UI")

; 3. Food Count (Nhập số rồi Enter là set)
Global $lblFoodCountCap = GUICtrlCreateLabel("SỐ THỨC ĂN (MAX 10)", 16, 186, 118, 18)
GUICtrlSetFont($lblFoodCountCap, 7.5, 600, 0, "Segoe UI")
GUICtrlSetColor($lblFoodCountCap, 0xAAB4C3)

Global $inpFoodCount = GUICtrlCreateInput("1", 136, 182, 138, 25, BitOR($ES_NUMBER, $ES_CENTER))
GUICtrlSetFont($inpFoodCount, 10, 700, 0, "Segoe UI")
GUICtrlSetColor($inpFoodCount, 0xFFFFFF)
GUICtrlSetBkColor($inpFoodCount, 0x1E2530)
GUICtrlSetLimit($inpFoodCount, 2)

; Bottom Separator
Global $lineBot = GUICtrlCreateLabel("", 16, 225, 258, 1)
GUICtrlSetBkColor($lineBot, 0x242B47)
GUICtrlSetState($lineBot, $GUI_DISABLE)

; Quick Max Preset Buttons (Màu cam DarkOrange 0xC76810)
Global $btnMaxMoney = _Metro_CreateButton("+5,000", 16, 238, 80, 28, 0xC76810, 0xFFFFFF, "Segoe UI", 8, 1)
Global $btnBestFood = _Metro_CreateButton("MAX FOOD", 102, 238, 86, 28, 0xC76810, 0xFFFFFF, "Segoe UI", 7.5, 1)
Global $btnAbout    = _Metro_CreateButton("ABOUT", 194, 238, 80, 28, 0xC76810, 0xFFFFFF, "Segoe UI", 8, 1)

; Footer
Global $lblFooter = GUICtrlCreateLabel("STP © 2026 - Shu Akashi", 16, 280, 258, 16, $SS_CENTER)
GUICtrlSetFont($lblFooter, 8, 400, 0, "Segoe UI")
GUICtrlSetColor($lblFooter, 0x6E7D91)

; Invisible Default Button to capture Enter key on inputs
Global $btnEnterHidden = GUICtrlCreateButton("", -100, -100, 10, 10, $BS_DEFPUSHBUTTON)

; ==============================================================================
; EVENT BINDINGS
; ==============================================================================
GUICtrlSetOnEvent($GUI_CLOSE_BUTTON, "_OnExit")
GUICtrlSetOnEvent($GUI_MINIMIZE_BUTTON, "_OnMinimize")

; Sự kiện khi chọn Loại thức ăn -> đổi ngay lập tức
GUICtrlSetOnEvent($cmbFoodType, "_OnSetFoodType")

; Sự kiện khi bấm Enter trong ô Input
GUICtrlSetOnEvent($btnEnterHidden, "_OnEnterPressed")

GUICtrlSetOnEvent($btnMaxMoney, "_OnQuickAddMoney")
GUICtrlSetOnEvent($btnBestFood, "_OnQuickMaxFood")
GUICtrlSetOnEvent($btnAbout, "_OnAbout")

; Khởi tạo trạng thái ban đầu
_SetControlsEnabled(False)
GUISetState(@SW_SHOW, $hGUI)

; Vòng lặp polling kiểm tra game
AdlibRegister("_PollGame", 1000)

While 1
    Sleep(200)
WEnd

; ==============================================================================
; LOGIC HÀM & XỬ LÝ GAME
; ==============================================================================
Func _PollGame()
    Local $iFoundPID = ProcessExists($g_sProcessName)

    If $iFoundPID = 0 Then
        If $g_bGameRunning Then
            $g_bGameRunning = False
            $g_iPID = 0
            If IsArray($g_hMemory) Then
                _MemoryClose($g_hMemory)
                $g_hMemory = 0
            EndIf
            _SetControlsEnabled(False)
            GUICtrlSetData($inpMoney, "--")
        EndIf

        If Not _IsStatusHolding() Then
            _SetStatus("●  Không tìm thấy " & $g_sProcessName, 0xF06A6A)
        EndIf
        Return
    EndIf

    ; Game đang chạy
    If Not $g_bGameRunning Or $g_iPID <> $iFoundPID Then
        $g_iPID = $iFoundPID
        $g_hMemory = _MemoryOpen($g_iPID)
        If @error Or Not IsArray($g_hMemory) Then
            _SetStatus("●  Không thể mở bộ nhớ game", 0xF06A6A)
            Return
        EndIf
        $g_bGameRunning = True
        _SetControlsEnabled(True)
        _SetStatus("●  Đã kết nối: " & $g_sWindowTitle, 0x4CD964)
    EndIf

    ; Đọc dữ liệu định kỳ từ game nếu cửa sổ trainer không trong trạng thái sửa
    _ReadGameData()
EndFunc

Func _ReadGameData()
    If Not $g_bGameRunning Or Not IsArray($g_hMemory) Then Return

    ; 1. Đọc tiền trong trận thông qua chuỗi Pointer
    Local $aMoneyData = _MemoryPointerRead($g_iBaseAddressMoney, $g_hMemory, $g_aOffsetMoney, "dword")
    If Not @error And IsArray($aMoneyData) Then
        Local $hFocus = _WinAPI_GetFocus()
        If $hFocus <> GUICtrlGetHandle($inpMoney) Then
            GUICtrlSetData($inpMoney, $aMoneyData[1])
        EndIf
    EndIf

    Local $iFoodType = _MemoryRead($g_iAddrFoodType, $g_hMemory, "dword")
    If Not @error Then
        Switch $iFoodType
            Case 0
                _SetComboIfNotOpen("Snack")
            Case 1
                _SetComboIfNotOpen("Thức ăn viên")
            Case 2
                _SetComboIfNotOpen("Thuốc viên")
        EndSwitch
    EndIf

    ; 3. Đọc số lượng thức ăn rơi cùng lúc
    Local $iFoodCount = _MemoryRead($g_iAddrFoodCount, $g_hMemory, "dword")
    If Not @error Then
        Local $hFocus = _WinAPI_GetFocus()
        If $hFocus <> GUICtrlGetHandle($inpFoodCount) Then
            GUICtrlSetData($inpFoodCount, $iFoodCount)
        EndIf
    EndIf
EndFunc

Func _SetComboIfNotOpen($sText)
    If GUICtrlRead($cmbFoodType) <> $sText Then
        GUICtrlSetData($cmbFoodType, $sText)
    EndIf
EndFunc

; ==============================================================================
; BUTTON HANDLERS
; ==============================================================================
Func _OnSetMoney()
    If Not $g_bGameRunning Or Not IsArray($g_hMemory) Then Return

    Local $sVal = StringStripWS(GUICtrlRead($inpMoney), 3)
    If $sVal = "" Or Not StringIsDigit($sVal) Then
        _SetStatus("●  Vui lòng nhập số tiền hợp lệ!", 0xF06A6A, 2500)
        Return
    EndIf

    Local $iVal = Number($sVal)
    Local $iRes = _MemoryPointerWrite($g_iBaseAddressMoney, $g_hMemory, $g_aOffsetMoney, $iVal, "dword")
    If not @error And ($iRes <> "" or $iRes <> 0) Then
        _SetStatus("●  Đã chỉnh tiền thành công: " & $iVal, 0x4CD964, 2500)
    Else
        _SetStatus("●  Lỗi ghi tiền", 0xF06A6A, 2500)
    EndIf
EndFunc

Func _OnSetFoodType()
    If Not $g_bGameRunning Or Not IsArray($g_hMemory) Then Return

    Local $sSelected = GUICtrlRead($cmbFoodType)
    Local $iTypeVal = 0
    Switch $sSelected
        Case "Snack"
            $iTypeVal = 0
        Case "Thức ăn viên"
            $iTypeVal = 1
        Case "Thuốc viên"
            $iTypeVal = 2
    EndSwitch

    _MemoryWrite($g_iAddrFoodType, $g_hMemory, $iTypeVal, "dword")
    If Not @error Then
        _SetStatus("●  Đã chỉnh loại thức ăn: " & $sSelected, 0x4CD964, 2500)
    Else
        _SetStatus("●  Lỗi cập nhật loại thức ăn!", 0xF06A6A, 2500)
    EndIf
EndFunc

Func _OnSetFoodCount()
    If Not $g_bGameRunning Or Not IsArray($g_hMemory) Then Return

    Local $sVal = StringStripWS(GUICtrlRead($inpFoodCount), 3)
    If $sVal = "" Or Not StringIsDigit($sVal) Then
        _SetStatus("●  Số lượng thức ăn phải là số!", 0xF06A6A, 2500)
        Return
    EndIf

    Local $iCount = Number($sVal)
    If $iCount < 1 Then
        $iCount = 1
        GUICtrlSetData($inpFoodCount, "1")
    ElseIf $iCount > 10 Then
        $iCount = 10
        GUICtrlSetData($inpFoodCount, "10")
        _SetStatus("●  Đã tự giới hạn tối đa 10 viên!", 0xF0B44D, 2000)
    EndIf

    _MemoryWrite($g_iAddrFoodCount, $g_hMemory, $iCount, "dword")
    If Not @error Then
        _SetStatus("●  Đã chỉnh số lượng thức ăn: " & $iCount, 0x4CD964, 2500)
    Else
        _SetStatus("●  Lỗi cập nhật số thức ăn!", 0xF06A6A, 2500)
    EndIf
EndFunc

Func _OnQuickAddMoney()
    If Not $g_bGameRunning Or Not IsArray($g_hMemory) Then Return

    Local $aMoneyData = _MemoryPointerRead($g_iBaseAddressMoney, $g_hMemory, $g_aOffsetMoney, "dword")
    Local $iCur = 0
    If Not @error And IsArray($aMoneyData) Then
        $iCur = Number($aMoneyData[1])
    EndIf

    Local $iNew = $iCur + 5000
    _MemoryPointerWrite($g_iBaseAddressMoney, $g_hMemory, $g_aOffsetMoney, $iNew, "dword")
    If Not @error Then
        GUICtrlSetData($inpMoney, $iNew)
        _SetStatus("●  Đã cộng thêm +50,000 $!", 0x4CD964, 2500)
    Else
        _SetStatus("●  Chưa vào ván chơi!", 0xF06A6A, 2500)
    EndIf
EndFunc

Func _OnQuickMaxFood()
    If Not $g_bGameRunning Or Not IsArray($g_hMemory) Then Return

    ; Đặt loại thức ăn là Thuốc (2) và số lượng thả là 10
    _MemoryWrite($g_iAddrFoodType, $g_hMemory, 2, "dword")
    _MemoryWrite($g_iAddrFoodCount, $g_hMemory, 10, "dword")

    GUICtrlSetData($cmbFoodType, "Thuốc viên")
    GUICtrlSetData($inpFoodCount, "10")
    _SetStatus("●  Đã kích hoạt Max Thức ăn (Thuốc x10)!", 0x4CD964, 2500)
EndFunc

Func _OnAbout()
    Local $sAbout = "INSANIQUARIUM DELUXE TRAINER" & @CRLF & _
                    "Phiên bản Game hỗ trợ: 1.1" & @CRLF & _
                    "Giao diện: MetroGUI Edition" & @CRLF & @CRLF & _
                    "Tác giả: Shu Akashi (nhokKiZ)" & @CRLF & _
                    "Cập nhật v1.1 & Metro: Shu Akashi © 2026" & @CRLF & @CRLF & _
                    "Chức năng:" & @CRLF & _
                    " • Chỉnh & Đọc tiền trong ván (In-Game Money)" & @CRLF & _
                    " • Chọn loại thức ăn (Snack, Viên, Thuốc)" & @CRLF & _
                    " • Chỉnh số lượng thức ăn rơi cùng lúc (Max 10)"

    _Metro_MsgBox(0, "About - STP Trainer", $sAbout, 400, 10, $hGUI, 0)
EndFunc

; Bắt phím Enter khi người dùng đang ở ô Money hoặc ô FoodCount
Func _OnEnterPressed()
    Local $hFocus = _WinAPI_GetFocus()
    If $hFocus = GUICtrlGetHandle($inpMoney) Then
        _OnSetMoney()
    ElseIf $hFocus = GUICtrlGetHandle($inpFoodCount) Then
        _OnSetFoodCount()
    EndIf
EndFunc

; ==============================================================================
; GUI STATE HELPERS
; ==============================================================================
Func _SetControlsEnabled($bEnable)
    Local $iState = $bEnable ? $GUI_ENABLE : $GUI_DISABLE
    GUICtrlSetState($inpMoney, $iState)
    GUICtrlSetState($cmbFoodType, $iState)
    GUICtrlSetState($inpFoodCount, $iState)
    GUICtrlSetState($btnMaxMoney, $iState)
    GUICtrlSetState($btnBestFood, $iState)
EndFunc

Func _SetStatus($sText, $iColor, $iHoldMs = 0)
    GUICtrlSetData($lblStatus, $sText)
    GUICtrlSetColor($lblStatus, $iColor)
    If $iHoldMs > 0 Then
        $g_hStatusHoldTimer = TimerInit()
        $g_iStatusHoldMs    = $iHoldMs
    Else
        $g_iStatusHoldMs    = 0
    EndIf
EndFunc

Func _IsStatusHolding()
    If $g_iStatusHoldMs <= 0 Then Return False
    If TimerDiff($g_hStatusHoldTimer) < $g_iStatusHoldMs Then Return True
    $g_iStatusHoldMs = 0
    Return False
EndFunc

Func _OnMinimize()
    GUISetState(@SW_MINIMIZE, $hGUI)
EndFunc

Func _OnExit()
    AdlibUnRegister("_PollGame")
    If IsArray($g_hMemory) Then
        _MemoryClose($g_hMemory)
        $g_hMemory = 0
    EndIf
    _Metro_GUIDelete($hGUI)
    Exit
EndFunc
