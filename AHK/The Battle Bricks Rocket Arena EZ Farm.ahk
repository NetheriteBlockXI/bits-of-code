#Requires AutoHotkey v2.0

; Mouse Counter
; Zig (_3xp on Discord)
; Code Version: 1.0.4-A / 4-A
; Tracks clicks for LMB, RMB, MMB, MB4, MB5, and totals. Saves data periodically.

; ------------------------
; User Guide
; ------------------------
; Overview:
; - This script tracks mouse clicks for:
;   - LMB: Left Mouse Button
;   - RMB: Right Mouse Button
;   - MMB: Middle Mouse Button
;   - MB4: Mouse Button 4 (side button)
;   - MB5: Mouse Button 5 (side button)
;   - Total: Total number of clicks across all buttons.
;
; Compatibility:
; - Required: AutoHotkey v2.0 or later.
; - Tested on: Windows 10 and Windows 11.
;
; Usage:
; 1. Save this script as `MouseClickCounter.ahk`.
; 2. Run it using AutoHotkey v2.0.
; 3. Use your mouse as usual; the script tracks and saves counts.
; 4. Press `ESC + Z + X` to view the click summary in a message box:
;    -------------------------------
;    Total Clicks - (clicks)
;    Left Clicks - (clicks)
;    Right Clicks - (clicks)
;    Middle Clicks - (clicks)
;    Mouse Button 4 Clicks - (clicks)
;    Mouse Button 5 Clicks - (clicks)
;    -------------------------------
; 5. Data is automatically saved to `saves/clicks.txt` every 5 seconds.
; 6. To stop the script, right-click its icon in the system tray and select Exit.
; ------------------------

; Set working directory to the script's path
SetWorkingDir(A_ScriptDir)

; Variables
SaveFile := A_ScriptDir "\saves\clicks.txt"
ClickCounts := {LMB: 0, RMB: 0, MMB: 0, MB4: 0, MB5: 0, Total: 0}

; Ensure save directory exists
if !FileExist(A_ScriptDir "\saves")
    DirCreate(A_ScriptDir "\saves")

; Load existing counts from file
if FileExist(SaveFile)
{
    FileRead := FileOpen(SaveFile, "r")
    while !FileRead.AtEOF
    {
        line := FileRead.ReadLine()
        if line ~= "^\w+: \d+$"
        {
            key := StrSplit(line, ": ")[1]
            value := StrSplit(line, ": ")[2] + 0
            if key in ClickCounts
                ClickCounts[key] := value
        }
    }
    FileRead.Close()
}

; Hotkeys for mouse buttons
Hotkey("~LButton", () => UpdateClicks("LMB"))
Hotkey("~RButton", () => UpdateClicks("RMB"))
Hotkey("~MButton", () => UpdateClicks("MMB"))
Hotkey("~XButton1", () => UpdateClicks("MB4"))
Hotkey("~XButton2", () => UpdateClicks("MB5"))

; Timer to save click counts every 5 seconds
SetTimer(() => SaveClicks(SaveFile, ClickCounts), 5000)

; Show data on ESC + Z + X
Hotkey("Esc & Z & X", () => ShowData(ClickCounts))

; Update click counts
UpdateClicks(button) {
    global ClickCounts
    ClickCounts[button]++
    ClickCounts.Total++
}

; Save click counts to file
SaveClicks(SaveFile, ClickCounts) {
    FileWrite := FileOpen(SaveFile, "w")
    for key, value in ClickCounts
        FileWrite.WriteLine(key ": " value)
    FileWrite.Close()
}

; Show data in a message box
ShowData(ClickCounts) {
    MsgBox("
    (LTrim)
    Total Clicks - " ClickCounts.Total "
    Left Clicks - " ClickCounts.LMB "
    Right Clicks - " ClickCounts.RMB "
    Middle Clicks - " ClickCounts.MMB "
    Mouse Button 4 Clicks - " ClickCounts.MB4 "
    Mouse Button 5 Clicks - " ClickCounts.MB5 "
    ")
}

; Save counts on exit
OnExit("SaveBeforeExit")
SaveBeforeExit() {
    global SaveFile, ClickCounts
    SaveClicks(SaveFile, ClickCounts)
}
