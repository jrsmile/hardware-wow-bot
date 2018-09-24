#include "MailSlot.au3"
#include <array.au3>

Global Const $sMailSlotNameSend = "\\.\mailslot\MS2Serial"
Global $aData, $update_pause
If @error Then
	MsgBox(48 + 262144, "MailSlot", "Failed to create new account!" & @CRLF & "Probably one using that 'address' already exists.")
	Exit
EndIf
AdlibRegister("update", 350)
Local Const $sMailSlotNameMouse = "\\.\mailslot\Mouse2MS"
Local $hMailSlot2 = _MailSlotCreate($sMailSlotNameMouse)
Global $g2 = False
While True
	While WinActive("World of Warcraft")
		$iSize2 = _MailSlotCheckForNextMessage($hMailSlot2)
		$sdata2 = ""
		$sdata2 = _MailSlotRead($hMailSlot2, $iSize2, 1)
		If $sdata2 = "g2" Then $g2 = Not $g2
		If ready2Cast() And EnemyCast() Then
			ToolTip("!Kick")
			_MailSlotWrite($sMailSlotNameSend, "KEY_8")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		If (ready2Cast() And Not targetHasSunfire()) Or (ready2Cast() And isMoving()) Then
			ToolTip("Sonnenfeuer")
			_MailSlotWrite($sMailSlotNameSend, "KEY_2")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		If (ready2Cast() And Not TargetHasMoonfire()) Or (ready2Cast() And isMoving()) Then
			ToolTip("Mondfeuer")
			_MailSlotWrite($sMailSlotNameSend, "KEY_1")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		If ready2Cast() And Not targetHasSolarfire()  Then
			ToolTip("Solarflare")
			_MailSlotWrite($sMailSlotNameSend, "KEY_9")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		If ready2Cast() And StarsurgeReady() Then
			ToolTip("Starsurge")
			_MailSlotWrite($sMailSlotNameSend, "KEY_5")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		If ready2Cast() And Not isMoving() And SolarEmpower() Then
			ToolTip("Zorn")
			_MailSlotWrite($sMailSlotNameSend, "KEY_3")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		If ready2Cast() And Not isMoving() And LunarEmpower() Then
			ToolTip("Lunarschlag")
			_MailSlotWrite($sMailSlotNameSend, "KEY_4")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		If ready2Cast() And EluneReady() Then
			ToolTip("Elune")
			_MailSlotWrite($sMailSlotNameSend, "KEY_0")
			Sleep(Random(1, 5, 1))
			_MailSlotWrite($sMailSlotNameSend, "KEY_RELEASE_ALL")
		EndIf
		Sleep(10)
	WEnd
	Sleep(10)

WEnd

Func ready2Cast()
	If InFight() and Not onGCD() And Not isCasting() And WinActive("World of Warcraft") And $g2 Then Return True
	Return False
EndFunc   ;==>ready2Cast

Func isCasting()
	If getData("414141FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>isCasting

Func isMoving()
	If getData("272727FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>isMoving


Func onGCD()
	If getData("171717FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>onGCD

Func TargetHasMoonfire()
	If getData("505050FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>TargetHasMoonfire

Func targetHasSunfire()
	If getData("515151FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func targetHasSolarfire()
	If getData("666666FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func StarsurgeReady()
	If getData("616161FF") <> 0 Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>StarsurgeReady

Func SolarEmpower()
	If getData("565656FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func LunarEmpower()
	If getData("575757FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func InstantLunar()
	If getData("585858FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func InFight()
	If getData("343434FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func InRange()
	If getData("191919FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func IsAFK()
	If getData("202020FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func EnemyCast()
	If getData("494949FF") <> 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>targetHasSunfire

Func EluneReady()
	If getData("676767FF") <> 0 Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>targetHasSunfire

Func update()
	If $update_pause Then Return
	Local Const $sMailSlotName = "\\.\mailslot\PX2MS"
	Local $hMailSlot = _MailSlotCreate($sMailSlotName)
	While Not _MailSlotCheckForNextMessage($hMailSlot)
		Sleep(1)
	WEnd
	Local $iSize = _MailSlotCheckForNextMessage($hMailSlot)
	Local $sData = _MailSlotRead($hMailSlot, $iSize, 1)
	_MailSlotClose($hMailSlot)
;~ 	ToolTip($sData)
	$aData = StringSplit($sData, @CRLF, 1)
EndFunc   ;==>update

Func getData($color)
	$update_pause = True
	For $i = 1 To $aData[0]
		If StringInStr($aData[$i], $color) Then
			$update_pause = False
			Return $aData[$i]
		Else
			ContinueLoop
		EndIf
	Next
	$update_pause = False
	Return 0
EndFunc   ;==>getData