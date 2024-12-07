; ------------------------
; Mouse Click Counter Script
; Zig (_3xp on Discord)
; Code Version: 1.0.2-R / 2-R
; ------------------------

#Persistent
SetTimer, SaveData, 5000

totalClicks := 0
leftClicks := 0
rightClicks := 0
middleClicks := 0
mb4Clicks := 0
mb5Clicks := 0

scriptPath := A_ScriptDir
savePath := scriptPath "\saves\clicks.txt"

LoadData() {
    global totalClicks, leftClicks, rightClicks, middleClicks, mb4Clicks, mb5Clicks, savePath
    if FileExist(savePath) {
        FileRead, data, % savePath
        Loop, parse, data, `n, `r
        {
            line := A_LoopField
            if (A_Index = 1) {
                totalClicks := SubStr(line, 19)
            } else if (A_Index = 2) {
                leftClicks := SubStr(line, 19)
            } else if (A_Index = 3) {
                rightClicks := SubStr(line, 20)
            } else if (A_Index = 4) {
                middleClicks := SubStr(line, 23)
            } else if (A_Index = 5) {
                mb4Clicks := SubStr(line, 24)
            } else if (A_Index = 6) {
                mb5Clicks := SubStr(line, 24)
            }
        }
    }
    RecalculateTotalClicks()
}

LoadData()

SaveData() {
    global totalClicks, leftClicks, rightClicks, middleClicks, mb4Clicks, mb5Clicks, savePath
    if !FileExist(scriptPath "\saves") {
        FileCreateDir, % scriptPath "\saves"
    }

    FileDelete, % savePath

    FileAppend, % "Total Mouse Clicks: " totalClicks "`n"
                . "Left Mouse Clicks: " leftClicks "`n"
                . "Right Mouse Clicks: " rightClicks "`n"
                . "Middle Mouse Clicks: " middleClicks "`n"
                . "Mouse Button 4 Clicks: " mb4Clicks "`n"
                . "Mouse Button 5 Clicks: " mb5Clicks "`n", % savePath
}

RecalculateTotalClicks() {
    global totalClicks, leftClicks, rightClicks, middleClicks, mb4Clicks, mb5Clicks
    totalClicks := leftClicks + rightClicks + middleClicks + mb4Clicks + mb5Clicks
    totalClicks := Round(totalClicks)
}

~esc & z::
    MsgBox, % "Click Summary:" "`n"
        . "Total Mouse Clicks: " totalClicks "`n"
        . "Left Mouse Clicks: " leftClicks "`n"
        . "Right Mouse Clicks: " rightClicks "`n"
        . "Middle Mouse Clicks: " middleClicks "`n"
        . "Mouse Button 4 Clicks: " mb4Clicks "`n"
        . "Mouse Button 5 Clicks: " mb5Clicks
return

~LButton::
    leftClicks++
    leftClicks := Round(leftClicks)
    RecalculateTotalClicks()
return

~RButton::
    rightClicks++
    rightClicks := Round(rightClicks)
    RecalculateTotalClicks()
return

~MButton::
    middleClicks++
    middleClicks := Round(middleClicks)
    RecalculateTotalClicks()
return

~XButton1::
    mb4Clicks++
    mb4Clicks := Round(mb4Clicks)
    RecalculateTotalClicks()
return

~XButton2::
    mb5Clicks++
    mb5Clicks := Round(mb5Clicks)
    RecalculateTotalClicks()
return
