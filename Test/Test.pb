ProcedureDLL Test(a.l)
  
  If test
  
  PrintN("Never")
  
  EndIf
  
EndProcedure

Test(5)

OpenConsole()

For i = 0 To 10
  Test - 1
Next

Test = 1
Test * 5

Float.f = 5
Float / 1.0

If Test = 5
  PrintN("Hiä")
EndIf

Input()
; IDE Options = PureBasic 5.41 LTS Beta 1 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 22
; Folding = -
; EnableUnicode
; EnableXP
; DisableDebugger
; Compiler = PureBasic 5.40 LTS (Windows - x86)