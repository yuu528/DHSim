/*
DHSim by Yuu528
  Simulate H-Shifter using Gamepad

To change settings, please edit lines from 18
*/

#SingleInstance, force
#include lib/AHK-CvJoyInterface/CvJoyInterface.ahk
#include lib/XInput.ahk

; Init XInput
XInput_Init()

; ==========================================
; SETTINGS
; - BUTTONS
KEY_SHIFT_UP    := XINPUT_GAMEPAD_DPAD_UP
KEY_SHIFT_DOWN  := XINPUT_GAMEPAD_DPAD_DOWN
KEY_SHIFT_RESET := XINPUT_GAMEPAD_LEFT_THUMB

; - GAMEPADS
VJOY_ID         := 1 ; Start from 1

; - OTHERS
SETUP_WAIT      := 5000 ; ms
; ==========================================

; Check xinput controller
padIds := ""
Loop, 4 {
	XInput_GetState(A_Index - 1)
	if (ErrorLevel = 0) {
		padIds .= (A_Index - 1) . "|"
	}
}

if (StrLen(padIds) = 0) {
	MsgBox, , Error, Any XInput controller is not found.
	ExitApp
}

; Trim last "|" and set first id as default
padIds := StrReplace(RTrim(padIds, "|"), "|", "||", barCount , 1)

if (barCount = 0) {
	padIds .= "||"
}

padId := SubStr(padIds, 1, 1)

; Init vJoy
vJoyInterface := new CvJoyInterface()

if (!vJoyInterface.vJoyEnabled()){
	Msgbox % vJoyInterface.LoadLibraryLog
	ExitApp
}

myStick := vJoyInterface.Devices[VJOY_ID]

resetButtons()

; Init GUI
Gui, +AlwaysOnTop
Gui, Add, Text, x10 w35, Pos
Gui, Add, Text, x+5 w100 vPosText, N
Gui, Add, Text, x10 w35, Btn
Gui, Add, Text, x+5 w100 vDirText, None
Gui, Add, Text, x10 w35, PadID
Gui, Add, DropDownList, x+5 w40 vPadIdDDL gChangePadId, %padIds%
Gui, Add, Text, x10 w150 vMiscText
Gui, Add, Button, x10 w80 gStartSetup, Setup
Gui, Add, Button, x+5 w80 gShowAbout, About

Gui, Show, W200, DHSim
OnExit, GuiClose

enabled := true

; Start timer
SetTimer watchPOV, 5

Return

startSetup() {
	global enabled
	global myStick
	global SETUP_WAIT
	enabled := false

	resetButtons()

	GuiControl, , MiscText, Key setup is starting.
	Sleep, 3000

	for k, v in Object("Reverse", 1, "1", 3, "2", 4, "3", 5, "4", 6, "5", 7, "6", 8) {
		GuiControl, , MiscText, Pos %k%: Waiting...
		Sleep, SETUP_WAIT
		myStick.SetBtn(1, v)
		Sleep, 500
		myStick.SetBtn(0, v)
	}

	GuiControl, , MiscText, Completed!
	Sleep, 2000
	GuiControl, , MiscText,

	enabled := true
}

changePadId() {
	global padId
	GuiControlGet, padId, , padIdDDL
}

showAbout() {
	MsgBox, , About DHSim, DHSim by Yuu528`nhttps://yuu-g.net
}

watchPOV() {
	global myStick
	global KEY_SHIFT_UP
	global KEY_SHIFT_DOWN
	global KEY_SHIFT_RESET
	global padId
	global enabled

	if enabled {
		static shiftPos := 0
		static povDir := ""

		btnState := XInput_GetState(padId).wButtons
		povDirPrev := povDir

		if (btnState & KEY_SHIFT_RESET) {
			povDir := "Reset"
		} else if (btnState & KEY_SHIFT_UP) {
			povDir := "Up"
		} else if (btnState & KEY_SHIFT_DOWN) {
			povDir := "Down"
		} else {
			povDir := "None"
		}

		if (povDir = povDirPrev) {
			return
		}

		myStick.SetBtn(0, shiftPos + 2)

		GuiControl, , DirText, % povDir

		; Reset gear when pressed left thumb
		if(povDir = "Reset") {
			shiftPos := 0
			GuiControl, , PosText, N

			Return
		}

		; Set gear to N on keydown
		if(povDir != "None") {
			GuiControl, , PosText, N
			Return
		}

		; Set gear on keyup
		; calculate gear pos
		switch povDirPrev {
			case "Up":
				shiftPos++

			case "Down":
				shiftPos--
		}

		if (shiftPos > 6) {
			shiftPos := 6
		} else if (shiftPos < -1) {
			shiftPos := -1
		}

		; Show gear text
		gear := shiftPos
		if (shiftPos = -1) {
			gear := "R"
		} else if (shiftPos = 0) {
			gear := "N"
		}

		GuiControl, , PosText, % gear

		; Press vJoy key
		if(shiftPos != 0) {
			myStick.SetBtn(1, shiftPos + 2)
		}
	}
}

resetButtons() {
	Loop, 8 {
		myStick.SetBtn(0, A_Index + 1)
	}
}

GuiClose:
	resetButtons()
	ExitApp
