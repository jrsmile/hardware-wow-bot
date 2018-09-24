#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=y
#include 'CommMG.au3'
#include "MailSlot.au3"

Global Const $sMailSlotName = "\\.\mailslot\MS2Serial"

Global $hMailSlot = _MailSlotCreate($sMailSlotName)
If @error Then
	MsgBox(48 + 262144, "MailSlot", "Failed to create new account!" & @CRLF & "Probably one using that 'address' already exists.")
	Exit
EndIf


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

While True
	While Not _MailSlotCheckForNextMessage($hMailSlot)
		Sleep(1)
	WEnd
	Local $iSize = _MailSlotCheckForNextMessage($hMailSlot)
	Local $sData = _MailSlotRead($hMailSlot, $iSize, 1)
	_CommSendString($sData & @LF)
	Sleep(Random(10, 20, 1))
WEnd
_MailSlotClose($hMailSlot)

#cs
	if (str == "KEY_A") {
	Keyboard.press('a');
	} else if (str == "KEY_B") {
	Keyboard.press('b');
	} else if (str == "KEY_C") {
	Keyboard.press('c');
	} else if (str == "KEY_D") {
	Keyboard.press('d');
	} else if (str == "KEY_E") {
	Keyboard.press('e');
	} else if (str == "KEY_F") {
	Keyboard.press('f');
	} else if (str == "KEY_G") {
	Keyboard.press('g');
	} else if (str == "KEY_H") {
	Keyboard.press('h');
	} else if (str == "KEY_I") {
	Keyboard.press('i');
	} else if (str == "KEY_J") {
	Keyboard.press('j');
	} else if (str == "KEY_K") {
	Keyboard.press('k');
	} else if (str == "KEY_L") {
	Keyboard.press('l');
	} else if (str == "KEY_M") {
	Keyboard.press('m');
	} else if (str == "KEY_N") {
	Keyboard.press('n');
	} else if (str == "KEY_O") {
	Keyboard.press('o');
	} else if (str == "KEY_P") {
	Keyboard.press('p');
	} else if (str == "KEY_Q") {
	Keyboard.press('q');
	} else if (str == "KEY_R") {
	Keyboard.press('r');
	} else if (str == "KEY_S") {
	Keyboard.press('s');
	} else if (str == "KEY_T") {
	Keyboard.press('t');
	} else if (str == "KEY_U") {
	Keyboard.press('u');
	} else if (str == "KEY_V") {
	Keyboard.press('v');
	} else if (str == "KEY_W") {
	Keyboard.press('w');
	} else if (str == "KEY_X") {
	Keyboard.press('x');
	} else if (str == "KEY_Y") {
	Keyboard.press('y');
	} else if (str == "KEY_Z") {
	Keyboard.press('z');
	} else if (str == "KEY_1") {
	Keyboard.press('1');
	} else if (str == "KEY_2") {
	Keyboard.press('2');
	} else if (str == "KEY_3") {
	Keyboard.press('3');
	} else if (str == "KEY_4") {
	Keyboard.press('4');
	} else if (str == "KEY_5") {
	Keyboard.press('5');
	} else if (str == "KEY_6") {
	Keyboard.press('6');
	} else if (str == "KEY_7") {
	Keyboard.press('7');
	} else if (str == "KEY_8") {
	Keyboard.press('8');
	} else if (str == "KEY_9") {
	Keyboard.press('9');
	} else if (str == "KEY_0") {
	Keyboard.press('0');
	} else if (str == "KEY_LEFT_CTRL") {
	Keyboard.press(KEY_LEFT_CTRL);
	} else if (str == "KEY_LEFT_SHIFT") {
	Keyboard.press(KEY_LEFT_SHIFT);
	} else if (str == "KEY_LEFT_ALT") {
	Keyboard.press(KEY_LEFT_ALT);
	} else if (str == "KEY_LEFT_GUI") {
	Keyboard.press(KEY_LEFT_GUI);
	} else if (str == "KEY_RIGHT_CTRL") {
	Keyboard.press(KEY_RIGHT_CTRL);
	} else if (str == "KEY_RIGHT_SHIFT") {
	Keyboard.press(KEY_RIGHT_SHIFT);
	} else if (str == "KEY_RIGHT_ALT") {
	Keyboard.press(KEY_RIGHT_ALT);
	} else if (str == "KEY_RIGHT_GUI") {
	Keyboard.press(KEY_RIGHT_GUI);
	} else if (str == "KEY_UP_ARROW") {
	Keyboard.press(KEY_UP_ARROW);
	} else if (str == "KEY_DOWN_ARROW") {
	Keyboard.press(KEY_DOWN_ARROW);
	} else if (str == "KEY_LEFT_ARROW") {
	Keyboard.press(KEY_LEFT_ARROW);
	} else if (str == "KEY_RIGHT_ARROW") {
	Keyboard.press(KEY_RIGHT_ARROW);
	} else if (str == "KEY_TAB") {
	Keyboard.press(KEY_TAB);
	} else if (str == "KEY_RETURN") {
	Keyboard.press(KEY_RETURN);
	} else if (str == "KEY_ESC") {
	Keyboard.press(KEY_ESC);
	} else if (str == "KEY_RELEASE_ALL") {
	Keyboard.releaseAll();
	} else if (str == "MOUSE_CLICK_LEFT") {
	Mouse.click(MOUSE_LEFT);
	} else if (str == "MOUSE_CLICK_RIGHT") {
	Mouse.click(MOUSE_RIGHT);
	} else if (str == "MOUSE_RELEASE") {
#ce
