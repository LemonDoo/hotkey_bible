#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>


Global $ChosenBibleFile = 0
Global $LineNum = 0

#include <Misc.au3>
$dll = 0


Opt("SendKeyDelay", 0)
Opt("SendKeyDownDelay", 0)

Func _Exit()
    FileClose($ChosenBibleFile)
    DllClose($dll)
    Exit
EndFunc


Func GetRandomBibleChapter()
    Local $fileList = _FileListToArray(@ScriptDir & "\bin\bible")
    Local $randomIndex = Random(1, $fileList[0], 1)
    Local $ChosenBibleChapter = $fileList[$randomIndex]

    MsgBox(0,'',"CHOSEN BIBLE CHAPTER: " & $ChosenBibleChapter, 5)

    $chapterDir = "bin\bible\" & $ChosenBibleChapter
    ;~ MsgBox(0,'',"CHAPTER DIR: " & $chapterDir, 5)

    $ChosenBibleFile = FileOpen($chapterDir, 0)

EndFunc


Func WriteBibleVerse()
    ;~ MsgBox(0,'',"STARTED WRITING BIBLE VERSE: " & $LineNum)

    $chosenLine = -1
    While 1
        If Not WinExists("[CLASS:RiotWindowClass]") Then
            _Exit()
        EndIf

        $LineNum = $LineNum + 1
        $line = FileReadLine($ChosenBibleFile, $LineNum)
        If $line == "" Then
            ;~ MsgBox(0,'',"GOT SPACE SKIPPING: " & $LineNum)
            ContinueLoop
        EndIf
        If @error == -1 Then 
            ExitLoop
        EndIf

        $chosenLine = $line
        ExitLoop

    WEnd

    ; type it in /all chat :)
    $chosenLine = "/all " & $chosenLine

    ;~ MsgBox(0,'',$chosenLine)
    SayText($chosenLine)
    
EndFunc


Func SayText($text)
    Opt("SendKeyDelay", 0)
    Opt("SendKeyDownDelay", 0)
    If NOT WinActive("[CLASS:RiotWindowClass]") Then
        WinActivate("[CLASS:RiotWindowClass]", "")
        ;~ Return 0
    EndIf

    ;~ MsgBox($MB_SYSTEMMODAL, "", "SAY TEXT: " & $text)

    Sleep(50)

    ; move to chatbox
    SafeSend('{ENTER}')
    Sleep(30)

    ;~ SafeSend('{ENTER}' & $text & '{ENTER}')
    ;~ Sleep(100)  

    SafeSend($text)
    Sleep(30)

    SafeSend('{ENTER}')
    ;~ Sleep(100)

EndFunc


Func SafeSend($text)
    If NOT WinActive("[CLASS:RiotWindowClass]") Then
        Return 0 
    EndIf
    return Send($text)

EndFunc


Func RunHotKeys()
    Dim $s_keys[117] = [116, _
            "01", "02", "04", "05", "06", "08", "09", "0C", "0D", "10", _
            "11", "12", "13", "14", "1B", "20", "21", "22", "23", "24", _
            "25", "26", "27", "28", "29", "2A", "2B", "2C", "2D", "2E", _
            "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", _
            "41", "42", "44", "45", "46", "47", "48", "49", "4A", "4B", "4C", _
            "4D", "4E", "4F", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", _
            "5A", "5B", "5C", "60", "61", "62", "63", "64", "65", "66", _
            "67", "68", "69", "6A", "6B", "6C", "6D", "6E", "6F", "70", _
            "71", "72", "73", "74", "75", "76", "77", "78", "79", "7A", _
            "7B", "7C", "7D", "7E", "7F", "80H", "81H", "82H", "83H", "84H", _
            "85H", "86H", "87H", "90", "91", "A0", "A1", "A2", "A3", "A4", "A5"]
    $dll = DllOpen("user32.dll")
    While 1
        Sleep(1)
        For $y = 1 To $s_keys[0]
            If _IsPressed ($s_keys[$y], $dll) Then
                If $s_keys[$y] == "70" Then ; F1
                    WriteBibleVerse()
                EndIf
                If $s_keys[$y] == "77" Then ; F8
                    _Exit()
                EndIf
                ;~ MsgBox(0, "I saw that one!", $s_keys[$y])
            EndIf
        Next
    WEnd

EndFunc


Func RunFull()
    GetRandomBibleChapter()
    WriteBibleVerse()

    RunHotKeys()

    ;~ While 1
    ;~     Sleep(1000)
    ;~ WEnd

EndFunc


RunFull()