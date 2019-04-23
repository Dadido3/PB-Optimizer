; ##################################################### License / Copyright #########################################
; 
;     PB-Optimizer
;     Copyright (C) 2015-2019  David Vogel
;     
;     This program is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;     
;     This program is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;     
;     You should have received a copy of the GNU General Public License
;     along with this program.  If not, see <http://www.gnu.org/licenses/>.
; 
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

DeclareModule Helper
  EnableExplicit
  
  ; ################################################### Prototypes ##################################################
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  
  ; ################################################### Variables ###################################################
  
  ; ################################################### Macros ######################################################
  Macro Line(x, y, Width, Height, Color)
    LineXY((x), (y), (x)+(Width), (y)+(Height), (Color))
  EndMacro
  
  ; ################################################### Declares ####################################################
  Declare.s GetFullPathName(Filename.s)
  Declare   IsChildOfPath(Parent.s, Child.s)
  Declare.s SHGetFolderPath(CSIDL)
  Declare   MakeSureDirectoryPathExists(Path.s)
  
  Declare.q Quad_Divide_Floor(A.q, B.q)
  Declare.q Quad_Divide_Ceil(A.q, B.q)
  
EndDeclareModule

; ###################################################################################################################
; ##################################################### Private #####################################################
; ###################################################################################################################

Module Helper
  EnableExplicit
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  
  ; ################################################### Variables ###################################################
  
  ; ################################################### Procedures ##################################################
  Procedure.s GetFullPathName(Filename.s)
    Protected Characters
    Protected *Temp_Buffer
    Protected Result.s
    
    Characters = GetFullPathName_(@Filename, #Null, #Null, #Null)
    *Temp_Buffer = AllocateMemory(Characters * SizeOf(Character))
    
    GetFullPathName_(@Filename, Characters, *Temp_Buffer, #Null)
    Result = PeekS(*Temp_Buffer, Characters)
    
    FreeMemory(*Temp_Buffer)
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure IsChildOfPath(Parent.s, Child.s)
    Protected Parent_Full.s = GetPathPart(GetFullPathName(Parent))
    Protected Child_Full.s = GetPathPart(GetFullPathName(Child))
    
    If Left(Child_Full, Len(Parent_Full)) = Parent_Full
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  
  Procedure.s SHGetFolderPath(CSIDL)
    Protected *String = AllocateMemory(#MAX_PATH+1)
    SHGetFolderPath_(0, CSIDL, #Null, 0, *String)     ; Doesn't include the last "\"
    Protected String.s = PeekS(*String)
    FreeMemory(*String)
    ProcedureReturn String
  EndProcedure
  
  Procedure MakeSureDirectoryPathExists(Path.s)
    Protected Parent_Path.s
    Path = GetPathPart(Path)
    Path = ReplaceString(Path, "\", "/")
    
    If FileSize(Path) = -2
      ; #### Directory exists
      ProcedureReturn #True
    Else
      ; #### Directory doesn't exist. Check (and create) parent directory, and then create the final directory
      Parent_Path = ReverseString(Path)
      Parent_Path = RemoveString(Parent_Path, "/", #PB_String_CaseSensitive, 1, 1)
      Parent_Path = Mid(Parent_Path, FindString(Parent_Path, "/"))
      Parent_Path = ReverseString(Parent_Path)
      If MakeSureDirectoryPathExists(Parent_Path)
        CreateDirectory(Path)
        ProcedureReturn #True
      EndIf
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  ; #### Works perfectly, A and B can be positive or negative. B must not be zero!
  Procedure.q Quad_Divide_Floor(A.q, B.q)
    Protected Temp.q = A / B
    If (((a ! b) < 0) And (a % b <> 0))
      ProcedureReturn Temp - 1
    Else
      ProcedureReturn Temp
    EndIf
  EndProcedure
  
  ; #### Works perfectly, A and B can be positive or negative. B must not be zero!
  Procedure.q Quad_Divide_Ceil(A.q, B.q)
    Protected Temp.q = A / B
    If (((a ! b) >= 0) And (a % b <> 0))
      ProcedureReturn Temp + 1
    Else
      ProcedureReturn Temp
    EndIf
  EndProcedure
  
EndModule

; IDE Options = PureBasic 5.61 (Windows - x64)
; CursorPosition = 18
; Folding = --
; EnableXP
; EnableUnicode