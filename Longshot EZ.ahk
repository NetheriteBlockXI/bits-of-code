#Requires AutoHotkey v2.0	

tab::
{
    Send "{f down}"        ; Hold the "f" key
    Sleep 50               ; Wait 0.05 seconds (50 ms)
    Send "{f up}"          ; Release the "f" key
    Sleep 500              ; Wait 0.50 seconds (500 ms)
    Send "{f down}"        ; Hold the "f" key again
    Sleep 50               ; Wait 0.05 seconds (50 ms)
    Send "{f up}"          ; Release the "f" key
}