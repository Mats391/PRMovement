Init_CrouchToggle(pKey)
{
	Global key, toggle, chatting, crouchBefore
	toggle			:= 0
	chatting 		:= 0
	crouchBefore 	:= 0
	key := pKey
}


ResetCrouch()
{
	Global toggle, crouchBefore, chatting, key
	SendInput {%key% up}
	toggle			:= 0
}

SetCrouch(b, sendAgain := 0)
{
	Global toggle, crouchBefore, key
	toggle := b
	
	if toggle = 0
	{	
		if chatting = 1
			crouchBefore := 1
		SendInput {%key% up}
	}
	else
	{
		if sendAgain = 1
			SendInput {%key% down}
	}
}

ToggleCrouch()
{
	Global toggle
	if toggle = 1
		SetCrouch(0)
	else
		SetCrouch(1)
}

GetChatting()
{
	Global chatting
	Return chatting
}

SetChatting(b)
{
	Global chatting, crouchBefore, toggle
	chatting := b
	
	if chatting = 1
	{
		if toggle = 1
			crouchBefore := 1
		SetCrouch(0)
	}
	else
		if crouchBefore = 1
		{
			Sleep 200
			crouchBefore := 0
			setCrouch(1, 1)
		}
}

GetKey()
{
	Global key
	return key
}
