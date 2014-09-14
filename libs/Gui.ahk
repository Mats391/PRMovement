;#######################################################################
;########################      Start up     ############################
;#######################################################################
SetBatchLines, -1

; Uncomment if Gdip.ahk is not in your standard library
#Include, libs\Gdip.ahk

; Start gdi+
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

;#######################################################################
;########################         GUI       ############################
;#######################################################################
Gui 1:-Caption +LastFound +AlwaysOnTop
Gui 1: Add, Picture, x1 y1 w40 h600 0xE vThrottleBar
Gui 1: Add, Picture, x45 y1 w40 h600 0xE vHoverBar 
Gui 1: Color, 0
Gui 1: Show, x1930 y10 w87 h602

;#######################################################################
;#########################     Function     ############################
;#######################################################################
HideGui()
{
	Gui 1: Hide
}

ShowGui()
{
	Gui 1: Show, x1930 y10 w87 h602
}

SetPilotHover(percentage)
{
	Global HoverBar
	Gdip_SetProgressWNegative(HoverBar, percentage, 0xffff0000, 0xFF000000, percentage, "x0p y50p s3p Center cffffffff r4 Bold")
}

SetPilotThrottle(percentage)
{
	Global ThrottleBar
	Gdip_SetProgressWNegative(ThrottleBar, percentage, 0xffff0000, 0xFF000000, percentage, "x0p y50p s3p Center cffffffff r4 Bold")
}

SetNormalThrottle(percentage)
{
	Global ThrottleBar
	Gdip_SetProgress(ThrottleBar, percentage, 0xffff0000, 0xFF000000, percentage, "x0p y50p s3p Center cffffffff r4 Bold")
}


Gdip_SetProgressWNegative(ByRef Variable, Percentage, Foreground, Background=0x00000000, Text="", TextOptions="x0p y50p s2p Center cff000000 r4 Bold", Font="Arial")
{
	; We first want the hwnd (handle to the picture control) so that we know where to put the bitmap we create
	; We also want to width and height (posw and Posh)
	GuiControlGet, Pos, Pos, Variable
	GuiControlGet, hwnd, hwnd, Variable
	
	Percentage := -Percentage

	; Create 2 brushes, one for the background and one for the foreground. Remember this is in ARGB
	pBrushFront := Gdip_BrushCreateSolid(Foreground), pBrushBack := Gdip_BrushCreateSolid(Background)
	
	; Create a gdi+ bitmap the width and height that we found the picture control to be
	; We will then get a reference to the graphics of this bitmap
	; We will also set the smoothing mode of the graphics to 4 (Antialias) to make the shapes we use smooth
	pBitmap := Gdip_CreateBitmap(Posw, Posh), G := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G, 4)
	
	; We will fill the background colour with out background brush
	; x = 0, y = 0, w = Posw, h = Posh
	Gdip_FillRectangle(G, pBrushBack, 0, 0, Posw, Posh)
	
	; We will then fill a rounded rectangle with our other brush, starting at x = 4 and y = 4
	; The total width is now Posw-8 as we have slightly indented the actual progress bar
	; The last parameter which is the amount the corners will be rounded by in pixels has been made to be 3 pixels...
	; ...however I have made it so that they are smaller if the percentage is too small as it cannot be rounded by that much
	if (Percentage > 0)
		; if Percentage is positiv
		Gdip_FillRoundedRectangle(G, pBrushFront, 4, (Posh/2), (Posw-8), ((Posh-8)*(Percentage/100))/2, (Percentage >= 3) ? 3 : Percentage)
	else
		; else Percentage is negativ
		Gdip_FillRoundedRectangle(G, pBrushFront, 4, (((Posh/2)+4) - ((Posh/2)*(abs(Percentage)/100))), (Posw-8), ((Posh/2)*(abs(Percentage)/100)), (abs(Percentage) >= 3) ? 3 : abs(Percentage))
		
	; As mentioned in previous examples, we will provide Gdip_TextToGraphics with the width and height of the graphics
	; We will then write the percentage centred onto the graphics (Look at previous examples to understand all options)
	; I added an optional text parameter at the top of this function, to make it so you could write an indication onto the progress bar
	; such as "Finished!" or whatever, otherwise it will write the percentage to it
	Gdip_TextToGraphics(G, (Text != "") ? Text : Round(Percentage), TextOptions, Font, Posw, Posh)
	
	; We then get a gdi bitmap from the gdi+ one we've been working with...
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	; ... and set it to the hwnd we found for the picture control
	SetImage(hwnd, hBitmap)
	
	; We then must delete everything we created
	; So the 2 brushes must be deleted
	; Then we can delete the graphics, our gdi+ bitmap and the gdi bitmap
	Gdip_DeleteBrush(pBrushFront), Gdip_DeleteBrush(pBrushBack)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
	Return, 0
}

Gdip_SetProgress(ByRef Variable, Percentage, Foreground, Background=0x00000000, Text="", TextOptions="x0p y50p s2p Center cff000000 r4 Bold", Font="Arial")
{
	; We first want the hwnd (handle to the picture control) so that we know where to put the bitmap we create
	; We also want to width and height (posw and Posh)
	GuiControlGet, Pos, Pos, Variable
	GuiControlGet, hwnd, hwnd, Variable
	
	;Percentage := -Percentage

	; Create 2 brushes, one for the background and one for the foreground. Remember this is in ARGB
	pBrushFront := Gdip_BrushCreateSolid(Foreground), pBrushBack := Gdip_BrushCreateSolid(Background)
	
	; Create a gdi+ bitmap the width and height that we found the picture control to be
	; We will then get a reference to the graphics of this bitmap
	; We will also set the smoothing mode of the graphics to 4 (Antialias) to make the shapes we use smooth
	pBitmap := Gdip_CreateBitmap(Posw, Posh), G := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G, 4)
	
	; We will fill the background colour with out background brush
	; x = 0, y = 0, w = Posw, h = Posh
	Gdip_FillRectangle(G, pBrushBack, 0, 0, Posw, Posh)
	
	; We will then fill a rounded rectangle with our other brush, starting at x = 4 and y = 4
	; The total width is now Posw-8 as we have slightly indented the actual progress bar
	; The last parameter which is the amount the corners will be rounded by in pixels has been made to be 3 pixels...
	; ...however I have made it so that they are smaller if the percentage is too small as it cannot be rounded by that much
	Gdip_FillRoundedRectangle(G, pBrushFront, 4, (Posh - ((Posh-4)*(abs(Percentage)/100))), (Posw-8), ((Posh-8)*(abs(Percentage)/100)), (abs(Percentage) >= 3) ? 3 : abs(Percentage))

		
	; As mentioned in previous examples, we will provide Gdip_TextToGraphics with the width and height of the graphics
	; We will then write the percentage centred onto the graphics (Look at previous examples to understand all options)
	; I added an optional text parameter at the top of this function, to make it so you could write an indication onto the progress bar
	; such as "Finished!" or whatever, otherwise it will write the percentage to it
	Gdip_TextToGraphics(G, (Text != "") ? Text : Round(Percentage), TextOptions, Font, Posw, Posh)
	
	; We then get a gdi bitmap from the gdi+ one we've been working with...
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	; ... and set it to the hwnd we found for the picture control
	SetImage(hwnd, hBitmap)
	
	; We then must delete everything we created
	; So the 2 brushes must be deleted
	; Then we can delete the graphics, our gdi+ bitmap and the gdi bitmap
	Gdip_DeleteBrush(pBrushFront), Gdip_DeleteBrush(pBrushBack)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
	Return, 0
}

