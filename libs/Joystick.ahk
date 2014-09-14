#include, libs\VJoy_lib.ahk
#include, libs\Gui.ahk


Init_JoyStick(i := 1)
{
	Global iInterface, xCenter, xCurLeft, xCurRight, moveLeft, moveRight, yCenter, yCurFwrd, yCurBwrd, moveFwrd, moveBwrd, speedMod, curSpeedMod
	Global pilotMode, hover 
	
	iInterface := i
	mydev := VJoy_Init(iInterface)
	if (!VJoy_Ready(iInterface)) {
		MsgBox, Device %iInterface% not ready.
		VJoy_Close()
		ExitApp
	}
	
	speedMod := 0.6
	curSpeedMod := 1
	
	xCenter := VJoy_GetAxisMax_X(iInterface) / 2
	xCurLeft := 0
	xCurRight := 0
	moveLeft := 0
	moveRight := 0

	yCenter := VJoy_GetAxisMax_Y(iInterface) / 2
	yCurFwrd := 0
	yCurBwrd := 0
	moveFwrd := 0
	moveBwrd := 0
	
	pilotMode := 0
	hover := 0
	
	SetNormalThrottle(Round(speedMod*100))
	SetPilotHover(Round(hover*100))
}

DecreaseHover()
{
	Global hover
	hover := hover - 0.02
	if hover < -1
		hover := -1
	SetPilotHover(Round(hover*100))
}

IncreaseHover()
{
	Global hover
	hover := hover + 0.02
	if hover > 1
		hover := 1
	SetPilotHover(Round(hover*100))
}

Hover()
{
	Global iInterface, yCenter, curSpeed, hover
	curSpeed := hover
	
	VJoy_SetAxis_Y(Round(yCenter - curSpeed * yCenter), iInterface)
	SetPilotThrottle(Round(curSpeed*100))
}

ResetJoystickPos()
{
	Global iInterface, xCenter, yCenter
	VJoy_SetAxis_X(xCenter, iInterface)
	VJoy_SetAxis_Y(yCenter, iInterface)
}

ResetJoystick()
{
	Global iInterface, xCenter, xCurLeft, xCurRight, moveLeft, moveRight, yCenter, yCurFwrd, yCurBwrd, moveFwrd, moveBwrd, speedMod, curSpeedMod
	Global pilotMode, hover, curSpeed
	
	speedMod := 0.6
	curSpeedMod := 1
	
	xCenter := VJoy_GetAxisMax_X(iInterface) / 2
	xCurLeft := 0
	xCurRight := 0
	moveLeft := 0
	moveRight := 0

	yCenter := VJoy_GetAxisMax_Y(iInterface) / 2
	yCurFwrd := 0
	yCurBwrd := 0
	moveFwrd := 0
	moveBwrd := 0
	
	pilotMode := 0
	hover := 0
	
	
	VJoy_SetAxis_X(xCenter, iInterface)
	VJoy_SetAxis_Y(yCenter, iInterface)
	
	SetNormalThrottle(Round(speedMod*100))
	SetPilotHover(Round(hover*100))
}

SetPilotMode(b:=0)
{
	Global pilotMode, curSpeed, speedMod, hover  
	pilotMode := b
	
	if pilotMode = 1
	{
		curSpeed := 0
		SetPilotThrottle(Round(curSpeed*100))
		
		SetPilotHover(Round(hover*100))
	}
	else
	{
		SetNormalThrottle(Round(speedMod*100))
		SetPilotHover(0)
	}
		
		
}


	
ThrottleUp()
{
	Global iInterface, yCenter, curSpeed
	curSpeed := curSpeed + 0.02
	if curSpeed > 1
		curSpeed := 1
	
	VJoy_SetAxis_Y(Round(yCenter - curSpeed * yCenter), iInterface)
	
	SetPilotThrottle(Round(curSpeed*100))
}

ThrottleDown()
{
	Global iInterface, yCenter, curSpeed
	curSpeed := curSpeed - 0.02
	if curSpeed < -1
		curSpeed := -1

	VJoy_SetAxis_Y(Round(yCenter - curSpeed * yCenter), iInterface)
	
	SetPilotThrottle(Round(curSpeed*100))
}

