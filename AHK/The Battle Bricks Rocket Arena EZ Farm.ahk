; The Battle Bricks: Rocket Arena - Ez Farm V1.4
; I am gonna be honest this needs a new name lol (it works with almost any level)
; Needs v2.0

; Credits
; Zig (_3xp on Discord), Daanbenan (On Discord)

; Tutorial/How To Use:
; Press N to start/stop the macro (unless toggle lock is active)
; Press M to reset the timer to 0
; Press P to set the timer to timerMax and start SendKeys immediately (unless toggle lock is active)
; Press Shift + N to toggle the lock on/off (allows typing N and P without triggering the macro while active)
; Q will be sent for the first 40 seconds, then the sequence Q 1 2 3 4 5 6 7 8

; Compatibility:
; Resolution Tested (so use this if possible, otherwise edit this script to match): 1920 x 1080 at 125% scale
; Color Filters (all should be compatible, except for grayscale(?)): None, Deuteranopia, Protanopia, Tritanopia

toggle := 0
lock := 0
timeElapsed := 0
timerMax := 40

N::
    NFire()
return

NFire() {
    global toggle, lock, timeElapsed
    if (lock = 0) {
        toggle := !toggle
        if (toggle = 1) {
            SetTimer, SendQ, 1000
            SetTimer, CheckPixel, 20 
        } else {
            SetTimer, SendQ, Off
            SetTimer, CheckPixel, Off
            SetTimer, SendKeys, Off
        }
    } else if (lock = 1) {
        SendInput, {N}
    }
}

<+N::
    lock := !lock
    if (lock = 1) {
        ToolTip, Toggle lock is ACTIVE
        Sleep, 1000
        ToolTip
    } else {
        ToolTip, Toggle lock is INACTIVE
        Sleep, 1000
        ToolTip
        SetTimer, SendKeys, Off 
    }
return

M::
    timeElapsed := 0
    if (lock = 1) {
        SendInput, {M}
    }
return

P::
    if (toggle = 1) { 
        if (lock = 0) {
            timeElapsed := timerMax
            SetTimer, SendQ, Off
            SetTimer, SendKeys, 1000
        }
    } else if (lock = 1) {
        SendInput, {P}
    }
return

SendQ:
    timeElapsed++
    if (timeElapsed <= timerMax) {
        Send, q
    } else {
        SetTimer, SendQ, Off
        SetTimer, SendKeys, 1000
    }
return

SendKeys:
    Send, q
    Sleep, 100
    Send, e
    Sleep, 100
    Send, 1
    Sleep, 100
    Send, 2
    Sleep, 100
    Send, 3
    Sleep, 100
    Send, 4
    Sleep, 100
    Send, 5
    Sleep, 100
    Send, 6
    Sleep, 100
    Send, 7
    Sleep, 100
    Send, 8
return

CheckPixel:
    if (toggle = 1) {
        MouseMove, 893, 970
        Sleep, 10 
        MouseMove, 893, 995
        Sleep, 10 
        PixelGetColor, color, 893, 995, RGB
        if (color = "0x010101") {
			SetTimer, SendQ, Off
            SetTimer, SendKeys, Off
            Click
            timeElapsed := 0
			SetTimer, SendQ, 1000
        }
    }
return
