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

DeclareModule Assembler
  EnableExplicit
  
  ; ################################################### Prototypes ##################################################
  
  ; ################################################### Constants ###################################################
  ; #### Registers in a group (like rax, eax, ax, ...) influence each other on a change
  Enumeration
    #Register_Group_A
    #Register_Group_B
    #Register_Group_C
    #Register_Group_D
    
    #Register_Group_BP
    #Register_Group_SI
    #Register_Group_DI
    #Register_Group_SP
    
    #Register_Group_IP
    
    #Register_Group_FLAGS
    
    #Register_Group_R8
    #Register_Group_R9
    #Register_Group_R10
    #Register_Group_R11
    #Register_Group_R12
    #Register_Group_R13
    #Register_Group_R14
    #Register_Group_R15
    
    #Register_Group_ST0
    #Register_Group_ST1
    #Register_Group_ST2
    #Register_Group_ST3
    #Register_Group_ST4
    #Register_Group_ST5
    #Register_Group_ST6
    #Register_Group_ST7
    
    #Register_Group_XMM0
    #Register_Group_XMM1
    #Register_Group_XMM2
    #Register_Group_XMM3
    #Register_Group_XMM4
    #Register_Group_XMM5
    #Register_Group_XMM6
    #Register_Group_XMM7
    #Register_Group_XMM8
    #Register_Group_XMM9
    #Register_Group_XMM10
    #Register_Group_XMM11
    #Register_Group_XMM12
    #Register_Group_XMM13
    #Register_Group_XMM14
    #Register_Group_XMM15
    #Register_Group_XMM16
    #Register_Group_XMM17
    #Register_Group_XMM18
    #Register_Group_XMM19
    #Register_Group_XMM20
    #Register_Group_XMM21
    #Register_Group_XMM22
    #Register_Group_XMM23
    #Register_Group_XMM24
    #Register_Group_XMM25
    #Register_Group_XMM26
    #Register_Group_XMM27
    #Register_Group_XMM28
    #Register_Group_XMM29
    #Register_Group_XMM30
    #Register_Group_XMM31
  EndEnumeration
  
  EnumerationBinary
    #Flag_00_CF   ; Status flags
    #Flag_01
    #Flag_02_PF
    #Flag_03
    #Flag_04_AF
    #Flag_05
    #Flag_06_ZF
    #Flag_07_SF
    #Flag_08_TF   ; Control flags
    #Flag_09_IF
    #Flag_10_DF
    #Flag_11_OF   ; Status flag
    #Flag_12_IOPL ; System flags
    #Flag_13_IOPL
    #Flag_14_NT
    #Flag_15
    #Flag_16_RF
    #Flag_17_VM
    #Flag_18_AC
    #Flag_19_VIF
    #Flag_20_VIP
    #Flag_21_ID
  EndEnumeration
  
  Enumeration
    ;#Address_Type_Undefined
    
    #Address_Type_Immediate_Value
    #Address_Type_Immediate_Label
    #Address_Type_Register
    #Address_Type_Memory
    #Address_Type_Stack              ; Similar to #Address_Memory, points to the address of the stackpointer
    #Address_Type_Flags              ; Similar to #Address_Stack, but only cares about #Register_Group_FLAGS
  EndEnumeration
  
  Enumeration
    #Line_Type_Raw
    
    #Line_Type_Instruction    ; Line contains an instruction (Opcode + Operands) (that can include a label, too)
  EndEnumeration
  
  EnumerationBinary
    #Line_Flag_Temp           ; Temporary flag
    #Line_Flag_Execute        ; Set, when it's possible that the IP reaches this instruction
    #Line_Flag_SP_Calculated  ; #True when the stack pointer offset is calculated for this line
  EndEnumeration
  
  Enumeration
    #Label_Type_None
    
    #Label_Type_Global            ; Normal Label
    #Label_Type_Global_No_Childs  ; Starting with "..", Like a global label, but it can't be a parent
    #Label_Type_Local             ; Starting with ".", and is a child of the previous global label
    #Label_Type_Anonymous         ; Starting with "@@"
  EndEnumeration
  
  Enumeration
    #Architecture_x86
    #Architecture_x86_64
  EndEnumeration
  
  #Stack_Pointer_Invalid = 2147483647
  
  ; ################################################### Structures ##################################################
  Structure Dependency
    *Influencer.Line              ; The line (instruction) which influences the data of the *Influencee
    *Influencer_Address.Address   ; The pointer to the address which influences the data of the *Influencee
    
    *Influencee.Line              ; The line (instruction) which depends on the data of the *Influencer
    *Influencee_Address.Address   ; The pointer to the address which caused the dependency
    
    Virtual.i                     ; #True: It's not a real dependency. The Influencee_Address isn't affected of the Influencer_Address
  EndStructure
  
  Structure Address
    Type.i
    
    Size_Operator.s               ; byte, word, qword, ...
    
    ; #### #Address_Immediate_Value
    Value.s
    
    ; #### #Address_Immediate_Label
    *Label_Line.Line
    Label_Raw.s                   ; If *Label_Line = #Null, use a raw string
    
    ; #### #Address_Register
    *Register.Register
    Multiplicator.l               ; Only used when this is a register in a memory address
    
    ; #### #Address_Memory
    List Sub_Address.Address()
    
    ; #### #Address_Stack
    Stack_Position.i              ; The stack pointer offset
    Stack_Relative.i              ; #True: position is relative to the stack pointer of the line. Like [esp - Stack_Position]
    
    ; #### #Address_Flags
    Flags.q
    
  EndStructure
  
  Structure Register
    Name.s
    Group.i               ; Registers in the same group (like rax, eax, ax, ...) influence each other on a change
  EndStructure
  
  Structure OpCode
    Mnemonic.s
    
    Operands.i
    
    List Read_Address.Address()   ; Addresses which are read by this instruction (Additional to the address in the operands)
    List Mod_Address.Address()    ; Addresses which are modified by this instruction (Additional to the address in the operands)
    
    List Read_Operand.i()         ; Operands which read data
    List Mod_Operand.i()          ; Operands which modify data
    
    ; #### Stack
    Stack_Delta_x86.i            ; Change of the stack pointer throught this opcode
    Stack_Delta_x86_64.i
    
  EndStructure
  
  Structure Operand
    Raw.s
    
    Address.Address
    
  EndStructure
  
  Structure Line
    Type.i
    
    Raw.s
    
    Label.s
    Label_Type.i
    *Label_Parent_Line.Line
    
    ; #### Type: #Line_Raw
    Raw_Minus_Label.s
    
    ; #### Type: #Line_Instruction
    *OpCode.OpCode                ; #Null when opcode unknown
    List Operand.Operand()
    Raw_Instruction.s             ; Used when *OpCode = #Null. (This includes the opcode and operands)
    
    List Dependency.Dependency()
    List *Influence.Dependency()
    
    ; #### Program flow
    List *Next_Line.Line()        ; List of line which can jump to the current line (Following the program flow)
    List *Prev_Line.Line()        ; List of possible next lines (Following the program flow)
    
    ; #### Stack
    Stack_Pointer.i               ; Current stack pointer offset
    
    Flag.i
  EndStructure
  
  Structure Line_Container
    List Line.Line()
    
    Architecture.i
  EndStructure
  
  Structure SubRoutine
    ;*Start_Line.Line
  EndStructure
  
  Structure File
    
    Line_Container.Line_Container
    
    *Entry_Point.Line
    
    ;List SubRoutine.SubRoutine()
  EndStructure
  
  Structure Line_Iteration
    *Line.Line
    
    Flags.q
  EndStructure
  
  Structure Address_Iteration
    *Address.Address
    
    Virtual.i
  EndStructure
  
  Structure Main
    
  EndStructure
  
  ; ################################################### Variables ###################################################
  Global Main.Main
  
  Global NewMap Register.Register()
  Global NewMap OpCode.OpCode()
  
  ; ################################################### Macros ######################################################
  
  ; ################################################### Declares ####################################################
  Declare   Address_Ident_Result(*Address_A.Address, *Address_B.Address)
  
  Declare   Operand_Parse(*Line_Container.Line_Container, *Line.Line, *Operand.Operand)
  Declare.s Operand_Compose(*Line_Container.Line_Container, *Line.Line, *Address.Address)
  
  Declare   Line_Delete(*Line_Container.Line_Container, *Line.Line)
  Declare   Line_Parse(*Line_Container.Line_Container, *Line.Line)
  Declare   Line_Compose(*Line_Container.Line_Container, *Line.Line)
  
  Declare   File_Parse(File.i)
  Declare   File_Compose(*Assembler_File.File, File.i)
  Declare   File_Free(*Assembler_File.File)
  
EndDeclareModule