IsPilotMode()
{
	Global pilotMode
	Return pilotMode
}

ThrottleFwrd()
{
	Global yCenter, yCurFwrd, yCurBwrd, moveFwrd, moveBwrd, curSpeedMod, iInterface
	yCurFwrd := yCenter
	moveFwrd := 1
	moveBwrd := 0
	VJoy_SetAxis_Y(Round(yCenter - curSpeedMod * yCurFwrd), iInterface)
}

ThrottleFwrdStop()
{
	Global yCenter, yCurFwrd, yCurBwrd, moveFwrd, moveBwrd, curSpeedMod, iInterface
	yCurFwrd := 0
	moveFwrd := 0
	VJoy_SetAxis_Y(Round(yCenter + curSpeedMod * yCurBwrd), iInterface)
	if yCurBwrd > 0
		moveBwrd := 1
}

ThrottleBwrd()
{
	Global yCenter, yCurFwrd, yCurBwrd, moveFwrd, moveBwrd, curSpeedMod, iInterface
	yCurBwrd := yCenter
	moveFwrd := 0
	moveBwrd := 1
	VJoy_SetAxis_Y(Round(yCenter + curSpeedMod * yCurBwrd), iInterface)
}

ThrottleBwrdStop()
{
	Global yCenter, yCurFwrd, yCurBwrd, moveFwrd, moveBwrd, curSpeedMod, iInterface
	yCurBwrd := 0
	moveBwrd := 0
	VJoy_SetAxis_Y(Round(yCenter - curSpeedMod * yCurFwrd), iInterface)
	if yCurFwrd > 0
		moveFwrd := 1
}

ThrottleLeft()
{
	Global xCenter, xCurLeft, xCurRight, moveLeft, moveRight, curSpeedMod, iInterface
	xCurLeft := xCenter
	moveRight := 0
	moveLeft := 1
	VJoy_SetAxis_X(Round(xCenter - curSpeedMod * xCurLeft), iInterface)
}

ThrottleLeftStop()
{
	Global xCenter, xCurLeft, xCurRight, moveLeft, moveRight, curSpeedMod, iInterface
	xCurLeft := 0
	moveLeft := 0
	VJoy_SetAxis_X(Round(xCenter + curSpeedMod * xCurRight), iInterface)
	if xCurRight > 0
		moveRight := 1
}

ThrottleRight()
{
	Global xCenter, xCurLeft, xCurRight, moveLeft, moveRight, curSpeedMod, iInterface
	xCurRight := xCenter
	moveRight := 1
	moveLeft := 0
	VJoy_SetAxis_X(Round(xCenter + curSpeedMod * xCurRight), iInterface)
}

ThrottleRightStop()
{
	Global xCenter, xCurLeft, xCurRight, moveLeft, moveRight, curSpeedMod, iInterface
	xCurRight := 0
	moveRight := 0
	VJoy_SetAxis_X(Round(xCenter - curSpeedMod * xCurLeft), iInterface)
	if xCurRight > 0
		moveLeft := 1
}

EnableSpeedMod(b)
{
	Global xCenter, xCurFwrd, xCurBwrd, moveLeft, moveRight, curSpeedMod, speedMod, yCenter, yCurFwrd, yCurBwrd, moveFwrd, moveBwrd, iInterface
	
	if b = 1
		curSpeedMod := speedMod
	else
		curSpeedMod := 1

	if moveFwrd = 1
		ThrottleFwrd()
	else if moveBwrd = 1
		ThrottleBwrd()
		
	if moveRight = 1
		ThrottleRight()
	else if moveLeft = 1
		ThrottleLeft()
}

IncreaseSpeedMod()
{
	Global speedMod, curSpeedMod
	speedMod:=speedMod + 0.02
	if speedMod > 1
	{
		speedMod:= 1
	}
	curSpeedMod := speedMod
	EnableSpeedMod(1)
	SetNormalThrottle(Round(speedMod*100))
}

DecreaseSpeedMod()
{
	Global speedMod, curSpeedMod
	speedMod:=speedMod - 0.02
	if speedMod < 0
	{
		speedMod:= 0
	}
	curSpeedMod := speedMod
	EnableSpeedMod(1)
	SetNormalThrottle(Round(speedMod*100))
}
