#include Moonlit_Resources\Gdip_All.ahk

#SingleInstance Force
setkeydelay, -1
setmousedelay, -1
setbatchlines, -1
SetTitleMatchMode 2

CoordMode, Tooltip, Relative
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative

;     GENERAL SETTINGS     ====================================================================================================;

; Set to true to automatically lower graphics to 1
AutoLowerGraphics := false
AutoGraphicsDelay := 50

; Set to true to automatically zoom in the camera
AutoZoomInCamera := false
AutoZoomDelay := 50

; Set to true to check for camera mode and enable it
AutoEnableCameraMode := false
AutoCameraDelay := 50

; Set to true to automatically look down
AutoLookDownCamera := false
AutoLookDelay := 200

; Set to true to automatically blur the camera
AutoBlurCamera := false
AutoBlurDelay := 50

; How long to wait after fishing before restarting
RestartDelay := 1200

; How long to hold the cast for before releasing
HoldRodCastDuration := 200

; How long to wait for the bobber to land in water
WaitForBobberDelay := 1200

; Set this to your navigation key, IMPORTANT
NavigationKey := "\"

;     Webhook SETTINGS     ====================================================================================================;

WebhookURL := "https://discord.com/api/webhooks/1310841391399702558/hAtNoWIlGSW2JNphlA2-Aj2UU1nV7YheFl7poQkxU78DENtbt8HJCHkkOkHgisnud9R0"
ResourcesFilePath := A_ScriptDir "\Moonlit_Resources\Screenshots"
ImageFile := ResourcesFilePath "\MoonlitScreenshot.png"

;     SHAKE SETTINGS     ====================================================================================================;

; Set to true to auto use shakes, false to not (Best disabled while using instant or fast catching rods)
; While enabled, Camera Mode does not have to be enabled!
AutoShake := false

; Change to "Navigation" or "Click"
ShakeMode := "Navigation"

; Color range to scan for fish bar
FishBarColorTolerance := 0

; Seconds for click shake to be considered failed
ClickShakeFailsafe := 5
; Color range to scan for "shake" text
ClickShakeColorTolerance := 3
; Delay between the second click for shaking in milliseconds
ClickShakeSecondClickTime := 10
; Delay between each scan in miliseconds
ClickScanDelay := 1
; How many scans before clicking regardless of repeats
RepeatBypassCounter := 10

; Seconds for navigation shake to be considered failed
NavigationShakeFailsafe := 5
; Delay between each "S+Enter" in miliseconds
NavigationSpamDelay := 0.3

;     MINIGAME SETTINGS     ====================================================================================================;

; Configurable Bar Size (manual override or auto-detect)
ManualBarSize := 0
; Seconds for calculation to be considered failed
BarCalculationFailsafe := 10
; Color range to scan for initial white bar
BarSizeCalculationColorTolerance := 15

; Color range to scan for minigame white bar
WhiteBarColorTolerance := 0
; Color range to scan for minigame arrow
ArrowColorTolerance := 0

; Amount of clicks per action cycle
CorrectZoneStabilizerLoop := 12
WrongZoneStabilizerLoop := 2

; Ratio for bar side maximum hold (1 = max bar|0.5 = half bar)
SideBarRatio := 0.7
; Multiplier for how long to wait at the sides to prevent bounce
SideBarWaitMultiplier := 5

; Strength for moving right in correct zone
StableRightMultiplier := 1.45
; Counter strafe after moving right in correct zone
StableRightDivision := 1.4
; Strength for moving left in correct zone
StableLeftMultiplier := 1.45
; Counter strafe after moving left in correct zone
StableLeftDivision := 1.3

; Strength for moving right when in wrong zone
UnstableRightMultiplier := 2.2
; Counter strafe after moving right in wrong zone
UnstableRightDivision := 1.4
; Strength for moving left when in wrong zone
UnstableLeftMultiplier := 2.2
; Counter strafe after moving left in wrong zone
UnstableLeftDivision := 1.3

; Strength for moving right after a shift in the middle
RightAnkleBreakMultiplier := 1.1
; Strength for moving left after a shift in the middle
LeftAnkleBreakMultiplier := 0.7
;====================================================================================================;

if (AutoLowerGraphics != true and AutoLowerGraphics != false)
	{
	msgbox, AutoLowerGraphics must be set to true or false! (check your spelling)
	exitapp
	}
	
if (AutoEnableCameraMode != true and AutoEnableCameraMode != false)
	{
	msgbox, AutoEnableCameraMode must be set to true or false! (check your spelling)
	exitapp
	}
	
if (AutoZoomInCamera != true and AutoZoomInCamera != false)
	{
	msgbox, AutoZoomInCamera must be set to true or false! (check your spelling)
	exitapp
	}
	
if (AutoLookDownCamera != true and AutoLookDownCamera != false)
	{
	msgbox, AutoLookDownCamera must be set to true or false! (check your spelling)
	exitapp
	}
	
if (AutoBlurCamera != true and AutoBlurCamera != false)
	{
	msgbox, AutoBlurCamera must be set to true or false! (check your spelling)
	exitapp
	}
	
if (ShakeMode != "Navigation" and ShakeMode != "Click")
	{
	msgbox, ShakeMode must be set to "Click" or "Navigation"! (check your spelling)
	exitapp
	}

