#include <_PixelGetColor.au3>

Dim $testMaxX = 200
Dim $testMaxY = 1

while True
CaptureUDF($testMaxX, $testMaxY)
Sleep(100)
WEnd

Func CaptureUDF($xmax, $ymax)
   Local $hDll = DllOpen("gdi32.dll")
   local $vDC = _PixelGetColor_CreateDC($hDll)
	$vRegion = _PixelGetColor_CaptureRegion($vDC, 0, 0, $xmax, $ymax, False, $hDll)
	For $x = 1 To $xmax step 10
		For $y = 1 To $ymax step 10
			ConsoleWrite ("X:" & $x & @TAB & "Y:" & $y & @TAB & "Color: " & @TAB & _PixelGetColor_GetPixel($vDC, $x, $y, $hDll) & @CRLF)
		Next
	Next
	_PixelGetColor_ReleaseRegion($vRegion)
	DllClose($hDll)
EndFunc   ;==>CaptureUDFw