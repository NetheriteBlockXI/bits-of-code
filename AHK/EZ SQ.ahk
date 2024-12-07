#Requires AutoHotkey v2.0

; ------------------------
; Script Title: EZ SQ/EZ Shove
; Zig (_3xp on Discord)
; Code Version: 1.0.0-A /  1-A
; ------------------------

; Global variables
Global Timer := 0.0
Global Running := True
Global Threshold := 9.9  ; Timer threshold (modifiable)

; Get screen resolution
ScreenWidth := A_ScreenWidth
ScreenHeight := A_ScreenHeight

; Calculate center of screen and adjust by 456px right and 256px up
CenterX := (ScreenWidth // 2) + 456
CenterY := (ScreenHeight // 2) - 256

; Timer function
Tick() {
    Global Timer, Running, CenterX, CenterY, Threshold
    if Running {
        Timer += 0.1
        if Timer >= Threshold {
            Tooltip("Shove (Q)!", CenterX, CenterY)  ; Display "Shove" message with custom position
        } else {
            Tooltip("Time Left: " . Round(Threshold - Timer, 1), CenterX, CenterY)  ; Custom tooltip position
        }
    }
}

; Start the timer with SetTimer
SetTimer(Tick, 100)

; Q key handler (without Shift)
~q:: {
    Global Timer, Running
    if (Timer >= Threshold) {
        Timer := 0.0  ; Reset timer when timer is >= Threshold
        Running := True
        Tooltip("")  ; Clear tooltip
    }
}

; Shift + Q key handler (passes through Shift + Q as well)
~+q:: {
    Global Timer, Running
    if (Timer >= Threshold) {
        Timer := 0.0  ; Reset timer when timer is >= Threshold
        Running := True
        Tooltip("")  ; Clear tooltip
    }
}

; Ctrl + Up to increase threshold
^Up:: {
    Global Threshold
    Threshold += 1  ; Increase threshold by 1
    Tooltip("Threshold set to: " . Threshold, CenterX, CenterY)  ; Display new threshold
    Sleep 1000  ; Show the tooltip for 1 second
    Tooltip("")  ; Clear tooltip
}

; Ctrl + Down to decrease threshold
^Down:: {
    Global Threshold
    Threshold -= 1  ; Decrease threshold by 1
    Tooltip("Threshold set to: " . Threshold, CenterX, CenterY)  ; Display new threshold
    Sleep 1000  ; Show the tooltip for 1 second
    Tooltip("")  ; Clear tooltip
}

; Cleanup on exit
Esc:: {
    Tooltip("")  ; Clear tooltip
    ExitApp()
}