;====================================================================================================;

WinActivate, Roblox
if WinActive("Roblox")
	{
	WinMaximize, Roblox
	}
else
	{
	msgbox, where roblox bruh
	exitapp
	}

;====================================================================================================;

if (!FileExist(ResourcesFilePath)) {
    FileCreateDir, %ResourcesFilePath%
}

if !pToken := Gdip_Startup()
{
    MsgBox, Failed to initialize GDI+.
    return
}
	
;====================================================================================================;

send {lbutton up}
send {rbutton up}
send {shift up}

;====================================================================================================;

Calculations:
WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowLeft, WindowTop

CameraCheckLeft := WindowWidth/2.8444
CameraCheckRight := WindowWidth/1.5421
CameraCheckTop := WindowHeight/1.28
CameraCheckBottom := WindowHeight

ClickShakeLeft := WindowWidth/4.6545
ClickShakeRight := WindowWidth/1.2736
ClickShakeTop := WindowHeight/14.08
ClickShakeBottom := WindowHeight/1.3409

FishBarLeft := WindowWidth/3.3160
FishBarRight := WindowWidth/1.4317
FishBarTop := WindowHeight/1.1871
FishBarBottom := WindowHeight/1.1512

FishBarTooltipHeight := WindowHeight/1.0626

ResolutionScaling := 2560/WindowWidth

LookDownX := WindowWidth/2
LookDownY := WindowHeight/4

runtimeS := 0
runtimeM := 0
runtimeH := 0

TooltipX := WindowWidth/20
Tooltip1 := (WindowHeight/2)-(20*9)
Tooltip2 := (WindowHeight/2)-(20*8)
Tooltip3 := (WindowHeight/2)-(20*7)
Tooltip4 := (WindowHeight/2)-(20*6)
Tooltip5 := (WindowHeight/2)-(20*5)
Tooltip6 := (WindowHeight/2)-(20*4)
Tooltip7 := (WindowHeight/2)-(20*3)
Tooltip8 := (WindowHeight/2)-(20*2)
Tooltip9 := (WindowHeight/2)-(20*1)
Tooltip10 := (WindowHeight/2)
Tooltip11 := (WindowHeight/2)+(20*1)
Tooltip12 := (WindowHeight/2)+(20*2)
Tooltip13 := (WindowHeight/2)+(20*3)
Tooltip14 := (WindowHeight/2)+(20*4)
Tooltip15 := (WindowHeight/2)+(20*5)
Tooltip16 := (WindowHeight/2)+(20*6)
Tooltip17 := (WindowHeight/2)+(20*7)
Tooltip18 := (WindowHeight/2)+(20*8)
Tooltip19 := (WindowHeight/2)+(20*9)
Tooltip20 := (WindowHeight/2)+(20*10)