Module Assembler
  EnableExplicit
  
  ; ################################################### Declares ####################################################
  
  ; ################################################### RegEx #######################################################
  Global RegEx_Line_Raw = CreateRegularExpression(#PB_Any, "^\s*(format|extrn|public|pb_public|macro|section|align|db|file|dw|du|dd|dp|df|dq|dt|(.+\=.+))\s*", #PB_RegularExpression_NoCase)
  Global RegEx_Line_Label = CreateRegularExpression(#PB_Any, "^\s*(?<Label>[@\._a-zA-Z][@\d\._a-zA-Z]*):\s*(?<Rest>.*)")
  Global RegEx_Line_Instruction_0 = CreateRegularExpression(#PB_Any, "^\s*(?<OpCode>[a-zA-Z]+)(;|$)")
  Global RegEx_Line_Instruction_1 = CreateRegularExpression(#PB_Any, "^\s*(?<OpCode>[a-zA-Z]+)\s+(?<Param_0>[\'\.\[\]\s@\-\+\*\d_a-zA-Z]+)(;|$)")
  Global RegEx_Line_Instruction_2 = CreateRegularExpression(#PB_Any, "^\s*(?<OpCode>[a-zA-Z]+)\s+(?<Param_0>[\'\.\[\]\s@\-\+\*\d_a-zA-Z]+),(?<Param_1>[\'\.\[\]\s@\-\+\*\d_a-zA-Z]+)(;|$)")
  Global RegEx_Line_Instruction_3 = CreateRegularExpression(#PB_Any, "^\s*(?<OpCode>[a-zA-Z]+)\s+(?<Param_0>[\'\.\[\]\s@\-\+\*\d_a-zA-Z]+),(?<Param_1>[\'\.\[\]\s@\-\+\*\d_a-zA-Z]+),(?<Param_2>[\'\.\[\]\s@\-\+\*\d_a-zA-Z]+)(;|$)")
  
  Global RegEx_Operand_Size_Operator = CreateRegularExpression(#PB_Any, "^\s*(?<Size_Operator>byte|word|dword|fword|pword|qword|tbyte|tword|dqword|xword|qqword|yword)\s+(?<Rest>.*)", #PB_RegularExpression_NoCase)
  Global RegEx_Operand_Value = CreateRegularExpression(#PB_Any, "^\s*(?<Value>[\+\-]*[\d]+)")
  Global RegEx_Operand_Memory = CreateRegularExpression(#PB_Any, "^\s*\[(?<Address>.+)\]")
  
  ; ################################################### Procedures ##################################################
  ; #### Check if two addresses point to the same entity and therefore can influence each other. (like eax and ax)
  Procedure Address_Conjugate(*Address_A.Address, *Address_B.Address)
    Repeat
      
      Select *Address_A\Type
        Case #Address_Type_Immediate_Value, #Address_Type_Immediate_Label
          ; #### A immediate address is its own unique entity
          ProcedureReturn #False
          
        Case #Address_Type_Register
          Select *Address_B\Type
            Case #Address_Type_Register
              ; #### Compare register group with register group
              If *Address_A\Register\Group = *Address_B\Register\Group
                ProcedureReturn #True
              EndIf
              ProcedureReturn #False
              
            Case #Address_Type_Flags
              ; #### Compare flags register group with flags
              If *Address_A\Register\Group = #Register_Group_FLAGS And *Address_B\Flags
                ProcedureReturn *Address_B\Flags
              EndIf
              ProcedureReturn #False
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Case #Address_Type_Flags
          Select *Address_B\Type
            Case #Address_Type_Flags
              ProcedureReturn *Address_A\Flags & *Address_B\Flags
              
            Case #Address_Type_Register
              ; #### Check it with swapped addresses
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Case #Address_Type_Memory
          Select *Address_B\Type
            Case #Address_Type_Memory
              ; TODO: Improve the way the addresses are compared
              ; #### Normalize the order of the sub-addresses (Not the best way)
              SortStructuredList(*Address_A\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Label_Line), #PB_Integer)
              SortStructuredList(*Address_A\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Label_Raw), TypeOf(Address\Label_Raw))
              SortStructuredList(*Address_A\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Register), #PB_Integer)
              SortStructuredList(*Address_A\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Value), TypeOf(Address\Value))
              SortStructuredList(*Address_A\Sub_Address(), #PB_Sort_Descending, OffsetOf(Address\Type), TypeOf(Address\Type))
              
              SortStructuredList(*Address_B\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Label_Line), #PB_Integer)
              SortStructuredList(*Address_B\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Label_Raw), TypeOf(Address\Label_Raw))
              SortStructuredList(*Address_B\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Register), #PB_Integer)
              SortStructuredList(*Address_B\Sub_Address(), #PB_Sort_Ascending, OffsetOf(Address\Value), TypeOf(Address\Value))
              SortStructuredList(*Address_B\Sub_Address(), #PB_Sort_Descending, OffsetOf(Address\Type), TypeOf(Address\Type))
              
              If ListSize(*Address_A\Sub_Address()) = ListSize(*Address_B\Sub_Address())
                ResetList(*Address_A\Sub_Address())
                ResetList(*Address_B\Sub_Address())
                While NextElement(*Address_A\Sub_Address()) And NextElement(*Address_B\Sub_Address())
                  If Not Address_Ident_Result(*Address_A\Sub_Address(), *Address_B\Sub_Address())
                    ProcedureReturn #False
                  EndIf
                Wend
                ProcedureReturn #True
              EndIf
              ProcedureReturn #False
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Default
          ProcedureReturn #False
          
      EndSelect
      
      ; #### Swap
      Swap *Address_A, *Address_B
      
    ForEver
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure Address_Ident_Result(*Address_A.Address, *Address_B.Address)
    Repeat
      
      Select *Address_A\Type
        Case #Address_Type_Immediate_Value
          Select *Address_B\Type
            Case #Address_Type_Immediate_Value
              If *Address_A\Value = *Address_B\Value
                ProcedureReturn #True
              Else
                ProcedureReturn #False
              EndIf
              
            Case #Address_Type_Immediate_Label
              ; #### The address of a label is unknown, it can't be compared with a value.
              ProcedureReturn #False
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Case #Address_Type_Immediate_Label
          Select *Address_B\Type
            Case #Address_Type_Immediate_Label
              If *Address_A\Label_Line And *Address_B\Label_Line
                If *Address_A\Label_Line = *Address_B\Label_Line
                  ProcedureReturn #True
                EndIf
              ElseIf *Address_A\Label_Line = #Null And *Address_B\Label_Line = #Null
                ; #### Assume that the label (Or variable) is static, this may not be true in every case. This should be implemented correctly later
                If *Address_A\Label_Raw = *Address_B\Label_Raw
                  ProcedureReturn #True
                EndIf
              EndIf
              ProcedureReturn #False
              
            Case #Address_Type_Immediate_Value
              ; #### The address of a label is unknown, it can't be compared with a value.
              ProcedureReturn #False
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Case #Address_Type_Register
          Select *Address_B\Type
            Case #Address_Type_Register
              If *Address_A\Register = *Address_B\Register
                ; TODO: Check if the register values are identical
                ProcedureReturn #False
              EndIf
              ProcedureReturn #False
              
            Case #Address_Type_Flags
              ; #### This may be possible, but is hard to check
              ProcedureReturn #False
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Case #Address_Type_Flags
          Select *Address_B\Type
            Case #Address_Type_Flags
              ; TODO: Check if the flags are identical
              ProcedureReturn #False
              
            Case #Address_Type_Register
              ; #### This may be possible, but is hard to check
              ProcedureReturn #False
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Case #Address_Type_Memory
          Select *Address_B\Type
            Case #Address_Type_Memory
              ; TODO: Check if the data at the address is identical
              ProcedureReturn #False
              
            Default
              ; #### Not comparable
              ProcedureReturn #False
              
          EndSelect
          
        Default
          ProcedureReturn #False
          
      EndSelect
      
      ProcedureReturn #False
      
    ForEver
    
    
  EndProcedure
  
  Procedure Label_Get_Prev_Global(*Line_Container.Line_Container, *Line.Line)
    Protected *Result.Line
    
    If Not *Line
      ProcedureReturn #Null
    EndIf
    
    PushListPosition(*Line_Container\Line())
    
    ChangeCurrentElement(*Line_Container\Line(), *Line)
    Repeat
      If *Line_Container\Line()\Label_Type = #Label_Type_Global
        *Result = *Line_Container\Line()
        Break
      EndIf
    Until Not PreviousElement(*Line_Container\Line())
    
    PopListPosition(*Line_Container\Line())
    
    ProcedureReturn *Result
  EndProcedure
  
  Procedure Label_Get(*Line_Container.Line_Container, *Start_Line.Line, Label.s)
    Protected *Result.Line
    Protected Label_Type
    Protected *Parent_Line.Line
    
    ; #### Determine the type of the label
    If Left(Label, 2) = ".."
      Label_Type = #Label_Type_Global_No_Childs
    ElseIf Left(Label, 1) = "."
      Label_Type = #Label_Type_Local
    ElseIf Left(Label, 1) = "@"
      Label_Type = #Label_Type_Anonymous
    ElseIf Label
      Label_Type = #Label_Type_Global
    Else
      Label_Type = #Label_Type_None
    EndIf
    
    Select Label_Type
      Case #Label_Type_Global, #Label_Type_Global_No_Childs
        PushListPosition(*Line_Container\Line())
        ForEach *Line_Container\Line()
          If *Line_Container\Line()\Label = Label
            *Result = *Line_Container\Line()
            Break
          ElseIf *Line_Container\Line()\Label_Parent_Line And *Line_Container\Line()\Label_Parent_Line\Label + *Line_Container\Line()\Label = Label
            *Result = *Line_Container\Line()
            Break
          EndIf
        Next
        PopListPosition(*Line_Container\Line())
      
      Case #Label_Type_Local
        PushListPosition(*Line_Container\Line())
        *Parent_Line = Label_Get_Prev_Global(*Line_Container, *Start_Line)
        ForEach *Line_Container\Line()
          If *Line_Container\Line()\Label_Parent_Line = *Parent_Line And *Line_Container\Line()\Label = Label
            *Result = *Line_Container\Line()
            Break
          EndIf
        Next
        PopListPosition(*Line_Container\Line())
        
    EndSelect ; TODO: Complete code for all label types
    
    ProcedureReturn *Result
  EndProcedure
  
  Procedure Operand_Parse(*Line_Container.Line_Container, *Line.Line, *Operand.Operand)
    Protected String.s = *Operand\Raw
    Protected Temp_String.s, String_Field.s
    Protected i
    Protected *Label_Line.Line
    
    ; #### Check if there is a size operator
    If ExamineRegularExpression(RegEx_Operand_Size_Operator, String) And NextRegularExpressionMatch(RegEx_Operand_Size_Operator)
      *Operand\Address\Size_Operator = RegularExpressionNamedGroup(RegEx_Operand_Size_Operator, "Size_Operator")
      String = RegularExpressionNamedGroup(RegEx_Operand_Size_Operator, "Rest")
    Else
      *Operand\Address\Size_Operator = #Null$
    EndIf
    
    ; #### Check if operand is a number
    If ExamineRegularExpression(RegEx_Operand_Value, String) And NextRegularExpressionMatch(RegEx_Operand_Value)
      *Operand\Address\Type = #Address_Type_Immediate_Value
      *Operand\Address\Value = RegularExpressionNamedGroup(RegEx_Operand_Value, "Value")
      ProcedureReturn #True
    EndIf
    
    ; #### Check if operand is memory address
    If ExamineRegularExpression(RegEx_Operand_Memory, String) And NextRegularExpressionMatch(RegEx_Operand_Memory)
      *Operand\Address\Type = #Address_Type_Memory
      Temp_String = RegularExpressionNamedGroup(RegEx_Operand_Memory, "Address")
      For i = 1 To CountString(Temp_String, "+")+1
        String_Field = Trim(StringField(Temp_String, i, "+"))
        
        ; #### Check if field is a register (with multiplicator "EAX * 4")
        If FindMapElement(Register(), UCase(Trim(StringField(String_Field,1,"*"))))
          AddElement(*Operand\Address\Sub_Address())
          *Operand\Address\Sub_Address()\Type = #Address_Type_Register
          *Operand\Address\Sub_Address()\Register = Register()
          If Trim(StringField(String_Field,2,"*"))
            *Operand\Address\Sub_Address()\Multiplicator = Val(StringField(String_Field,2,"*"))
          Else
            *Operand\Address\Sub_Address()\Multiplicator = 1
          EndIf
          Continue
        EndIf
        
        ; #### Check if field is a register (with multiplicator "4 * EAX") ; TODO: Simplify the parsing of registers
        If FindMapElement(Register(), UCase(Trim(StringField(String_Field,2,"*"))))
          AddElement(*Operand\Address\Sub_Address())
          *Operand\Address\Sub_Address()\Type = #Address_Type_Register
          *Operand\Address\Sub_Address()\Register = Register()
          If Trim(StringField(String_Field,1,"*"))
            *Operand\Address\Sub_Address()\Multiplicator = Val(StringField(String_Field,1,"*"))
          Else
            *Operand\Address\Sub_Address()\Multiplicator = 1
          EndIf
          Continue
        EndIf
        
        ; #### Check if field is a label
        *Label_Line = Label_Get(*Line_Container, *Line, String_Field)
        If *Label_Line
          AddElement(*Operand\Address\Sub_Address())
          *Operand\Address\Sub_Address()\Type = #Address_Type_Immediate_Label
          *Operand\Address\Sub_Address()\Label_Line = *Label_Line
          Continue
        EndIf
        
        ; #### Check if field is a number
        If ExamineRegularExpression(RegEx_Operand_Value, String_Field) And NextRegularExpressionMatch(RegEx_Operand_Value)
          AddElement(*Operand\Address\Sub_Address())
          *Operand\Address\Sub_Address()\Type = #Address_Type_Immediate_Value
          *Operand\Address\Sub_Address()\Value = RegularExpressionNamedGroup(RegEx_Operand_Value, "Value")
          Continue
        EndIf
        
        ; #### Set it to #Address_Type_Immediate_Label, without line reference
        AddElement(*Operand\Address\Sub_Address())
        *Operand\Address\Sub_Address()\Type = #Address_Type_Immediate_Label
        *Operand\Address\Sub_Address()\Label_Raw = String_Field
      Next
      ProcedureReturn #True
    EndIf
    
    ; #### Check if operand is a register
    If FindMapElement(Register(), UCase(String))
      *Operand\Address\Type = #Address_Type_Register
      *Operand\Address\Register = Register()
      *Operand\Address\Multiplicator = 1
      ;*Operand\Raw = #Null$
      ProcedureReturn #True
    EndIf
    
    ; #### Check if operand is a label
    *Label_Line = Label_Get(*Line_Container, *Line, String)
    If *Label_Line
      *Operand\Address\Type = #Address_Type_Immediate_Label
      *Operand\Address\Label_Line = *Label_Line
      ProcedureReturn #True
    EndIf
    
    ; #### Set it to #Address_Type_Immediate_Label, without line reference
    *Operand\Address\Type = #Address_Type_Immediate_Label
    *Operand\Address\Label_Line = #Null
    *Operand\Address\Label_Raw = String
    ProcedureReturn #True
  EndProcedure
  
  Procedure.s Operand_Compose(*Line_Container.Line_Container, *Line.Line, *Address.Address)
    Protected String.s
    Protected *Parent_Line.Line
    
    Select *Address\Type
      Case #Address_Type_Immediate_Value
        If *Address\Size_Operator
          String = *Address\Size_Operator + " "
        EndIf
        String + *Address\Value
        
      Case #Address_Type_Immediate_Label
        If *Address\Size_Operator
          String = *Address\Size_Operator + " "
        EndIf
        If *Address\Label_Line
          
          Select *Address\Label_Line\Label_Type
            Case #Label_Type_Anonymous, #Label_Type_Global, #Label_Type_Global_No_Childs
              String + *Address\Label_Line\Label
              
            Case #Label_Type_Local
              *Parent_Line = Label_Get_Prev_Global(*Line_Container, *Line)
              If *Parent_Line
                If *Parent_Line = *Address\Label_Line\Label_Parent_Line
                  String + *Address\Label_Line\Label
                ElseIf *Address\Label_Line\Label_Parent_Line
                  String + *Address\Label_Line\Label_Parent_Line\Label + *Address\Label_Line\Label
                Else
                  String + "<Label error>"
                EndIf
              EndIf
              
            Default
              String + "<No Label>"
              
          EndSelect
          
        Else
          String + *Address\Label_Raw
        EndIf
        
      Case #Address_Type_Register
        If *Address\Size_Operator
          String = *Address\Size_Operator + " "
        EndIf
        If *Address\Register
          If *Address\Multiplicator > 1
            String + *Address\Register\Name + "*" + Str(*Address\Multiplicator)
          Else
            String + *Address\Register\Name
          EndIf
        Else
          String + "<Unknown_Register>"
        EndIf
        
      Case #Address_Type_Memory
        If *Address\Size_Operator
          String = *Address\Size_Operator + " "
        EndIf
        String + "["
        ForEach *Address\Sub_Address()
          String + Operand_Compose(*Line_Container, *Line, *Address\Sub_Address())
          If ListIndex(*Address\Sub_Address()) < ListSize(*Address\Sub_Address())-1
            String + " + "
          EndIf
        Next
        String + "]"
        
      Default
        String = "<Unknown_Address_Type>"
        
    EndSelect
    
    ProcedureReturn String
  EndProcedure
  
  ; #### Check for dependencies (Opposit direction of program flow)
  Procedure Line_Calculate_Dependencies(*Line_Container.Line_Container, *Line.Line)
    Protected NewList Line_Iteration.Line_Iteration()
    Protected NewMap Line_Done()                        ; Map to check if line was done previously
    Protected NewList Read_Address.Address_Iteration()  ; List of addresses to be checked
    Protected *Current_Line.Line
    Protected Current_Flags.q
    Protected Temp_Result.q
    Protected Found
    
    If Not *Line\Type = #Line_Type_Instruction
      ProcedureReturn #False
    EndIf
    
    If Not *Line\OpCode
      ProcedureReturn #False
    EndIf
    
    ; #### Remove old dependencies
    ForEach *Line\Dependency()
      If *Line\Dependency()\Influencer
        ForEach *Line\Dependency()\Influencer\Influence()
          If *Line\Dependency()\Influencer\Influence() = *Line\Dependency()
            DeleteElement(*Line\Dependency()\Influencer\Influence())
            Break
          EndIf
        Next
      EndIf
      DeleteElement(*Line\Dependency())
    Next
    
    ; #### Add opcode based addresses to the address-queue
    ForEach *Line\OpCode\Read_Address()
      AddElement(Read_Address())
      Read_Address()\Address = *Line\OpCode\Read_Address()
    Next
    
    ; #### Add registers of operands with the address type #Address_Type_Memory
    ForEach *Line\Operand()
      If *Line\Operand()\Address\Type = #Address_Type_Memory
        ForEach *Line\Operand()\Address\Sub_Address()
          If *Line\Operand()\Address\Sub_Address()\Type = #Address_Type_Register
            AddElement(Read_Address())
            Read_Address()\Address = *Line\Operand()\Address\Sub_Address()
          EndIf
        Next
      EndIf
    Next
    
    ; #### Add operand based addresses to the address-queue (Instruction is reading from operand)
    ForEach *Line\OpCode\Read_Operand()
      If SelectElement(*Line\Operand(), *Line\OpCode\Read_Operand())
        AddElement(Read_Address())
        Read_Address()\Address = *Line\Operand()\Address
      EndIf
    Next
    
    ; #### Add operand based addresses to the address-queue (Instruction is writing to operand, this will be a virtual dependency)
    ForEach *Line\OpCode\Mod_Operand()
      If SelectElement(*Line\Operand(), *Line\OpCode\Mod_Operand())
        AddElement(Read_Address())
        Read_Address()\Address = *Line\Operand()\Address
        Read_Address()\Virtual = #True
      EndIf
    Next
    
    PushListPosition(*Line_Container\Line())
    
    ; #### Find the dependency of all addresses the instruction reads from
    ForEach Read_Address()
      
      ; #### Check for address types, which can't have any dependencies
      Select Read_Address()\Address\Type
        Case #Address_Type_Immediate_Value, #Address_Type_Immediate_Label
          Continue
          
      EndSelect
      
      ClearMap(Line_Done())
      
      ForEach *Line\Prev_Line()
        AddElement(Line_Iteration())
        Line_Iteration()\Line = *Line\Prev_Line()
        Line_Iteration()\Flags = #True
        If Read_Address()\Address\Type = #Address_Type_Flags
          Line_Iteration()\Flags = Read_Address()\Address\Flags
        EndIf
      Next
      ; #### Exclude the own line from the iteration
      ;Line_Done(Str(*Line)) = #True
      
      While FirstElement(Line_Iteration())
        *Current_Line = Line_Iteration()\Line
        Current_Flags = Line_Iteration()\Flags
        DeleteElement(Line_Iteration())
        
        ; #### Check if this line was processed already
        If Line_Done(Str(*Current_Line))
          Continue
        EndIf
        Line_Done() = #True
        
        If *Current_Line\Type = #Line_Type_Instruction
          
          If *Current_Line\OpCode
            
            ; #### If this line calls a subroutine, and the influencee is a memory-address, then the memory could have been modified by the subroutine
            ; #### This doesn't mean that it is a dependency, therefore this should neither stop searching nor change "Current_Flags"
            If Read_Address()\Address\Type = #Address_Type_Memory And *Current_Line\OpCode\Mnemonic = "CALL"
              AddElement(*Line\Dependency())
              *Line\Dependency()\Influencer = *Current_Line
              *Line\Dependency()\Influencer_Address = #Null
              *Line\Dependency()\Influencee = *Line
              *Line\Dependency()\Influencee_Address = Read_Address()\Address
              *Line\Dependency()\Virtual = Read_Address()\Virtual
              If Not Read_Address()\Virtual
                AddElement(*Current_Line\Influence())
                *Current_Line\Influence() = *Line\Dependency()
              EndIf
            EndIf
            
            ; #### Search for opcode specific modifications
            ForEach *Current_Line\OpCode\Mod_Address()
              Temp_Result = Address_Conjugate(Read_Address()\Address, *Current_Line\OpCode\Mod_Address())
              If Temp_Result & Current_Flags
                Current_Flags & ~Temp_Result
                
                ; #### Add dependency
                AddElement(*Line\Dependency())
                *Line\Dependency()\Influencer = *Current_Line
                *Line\Dependency()\Influencer_Address = *Current_Line\OpCode\Mod_Address()
                *Line\Dependency()\Influencee = *Line
                *Line\Dependency()\Influencee_Address = Read_Address()\Address
                *Line\Dependency()\Virtual = Read_Address()\Virtual
                If Not Read_Address()\Virtual
                  AddElement(*Current_Line\Influence())
                  *Current_Line\Influence() = *Line\Dependency()
                EndIf
                
              EndIf
              If Not Current_Flags
                Break
              EndIf
            Next
            If Not Current_Flags
              Continue
            EndIf
            
            ; #### Search for operand specific modifications
            ForEach *Current_Line\OpCode\Mod_Operand()
              If SelectElement(*Current_Line\Operand(), *Current_Line\OpCode\Mod_Operand())
                If *Current_Line\Operand()\Address
                  Temp_Result = Address_Conjugate(Read_Address()\Address, *Current_Line\Operand()\Address)
                  If Temp_Result & Current_Flags
                    Current_Flags & ~Temp_Result
                    
                    ; #### Add dependency
                    AddElement(*Line\Dependency())
                    *Line\Dependency()\Influencer = *Current_Line
                    *Line\Dependency()\Influencer_Address = *Current_Line\Operand()\Address
                    *Line\Dependency()\Influencee = *Line
                    *Line\Dependency()\Influencee_Address = Read_Address()\Address
                    *Line\Dependency()\Virtual = Read_Address()\Virtual
                    If Not Read_Address()\Virtual
                      AddElement(*Current_Line\Influence())
                      *Current_Line\Influence() = *Line\Dependency()
                    EndIf
                    
                  EndIf
                EndIf
              EndIf
              If Not Current_Flags
                Break
              EndIf
            Next
            If Not Current_Flags
              Continue
            EndIf
            
          Else
            ; #### Current line has an unknown opcode, expect anything to be changed. Add dependency
            ; #### But this doesn't mean that it is a dependency, therefore this shouldn't stop searching nor change "Current_Flags"
            AddElement(*Line\Dependency())
            *Line\Dependency()\Influencer = *Current_Line
            *Line\Dependency()\Influencer_Address = #Null
            *Line\Dependency()\Influencee = *Line
            *Line\Dependency()\Influencee_Address = Read_Address()\Address
            *Line\Dependency()\Virtual = Read_Address()\Virtual
            If Not Read_Address()\Virtual
              AddElement(*Current_Line\Influence())
              *Current_Line\Influence() = *Line\Dependency()
            EndIf
            
          EndIf
          
        EndIf
        
        ; #### Add previous line to the queue if needed
        If Current_Flags
          
          If Not ListSize(*Current_Line\Prev_Line())
            ; #### If no dependency was found yet and there is no more previous line, use this line. (Most likely a label)
            AddElement(*Line\Dependency())
            *Line\Dependency()\Influencer = *Current_Line
            *Line\Dependency()\Influencer_Address = #Null
            *Line\Dependency()\Influencee = *Line
            *Line\Dependency()\Influencee_Address = Read_Address()\Address
            *Line\Dependency()\Virtual = Read_Address()\Virtual
            If Not Read_Address()\Virtual
              AddElement(*Current_Line\Influence())
              *Current_Line\Influence() = *Line\Dependency()
            EndIf
          Else
            ; #### Add the previous lines to the queue
            ForEach *Current_Line\Prev_Line()
              AddElement(Line_Iteration())
              Line_Iteration()\Line = *Current_Line\Prev_Line()
              Line_Iteration()\Flags = Current_Flags
            Next
          EndIf
          
        EndIf
        
      Wend
      
    Next
    
    PopListPosition(*Line_Container\Line())
    
    ProcedureReturn #True
  EndProcedure
  
  ; #### Calculates possible next instructions
  Procedure Line_Calculate_Flow(*Line_Container.Line_Container, *Line.Line)
    PushListPosition(*Line_Container\Line())
    
    If ChangeCurrentElement(*Line_Container\Line(), *Line)
      
      ; #### Remove old Next_Instruction_Line() entries
      ForEach *Line\Next_Line()
        ForEach *Line\Next_Line()\Prev_Line()
          If *Line\Next_Line()\Prev_Line() = *Line
            DeleteElement(*Line\Next_Line()\Prev_Line())
            DeleteElement(*Line\Next_Line())
            Break
          EndIf
        Next
      Next
      
      ; #### Find next instruction, except for RET and JMP
      If *Line\OpCode = #Null Or (*Line\OpCode And *Line\OpCode\Mnemonic <> "RET" And *Line\OpCode\Mnemonic <> "JMP")
        If NextElement(*Line_Container\Line())
          AddElement(*Line\Next_Line())
          *Line\Next_Line() = *Line_Container\Line()
          AddElement(*Line\Next_Line()\Prev_Line())
          *Line\Next_Line()\Prev_Line() = *Line
        EndIf
      EndIf
      
      ; #### Jump address
      If *Line\OpCode
        Select *Line\OpCode\Mnemonic
          Case "JMP", "JO", "JNO", "JS", "JNS", "JE", "JZ", "JNE", "JNZ", "JB", "JNAE", "JC", "JNB", "JAE", "JNC", "JBE", "JNA", "JA", "JNBE", "JL", "JNGE", "JGE", "JNL", "JLE", "JNG", "JG", "JNLE", "JP", "JPE", "JNP", "JPO", "JCXZ", "JECXZ"
            If FirstElement(*Line\Operand()) And *Line\Operand()\Address\Type = #Address_Type_Immediate_Label And *Line\Operand()\Address\Label_Line
              AddElement(*Line\Next_Line())
              *Line\Next_Line() = *Line\Operand()\Address\Label_Line
              AddElement(*Line\Next_Line()\Prev_Line())
              *Line\Next_Line()\Prev_Line() = *Line
            EndIf
        EndSelect
      EndIf
      
    EndIf
    
    PopListPosition(*Line_Container\Line())
  EndProcedure
  
  ; #### Calculate the program flow (Forward direction). Set the executable flag for each instruction.
  Procedure Line_Calculate_Flow_Tree(*Line_Container.Line_Container, *Start_Line.Line)
    Protected NewList *Next_Line.Line()
    Protected *Line.Line
    
    PushListPosition(*Line_Container\Line())
    
    ; #### Use #Line_Flag_Temp to prevent infinite loops
    ForEach *Line_Container\Line()
      *Line_Container\Line()\Flag & ~#Line_Flag_Temp
    Next
    
    AddElement(*Next_Line())
    *Next_Line() = *Start_Line
    
    While FirstElement(*Next_Line())
      *Line = *Next_Line()
      DeleteElement(*Next_Line())
      
      ; #### If the line wasn't checked previously
      If Not *Line\Flag & #Line_Flag_Temp
        ; #### Mark line as done
        ; #### Mark this line as reachable by the IP
        *Line\Flag | #Line_Flag_Temp | #Line_Flag_Execute
        
        Line_Calculate_Flow(*Line_Container, *Line)
        
        ForEach *Line\Next_Line()
          AddElement(*Next_Line())
          *Next_Line() = *Line\Next_Line()
        Next
        
      EndIf
    Wend
    
    PopListPosition(*Line_Container\Line())
  EndProcedure
  
  ; #### Calculates the stack pointer for the *Line, depending on the previous lines
  ; #### Result: #True: There was a change of the stack pointer or the validity of the data
  Procedure Line_Calculate_Stack(*Line_Container.Line_Container, *Line.Line, Only_Invalidate=#False)
    Protected Stack_Pointer.i
    Protected Valid
    Protected Change
    
    ; #### Get the stack position of the previous lines, but only if they don't contradict each other!
    If FirstElement(*Line\Prev_Line())
      
      Stack_Pointer = *Line\Prev_Line()\Stack_Pointer
      If *Line\Prev_Line()\Flag & #Line_Flag_SP_Calculated
        If Not Only_Invalidate
          Valid = #True
        EndIf
      EndIf
      
      While NextElement(*Line\Prev_Line())
        If *Line\Prev_Line()\Flag & #Line_Flag_SP_Calculated
          If Not Only_Invalidate
            Valid = #True
          EndIf
        EndIf
        If Stack_Pointer <> *Line\Prev_Line()\Stack_Pointer
          Valid = #False
          Break
        EndIf
      Wend
      
    ElseIf Not Only_Invalidate
      
      Valid = #True
      
    EndIf
    
    If *Line\OpCode
      
      ; #### In case of a subroutine, stop calculating the stack TODO: Gather informations from subroutines, and use it 
      If *Line\OpCode\Mnemonic = "CALL"
        Valid = #False
      EndIf
      
      ; #### RET can change the stack, too
      If *Line\OpCode\Mnemonic = "RET"
        If SelectElement(*Line\Operand(), 0)
          If *Line\Operand()\Address\Type = #Address_Type_Immediate_Value
            Stack_Pointer + Val(*Line\Operand()\Address\Value)
          Else
            Valid = #False
          EndIf
        EndIf
      EndIf
      
      ; #### Apply delta values to the stack pointer
      Select *Line_Container\Architecture
        Case #Architecture_x86
          Stack_Pointer + *Line\OpCode\Stack_Delta_x86
          
        Case #Architecture_x86_64
          Stack_Pointer + *Line\OpCode\Stack_Delta_x86_64
          
      EndSelect
      
      ; #### Special case when operands write to the SP register. Like ADD esp, 5
      ForEach *Line\OpCode\Mod_Operand()
        If SelectElement(*Line\Operand(), *Line\OpCode\Mod_Operand())
          If *Line\Operand()\Address\Type = #Address_Type_Register And *Line\Operand()\Address\Register\Group = #Register_Group_SP
            Select *Line\OpCode\Mnemonic
              Case "SUB"
                If SelectElement(*Line\Operand(), 1) And *Line\Operand()\Address\Type = #Address_Type_Immediate_Value
                  Stack_Pointer - Val(*Line\Operand()\Address\Value)
                Else
                  Valid = #False
                EndIf
                
              Case "ADD"
                If SelectElement(*Line\Operand(), 1) And *Line\Operand()\Address\Type = #Address_Type_Immediate_Value
                  Stack_Pointer + Val(*Line\Operand()\Address\Value)
                Else
                  Valid = #False
                EndIf
                
              Default
                Valid = #False
                
            EndSelect
          EndIf
        EndIf
      Next
      
    EndIf
    
    If *Line\Flag & #Line_Flag_SP_Calculated <> Valid * #Line_Flag_SP_Calculated
      Change = #True
    ElseIf *Line\Stack_Pointer <> Stack_Pointer
      Change = #True
    EndIf
    
    If Valid
      *Line\Flag | #Line_Flag_SP_Calculated
    Else
      *Line\Flag & ~#Line_Flag_SP_Calculated
    EndIf
    
    *Line\Stack_Pointer = Stack_Pointer
    
    ProcedureReturn Change
  EndProcedure
  
  Procedure Line_Calculate_Stack_Tree(*Line_Container.Line_Container, *Start_Line.Line)
    Protected NewList Line_Iteration.Line_Iteration()
    Protected *Current_Line.Line, Current_Flags
    
    PushListPosition(*Line_Container\Line())
    
    AddElement(Line_Iteration())
    Line_Iteration()\Line = *Start_Line
      
    While FirstElement(Line_Iteration())
      *Current_Line = Line_Iteration()\Line
      Current_Flags = Line_Iteration()\Flags
      DeleteElement(Line_Iteration())
      
      If Not Line_Calculate_Stack(*Line_Container, *Current_Line, Current_Flags)
        Continue
      EndIf
      
      ForEach *Current_Line\Next_Line()
        LastElement(Line_Iteration())
        AddElement(Line_Iteration())
        Line_Iteration()\Line = *Current_Line\Next_Line()
        
        If Not *Current_Line\Flag & #Line_Flag_SP_Calculated
          Line_Iteration()\Flags = #True
        EndIf
      Next
      
    Wend
    
    PopListPosition(*Line_Container\Line())
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Line_Delete(*Line_Container.Line_Container, *Line.Line)
    NewList *Recalculate_Dependency.Line()
    NewList *Recalculate_Flow.Line()
    
    If ChangeCurrentElement(*Line_Container\Line(), *Line)
      
      ; #### Remove dependencies
      ForEach *Line\Dependency()
        If *Line\Dependency()\Influencer
          ForEach *Line\Dependency()\Influencer\Influence()
            If *Line\Dependency()\Influencer\Influence() = *Line\Dependency()
              AddElement(*Recalculate_Dependency())
              *Recalculate_Dependency() = *Line\Dependency()\Influencer
              DeleteElement(*Line\Dependency()\Influencer\Influence())
              Break
            EndIf
          Next
        EndIf
        DeleteElement(*Line\Dependency())
      Next
      
      ; #### Remove next line reference
      ForEach *Line\Next_Line()
        ForEach *Line\Next_Line()\Prev_Line()
          If *Line\Next_Line()\Prev_Line() = *Line
            AddElement(*Recalculate_Flow())
            *Recalculate_Flow() = *Line\Next_Line()
            DeleteElement(*Line\Next_Line()\Prev_Line())
            Break
          EndIf
        Next
        DeleteElement(*Line\Next_Line())
      Next
      
      ; #### Remove previous line reference
      ForEach *Line\Prev_Line()
        ForEach *Line\Prev_Line()\Next_Line()
          If *Line\Prev_Line()\Next_Line() = *Line
            AddElement(*Recalculate_Flow())
            *Recalculate_Flow() = *Line\Prev_Line()
            DeleteElement(*Line\Prev_Line()\Next_Line())
            Break
          EndIf
        Next
        DeleteElement(*Line\Prev_Line())
      Next
      
      ; #### Delete all label references
      PushListPosition(*Line_Container\Line())
      ForEach *Line_Container\Line()
        ForEach *Line_Container\Line()\Operand()
          If *Line_Container\Line()\Operand()\Address\Type = #Address_Type_Immediate_Label
            *Line_Container\Line()\Operand()\Address\Label_Line = #Null
            *Line_Container\Line()\Operand()\Address\Label_Raw = "<REFERENCE_REMOVED>"
          EndIf
        Next
      Next
      PopListPosition(*Line_Container\Line())
      
      DeleteElement(*Line_Container\Line())
      
      ; #### Recalculate flow
      ForEach *Recalculate_Flow()
        Line_Calculate_Flow(*Line_Container, *Recalculate_Flow())
      Next
      
      ; #### Recalculate dependencies
      ForEach *Recalculate_Dependency()
        Line_Calculate_Flow(*Line_Container, *Recalculate_Dependency())
      Next
      
    EndIf
  EndProcedure
  
  Procedure Line_Parse(*Line_Container.Line_Container, *Line.Line)
    Protected String.s = *Line\Raw
    
    ; #### Check if there is a label
    *Line\Label_Type = #Label_Type_None
    If ExamineRegularExpression(RegEx_Line_Label, String) And NextRegularExpressionMatch(RegEx_Line_Label)
      *Line\Label = RegularExpressionNamedGroup(RegEx_Line_Label, "Label")
      String = RegularExpressionNamedGroup(RegEx_Line_Label, "Rest")
      If Left(*Line\Label, 2) = ".."
        *Line\Label_Type = #Label_Type_Global_No_Childs
      ElseIf Left(*Line\Label, 1) = "."
        *Line\Label_Type = #Label_Type_Local
        PushListPosition(*Line_Container\Line())
        ChangeCurrentElement(*Line_Container\Line(), *Line)
        Repeat
          If *Line_Container\Line()\Label_Type = #Label_Type_Global
            *Line\Label_Parent_Line = *Line_Container\Line()
            Break
          EndIf
        Until Not PreviousElement(*Line_Container\Line())
        PopListPosition(*Line_Container\Line())
      ElseIf Left(*Line\Label, 2) = "@@"
        *Line\Label_Type = #Label_Type_Anonymous
      Else
        *Line\Label_Type = #Label_Type_Global
      EndIf
    Else
      *Line\Label = #Null$
    EndIf
    *Line\Raw_Minus_Label = String
    
    ; #### Check if the line should be treated as "Raw" data
    If MatchRegularExpression(RegEx_Line_Raw, String)
      *Line\Type = #Line_Type_Raw
      ProcedureReturn #True
    EndIf
    
    ; #### Check for instruction with three operands
    If ExamineRegularExpression(RegEx_Line_Instruction_3, String)
      If NextRegularExpressionMatch(RegEx_Line_Instruction_3)
        *Line\Type = #Line_Type_Instruction
        If FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_3, "OpCode"))+"@3") Or FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_3, "OpCode")))
          *Line\OpCode = OpCode()
          AddElement(*Line\Operand())
          *Line\Operand()\Raw = RegularExpressionNamedGroup(RegEx_Line_Instruction_3, "Param_0")
          AddElement(*Line\Operand())
          *Line\Operand()\Raw = RegularExpressionNamedGroup(RegEx_Line_Instruction_3, "Param_1")
          AddElement(*Line\Operand())
          *Line\Operand()\Raw = RegularExpressionNamedGroup(RegEx_Line_Instruction_3, "Param_2")
        Else
          *Line\Raw_Instruction = String
        EndIf
        ;*Line\Raw = #Null$
        ProcedureReturn #True
      EndIf
    EndIf
    
    ; #### Check for instruction with two operands
    If ExamineRegularExpression(RegEx_Line_Instruction_2, String)
      If NextRegularExpressionMatch(RegEx_Line_Instruction_2)
        *Line\Type = #Line_Type_Instruction
        If FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_2, "OpCode"))+"@2") Or FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_2, "OpCode")))
          *Line\OpCode = OpCode()
          AddElement(*Line\Operand())
          *Line\Operand()\Raw = RegularExpressionNamedGroup(RegEx_Line_Instruction_2, "Param_0")
          AddElement(*Line\Operand())
          *Line\Operand()\Raw = RegularExpressionNamedGroup(RegEx_Line_Instruction_2, "Param_1")
        Else
          *Line\Raw_Instruction = String
        EndIf
        ;*Line\Raw = #Null$
        ProcedureReturn #True
      EndIf
    EndIf
    
    ; #### Check for instruction with one operand
    If ExamineRegularExpression(RegEx_Line_Instruction_1, String)
      If NextRegularExpressionMatch(RegEx_Line_Instruction_1)
        *Line\Type = #Line_Type_Instruction
        If FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_1, "OpCode"))+"@1") Or FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_1, "OpCode")))
          *Line\OpCode = OpCode()
          AddElement(*Line\Operand())
          *Line\Operand()\Raw = RegularExpressionNamedGroup(RegEx_Line_Instruction_1, "Param_0")
        Else
          *Line\Raw_Instruction = String
        EndIf
        ;*Line\Raw = #Null$
        ProcedureReturn #True
      EndIf
    EndIf
    
    ; #### Check for instruction with no operands
    If ExamineRegularExpression(RegEx_Line_Instruction_0, String)
      If NextRegularExpressionMatch(RegEx_Line_Instruction_0)
        *Line\Type = #Line_Type_Instruction
        If FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_0, "OpCode"))+"@0") Or FindMapElement(OpCode(), UCase(RegularExpressionNamedGroup(RegEx_Line_Instruction_0, "OpCode")))
          *Line\OpCode = OpCode()
        Else
          *Line\Raw_Instruction = String
        EndIf
        ;*Line\Raw = #Null$
        ProcedureReturn #True
      EndIf
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure Line_Compose(*Line_Container.Line_Container, *Line.Line)
    Select *Line\Label_Type
      Case #Label_Type_None
        *Line\Raw = ""
        
      Case #Label_Type_Global, #Label_Type_Global_No_Childs, #Label_Type_Anonymous, #Label_Type_Local
        *Line\Raw = *Line\Label + ":"
        
      Default
        *Line\Raw = "<UNKOWN_LABEL>"
        
    EndSelect
    
    Select *Line\Type
      Case #Line_Type_Raw
        *Line\Raw + " " + *Line\Raw_Minus_Label
        
      Case #Line_Type_Instruction
        ForEach *Line\Operand()
          *Line\Operand()\Raw = Operand_Compose(*Line_Container, *Line, *Line\Operand()\Address)
        Next
        If *Line\OpCode
          *Line\Raw + " " + *Line\OpCode\Mnemonic
          ForEach *Line\Operand()
            If ListIndex(*Line\Operand()) = 0
              *Line\Raw + " "
            Else
              *Line\Raw + ","
            EndIf
            *Line\Raw + *Line\Operand()\Raw
          Next
        Else
          *Line\Raw + " " + *Line\Raw_Instruction
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure File_Parse(File.i)
    Protected *Assembler_File.File = AllocateStructure(File)
    If Not *Assembler_File
      ProcedureReturn #Null
    EndIf
    
    ; #### Read the file
    While Eof(File) = #False
      AddElement(*Assembler_File\Line_Container\Line())
      *Assembler_File\Line_Container\Line()\Raw = ReadString(File, #PB_Ascii)
      *Assembler_File\Line_Container\Line()\Stack_Pointer = #Stack_Pointer_Invalid
    Wend
    
    ; #### Define the architecture
    *Assembler_File\Line_Container\Architecture | #Architecture_x86
    
    ; #### Parse each line
    ForEach *Assembler_File\Line_Container\Line()
      Line_Parse(*Assembler_File\Line_Container, *Assembler_File\Line_Container\Line())
    Next
    
    ; #### Parse each operand of the lines
    ForEach *Assembler_File\Line_Container\Line()
      ForEach *Assembler_File\Line_Container\Line()\Operand()
        Operand_Parse(*Assembler_File\Line_Container, *Assembler_File\Line_Container\Line(), *Assembler_File\Line_Container\Line()\Operand())
      Next
    Next
    
    ; #### Find entry point
    ForEach *Assembler_File\Line_Container\Line()
      If *Assembler_File\Line_Container\Line()\Label = "PureBasicStart"
        *Assembler_File\Entry_Point = *Assembler_File\Line_Container\Line()
        Break
      EndIf
    Next
    
    If Not *Assembler_File\Entry_Point
      File_Free(*Assembler_File)
      ProcedureReturn #Null
    EndIf
    
    ; #### Reset the execution status flag of each line
    ForEach *Assembler_File\Line_Container\Line()
      *Assembler_File\Line_Container\Line()\Flag & ~#Line_Flag_Execute
    Next
    
    ; #### Calculate the program flow (Including the execute flag)
    Line_Calculate_Flow_Tree(*Assembler_File\Line_Container, *Assembler_File\Entry_Point)
    
    ; #### DEBUG: also calculate the flow starting from labels containing "_Procedure"
    ForEach *Assembler_File\Line_Container\Line()
      If *Assembler_File\Line_Container\Line()\Label_Type = #Label_Type_Global And FindString(*Assembler_File\Line_Container\Line()\Label, "_Procedure")
        Line_Calculate_Flow_Tree(*Assembler_File\Line_Container, *Assembler_File\Line_Container\Line())
      EndIf
    Next
    
    ; #### Calculate the stack
    Line_Calculate_Stack_Tree(*Assembler_File\Line_Container, *Assembler_File\Entry_Point)
    ForEach *Assembler_File\Line_Container\Line()
      If *Assembler_File\Line_Container\Line()\Label_Type = #Label_Type_Global And FindString(*Assembler_File\Line_Container\Line()\Label, "_Procedure")
        Line_Calculate_Stack_Tree(*Assembler_File\Line_Container, *Assembler_File\Line_Container\Line())
      EndIf
    Next
    
    
    ; #### Calculate dependencies
    ForEach *Assembler_File\Line_Container\Line()
      Line_Calculate_Dependencies(*Assembler_File\Line_Container, *Assembler_File\Line_Container\Line())
    Next
    
    ProcedureReturn *Assembler_File
  EndProcedure
  
  Procedure File_Compose(*Assembler_File.File, File.i)
    Protected String.s
    
    If Not *Assembler_File
      ProcedureReturn #Null
    EndIf
    
    ForEach *Assembler_File\Line_Container\Line()
      Line_Compose(*Assembler_File\Line_Container, *Assembler_File\Line_Container\Line())
      
      String = *Assembler_File\Line_Container\Line()\Raw
      
      ; ##### Debug strings
      ForEach *Assembler_File\Line_Container\Line()\Dependency()
        String + " ;Dep: " + *Assembler_File\Line_Container\Line()\Dependency()\Influencer\Raw
      Next
      
      ;ForEach *Assembler_File\Line_Container\Line()\Next_Line()
      ;  String + " ;Next: " + *Assembler_File\Line_Container\Line()\Next_Line()\Raw
      ;Next
      
      If *Assembler_File\Line_Container\Line()\Flag & #Line_Flag_Execute
        String + " ;EXEC."
      EndIf
      
      WriteStringN(File, String, #PB_Ascii)
    Next
    
    ProcedureReturn *Assembler_File
  EndProcedure
  
  Procedure File_Free(*Assembler_File.File)
    If Not *Assembler_File
      ProcedureReturn #False
    EndIf
    
    FreeStructure(*Assembler_File)
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Register_Add(Name.s, Group.i)
    Register(Name)\Name = Name
    Register()\Group = Group
  EndProcedure
  
  Procedure OpCode_Mod_Register_Add(*OpCode.OpCode, *Register.Register)
    AddElement(*OpCode\Mod_Address())
    *OpCode\Mod_Address()\Type = #Address_Type_Register
    *OpCode\Mod_Address()\Register = *Register
  EndProcedure
  
  Procedure OpCode_Read_Register_Add(*OpCode.OpCode, *Register.Register)
    AddElement(*OpCode\Read_Address())
    *OpCode\Read_Address()\Type = #Address_Type_Register
    *OpCode\Read_Address()\Register = *Register
  EndProcedure
  
  Procedure OpCode_Add(Name.s, Stack_Delta_x86.i, Stack_Delta_x86_64, Test_Flags.q, Mod_Flags.q, Read_Operands.i, Mod_Operands.i)
    Protected i
    
    OpCode(Name)\Mnemonic = StringField(Name, 1, "@")
    If StringField(Name, 2, "@")
      OpCode()\Operands = Val(StringField(Name, 2, "@"))
    Else
      OpCode()\Operands = -1
    EndIf
    
    ; #### Set flags which are tested by this opcode
    If Test_Flags
      AddElement(OpCode()\Read_Address())
      OpCode()\Read_Address()\Type = #Address_Type_Flags
      OpCode()\Read_Address()\Flags = Test_Flags
    EndIf
    
    ; #### Set flags which are modified by this opcode
    If Mod_Flags
      AddElement(OpCode()\Mod_Address())
      OpCode()\Mod_Address()\Type = #Address_Type_Flags
      OpCode()\Mod_Address()\Flags = Mod_Flags
    EndIf
    
    ; #### Set operands which read data
    For i = 0 To 7
      If Read_Operands & 1 << i
        AddElement(OpCode()\Read_Operand())
        OpCode()\Read_Operand() = i
      EndIf
    Next
    
    ; #### Set operands which modify data
    For i = 0 To 7
      If Mod_Operands & 1 << i
        AddElement(OpCode()\Mod_Operand())
        OpCode()\Mod_Operand() = i
      EndIf
    Next
    
    ; #### Stack delta
    OpCode()\Stack_Delta_x86 = Stack_Delta_x86
    OpCode()\Stack_Delta_x86_64 = Stack_Delta_x86_64
    If OpCode()\Stack_Delta_x86
      OpCode_Mod_Register_Add(OpCode(), Register("ESP"))
      OpCode_Read_Register_Add(OpCode(), Register("ESP"))
    EndIf
    If OpCode()\Stack_Delta_x86_64
      OpCode_Mod_Register_Add(OpCode(), Register("RSP"))
      OpCode_Read_Register_Add(OpCode(), Register("RSP"))
    EndIf
    
  EndProcedure
  
  ; ################################################### Init ########################################################
  ; #### Registers
  Register_Add("AL",     #Register_Group_A)
  Register_Add("AH",     #Register_Group_A)
  Register_Add("AX",     #Register_Group_A)
  Register_Add("EAX",    #Register_Group_A)
  Register_Add("RAX",    #Register_Group_A)
  
  Register_Add("BL",     #Register_Group_B)
  Register_Add("BH",     #Register_Group_B)
  Register_Add("BX",     #Register_Group_B)
  Register_Add("EBX",    #Register_Group_B)
  Register_Add("RBX",    #Register_Group_B)
  
  Register_Add("CL",     #Register_Group_C)
  Register_Add("CH",     #Register_Group_C)
  Register_Add("CX",     #Register_Group_C)
  Register_Add("ECX",    #Register_Group_C)
  Register_Add("RCX",    #Register_Group_C)
  
  Register_Add("DL",     #Register_Group_D)
  Register_Add("DH",     #Register_Group_D)
  Register_Add("DX",     #Register_Group_D)
  Register_Add("EDX",    #Register_Group_D)
  Register_Add("RDX",    #Register_Group_D)
  
  Register_Add("BPL",    #Register_Group_BP)
  Register_Add("BP",     #Register_Group_BP)
  Register_Add("EBP",    #Register_Group_BP)
  Register_Add("RBP",    #Register_Group_BP)
  
  Register_Add("SIL",    #Register_Group_SI)
  Register_Add("SI",     #Register_Group_SI)
  Register_Add("ESI",    #Register_Group_SI)
  Register_Add("RSI",    #Register_Group_SI)
  
  Register_Add("DIL",    #Register_Group_DI)
  Register_Add("DI",     #Register_Group_DI)
  Register_Add("EDI",    #Register_Group_DI)
  Register_Add("RDI",    #Register_Group_DI)
  
  Register_Add("SPL",    #Register_Group_SP)
  Register_Add("SP",     #Register_Group_SP)
  Register_Add("ESP",    #Register_Group_SP)
  Register_Add("RSP",    #Register_Group_SP)
  
  Register_Add("IP",     #Register_Group_IP)
  Register_Add("EIP",    #Register_Group_IP)
  Register_Add("RIP",    #Register_Group_IP)
  
  Register_Add("FLAGS",  #Register_Group_FLAGS)
  Register_Add("EFLAGS", #Register_Group_FLAGS)
  Register_Add("RFLAGS", #Register_Group_FLAGS)
  
  Register_Add("R8B",    #Register_Group_R8)
  Register_Add("R8W",    #Register_Group_R8)
  Register_Add("R8D",    #Register_Group_R8)
  Register_Add("R8",     #Register_Group_R8)
  Register_Add("R9B",    #Register_Group_R9)
  Register_Add("R9W",    #Register_Group_R9)
  Register_Add("R9D",    #Register_Group_R9)
  Register_Add("R9",     #Register_Group_R9)
  Register_Add("R10B",   #Register_Group_R10)
  Register_Add("R10W",   #Register_Group_R10)
  Register_Add("R10D",   #Register_Group_R10)
  Register_Add("R10",    #Register_Group_R10)
  Register_Add("R11B",   #Register_Group_R11)
  Register_Add("R11W",   #Register_Group_R11)
  Register_Add("R11D",   #Register_Group_R11)
  Register_Add("R11",    #Register_Group_R11)
  Register_Add("R12B",   #Register_Group_R12)
  Register_Add("R12W",   #Register_Group_R12)
  Register_Add("R12D",   #Register_Group_R12)
  Register_Add("R12",    #Register_Group_R12)
  Register_Add("R13B",   #Register_Group_R13)
  Register_Add("R13W",   #Register_Group_R13)
  Register_Add("R13D",   #Register_Group_R13)
  Register_Add("R13",    #Register_Group_R13)
  Register_Add("R14B",   #Register_Group_R14)
  Register_Add("R14W",   #Register_Group_R14)
  Register_Add("R14D",   #Register_Group_R14)
  Register_Add("R14",    #Register_Group_R14)
  Register_Add("R15B",   #Register_Group_R15)
  Register_Add("R15W",   #Register_Group_R15)
  Register_Add("R15D",   #Register_Group_R15)
  Register_Add("R15",    #Register_Group_R15)
  
  Register_Add("ST0",    #Register_Group_ST0)
  Register_Add("ST1",    #Register_Group_ST1)
  Register_Add("ST2",    #Register_Group_ST2)
  Register_Add("ST3",    #Register_Group_ST3)
  Register_Add("ST4",    #Register_Group_ST4)
  Register_Add("ST5",    #Register_Group_ST5)
  Register_Add("ST6",    #Register_Group_ST6)
  Register_Add("ST7",    #Register_Group_ST7)
  Register_Add("MM0",    #Register_Group_ST0)
  Register_Add("MM1",    #Register_Group_ST1)
  Register_Add("MM2",    #Register_Group_ST2)
  Register_Add("MM3",    #Register_Group_ST3)
  Register_Add("MM4",    #Register_Group_ST4)
  Register_Add("MM5",    #Register_Group_ST5)
  Register_Add("MM6",    #Register_Group_ST6)
  Register_Add("MM7",    #Register_Group_ST7)
  
  Register_Add("XMM0",   #Register_Group_XMM0)
  Register_Add("XMM1",   #Register_Group_XMM1)
  Register_Add("XMM2",   #Register_Group_XMM2)
  Register_Add("XMM3",   #Register_Group_XMM3)
  Register_Add("XMM4",   #Register_Group_XMM4)
  Register_Add("XMM5",   #Register_Group_XMM5)
  Register_Add("XMM6",   #Register_Group_XMM6)
  Register_Add("XMM7",   #Register_Group_XMM7)
  Register_Add("XMM8",   #Register_Group_XMM8)
  Register_Add("XMM9",   #Register_Group_XMM9)
  Register_Add("XMM10",  #Register_Group_XMM10)
  Register_Add("XMM11",  #Register_Group_XMM11)
  Register_Add("XMM12",  #Register_Group_XMM12)
  Register_Add("XMM13",  #Register_Group_XMM13)
  Register_Add("XMM14",  #Register_Group_XMM14)
  Register_Add("XMM15",  #Register_Group_XMM15)
  Register_Add("YMM0",   #Register_Group_XMM0)
  Register_Add("YMM1",   #Register_Group_XMM1)
  Register_Add("YMM2",   #Register_Group_XMM2)
  Register_Add("YMM3",   #Register_Group_XMM3)
  Register_Add("YMM4",   #Register_Group_XMM4)
  Register_Add("YMM5",   #Register_Group_XMM5)
  Register_Add("YMM6",   #Register_Group_XMM6)
  Register_Add("YMM7",   #Register_Group_XMM7)
  Register_Add("YMM8",   #Register_Group_XMM8)
  Register_Add("YMM9",   #Register_Group_XMM9)
  Register_Add("YMM10",  #Register_Group_XMM10)
  Register_Add("YMM11",  #Register_Group_XMM11)
  Register_Add("YMM12",  #Register_Group_XMM12)
  Register_Add("YMM13",  #Register_Group_XMM13)
  Register_Add("YMM14",  #Register_Group_XMM14)
  Register_Add("YMM15",  #Register_Group_XMM15)
  Register_Add("ZMM0",   #Register_Group_XMM0)
  Register_Add("ZMM1",   #Register_Group_XMM1)
  Register_Add("ZMM2",   #Register_Group_XMM2)
  Register_Add("ZMM3",   #Register_Group_XMM3)
  Register_Add("ZMM4",   #Register_Group_XMM4)
  Register_Add("ZMM5",   #Register_Group_XMM5)
  Register_Add("ZMM6",   #Register_Group_XMM6)
  Register_Add("ZMM7",   #Register_Group_XMM7)
  Register_Add("ZMM8",   #Register_Group_XMM8)
  Register_Add("ZMM9",   #Register_Group_XMM9)
  Register_Add("ZMM10",  #Register_Group_XMM10)
  Register_Add("ZMM11",  #Register_Group_XMM11)
  Register_Add("ZMM12",  #Register_Group_XMM12)
  Register_Add("ZMM13",  #Register_Group_XMM13)
  Register_Add("ZMM14",  #Register_Group_XMM14)
  Register_Add("ZMM15",  #Register_Group_XMM15)
  Register_Add("ZMM16",  #Register_Group_XMM16)
  Register_Add("ZMM17",  #Register_Group_XMM17)
  Register_Add("ZMM18",  #Register_Group_XMM18)
  Register_Add("ZMM19",  #Register_Group_XMM19)
  Register_Add("ZMM20",  #Register_Group_XMM20)
  Register_Add("ZMM21",  #Register_Group_XMM21)
  Register_Add("ZMM22",  #Register_Group_XMM22)
  Register_Add("ZMM23",  #Register_Group_XMM23)
  Register_Add("ZMM24",  #Register_Group_XMM24)
  Register_Add("ZMM25",  #Register_Group_XMM25)
  Register_Add("ZMM26",  #Register_Group_XMM26)
  Register_Add("ZMM27",  #Register_Group_XMM27)
  Register_Add("ZMM28",  #Register_Group_XMM28)
  Register_Add("ZMM29",  #Register_Group_XMM29)
  Register_Add("ZMM30",  #Register_Group_XMM30)
  Register_Add("ZMM31",  #Register_Group_XMM31)
  
  ; #### OpCodes       Stack    Test_Flags     Mod_Flags      Read Oper. Mod. Oper.
  ;                    x86 _64  %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("CALL",     0,  0, %000000000000, %000000000000, %00000001, %00000000) : OpCode_Mod_Register_Add(OpCode(), Register("ESP")) : OpCode_Mod_Register_Add(OpCode(), Register("EAX")) : OpCode_Mod_Register_Add(OpCode(), Register("ECX")) : OpCode_Mod_Register_Add(OpCode(), Register("EDX"))
  OpCode_Add("MOV",      0,  0, %000000000000, %000000000000, %00000010, %00000001)
  OpCode_Add("LEA",      0,  0, %000000000000, %000000000000, %00000010, %00000001)
  ;                             %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("ADD",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("ADC",      0,  0, %000000000001, %100011010101, %00000011, %00000001)
  OpCode_Add("SUB",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("SBB",      0,  0, %000000000001, %100011010101, %00000011, %00000001)
  OpCode_Add("IMUL@1",   0,  0, %000000000000, %100011010101, %00000001, %00000000) : OpCode_Mod_Register_Add(OpCode(), Register("EAX")) : OpCode_Mod_Register_Add(OpCode(), Register("EDX")) : OpCode_Read_Register_Add(OpCode(), Register("EAX"))
  OpCode_Add("IMUL@2",   0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("IMUL@3",   0,  0, %000000000000, %100011010101, %00000110, %00000001)
  OpCode_Add("DEC",      0,  0, %000000000000, %100011010100, %00000001, %00000001)
  OpCode_Add("INC",      0,  0, %000000000000, %100011010100, %00000001, %00000001)
  ;                             %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("SHL",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("SHR",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("SAL",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("SAR",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("ROL",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("ROR",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("RCL",      0,  0, %000000000001, %100011010101, %00000011, %00000001)
  OpCode_Add("RCR",      0,  0, %000000000001, %100011010101, %00000011, %00000001)
  ;                             %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("AND",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("OR",       0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("XOR",      0,  0, %000000000000, %100011010101, %00000011, %00000001)
  OpCode_Add("NOT",      0,  0, %000000000000, %000000000000, %00000001, %00000001)
  OpCode_Add("NEG",      0,  0, %000000000000, %100011010101, %00000001, %00000001)
  ;                             %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("CWD",      0,  0, %000000000000, %000000000000, %00000000, %00000000) : OpCode_Mod_Register_Add(OpCode(), Register("DX"))  : OpCode_Read_Register_Add(OpCode(), Register("AX"))
  OpCode_Add("CDQ",      0,  0, %000000000000, %000000000000, %00000000, %00000000) : OpCode_Mod_Register_Add(OpCode(), Register("EDX")) : OpCode_Read_Register_Add(OpCode(), Register("EAX"))
  OpCode_Add("CQO",      0,  0, %000000000000, %000000000000, %00000000, %00000000) : OpCode_Mod_Register_Add(OpCode(), Register("RDX")) : OpCode_Read_Register_Add(OpCode(), Register("RAX"))
  ;                             %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("PUSH",    -4, -8, %000000000000, %000000000000, %00000001, %00000000)
  OpCode_Add("POP",      4,  8, %000000000000, %000000000000, %00000000, %00000001)
  OpCode_Add("CMP",      0,  0, %000000000000, %100011010101, %00000011, %00000000)
  ;                             %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("JB",       0,  0, %000000000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JNAE",     0,  0, %000000000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JC",       0,  0, %000000000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JBE",      0,  0, %000001000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JNA",      0,  0, %000001000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JCXZ",     0,  0, %000000000000, %000000000000, %00000001, %00000000) : OpCode_Read_Register_Add(OpCode(), Register("ECX"))
  OpCode_Add("JECXZ",    0,  0, %000000000000, %000000000000, %00000001, %00000000) : OpCode_Read_Register_Add(OpCode(), Register("ECX"))
  OpCode_Add("JL",       0,  0, %100010000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNGE",     0,  0, %100010000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JLE",      0,  0, %100011000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNG",      0,  0, %100011000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JMP",      0,  0, %000000000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNB",      0,  0, %000000000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JAE",      0,  0, %000000000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JNC",      0,  0, %000000000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JNBE",     0,  0, %000001000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JA",       0,  0, %000001000001, %000000000000, %00000001, %00000000)
  OpCode_Add("JNL",      0,  0, %100010000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JGE",      0,  0, %100010000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNLE",     0,  0, %100011000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JG",       0,  0, %100011000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNO",      0,  0, %100000000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNP",      0,  0, %000000000100, %000000000000, %00000001, %00000000)
  OpCode_Add("JPO",      0,  0, %000000000100, %000000000000, %00000001, %00000000)
  OpCode_Add("JNS",      0,  0, %000010000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNZ",      0,  0, %000001000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JNE",      0,  0, %000001000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JO",       0,  0, %000001000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JP",       0,  0, %000000000100, %000000000000, %00000001, %00000000)
  OpCode_Add("JPE",      0,  0, %000000000100, %000000000000, %00000001, %00000000)
  OpCode_Add("JS",       0,  0, %000010000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JZ",       0,  0, %000001000000, %000000000000, %00000001, %00000000)
  OpCode_Add("JE",       0,  0, %000001000000, %000000000000, %00000001, %00000000)
  ;                             %ODITSZ A P C  %ODITSZ A P C  %87654321  %87654321
  OpCode_Add("NOP",      0,  0, %000000000000, %000000000000, %00000000, %00000000)
  OpCode_Add("RET",      0,  0, %000000000000, %000000000000, %00000001, %00000000)
  
  ; ################################################### Data Sections ###############################################
  
EndModule
; IDE Options = PureBasic 5.41 LTS Beta 1 (Windows - x64)
; CursorPosition = 1152
; FirstLine = 1141
; Folding = ----
; EnableUnicode
; EnableXP
; DisableDebugger