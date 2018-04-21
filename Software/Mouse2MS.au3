#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <APISysConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WinAPIGdi.au3>
#include <WinAPIMisc.au3>
#include <WinAPISys.au3>
#include <WindowsConstants.au3>
#include "CommMG.au3"
;~ $mgdebug = True
Global $sportSetError
$tset = _ComGetPortNames()
For $i = 0 To UBound($tset) - 1
	If $tset[$i][1] = "Serielles USB-Gerät" Then
		$COMPort = StringTrimLeft($tset[$i][0], 3)
		ConsoleWrite("Teensy an Port COM" & $COMPort & " gefunden!" & @CRLF)
	EndIf
Next
$resOpen = _CommSetPort($COMPort, $sportSetError, 31250, 8, 0, 1, 0, 0, 0)
If $resOpen = 0 Then
	ConsoleWrite($sportSetError & @LF)
   Exit
EndIf

Global $g2_toogle = False
AdlibRegister("g2_proc",1000)

$atagRID_DEVICE_INFO_HID = 'struct;dword VendorId;dword ProductId;dword VersionNumber;ushort UsagePage;ushort Usage;endstruct'
$atagRID_INFO_HID = 'dword Size;dword Type;' & $atagRID_DEVICE_INFO_HID & ';dword Unused[2]'

Opt('TrayAutoPause', 0)
; Create GUI
Global $g_hForm = GUICreate('G600', 100, 25, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))

Local $tRID = DllStructCreate($tagRAWINPUTDEVICE)
DllStructSetData($tRID, 'Flags', $RIDEV_INPUTSINK)
DllStructSetData($tRID, 'hTarget', $g_hForm)

DllStructSetData($tRID, 'UsagePage', 0x80) ; Logitech G600
DllStructSetData($tRID, 'Usage', 0x0A) ;
_WinAPI_RegisterRawInputDevices($tRID)

; Now iterate to find other devices
Local $tText, $aData = _WinAPI_EnumRawInputDevices()
If IsArray($aData) Then
	ReDim $aData[$aData[0][0] + 1][3]
	$tText = DllStructCreate('wchar[256]')
	For $i = 1 To $aData[0][0]
		If _WinAPI_GetRawInputDeviceInfo($aData[$i][0], $tText, 256, $RIDI_DEVICENAME) Then
			$aData[$i][2] = DllStructGetData($tText, 1)
		Else
			$aData[$i][2] = ''
		EndIf

		If $aData[$i][1] = $RIM_TYPEHID Then
			$devInf = DllStructCreate($atagRID_INFO_HID)

			If _WinAPI_GetRawInputDeviceInfo($aData[$i][0], $devInf, DllStructGetSize($devInf), $RIDI_DEVICEINFO) Then
				If DllStructGetData($devInf, 'VendorId') = 0x046D And DllStructGetData($devInf, 'ProductId') = 0xC24A Then ; G600 VID & PID
					ConsoleWrite("Device Info:-" & @CRLF)
					ConsoleWrite('VendorId: ' & Hex(DllStructGetData($devInf, 'VendorId'), 4) & @CRLF)
					ConsoleWrite('ProductId: ' & Hex(DllStructGetData($devInf, 'ProductId'), 4) & @CRLF)
					ConsoleWrite('VersionNumber: ' & DllStructGetData($devInf, 'VersionNumber') & @CRLF)
					ConsoleWrite('UsagePage: ' & Hex(DllStructGetData($devInf, 'UsagePage'), 2) & @CRLF)
					ConsoleWrite('Usage: ' & Hex(DllStructGetData($devInf, 'Usage'), 2) & @CRLF)

					DllStructSetData($tRID, 'UsagePage', DllStructGetData($devInf, 'UsagePage'))
					DllStructSetData($tRID, 'Usage', DllStructGetData($devInf, 'Usage'))
					_WinAPI_RegisterRawInputDevices($tRID)
				EndIf
			EndIf
		EndIf
	Next
EndIf



; Register WM_INPUT message
GUIRegisterMsg($WM_INPUT, 'WM_INPUT')

GUISetState(@SW_SHOW)

Global $structHID_DATA = "struct;" & _
		"dword Type;" & _
		"dword Size;" & _
		"handle hDevice;" & _
		"wparam wParam;" & _
		"dword dwSizeHid;" & _
		"dword dwCount;" & _
		"endstruct;"