tooltip, Moonlit v1.52 by Lunarosity`nOriginal macro by AsphaltCake, %TooltipX%, %Tooltip1%, 1

tooltip, Thanks to holyservice and caughtbyafed both on discord, %TooltipX%, %Tooltip4%, 4
tooltip, Thanks to mani for testing the macro, %TooltipX%, %Tooltip5%, 5
tooltip, This was primarily inspired by Universal Hu6 and Horror V11, %TooltipX%, %Tooltip6%, 6

tooltip, Press "P" to Start`nPress "O" to Reload`nPress "M" to Exit, %TooltipX%, %Tooltip8%, 8

tooltip, AutoLowerGraphics: %AutoLowerGraphics%, %TooltipX%, %Tooltip12%, 12
tooltip, AutoEnableCameraMode: %AutoEnableCameraMode%, %TooltipX%, %Tooltip13%, 13
tooltip, AutoZoomInCamera: %AutoZoomInCamera%, %TooltipX%, %Tooltip14%, 14
tooltip, AutoLookDownCamera: %AutoLookDownCamera%, %TooltipX%, %Tooltip15%, 15
tooltip, AutoBlurCamera: %AutoBlurCamera%, %TooltipX%, %Tooltip16%, 16

if (AutoShake == true)
    {
    tooltip, Shake Mode: %ShakeMode%, %TooltipX%, %Tooltip19%, 19
    }
else if (AutoShake == false)
    {
    tooltip, Shake Mode: Disabled, %TooltipX%, %Tooltip19%, 19
    }
else if (AutoShake != true or false)
    {
    msgbox, 0, AutoShake, Autoshake must be either true or false. Check for any potential spelling errors.
    }
	
;====================================================================================================;

runtime:
runtimeS++
if (runtimeS >= 60)
	{
	runtimeS := 0
	runtimeM++
	}
if (runtimeM >= 60)
	{
	runtimeM := 0
	runtimeH++
	}

if WinActive("Roblox")
	{
	tooltip, Runtime: %runtimeH%h %runtimeM%m %runtimeS%s, %TooltipX%, %Tooltip20%, 20
	}
else
	{
	exitapp
	}
return

;====================================================================================================;

$i:: pause
$o:: reload
$m:: exitapp
$p::

;====================================================================================================;

gosub, Calculations
settimer, runtime, 1000

tooltip, Press "I" to Pause`nPress "O" to Reload`nPress "M" to Exit, %TooltipX%, %Tooltip3%, 3

tooltip, , , , 4
tooltip, , , , 5
tooltip, , , , 6
tooltip, , , , 10
tooltip, , , , 11
tooltip, , , , 12
tooltip, , , , 13
tooltip, , , , 14
tooltip, , , , 15
tooltip, , , , 16

tooltip, Current Task: AutoLowerGraphics, %TooltipX%, %Tooltip7%, 7
tooltip, F10 Count: 0/20, %TooltipX%, %Tooltip9%, 9
f10counter := 0
if (AutoLowerGraphics == true)
	{
	send {shift}
	tooltip, Action: Press Shift, %TooltipX%, %Tooltip8%, 8
	sleep %AutoGraphicsDelay%
	send {shift down}
	tooltip, Action: Hold Shift, %TooltipX%, %Tooltip8%, 8
	sleep %AutoGraphicsDelay%
	loop, 20
		{
		f10counter++
		tooltip, F10 Count: %f10counter%/20, %TooltipX%, %Tooltip9%, 9
		send {f10}
		tooltip, Action: Press F10, %TooltipX%, %Tooltip8%, 8
		sleep %AutoGraphicsDelay%
		}
	send {shift up}
	tooltip, Action: Release Shift, %TooltipX%, %Tooltip8%, 8
	sleep %AutoGraphicsDelay%
	}

tooltip, Current Task: AutoZoomInCamera, %TooltipX%, %Tooltip7%, 7
tooltip, Scroll In: 0/20, %TooltipX%, %Tooltip9%, 9
tooltip, Scroll Out: 0/1, %TooltipX%, %Tooltip10%, 10
scrollcounter := 0
if (AutoZoomInCamera == true)
	{
	sleep %AutoZoomDelay%
	loop, 20
		{
		scrollcounter++
		tooltip, Scroll In: %scrollcounter%/20, %TooltipX%, %Tooltip9%, 9
		send {wheelup}
		tooltip, Action: Scroll In, %TooltipX%, %Tooltip8%, 8
		sleep %AutoZoomDelay%
		}
	send {wheeldown}
	tooltip, Scroll Out: 1/1, %TooltipX%, %Tooltip10%, 10
	tooltip, Action: Scroll Out, %TooltipX%, %Tooltip8%, 8
	AutoZoomDelay := AutoZoomDelay*5
	sleep %AutoZoomDelay%
	}
	
tooltip, , , , 10

tooltip, Current Task: AutoEnableCameraMode, %TooltipX%, %Tooltip7%, 7
tooltip, Right Count: 0/10, %TooltipX%, %Tooltip9%, 9
rightcounter := 0
if (AutoEnableCameraMode == true)
	{
	PixelSearch, , , CameraCheckLeft, CameraCheckTop, CameraCheckRight, CameraCheckBottom, 0xFFFFFF, 0, Fast
	if (ErrorLevel == 0)
		{
		sleep %AutoCameraDelay%
		send {2}
		tooltip, Action: Presss 2, %TooltipX%, %Tooltip8%, 8
		sleep %AutoCameraDelay%
		send {1}
		tooltip, Action: Press 1, %TooltipX%, %Tooltip8%, 8
		sleep %AutoCameraDelay%
		send {%NavigationKey%}
		tooltip, Action: Press %NavigationKey%, %TooltipX%, %Tooltip8%, 8
		sleep %AutoCameraDelay%
		loop, 10
			{
			rightcounter++
			tooltip, Right Count: %rightcounter%/10, %TooltipX%, %Tooltip9%, 9
			send {right}
			tooltip, Action: Press Right, %TooltipX%, %Tooltip8%, 8
			sleep %AutoCameraDelay%
			}
		send {enter}
		tooltip, Action: Press Enter, %TooltipX%, %Tooltip8%, 8
		sleep %AutoCameraDelay%
		}
	}

RestartMacro:

if (FileExist(ImageFile)) {
	tooltip, Current Task: Deleting old screenshot, %TooltipX%, %Tooltip7%, 7
	FileDelete, %ImageFile%
}

tooltip, , , , 9

tooltip, Current Task: AutoLookDownCamera, %TooltipX%, %Tooltip7%, 7
if (AutoLookDownCamera == true)
	{
	send {rbutton up}
	sleep %AutoLookDelay%
	mousemove, LookDownX, LookDownY
	tooltip, Action: Position Mouse, %TooltipX%, %Tooltip8%, 8
	sleep %AutoLookDelay%
	send {rbutton down}
	tooltip, Action: Hold Right Click, %TooltipX%, %Tooltip8%, 8
	sleep %AutoLookDelay%
	DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 10000)
	tooltip, Action: Move Mouse Down, %TooltipX%, %Tooltip8%, 8
	sleep %AutoLookDelay%
	send {rbutton up}
	tooltip, Action: Release Right Click, %TooltipX%, %Tooltip8%, 8
	sleep %AutoLookDelay%
	mousemove, LookDownX, LookDownY
	tooltip, Action: Position Mouse, %TooltipX%, %Tooltip8%, 8
	sleep %AutoLookDelay%
	}
	
tooltip, Current Task: AutoBlurCamera, %TooltipX%, %Tooltip7%, 7	
if (AutoBlurCamera == true)
	{
	sleep %AutoBlurDelay%
	send {m}
	tooltip, Action: Press M, %TooltipX%, %Tooltip8%, 8
	sleep %AutoBlurDelay%
	}

tooltip, Current Task: Casting Rod, %TooltipX%, %Tooltip7%, 7
tooltip, Action: Casting For %HoldRodCastDuration%ms, %TooltipX%, %Tooltip8%, 8
send {lbutton down}
sleep %HoldRodCastDuration%
send {lbutton up}
tooltip, Action: Waiting For Bobber (%WaitForBobberDelay%ms), %TooltipX%, %Tooltip8%, 8
sleep %WaitForBobberDelay%

;====================================================================================================;

if (AutoShake == false ) {
	tooltip, Searching for minigame | False, %TooltipX%, %Tooltip7%, 7

	noshakefunc:
	PixelSearch, BarX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0xFFFFFF, %BarSizeCalculationColorTolerance%, Fast
	if (ErrorLevel == 0)
	{
		tooltip, Searching for minigame | True, %TooltipX%, %Tooltip7%, 7
		settimer, BarCalculationFailsafe, off
    	if (ManualBarSize != 0)
    	{
        	WhiteBarSize := ManualBarSize
        	goto BarMinigameSingle
    	}
    	WhiteBarSize := (FishBarRight - (BarX - FishBarLeft)) - BarX
    	goto BarMinigameSingle
    	}
	sleep 50
	goto noshakefunc
}
else if (AutoShake != true or false) {
	msgbox, 0, AutoShake, Autoshake must be either true or false. Check for any potential spelling errors.
}

if (ShakeMode == "Click") {
	goto ClickShakeMode
}
else if (ShakeMode == "Navigation") {
	goto NavigationShakeMode
}

ClickShakeFailsafe:
ClickFailsafeCount++
tooltip, Failsafe: %ClickFailsafeCount%/%ClickShakeFailsafe%, %TooltipX%, %Tooltip14%, 14
if (ClickFailsafeCount >= ClickShakeFailsafe)
	{
	settimer, ClickShakeFailsafe, off
	ForceReset := true
	}
return

ClickShakeMode:

tooltip, Current Task: Shaking, %TooltipX%, %Tooltip7%, 7
tooltip, Click X: None, %TooltipX%, %Tooltip8%, 8
tooltip, Click Y: None, %TooltipX%, %Tooltip9%, 9

tooltip, Click Count: 0, %TooltipX%, %Tooltip11%, 11
tooltip, Bypass Count: 0/%RepeatBypassCounter%, %TooltipX%, %Tooltip12%, 12

tooltip, Failsafe: 0/%ClickShakeFailsafe%, %TooltipX%, %Tooltip14%, 14

ClickFailsafeCount := 0
ClickCount := 0
ClickShakeRepeatBypassCounter := 0
MemoryX := 0
MemoryY := 0
ForceReset := false

settimer, ClickShakeFailsafe, 1000

ClickShakeModeRedo:
if (ForceReset == true)
	{
	tooltip, , , , 11
	tooltip, , , , 12
	tooltip, , , , 14
	goto RestartMacro
	}
sleep %ClickScanDelay%
PixelSearch, , , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
if (ErrorLevel == 0)
	{
	settimer, ClickShakeFailsafe, off
	tooltip, , , , 9
	tooltip, , , , 11
	tooltip, , , , 12
	tooltip, , , , 14
	goto BarMinigame
	}
else
	{
	PixelSearch, ClickX, ClickY, ClickShakeLeft, ClickShakeTop, ClickShakeRight, ClickShakeBottom, 0xFFFFFF, %ClickShakeColorTolerance%, Fast
	if (ErrorLevel == 0)
		{
		tooltip, Click X: %ClickX%, %TooltipX%, %Tooltip8%, 8
		tooltip, Click Y: %ClickY%, %TooltipX%, %Tooltip9%, 9
		if (ClickX != MemoryX and ClickY != MemoryY)
			{
			ClickShakeRepeatBypassCounter := 0
			tooltip, Bypass Count: %ClickShakeRepeatBypassCounter%/%RepeatBypassCounter%, %TooltipX%, %Tooltip12%, 12
			ClickCount++
			loop, 2 {
				click, %ClickX%, %ClickY%
				sleep %ClickShakeSecondClickTime%
			}
			tooltip, Click Count: %ClickCount%, %TooltipX%, %Tooltip11%, 11
			MemoryX := ClickX
			MemoryY := ClickY
			goto ClickShakeModeRedo
			}
		else
			{
			ClickShakeRepeatBypassCounter++
			tooltip, Bypass Count: %ClickShakeRepeatBypassCounter%/%RepeatBypassCounter%, %TooltipX%, %Tooltip12%, 12
			if (ClickShakeRepeatBypassCounter >= RepeatBypassCounter)
				{
				MemoryX := 0
				MemoryY := 0
				}
			goto ClickShakeModeRedo
			}
		}
	else
		{
		goto ClickShakeModeRedo
		}
	}


NavigationShakeFailsafe:
NavigationFailsafeCount++
tooltip, Failsafe: %NavigationFailsafeCount%/%NavigationShakeFailsafe%, %TooltipX%, %Tooltip10%, 10
if (NavigationFailsafeCount >= NavigationShakeFailsafe)
	{
	settimer, NavigationShakeFailsafe, off
	ForceReset := true
	}
return

NavigationShakeMode:

tooltip, Current Task: Shaking, %TooltipX%, %Tooltip7%, 7
tooltip, Attempt Count: 0, %TooltipX%, %Tooltip8%, 8

tooltip, Failsafe: 0/%NavigationShakeFailsafe%, %TooltipX%, %Tooltip10%, 10

NavigationFailsafeCount := 0
NavigationCounter := 0
ForceReset := false
settimer, NavigationShakeFailsafe, 1000
send {%NavigationKey%}
NavigationShakeModeRedo:
if (ForceReset == true)
	{
	tooltip, , , , 10
	goto RestartMacro
	}
sleep %NavigationSpamDelay%
PixelSearch, , , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
if (ErrorLevel == 0)
	{
	settimer, NavigationShakeFailsafe, off
	goto BarMinigame
	}
else
	{
	NavigationCounter++
	tooltip, Attempt Count: %NavigationCounter%, %TooltipX%, %Tooltip8%, 8
	sleep 1
	send {s}
	sleep 1
	send {enter}
	goto NavigationShakeModeRedo
	}

;====================================================================================================;

BarCalculationFailsafe:
BarCalcFailsafeCounter++
tooltip, Failsafe: %BarCalcFailsafeCounter%/%BarCalculationFailsafe%, %TooltipX%, %Tooltip10%, 10
if (BarCalcFailsafeCounter >= BarCalculationFailsafe)
	{
	settimer, BarCalculationFailsafe, off
	ForceReset := true
	}
return

BarMinigame:

tooltip, Current Task: Calculating Bar Size, %TooltipX%, %Tooltip7%, 7
tooltip, Bar Size: Not Found, %TooltipX%, %Tooltip8%, 8
tooltip, Failsafe: 0/%BarCalculationFailsafe%, %TooltipX%, %Tooltip10%, 10

ForceReset := false
BarCalcFailsafeCounter := 0
settimer, BarCalculationFailsafe, 1000

BarMinigameRedo:
if (ForceReset == true)
{
    tooltip, , , , 10
    goto RestartMacro
}


PixelSearch, BarX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0xFFFFFF, %BarSizeCalculationColorTolerance%, Fast
if (ErrorLevel == 0)
{
    settimer, BarCalculationFailsafe, off
    if (ManualBarSize != 0)
    {
        WhiteBarSize := ManualBarSize
        goto BarMinigameSingle
    }
    WhiteBarSize := (FishBarRight - (BarX - FishBarLeft)) - BarX
	sleep 50
    goto BarMinigameSingle
}
sleep 1
goto BarMinigameRedo

BarMinigameSingle:

tooltip, Current Task: Playing Bar Minigame, %TooltipX%, %Tooltip7%, 7
tooltip, Bar Size: %WhiteBarSize%, %TooltipX%, %Tooltip8%, 8

tooltip, Direction: None, %TooltipX%, %Tooltip10%, 10
tooltip, Forward Delay: None, %TooltipX%, %Tooltip11%, 11
tooltip, Counter Delay: None, %TooltipX%, %Tooltip12%, 12
tooltip, Ankle Delay: None, %TooltipX%, %Tooltip13%, 13
tooltip, Side Delay: None, %TooltipX%, %Tooltip14%, 14

HalfBarSize := WhiteBarSize/2
SideDelay := 0
AnkleBreakDelay := 0
DirectionalToggle := "Disabled"
AtLeastFindWhiteBar := false

MaxLeftToggle := false
MaxRightToggle := false
MaxLeftBar := FishBarLeft+WhiteBarSize*SideBarRatio
MaxRightBar := FishBarRight-WhiteBarSize*SideBarRatio

tooltip, |, %MaxLeftBar%, %FishBarTooltipHeight%, 18
tooltip, |, %MaxRightBar%, %FishBarTooltipHeight%, 17

PixelSearch, FishX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
if (ErrorLevel == 0) {
	goto BarMinigame2
}


goto BarMinigameSingle

BarMinigame2:
sleep 1
PixelSearch, FishX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
if (ErrorLevel == 0) 
{
	WhiteBarLeft := BarX - (WhiteBarSize / 2)
	WhiteBarRight := BarX + (WhiteBarSize / 2)

    Distance := Ceil((FishX - WhiteBarLeft) * -1)
    Distance2 := Ceil((WhiteBarRight - FishX) * -1)

    tooltip, Distance: %Distance% | Left`nDistance: %Distance2% | Right, %TooltipX%, %Tooltip17%, 16

    if (FishX < MaxLeftBar) {
		if (Distance < 0) {
            Distance := 0
        }
        BounceMitigationLeft := Ceil(Distance * ResolutionScaling * StableLeftMultiplier)
        if (MaxLeftToggle == false)
        {
			{
            	tooltip, <, %MaxLeftBar%, %FishBarTooltipHeight%, 19
            	tooltip, Direction: Max Left, %TooltipX%, %Tooltip10%, 10
            	tooltip, Forward Delay: Infinite, %TooltipX%, %Tooltip11%, 11
            	tooltip, Counter Delay: None, %TooltipX%, %Tooltip12%, 12
            	tooltip, Ankle Delay: 0, %TooltipX%, %Tooltip13%, 13
            	tooltip, Bounce Mitigation: %BounceMitigationLeft% | Left, %TooltipX%, %Tooltip16%, 15
            	MaxLeftToggle := true
				send {lbutton up}
            	sleep 1
            	send {lbutton up}
				if (Distance > 0) {
					sleep BounceMitigationLeft / 2
					send {lbutton down}
					sleep Distance * ResolutionScaling * StableLeftMultiplier
					if (FishX > MaxLeftBar) {
						sleep (Distance * ResolutionScaling * StableLeftMultiplier) * 1.5
						goto BarMinigame2
					}
					send {lbutton up}
					}
            	sleep %SideDelay%
            	AnkleBreakDelay := 0
            	SideDelay := 0
            	tooltip, Side Delay: 0, %TooltipX%, %Tooltip14%, 14
			}
        }
        goto BarMinigame2
    }
    else if (FishX > MaxRightBar) {
		if (Distance2 < 0) {
            Distance2 := 0
        }
		BounceMitigationRight := Ceil(Distance2 * ResolutionScaling * StableRightMultiplier)
        if (MaxRightToggle == false) {
            tooltip, >, %MaxRightBar%, %FishBarTooltipHeight%, 19
            tooltip, Direction: Max Right, %TooltipX%, %Tooltip10%, 10
            tooltip, Forward Delay: Infinite, %TooltipX%, %Tooltip11%, 11
            tooltip, Counter Delay: None, %TooltipX%, %Tooltip12%, 12
            tooltip, Ankle Delay: 0, %TooltipX%, %Tooltip13%, 13
            tooltip, Bounce Mitigation: %BounceMitigationRight% | Right, %TooltipX%, %Tooltip16%, 15
            MaxRightToggle := true
			send {lbutton down}
            sleep 1
            send {lbutton down}
			if (Distance2 > 0) {
				sleep BounceMitigationRight / 2
				send {lbutton up}
				sleep Distance2 * ResolutionScaling * StableRightMultiplier
				if (FishX < MaxRightBar) {
					sleep (Distance2 * ResolutionScaling * StableLeftMultiplier) * 1.5
					goto BarMinigame2
				}
				send {lbutton down}
			}
           	sleep %SideDelay%
           	AnkleBreakDelay := 0
           	SideDelay := 0
           	tooltip, Side Delay: 0, %TooltipX%, %Tooltip14%, 14
		}
		goto BarMinigame2
	}
		
    MaxLeftToggle := false
    MaxRightToggle := false
    PixelSearch, BarX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0xFFFFFF, %WhiteBarColorTolerance%, Fast
    if (ErrorLevel == 0)
    {
        AtLeastFindWhiteBar := true
        BarX := BarX + (WhiteBarSize / 2)
        if (BarX > FishX)
        {
            tooltip, <, %BarX%, %FishBarTooltipHeight%, 19
            tooltip, Direction: <, %TooltipX%, %Tooltip10%, 10
            Difference := Ceil((BarX - FishX) * ResolutionScaling * StableLeftMultiplier)
            CounterDifference := Ceil(Difference / StableLeftDivision)
            tooltip, Forward Delay: %Difference%, %TooltipX%, %Tooltip11%, 11
            tooltip, Counter Delay: %CounterDifference%, %TooltipX%, %Tooltip12%, 12
			send {lbutton up}
            if (DirectionalToggle == "Right")
            {
                tooltip, Ankle Delay: 0, %TooltipX%, %Tooltip13%, 13
                sleep %AnkleBreakDelay%
                AnkleBreakDelay := 0
            }
            else
            {
                AnkleBreakDelay := Ceil(AnkleBreakDelay + (Difference - CounterDifference) * LeftAnkleBreakMultiplier)
                SideDelay := Ceil(AnkleBreakDelay / LeftAnkleBreakMultiplier * SideBarWaitMultiplier)
                tooltip, Ankle Delay: %AnkleBreakDelay%, %TooltipX%, %Tooltip13%, 13
                tooltip, Side Delay: %SideDelay%, %TooltipX%, %Tooltip14%, 14
            }
            sleep %Difference%

			send {lbutton down}
            sleep %CounterDifference%
            loop, %CorrectZoneStabilizerLoop%
			{
				send {lbutton down}
				send {lbutton up}
			}
            DirectionalToggle := "Left"
        }
		else
		{
			tooltip, >, %BarX%, %FishBarTooltipHeight%, 19
			tooltip, Direction: >, %TooltipX%, %Tooltip10%, 10
			Difference := Ceil((FishX-BarX)*ResolutionScaling*StableRightMultiplier)
			CounterDifference := Ceil(Difference/StableRightDivision)
			tooltip, Forward Delay: %Difference%, %TooltipX%, %Tooltip11%, 11
			tooltip, Counter Delay: %CounterDifference%, %TooltipX%, %Tooltip12%, 12
            send {lbutton down}
			if (DirectionalToggle == "Left")
				{
				tooltip, Ankle Delay: 0, %TooltipX%, %Tooltip13%, 13
				sleep %AnkleBreakDelay%
				AnkleBreakDelay := 0
				}
			else
				{
				AnkleBreakDelay := Ceil(AnkleBreakDelay+(Difference-CounterDifference)*RightAnkleBreakMultiplier)
				SideDelay := Ceil(AnkleBreakDelay/RightAnkleBreakMultiplier*SideBarWaitMultiplier)
				tooltip, Ankle Delay: %AnkleBreakDelay%, %TooltipX%, %Tooltip13%, 13
				tooltip, Side Delay: %SideDelay%, %TooltipX%, %Tooltip14%, 14
				}
			sleep %Difference%

			send {lbutton up}
			sleep %CounterDifference%
			loop, %CorrectZoneStabilizerLoop%
			{
				send {lbutton down}
				send {lbutton up}
			}
			DirectionalToggle := "Right"
		}
	}
	else
	{
		if (AtLeastFindWhiteBar == false)
			{
				send {lbutton down}
            	send {lbutton up}
			goto BarMinigame2
			}
		PixelSearch, ArrowX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x878584, %ArrowColorTolerance%, Fast
		if (ArrowX > FishX)
		{
			tooltip, <, %ArrowX%, %FishBarTooltipHeight%, 19
			tooltip, Direction: <<<, %TooltipX%, %Tooltip10%, 10
			Difference := Ceil(HalfBarSize*UnstableLeftMultiplier)
			CounterDifference := Ceil(Difference/UnstableLeftDivision)
			tooltip, Forward Delay: %Difference%, %TooltipX%, %Tooltip11%, 11
			tooltip, Counter Delay: %CounterDifference%, %TooltipX%, %Tooltip12%, 12
			send {lbutton up}
			if (DirectionalToggle == "Right")
				{
				tooltip, Ankle Delay: 0, %TooltipX%, %Tooltip13%, 13
				sleep %AnkleBreakDelay%
				AnkleBreakDelay := 0
				}
			else
				{
				AnkleBreakDelay := Ceil(AnkleBreakDelay+(Difference-CounterDifference)*LeftAnkleBreakMultiplier)
				SideDelay := Ceil(AnkleBreakDelay/LeftAnkleBreakMultiplier*SideBarWaitMultiplier)
				tooltip, Ankle Delay: %AnkleBreakDelay%, %TooltipX%, %Tooltip13%, 13
				tooltip, Side Delay: %SideDelay%, %TooltipX%, %Tooltip15%, 15
				}
			sleep %Difference%
			PixelSearch, FishX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
				{
				if (FishX < MaxLeftBar)
				goto BarMinigame2
				}
			send {lbutton down}
			sleep %CounterDifference%
			loop, %WrongZoneStabilizerLoop%
				{
				send {lbutton down}
            	send {lbutton up}
				}
			DirectionalToggle := "Left"
		}
		else
		{
			tooltip, >, %ArrowX%, %FishBarTooltipHeight%, 19
			tooltip, Direction: >>>, %TooltipX%, %Tooltip10%, 10
			Difference := Ceil(HalfBarSize*UnstableRightMultiplier)
			CounterDifference := Ceil(Difference/UnstableRightDivision)
			tooltip, Forward Delay: %Difference%, %TooltipX%, %Tooltip11%, 11
			tooltip, Counter Delay: %CounterDifference%, %TooltipX%, %Tooltip12%, 12
			send {lbutton down}
			if (DirectionalToggle == "Left")
				{
				tooltip, Ankle Delay: 0, %TooltipX%, %Tooltip13%, 13
				sleep %AnkleBreakDelay%
				AnkleBreakDelay := 0
				}
			else
				{
				AnkleBreakDelay := Ceil(AnkleBreakDelay+(Difference-CounterDifference)*RightAnkleBreakMultiplier)
				SideDelay := Ceil(AnkleBreakDelay/RightAnkleBreakMultiplier*SideBarWaitMultiplier)
				tooltip, Ankle Delay: %AnkleBreakDelay%, %TooltipX%, %Tooltip13%, 13
				tooltip, Side Delay: %SideDelay%, %TooltipX%, %Tooltip15%, 15
				}
			sleep %Difference%
			PixelSearch, FishX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
				{
				if (FishX > MaxRightBar)
				goto BarMinigame2
				}
			send {lbutton up}
			sleep %CounterDifference%
			loop, %WrongZoneStabilizerLoop%
				{
				send {lbutton down}
            	send {lbutton up}
				}
			DirectionalToggle := "Right"
		}
    }
	goto BarMinigame2
}

