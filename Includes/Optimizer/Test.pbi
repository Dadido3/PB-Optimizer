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

DeclareModule Optimizer_Test
  EnableExplicit
  
  ; ################################################### Prototypes ##################################################
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  
  ; ################################################### Variables ###################################################
  
  ; ################################################### Macros ######################################################
  
  ; ################################################### Declares ####################################################
  Declare   Optimize(*Assembler_File.Assembler::File)
  
EndDeclareModule

Module Optimizer_Test
  EnableExplicit
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  
  ; ################################################### Variables ###################################################
  
  ; ################################################### Declares ####################################################
  
  ; ################################################### Procedures ##################################################
  Procedure Optimize(*Assembler_File.Assembler::File)
    
    
    
    
    ForEach *Assembler_File\Line_Container\Line()
      If Not *Assembler_File\Line_Container\Line()\Flag & Assembler::#Line_Flag_Execute And *Assembler_File\Line_Container\Line()\Type = Assembler::#Line_Type_Instruction
        *Assembler_File\Line_Container\Line()\Type = Assembler::#Line_Type_Raw
        *Assembler_File\Line_Container\Line()\Raw_Minus_Label = "; " + *Assembler_File\Line_Container\Line()\Raw_Minus_Label
      EndIf
    Next
    
  EndProcedure
  
  ; ################################################### Init ########################################################
  
  ; ################################################### Data Sections ###############################################
  
EndModule
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 18
; Folding = -
; EnableUnicode
; EnableXP