Global $structWACOM_PEN_DATA = "struct;" & _
		"dword Type;" & _
		"dword Size;" & _
		"handle hDevice;" & _
		"wparam wParam;" & _
		"dword dwSizeHid;" & _
		"dword dwCount;" & _
		"ubyte bRawData00;" & _
		"ubyte penvsEraser;" & _
		"word x;" & _
		"word y;" & _
		"word proximity;" & _
		"word pressure;" & _
		"ubyte bRawData09;" & _
		"ubyte bRawData10;" & _
		"ubyte bRawData11;" & _
		"ubyte bRawData12;" & _
		"ubyte bRawData13;" & _
		"ubyte bRawData14;" & _
		"ubyte bRawData15;" & _
		"ubyte bRawData16;" & _
		"ubyte bRawData17;" & _
		"ubyte bRawData18;" & _
		"ubyte bRawData19;" & _
		"ubyte bRawData20;" & _
		"ubyte bRawData21;" & _
		"ubyte bRawData22;" & _
		"ubyte bRawData23;" & _
		"ubyte bRawData24;" & _
		"ubyte bRawData25;" & _
		"ubyte bRawData26;" & _
		"ubyte bRawData27;" & _
		"ubyte bRawData28;" & _
		"ubyte bRawData29;" & _
		"ubyte bRawData30;" & _
		"ubyte bRawData31;" & _
		"ubyte bRawData32;" & _
		"ubyte bRawData33;" & _
		"ubyte tilt_ba;" & _
		"ubyte bRawData35;" & _
		"ubyte tilt_na;" & _
		"ubyte bRawData37;" & _
		"endstruct;"

Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE

Func WM_INPUT($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $wParam


	Switch $hWnd
		Case $g_hForm
			Local $tRIM = DllStructCreate($tagRAWINPUTHEADER)
			If _WinAPI_GetRawInputData($lParam, $tRIM, DllStructGetSize($tRIM), $RID_HEADER) Then ; Retrieves the raw input from the specified device
				$devType = DllStructGetData($tRIM, 'Type')
				$devSize = DllStructGetData($tRIM, 'Size')
			Else
				ConsoleWrite("Device Header Retrieval Failed" & @CRLF)
				Return
			EndIf

			; Now use the handle to the device to get it's name
			Local $tText = DllStructCreate('wchar[256]')
			If _WinAPI_GetRawInputDeviceInfo(DllStructGetData($tRIM, 'hDevice'), $tText, 256, $RIDI_DEVICENAME) Then
				$devName = DllStructGetData($tText, 1)
			Else
				ConsoleWrite("Device Name Retrieval Failed" & @CRLF)
			EndIf

			If $devType = $RIM_TYPEHID Then

				$tRIM = DllStructCreate($structWACOM_PEN_DATA)
				If _WinAPI_GetRawInputData($lParam, $tRIM, DllStructGetSize($tRIM), $RID_INPUT) Then
					If DllStructGetData($tRIM, 8) = 32 Then ; filter for ring key down (G-Mode)
						Switch DllStructGetData($tRIM, 9) ; if in g mode assign the Keys G9 to G20 to autoit functions.
							Case 0
								Return ; key released
							Case 1
								g1()
							Case 2
								g2()
							Case 4
								g3()
							Case 8
								g4()
							Case 16
								g5()
							Case 32
								g6()
							Case 64
								g7()
							Case 128
								g8()
							Case 256
								g9()
							Case 512
								g10()
							Case 1024
								g11()
							Case 2048
								g12()
							Case Else
								;;;
								ConsoleWrite(DllStructGetData($tRIM, 9) & @CRLF)
						EndSwitch

					EndIf
				EndIf
			EndIf

	EndSwitch
	Sleep(50)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_INPUT

Func g1()
	ConsoleWrite("g1" & @CRLF)
	_CommSendString("KEY_TAB" & @LF)
	Sleep(Random(50, 100, 1))
	_CommSendString("KEY_RELEASE_ALL" & @LF)
	Sleep(Random(50, 100, 1))
	_CommSendString("KEY_2" & @LF)
	Sleep(Random(50, 100, 1))
	_CommSendString("KEY_RELEASE_ALL" & @LF)
EndFunc   ;==>g1

Func g2()
	ConsoleWrite("g2" & @CRLF)
	$g2_toogle = not $g2_toogle
EndFunc   ;==>g2
Func g2_proc()
	if $g2_toogle then
		g1()
		Sleep(Random(50, 100, 1))
		_CommSendString("MOUSE_CLICK_RIGHT" & @LF)
	EndIf
EndFunc

Func g3()
	ConsoleWrite("g3" & @CRLF)
EndFunc   ;==>g3
Func g4()
	ConsoleWrite("g4" & @CRLF)
EndFunc   ;==>g4
Func g5()
	ConsoleWrite("g5" & @CRLF)
EndFunc   ;==>g5
Func g6()
	ConsoleWrite("g6" & @CRLF)
EndFunc   ;==>g6
Func g7()
	ConsoleWrite("g7" & @CRLF)
EndFunc   ;==>g7
Func g8()
	ConsoleWrite("g8" & @CRLF)
EndFunc   ;==>g8
Func g9()
	ConsoleWrite("g9" & @CRLF)
EndFunc   ;==>g9
Func g10()
	ConsoleWrite("g10" & @CRLF)
EndFunc   ;==>g10
Func g11()
	ConsoleWrite("g11" & @CRLF)
EndFunc   ;==>g11
Func g12()
	ConsoleWrite("g12" & @CRLF)
EndFunc   ;==>g12