else {
    send {lbutton up}
	tooltip, , , , 10	
	tooltip, , , , 11
	tooltip, , , , 12
	tooltip, , , , 13
    tooltip, , , , 14
	tooltip, , , , 15
    tooltip, , , , 16
	tooltip, , , , 17
	tooltip, , , , 18
	tooltip, , , , 19
	sleep %RestartDelay%
	goto Screenshotsys
}

Screenshotsys:
tooltip, Current Task: Sending to webhook, %TooltipX%, %Tooltip7%, 7

ScreenshotX := A_ScreenWidth / 2.8
ScreenshotY := A_ScreenHeight / 1.35
ScreenshotW := A_ScreenWidth / 1.53 - ScreenshotX
ScreenshotH := ResolutionScaling * 50
ScreenshotRange := ScreenshotX "|" ScreenshotY "|" ScreenshotW "|" ScreenshotH

pBitmap := Gdip_BitmapFromScreen(ScreenshotRange)
if !pBitmap
{
    MsgBox, Failed to capture the screen. Bitmap is null.
    Gdip_Shutdown(pToken)
    return
}

saved := Gdip_SaveBitmapToFile(pBitmap, ImageFile)
Gdip_DisposeImage(pBitmap)

if (!ImageFile) {
    MsgBox, Failed to save the screenshot. Please check the file path or permissions.
    Gdip_Shutdown(pToken)
    return
}

