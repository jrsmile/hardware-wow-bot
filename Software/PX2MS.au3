#AutoIt3Wrapper_UseX64=y
#NoTrayIcon
#include <array.au3>
#include "MailSlot.au3"
Local $width, $hight, $output, $hdll,$o_byte,$o_size
Global Const $sMailSlotName = "\\.\mailslot\PX2MS"
While True
$hDLL = DllOpen("DXGCap64.dll")
;~ void init()
DllCall($hDLL, "none:cdecl", "init")
If @error Then Exit -1

;~ void* create_dxgi_manager()
$aCall = DllCall($hDLL, "ptr:cdecl", "create_dxgi_manager")
If @error Then Exit -2

; Read data
$pManager = $aCall[0]

;~ void get_output_dimensions(void*const dxgi_manager, uint32_t* width, uint32_t* height)
;~ $aCall = DllCall($hDLL, "none:cdecl", "get_output_dimensions", "ptr", $pManager, "uint*", 0, "uint*", 0)
;~ If @error Then Exit -3

;~ ConsoleWrite("Width = " & $aCall[2] & ", Height = " & $aCall[3] & @CRLF)
;~ uint8_t get_frame_bytes(void* dxgi_manager, size_t* o_size, uint8_t** o_bytes)
Local $pBuffer, $iBufferSize
$aCall = DllCall($hDLL, "byte:cdecl", "get_frame_bytes", "ptr", $pManager, "uint*", 0, "ptr*", 0)
If @error Then Exit -4

; Read data
$iBufferSize = $aCall[2]
$pBuffer = $aCall[3]

$iBufferSize =2050

; Fill the buffer
$aCall = DllCall($hDLL, "byte:cdecl", "get_frame_bytes", "ptr", $pManager, "uint*", $iBufferSize, "ptr", $pBuffer)
If @error Then Exit -5

; Make the data accessible thru dllstruct
$tData = DllStructCreate("byte[" & $iBufferSize & "]", $pBuffer)
If @error Then Exit -6
$screen = BinaryMid(DllStructGetData($tData, 1), 6,2048)
$tData = 0
; $screen holds Pixel Data in BGRA Format
$asample = StringRegExp($screen, "\N{8}", 3)
		$auniq = _ArrayUnique($asample, 0, 0, 0, 0, 1)
		Local $aRes[UBound($auniq)][2]
		For $i = 0 To UBound($auniq) - 1
			$acnt = _ArrayFindAll($asample, $auniq[$i])
			$aRes[$i][0] = $auniq[$i]
			$aRes[$i][1] = UBound($acnt)
		Next
		$sRes = ""
		For $y = 0 To UBound($aRes, 1) - 1
			If $aRes[$y][0] = "000000FF" Then ContinueLoop
			If $aRes[$y][0] = "0x020000" Then ContinueLoop
			$sRes &= $aRes[$y][0] & "," & $aRes[$y][1] & @CRLF
		Next
;~ 		ToolTip($sRes)
		_MailSlotWrite($sMailSlotName, $sRes)
;~ ConsoleWrite("Data = " & $screen & @CRLF) ; print first 30000 bytes

;~ void delete_dxgi_manager(void* dxgi_manager)
DllCall($hDLL, "none:cdecl", "delete_dxgi_manager", "ptr", $pManager)
If @error Then Exit -7

DllCall($hDLL, "none", "uninit")
DllClose($hDLL)
Sleep(33)
WEnd
