#include "MailSlot.au3"
#include <array.au3>

Global Const $sMailSlotNameSend = "\\.\mailslot\MS2Serial"

If @error Then
	MsgBox(48 + 262144, "MailSlot", "Failed to create new account!" & @CRLF & "Probably one using that 'address' already exists.")
	Exit
EndIf

Local Const $sMailSlotNameMouse = "\\.\mailslot\Mouse2MS"
Local $hMailSlot2 = _MailSlotCreate($sMailSlotNameMouse)
Global $g2 = False
While True
	while WinActive("World of Warcraft")
;~ 	if getData("8A8F0200") <> 0 Then ConsoleWrite("GCD..." & @CRLF)
;~ 	if getData("048F2700") <> 0 Then ConsoleWrite("Moving..." & @CRLF)
;~ 	if getData("07078F00") <> 0 Then ConsoleWrite("Casting..." & @CRLF)
	$iSize2 = _MailSlotCheckForNextMessage($hMailSlot2)
	$sdata2 = ""
	$sData2 = _MailSlotRead($hMailSlot2, $iSize2, 1)
	if $sdata2 = "g2" Then $g2 = not $g2

	if ready2Cast() Then
		_MailSlotWrite($sMailSlotNameSend, "KEY_2")
		_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
	EndIf
	if ready2Cast() Then
		_MailSlotWrite($sMailSlotNameSend, "KEY_1")
		_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
	EndIf
	if ready2Cast() and not isMoving() Then
		_MailSlotWrite($sMailSlotNameSend, "KEY_3")
		_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
	EndIf
	if ready2Cast() and not isMoving()  Then
		_MailSlotWrite($sMailSlotNameSend, "KEY_3")
		_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
	EndIf
	if ready2Cast() and not isMoving()  Then
		_MailSlotWrite($sMailSlotNameSend, "KEY_3")
		_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
	EndIf
	if ready2Cast() Then
		_MailSlotWrite($sMailSlotNameSend, "KEY_4")
		_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
	EndIf
	if ready2Cast() and not isMoving()  Then
		_MailSlotWrite($sMailSlotNameSend, "KEY_6")
		_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
	EndIf
	Sleep(100)
	WEnd
	Sleep(10)
WEnd

func ready2Cast()
	if not onGCD() and not isCasting() and WinActive("World of Warcraft") and $g2 then Return True
	return False
EndFunc

func isCasting()
	if getData("07078F00") <> 0 then
		Return True
	Else
		Return False
	EndIf
EndFunc

func isMoving()
	if getData("048F2700") <> 0 then
		Return True
	Else
		Return False
	EndIf
EndFunc


func onGCD()
	if getData("8A8F0200") <> 0 then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func getData($color)
	Local Const $sMailSlotName = "\\.\mailslot\PX2MS"
	Local $hMailSlot = _MailSlotCreate($sMailSlotName)
	While Not _MailSlotCheckForNextMessage($hMailSlot)
		Sleep(1)
	WEnd
	Local $iSize = _MailSlotCheckForNextMessage($hMailSlot)
	Local $sData = _MailSlotRead($hMailSlot, $iSize, 1)
	_MailSlotClose($hMailSlot)
;~ 	ToolTip($sData)
	Local $aData = StringSplit($sData, @CRLF, 1)
	For $i = 1 To $aData[0]
;~ 		ConsoleWrite($aData[$i] &  @CRLF)
		If StringInStr($aData[$i], $color) Then
			Return $aData[$i]
		Else
			ContinueLoop
		EndIf
	Next
	Return 0
EndFunc   ;==>getData

;8A8F0200 ; GCD
;048F2700 ; moving
;07078F00 ; casting
