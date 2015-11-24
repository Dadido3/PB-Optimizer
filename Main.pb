; ##################################################### License / Copyright #########################################
; 
;     Optimizer
;     Copyright (C) 2015  David Vogel
; 
;     This program is free software; you can redistribute it and/or modify
;     it under the terms of the GNU General Public License As published by
;     the Free Software Foundation; either version 2 of the License, or
;     (at your option) any later version.
; 
;     This program is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY Or FITNESS For A PARTICULAR PURPOSE.  See the
;     GNU General Public License For more details.
; 
;     You should have received a copy of the GNU General Public License along
;     With this program; if not, write to the Free Software Foundation, Inc.,
;     51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
; 
; ##################################################### Documentation / Comments ####################################
; 
; Todo:
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; ##################################################### External Includes ###########################################

; ##################################################### Includes ####################################################

DeclareModule Main
  EnableExplicit
  
  ; ################################################### Prototypes ##################################################
  
  ; ################################################### Constants ###################################################
  #Version = 0100
  
  ; ################################################### Structures ##################################################
  Structure Main
    
  EndStructure
  
  ; ################################################### Variables ###################################################
  Global Main.Main
  
  ; ################################################### Macros ######################################################
  
  ; ################################################### Declares ####################################################
EndDeclareModule

; ##################################################### Includes ####################################################
XIncludeFile "Includes/Assembler.pbi"
XIncludeFile "Includes/Visualizer.pbi"

XIncludeFile "Includes/Optimizer/Test.pbi"

Module Main
  EnableExplicit
  
  ; ################################################### Init ########################################################
  
  ; ################################################### Declares ####################################################
  
  ; ################################################### Procedures ##################################################
  
  ; ################################################### Initialisation ##############################################
  OpenConsole()
  
  ; ################################################### Main ########################################################
  Define i
  Define Filename.s, File.i
  Define Parameter.s
  Define Program.i
  Define ExitCode.i
  Define *Assembler_File
  
  Filename = ProgramParameter(0)
  
  ;CopyFile(Filename, "C:\Users\David Vogel\Desktop\Original Output.asm")
  
  ;File = ReadFile(#PB_Any, Filename)
  File = ReadFile(#PB_Any, "Test/PureBasic.asm")
  If File
    *Assembler_File = Assembler::File_Parse(File)
    
    CloseFile(File)
  EndIf
  
  ; #### Optimize test
  Optimizer_Test::Optimize(*Assembler_File)
  
  ;File = CreateFile(#PB_Any, Filename)
  ;If File
  ;  Assembler::File_Compose(*Assembler_File, File)
  ;  
  ;  CloseFile(File)
  ;EndIf
  
  ; #### Visualizer
  Visualizer::Main(*Assembler_File)
  
  ; #### Forward the Parameters to the original FAsm executable
  For i = 0 To CountProgramParameters()-1
    If i = CountProgramParameters()-1
      Parameter + ProgramParameter(i)
    Else
      Parameter + ProgramParameter(i) + " "
    EndIf
  Next
  
  Program = RunProgram(GetPathPart(ProgramFilename())+"FAsm_Original.exe", Parameter, GetCurrentDirectory(), #PB_Program_Open); | #PB_Program_Read | #PB_Program_Error | #PB_Program_UTF8)
  If Not Program
    End
  EndIf
  
;   Define File = CreateFile(#PB_Any, "C:\Users\David Vogel\Desktop\FAsm output.txt")
  
  While ProgramRunning(Program)
;     Define String.s
;     While AvailableProgramOutput(Program)
;       String.s = ReadProgramString(Program)
;       WriteStringN(File, "stdout: " + String)
;       PrintN(String)
;     Wend
;     
;     String.s = ReadProgramError(Program)
;     While String
;       WriteStringN(File, "stderr: " + String)
;       ConsoleError(String)
;       String.s = ReadProgramError(Program)
;     Wend
  Wend
  
  ExitCode = ProgramExitCode(Program)
;   WriteStringN(File, "ExitCode: "+ExitCode)
  CloseProgram(Program)
  
;   CloseFile(File)
  
  ; ################################################### End #########################################################
  End ExitCode
  
  ; ################################################### Data Sections ###############################################
  
EndModule
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 4
; EnableUnicode
; EnableXP