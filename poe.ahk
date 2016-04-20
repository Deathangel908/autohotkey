Loop {
	if (not isPoeClosed() and isLowHp()) {
		send {1}
	}
	Sleep, 100
}

global debugInited := false
global Debug
global charActive := false
global lolka := 1

isLowHp() {
	charActive := isCharacterActive()
	PixelGetColor, lowHpColor, 124, 1005
	return charActive and getColor(lowHpColor) != "r" 
}

isCharacterActive() {
	PixelGetColor, colorTopManaBorder, 1890, 913
	PixelGetColor, colorShop, 1458, 1000
	colorShopSat := getColor(colorShop)
	colorManaBorderSat := getColor(colorTopManaBorder)
	newCharActiveStatus := colorManaBorderSat == "grey" and colorShopSat == "g"
	if (not charActive and newCharActiveStatus) {
		sleep 300 ; delay if it wasn't active for outside functions like @isLowHp()
	}
	charActive := newCharActiveStatus
	return charActive
}

getColor(color) {
	return getColorDebug(color, false)
}

getColorDebug(color, printDebug) {
	Blue:="0x" SubStr(color,3,2) ;substr is to get the piece
	Blue:=Blue+0 ;add 0 is to convert it to the current number format
	Green:="0x" SubStr(color,5,2)
	Green:=Green+0
	Red:="0x" SubStr(color,7,2)
	Red:=Red+0
	satur := 35
	diff := sqrt((blue - green)*(blue - green) + (blue - red)*(blue - red) + (red - green)*(red - green))
	if (color == 0x000000) {
		colorReal := "black"
	} else if (color == 0xFFFFFF){
		colorReal := "white" 
	} else if (diff < 8) {
		colorReal := "grey"
	} else if (blue < 10 and green > 40 and green < 60 and red > 100 and red < 200) {
		colorReal := "brown"
	} else if (blue + satur < red and green + satur < red) {
		colorReal := "r"
	} else if (red + satur < green and blue + satur < green) {
		colorReal := "g"
	} else if (red + satur < blue and green + satur < blue) {
		colorReal := "b"
	} else {
		colorReal := "u" ;unknown
	}
	if (printDebug) {
		DebugAppend( "R:" red ";G:" green ";B:" blue )
	}
	return colorReal
}

DebugAppend(Data) {
	if (!debugInited) {
		Gui, Add, Edit, Readonly x10 y10 w400 h300 vDebug
		Gui, Show, w420 h320, Debug Window
		debugInited := true
	}
	GuiControlGet, Debug
	GuiControl,, Debug, %Data%`r`n
}


$F1::Remaining()
$F2::DrinkFlask()
$F3::SwitchBoth()
$F4::OpenPortal()
;$f12::reload
;$`::PhaseRun()
;$A::IceCrash()

IceCrash() {
	if (isPoeClosed() or isChatOpen()) {
		send {a}
		return
	}
	PixelGetColor, qSkillColor, 1453, 1056
	rgbQSkill := getColor(qSkillColor)
	DebugAppend(rgbQSkill)
	if (rgbQSkill == "g") {
		send {x}
		sleep 100
		send {q}
	} else if (rgbQSkill == "b") {
		send {q}
	}
}


isChatOpen() {
	PixelGetColor, XChatColor, 679, 392
	PixelGetColor, afterChatTypeColor, 80, 790
	rgbX := getColor(XChatColor)
	rgbName := getColor(afterChatTypeColor)
	return rgbX == "brown" and rgbName == "black"
}

PhaseRun() {
	if (isPoeClosed()  or isChatOpen()) {
		send {`}
		return
	}
	PixelGetColor, qSkillColor, 1453, 1056
	rgbQSkill := getColor(qSkillColor)
	if (rgbQSkill == "g") {
		send {q}
	} else if (rgbQSkill == "b") {
		send {x}
		sleep 100
		send {q}
	}
}

Remaining() {
	if (isPoeClosed()) {
		send {f1}
		return
	}
	BlockInput On
	Send {Enter}
	Sleep 1
	Send /remaining
	Send {Enter}
	BlockInput Off
	return
}

FastLogOut(){
	if (isPoeClosed()) {
		return
	}
	BlockInput On
	SetDefaultMouseSpeed 0
	sendinput {esc}
	MouseClick, left, 959, 432, 1, 1
	BlockInput Off
	return
}



isPoeClosed() {
	IfWinNotActive , Path of Exile 
	{ 
		return true
	}
}

OpenInventory() {
	PixelGetColor, colorKaomBack, 1581, 366
	if (colorKaomBack != 0x200706) {
		Send {i}
		Sleep 30
		return true
	} else {
		return false
	}
}

SwitchBoth() {
	if (isPoeClosed()) {
		send {f3}
		return
	}
	yBottomGems := 825
	squareDimension := 54
	firstBottomGemX := 1719
	secondBottomGemX := firstBottomGemX + squareDimension
	thirdBottomGemX := firstBottomGemX + squareDimension * 2
	
	MouseGetPos, xpos, ypox
	BlockInput On
	closeInvAfter := OpenInventory()
	PixelGetColor, middleLeftSocketColor, 1350, 225
	middleLeftSocketColorRgb := getColor(middleLeftSocketColor)
	if (middleLeftSocketColorRgb != "r") {
		send {x}
		sleep 50
	}
	Click left %firstBottomGemX%, %yBottomGems%
	Sleep 1
	Click left 1353, 173 ; top left staff
	Sleep 1
	Click left %firstBottomGemX%, %yBottomGems%
	Sleep 1
	
	Click left %secondBottomGemX%, %yBottomGems%
	Sleep 1
	Click left 1557, 189 ; top left staff
	Sleep 1
	Click left %secondBottomGemX%, %yBottomGems%
	Sleep 1
	
	Click left %thirdBottomGemX%, %yBottomGems%
	Sleep 1
	Click left 1478, 371
	Sleep 1
	Click left %thirdBottomGemX%, %yBottomGems%
	Sleep 1
	
	
	if (closeInvAfter) {
		Send {i}
	}
	MouseMove xpos, ypox 
	BlockInput Off
	return
}


OpenPortal(){
	if (isPoeClosed()) {
		send {f4}
		return
	}
	MouseGetPos, xpos, ypox
	BlockInput On
	OpenInventory()
	Click right 1881,838 
	Send {i}
	Sleep 1
	Click left 960, 450 
	BlockInput Off
	return
}

DrinkFlask() {
	if (isPoeClosed()) {
		send {f2}
		return
	}
	Send {2}
	Send {3}
	Send {4}
	Send {5}
}

