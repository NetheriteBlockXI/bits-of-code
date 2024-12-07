#Requires AutoHotkey v2.0

; ------------------------
; Script Title: EZ SQ/EZ Shove
; Zig (_3xp on Discord)
; Code Version: 1.0.0-A /  1-A
; ------------------------

Global Timer := 0.0
Global Running := True
Global Threshold := 9.9

ScreenWidth := A_ScreenWidth
ScreenHeight := A_ScreenHeight

CenterX := (ScreenWidth // 2) + 456
CenterY := (ScreenHeight // 2) - 256

Tick() {
    Global Timer, Running, CenterX, CenterY, Threshold
    if Running {
        Timer += 0.1
        if Timer >= Threshold {
            Tooltip("Shove (Q)!", CenterX, CenterY)
        } else {
            Tooltip("Time Left: " . Round(Threshold - Timer, 1), CenterX, CenterY)
        }
    }
}

SetTimer(Tick, 100)

~q:: {
    Global Timer, Running
    if (Timer >= Threshold) {
        Timer := 0.0
        Running := True
        Tooltip("")
    }
}

~+q:: {
    Global Timer, Running
    if (Timer >= Threshold) {
        Timer := 0.0
        Running := True
        Tooltip("")
    }
}

^Up:: {
    Global Threshold
    Threshold += 1
    Tooltip("Threshold set to: " . Threshold, CenterX, CenterY)
    Sleep 1000
    Tooltip("")
}

^Down:: {
    Global Threshold
    Threshold -= 1
    Tooltip("Threshold set to: " . Threshold, CenterX, CenterY)
    Sleep 1000
    Tooltip("")
}

~Esc:: {
    Tooltip("")  ; Clears the tooltip
}
