; ##################################################### License / Copyright #########################################
; 
;     PB-Optimizer
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
; Author: Dadido3 (David Vogel)
; Creation: 2015-11-27
; Optimizes:
; - Size
; - Speed
; 
; Description:
;   This optimizer removes unnecessary PUSH and POP pairs.
;   Additionally it corrects the offset of memory addresses between the removed instructions.
; 
; Example:
;   PUSH EAX              --> <REMOVE>
;   MOV EBP, [ESP + 4]    --> MOV EBP, [ESP - 4 + 4]
;   MOV EBX, [EBP + 4]    --> MOV EBX, [EBP + 4]
;   MOV [ESP + 8], EBX    --> MOV [ESP - 4 + 8], EBX
;   POP EAX               --> <REMOVE>
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

DeclareModule Optimizer_PUSH_POP
  EnableExplicit
  
  ; ################################################### Prototypes ##################################################
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  
  ; ################################################### Variables ###################################################
  
  ; ################################################### Macros ######################################################
  
  ; ################################################### Declares ####################################################
  Declare   Optimize(*Line_Container.Assembler::Line_Container)
  
EndDeclareModule

Module Optimizer_PUSH_POP
  EnableExplicit
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  
  ; ################################################### Variables ###################################################
  
  ; ################################################### Declares ####################################################
  
  ; ################################################### Procedures ##################################################
  Procedure Optimize(*Line_Container.Assembler::Line_Container)
    Protected *Line_POP.Assembler::Line
    Protected *Line_PUSH.Assembler::Line
    Protected Dependencies
    Protected *Dependency.Assembler::Dependency
    Protected Found
    Protected NewList *Memory_Address.Assembler::Address()
    
    ; #### Find unnecessary PUSH, POP pairs
    ForEach *Line_Container\Line()
      *Line_POP = *Line_Container\Line()
      
      If *Line_POP\Flag & Assembler::#Line_Flag_Execute And *Line_POP\Type = Assembler::#Line_Type_Instruction And *Line_POP\OpCode And *Line_POP\OpCode\Mnemonic = "POP"
        
        ; #### Search lines which influence the POP instruction
        Dependencies = 0
        ForEach *Line_POP\Dependency()
          If *Line_POP\Dependency()\Influencee_Address\Type = Assembler::#Address_Type_Register And *Line_POP\Dependency()\Influencee_Address\Register\Group = Assembler::#Register_Group_SP
            *Dependency = *Line_POP\Dependency()
            Dependencies + 1
          EndIf
        Next
        
        ; #### If there are more than 1 dependencies, it's too complex to check
        If Not Dependencies = 1
          Continue
        EndIf
        
        If *Dependency\Influencer And *Dependency\Influencer\OpCode And *Dependency\Influencer\OpCode\Mnemonic = "PUSH"
          *Line_PUSH = *Dependency\Influencer
          
          ; #### Check if the PUSH instruction influences anything else than *Line_POP
          ClearList(*Memory_Address())
          Found = #True
          ForEach *Line_PUSH\Influence()
            If *Line_PUSH\Influence()\Virtual = #False And *Line_PUSH\Influence()\Influencee <> *Line_POP
              
              ; #### Check if the influencee address is part of a memory address
              Found = #False
              ForEach *Line_PUSH\Influence()\Influencee\Operand()
                If *Line_PUSH\Influence()\Influencee\Operand()\Address\Type = Assembler::#Address_Type_Memory
                  ForEach *Line_PUSH\Influence()\Influencee\Operand()\Address\Sub_Address()
                    If *Line_PUSH\Influence()\Influencee\Operand()\Address\Sub_Address() = *Line_PUSH\Influence()\Influencee_Address
                      
                      ; #### Add memory address to the list of addresses which have to be corrected
                      AddElement(*Memory_Address())
                      *Memory_Address() = *Line_PUSH\Influence()\Influencee\Operand()\Address
                      
                      Found = #True
                      
                      Break 2
                    EndIf
                  Next
                EndIf
              Next
              
              If Not Found
                Break
              EndIf
              
            EndIf
          Next
          If Not Found
            ; #### Found some dependency between PUSH and POP, which can't be fixed
            Continue
          EndIf
          
          ; #### Check if the operands of POP and PUSH have the same value.
          ; #### In other words: Check if the operand wasn't changed between PUSH and POP
          If SelectElement(*Line_POP\Operand(), 0) And SelectElement(*Line_PUSH\Operand(), 0)
            
            If Assembler::Address_Ident_Result(*Line_POP, *Line_POP\Operand()\Address, *Line_PUSH, *Line_PUSH\Operand()\Address)
              
              ;Debug "Delete: " + *Line_PUSH\Raw
              ;Debug "Delete: " + *Line_POP\Raw
              
              ; #### Add an offset to any memory addressing between PUSH and POP
              ForEach *Memory_Address()
                AddElement(*Memory_Address()\Sub_Address())
                *Memory_Address()\Sub_Address()\Type = Assembler::#Address_Type_Immediate_Value
                Select *Line_Container\Architecture
                  Case Assembler::#Architecture_x86
                    *Memory_Address()\Sub_Address()\Value = "4" ; TODO: Values should be stored as number, if possible.
                    *Memory_Address()\Sub_Address()\Negative = #True
                  Case Assembler::#Architecture_x86_64
                    *Memory_Address()\Sub_Address()\Value = "8"
                    *Memory_Address()\Sub_Address()\Negative = #True
                EndSelect
              Next
              
              Assembler::Line_Delete(*Line_Container, *Line_PUSH)
              Assembler::Line_Delete(*Line_Container, *Line_POP)
              ;*Line_POP\Type = Assembler::#Line_Type_Raw
              ;*Line_PUSH\Type = Assembler::#Line_Type_Raw
              ;*Line_POP\Raw_Minus_Label = "; " + *Line_POP\Raw_Minus_Label
              ;*Line_PUSH\Raw_Minus_Label = "; " + *Line_PUSH\Raw_Minus_Label
              
              ; #### Let the for loop continue with the next line
              ;PreviousElement(*Line_Container\Line())
              
            EndIf
            
          EndIf
          
        EndIf
        
      EndIf
    Next
    
  EndProcedure
  
  ; ################################################### Init ########################################################
  
  ; ################################################### Data Sections ###############################################
  
EndModule
; IDE Options = PureBasic 5.41 LTS Beta 1 (Windows - x64)
; CursorPosition = 153
; FirstLine = 145
; Folding = -
; EnableUnicode
; EnableXP