FileGetSize, fileSize, %ImageFile%
if (fileSize = 0) {
    MsgBox, Screenshot file is empty. Path: %ImageFile%
    Gdip_Shutdown(pToken)
    return
}

tooltip, Screenshot saved successfully at %ImageFile%, %TooltipX%, %Tooltip8%, 8

Gdip_Shutdown(pToken)

objParam := {file: [ImageFile], content: test}
CreateFormData(PostData, hdr_ContentType, objParam)

HTTP := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
HTTP.Open("POST", WebhookURL, true)
HTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
HTTP.SetRequestHeader("Content-Type", hdr_ContentType)
HTTP.SetRequestHeader("Pragma", "no-cache")
HTTP.SetRequestHeader("Cache-Control", "no-cache, no-store")
HTTP.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")
HTTP.Send(PostData)
HTTP.WaitForResponse()

; CreateFormData() by tmplinshi, AHK Topic: https://autohotkey.com/boards/viewtopic.php?t=7647
; Thanks to Coco: https://autohotkey.com/boards/viewtopic.php?p=41731#p41731
; Modified version by SKAN, 09/May/2016

CreateFormData(ByRef retData, ByRef retHeader, objParam) {
	New CreateFormData(retData, retHeader, objParam)
}

Class CreateFormData {

	__New(ByRef retData, ByRef retHeader, objParam) {

		Local CRLF := "`r`n", i, k, v, str, pvData
		; Create a random Boundary
		Local Boundary := this.RandomBoundary()
		Local BoundaryLine := "------------------------------" . Boundary

    this.Len := 0 ; GMEM_ZEROINIT|GMEM_FIXED = 0x40
    this.Ptr := DllCall( "GlobalAlloc", "UInt",0x40, "UInt",1, "Ptr"  )          ; allocate global memory

		; Loop input paramters
		For k, v in objParam
		{
			If IsObject(v) {
				For i, FileName in v
				{
					str := BoundaryLine . CRLF
					     . "Content-Disposition: form-data; name=""" . k . """; filename=""" . FileName . """" . CRLF
					     . "Content-Type: " . this.MimeType(FileName) . CRLF . CRLF
          this.StrPutUTF8( str )
          this.LoadFromFile( Filename )
          this.StrPutUTF8( CRLF )
				}
			} Else {
				str := BoundaryLine . CRLF
				     . "Content-Disposition: form-data; name=""" . k """" . CRLF . CRLF
				     . v . CRLF
        this.StrPutUTF8( str )
			}
		}

		this.StrPutUTF8( BoundaryLine . "--" . CRLF )

    ; Create a bytearray and copy data in to it.
    retData := ComObjArray( 0x11, this.Len ) ; Create SAFEARRAY = VT_ARRAY|VT_UI1
    pvData  := NumGet( ComObjValue( retData ) + 8 + A_PtrSize )
    DllCall( "RtlMoveMemory", "Ptr",pvData, "Ptr",this.Ptr, "Ptr",this.Len )

    this.Ptr := DllCall( "GlobalFree", "Ptr",this.Ptr, "Ptr" )                   ; free global memory 

    retHeader := "multipart/form-data; boundary=----------------------------" . Boundary
	}

  StrPutUTF8( str ) {
    Local ReqSz := StrPut( str, "utf-8" ) - 1
    this.Len += ReqSz                                  ; GMEM_ZEROINIT|GMEM_MOVEABLE = 0x42
    this.Ptr := DllCall( "GlobalReAlloc", "Ptr",this.Ptr, "UInt",this.len + 1, "UInt", 0x42 )   
    StrPut( str, this.Ptr + this.len - ReqSz, ReqSz, "utf-8" )
  }
  
  LoadFromFile( Filename ) {
    Local objFile := FileOpen( FileName, "r" )
    this.Len += objFile.Length                     ; GMEM_ZEROINIT|GMEM_MOVEABLE = 0x42 
    this.Ptr := DllCall( "GlobalReAlloc", "Ptr",this.Ptr, "UInt",this.len, "UInt", 0x42 )
    objFile.RawRead( this.Ptr + this.Len - objFile.length, objFile.length )
    objFile.Close()       
  }

	RandomBoundary() {
		str := "0|1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z"
		Sort, str, D| Random
		str := StrReplace(str, "|")
		Return SubStr(str, 1, 12)
	}

	MimeType(FileName) {
		n := FileOpen(FileName, "r").ReadUInt()
		Return (n        = 0x474E5089) ? "image/png"
		     : (n        = 0x38464947) ? "image/gif"
		     : (n&0xFFFF = 0x4D42    ) ? "image/bmp"
		     : (n&0xFFFF = 0xD8FF    ) ? "image/jpeg"
		     : (n&0xFFFF = 0x4949    ) ? "image/tiff"
		     : (n&0xFFFF = 0x4D4D    ) ? "image/tiff"
		     : "application/octet-stream"
	}
}
goto RestartMacro