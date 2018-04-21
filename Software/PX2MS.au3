#include <array.au3>
#include "FastFind.au3"
#include "mailslot.au3"
#NoTrayIcon
FFSetDefaultSnapShot(0)
Global Const $iWidth = 360
Global Const $sMailSlotName = "\\.\mailslot\PX2MS"

While True
	If FFSnapShot(1, 1, $iWidth, 1) = 1 Then ; 10x200 pixels area
		$sample = FFGetRawData()
		$asample = StringRegExp($sample, "\N{8}", 3)
		$auniq = _ArrayUnique($asample, 0, 0, 0, 0, 1)
		Local $aRes[UBound($auniq)][2]
		For $i = 0 To UBound($auniq) - 1
			$acnt = _ArrayFindAll($asample, $auniq[$i])
			$aRes[$i][0] = $auniq[$i]
			$aRes[$i][1] = UBound($acnt)
		Next
		$sRes = ""
		For $y = 0 To UBound($aRes, 1) - 1
			If $aRes[$y][0] = "00000000" Then ContinueLoop
				$sRes &= $aRes[$y][0] & "," & $aRes[$y][1] & @CRLF
			Next
;~ 			ToolTip($sRes)
			_MailSlotWrite($sMailSlotName, $sRes)
			Sleep(10)
		EndIf
	WEnd
