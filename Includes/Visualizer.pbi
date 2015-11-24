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

DeclareModule Visualizer
  EnableExplicit
  
  ; ################################################### Prototypes ##################################################
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  
  ; ################################################### Variables ###################################################
  
  ; ################################################### Macros ######################################################
  
  ; ################################################### Declares ####################################################
  Declare   Main(*Assembler_File.Assembler::File)
  
EndDeclareModule

Module Visualizer
  EnableExplicit
  
  ; ################################################### Constants ###################################################
  #Text_Height = 20
  #Text_Line_Spacing = 20
  
  ; ################################################### Structures ##################################################
  Structure Main
    
    Quit.i
  EndStructure
  
  Structure Canvas
    Offset_X.d
    Offset_Y.d
    Zoom.d
    
    Redraw.i
  EndStructure
  
  Structure Window
    ID.i
    
    Canvas.i
  EndStructure
  
  Structure Line_Reference_Element
    *Parent.Line_Reference
    
    X.d
    Width.d
    
    Color.l
    
    List *Dependency.Line_Reference_Element()
    List Dependency_Virtual.i()
    
    *Address.Assembler::Address
    
    Text.s
  EndStructure
  
  Structure Line_Reference_Flow
    *Line_From.Line_Reference
    *Line_To.Line_Reference
    
    X.i
    Done.i
    
    List *Inside.Line_Reference_Flow()
    
    Start_Line.i
    End_Line.i
    
    Lines.i
  EndStructure
  
  Structure Line_Reference
    Line_Number.i
    
    *Line.Assembler::Line
    
    Highlighted.i
    
    List Element.Line_Reference_Element()
  EndStructure
  
  ; ################################################### Variables ###################################################
  Global Main.Main
  
  Global Canvas.Canvas
  
  Global NewList Line_Reference.Line_Reference()
  Global NewList Line_Reference_Flow.Line_Reference_Flow()
  
  Global Window.Window
  
  ; ################################################### Init ########################################################
  Canvas\Zoom = 1
  
  Global Font_Canvas = LoadFont(#PB_Any, "Courier New", 10)
  
  ; ################################################### Declares ####################################################
  Declare   Window_Close()
  
  ; ################################################### Procedures ##################################################
  Procedure AddPathLineArrow(X.d, Y.d, Size.d)
    Protected X_0.d, Y_0.d
    
    X_0 = PathCursorX()
    Y_0 = PathCursorY()
    
    Protected Angle.d = ATan2(X-X_0, Y-Y_0)
    
    AddPathLine(X, Y)
    
    SaveVectorState()
    
    RotateCoordinates(X, Y, Degree(Angle))
    
    MovePathCursor(X-Size, Y+Size*0.2)
    AddPathLine(Size, -Size*0.2, #PB_Path_Relative)
    AddPathLine(-Size,-Size*0.2, #PB_Path_Relative)
    MovePathCursor(X, Y)
    
    RestoreVectorState()
    
  EndProcedure
  
  Procedure Canvas_Redraw()
    Protected Width, Height
    Protected X.d
    Protected X_M.d, Y_M.d
    Protected X_M_0.d, Y_M_0.d
    Protected X_M_1.d, Y_M_1.d
    Protected Text.s
    
    If StartVectorDrawing(CanvasVectorOutput(Window\Canvas))
      
      Width = VectorOutputWidth()
      Height = VectorOutputHeight()
      
      VectorSourceColor(RGBA(0,0,0,255))
      FillVectorOutput()
      
      VectorFont(FontID(Font_Canvas), #Text_Height)
      
      ForEach Line_Reference()
        X = 0
        ForEach Line_Reference()\Element()
          Text = Line_Reference()\Element()\Text
          
          Line_Reference()\Element()\Width = VectorTextWidth(Text)
          Line_Reference()\Element()\X = X
          X + Line_Reference()\Element()\Width
        Next
      Next
      
      VectorFont(FontID(Font_Canvas), #Text_Height * Canvas\Zoom)
      
      ForEach Line_Reference()
        Y_M = Line_Reference()\Line_Number * (#Text_Height + #Text_Line_Spacing)  * Canvas\Zoom + Canvas\Offset_Y
        If Y_M >= - #Text_Height * Canvas\Zoom And Y_M < Height
          ForEach Line_Reference()\Element()
            X_M = Line_Reference()\Element()\X * Canvas\Zoom + Canvas\Offset_X
            Text = Line_Reference()\Element()\Text
            
            MovePathCursor(X_M, Y_M)
            
            VectorSourceColor(Line_Reference()\Element()\Color)
            DrawVectorText(Text)
            
            If Line_Reference()\Highlighted & %10
              VectorSourceColor(RGBA(255,255,255,50))
              AddPathBox(X_M, Y_M, Line_Reference()\Element()\Width * Canvas\Zoom, #Text_Height * Canvas\Zoom)
              StrokePath(2 * Canvas\Zoom)
            EndIf
            If Line_Reference()\Highlighted & %01
              VectorSourceColor(RGBA(255,255,255,50))
              AddPathBox(X_M, Y_M, Line_Reference()\Element()\Width * Canvas\Zoom, #Text_Height * Canvas\Zoom)
              FillPath()
            EndIf
          Next
        EndIf
      Next
      
      ForEach Line_Reference()
        If Line_Reference()\Highlighted
          Y_M_0 = Line_Reference()\Line_Number * (#Text_Height + #Text_Line_Spacing) * Canvas\Zoom + Canvas\Offset_Y + #Text_Height * Canvas\Zoom / 2
          ForEach Line_Reference()\Element()
            X_M_0 = (Line_Reference()\Element()\X + Line_Reference()\Element()\Width / 3) * Canvas\Zoom + Canvas\Offset_X
            ResetList(Line_Reference()\Element()\Dependency_Virtual())
            ForEach Line_Reference()\Element()\Dependency()
              NextElement(Line_Reference()\Element()\Dependency_Virtual())
              X_M_1 = (Line_Reference()\Element()\Dependency()\X + Line_Reference()\Element()\Dependency()\Width * 2 / 3) * Canvas\Zoom + Canvas\Offset_X
              If Line_Reference()\Element()\Dependency()\Parent
                Y_M_1 = Line_Reference()\Element()\Dependency()\Parent\Line_Number * (#Text_Height + #Text_Line_Spacing) * Canvas\Zoom + Canvas\Offset_Y + #Text_Height * Canvas\Zoom / 2
                
                MovePathCursor(X_M_1, Y_M_1)
                AddPathLineArrow(X_M_0, Y_M_0, 10 * Canvas\Zoom)
                
                If Line_Reference()\Element()\Dependency_Virtual()
                  VectorSourceColor(RGBA(255,255,0,100))
                  DotPath(1 * Canvas\Zoom, 2 * Canvas\Zoom)
                Else
                  VectorSourceColor(RGBA(255,255,0,100))
                  StrokePath(1 * Canvas\Zoom)
                EndIf
                
              EndIf
            Next
          Next
        EndIf
      Next
      
      
      ForEach Line_Reference_Flow()
        ;X_M_0 = -(5 + Line_Reference_Flow()\X) * 2 * Canvas\Zoom + Canvas\Offset_X
        X_M_0 = -5 * Canvas\Zoom + Canvas\Offset_X
        X_M_1 = -(2 + Line_Reference_Flow()\X) * 10 * Canvas\Zoom + Canvas\Offset_X
        Y_M_0 = Line_Reference_Flow()\Line_From\Line_Number * (#Text_Height + #Text_Line_Spacing) * Canvas\Zoom + Canvas\Offset_Y + #Text_Height * Canvas\Zoom / 2
        Y_M_1 = Line_Reference_Flow()\Line_To\Line_Number * (#Text_Height + #Text_Line_Spacing) * Canvas\Zoom + Canvas\Offset_Y + #Text_Height * Canvas\Zoom / 2
        
        If Y_M_0 < Y_M_1
          MovePathCursor(X_M_0, Y_M_0)
          AddPathLine(X_M_1, Y_M_0 + (X_M_0 - X_M_1)*0.2)
          AddPathLine(X_M_1, Y_M_1 - (X_M_0 - X_M_1)*0.2 - 3 * Canvas\Zoom)
          AddPathLineArrow(X_M_0, Y_M_1 - 3 * Canvas\Zoom, 6 * Canvas\Zoom)
          VectorSourceColor(RGBA(0,255,0,255))
          StrokePath(1 * Canvas\Zoom)
        Else
          MovePathCursor(X_M_0, Y_M_0)
          AddPathLine(X_M_1, Y_M_0 - (X_M_0 - X_M_1)*0.2)
          AddPathLine(X_M_1, Y_M_1 + (X_M_0 - X_M_1)*0.2 + 3 * Canvas\Zoom)
          AddPathLineArrow(X_M_0, Y_M_1 + 3 * Canvas\Zoom, 6 * Canvas\Zoom)
          VectorSourceColor(RGBA(255,0,0,255))
          StrokePath(1 * Canvas\Zoom)
        EndIf
        
      Next
      
      StopVectorDrawing()
    EndIf
  EndProcedure
  
  Procedure Window_Event_Canvas()
    Protected Event_Window = EventWindow()
    Protected Event_Gadget = EventGadget()
    Protected Event_Type = EventType()
    
    Protected Zoom.d
    Static Move_State, Move_X.d, Move_Y.d
    Protected R_X.d, R_Y.d, Line
    
    Select Event_Type
      Case #PB_EventType_LeftClick
        R_X = (GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseX) - Canvas\Offset_X) / Canvas\Zoom
        R_Y = (GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseY) - Canvas\Offset_Y) / Canvas\Zoom
        Line = (R_Y - #Text_Line_Spacing * 0.5) / (#Text_Height + #Text_Line_Spacing)
        If R_X >= 0 And SelectElement(Line_Reference(), Line) And LastElement(Line_Reference()\Element()) And R_X < Line_Reference()\Element()\X + Line_Reference()\Element()\Width
          Select Line_Reference()\Highlighted & %1
            Case #True  : Line_Reference()\Highlighted = #False
            Case #False : Line_Reference()\Highlighted = #True
          EndSelect
        EndIf
        Canvas\Redraw = #True
        
      Case #PB_EventType_MouseWheel
        Zoom = Pow(1.2, GetGadgetAttribute(Event_Gadget, #PB_Canvas_WheelDelta))
        Canvas\Offset_X - (Zoom - 1) * (GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseX) - Canvas\Offset_X)
        Canvas\Offset_Y - (Zoom - 1) * (GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseY) - Canvas\Offset_Y)
        Canvas\Zoom * Zoom
        Canvas\Redraw = #True
        
      Case #PB_EventType_RightButtonDown
        Move_State = #True
        Move_X = GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseX)
        Move_Y = GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseY)
        
      Case #PB_EventType_RightButtonUp
        Move_State = #False
        
      Case #PB_EventType_MouseMove
        If Move_State
          Canvas\Offset_X + GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseX) - Move_X
          Canvas\Offset_Y + GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseY) - Move_Y
          Move_X = GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseX)
          Move_Y = GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseY)
        EndIf
        R_X = (GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseX) - Canvas\Offset_X) / Canvas\Zoom
        R_Y = (GetGadgetAttribute(Event_Gadget, #PB_Canvas_MouseY) - Canvas\Offset_Y) / Canvas\Zoom
        Line = (R_Y - #Text_Line_Spacing * 0.5) / (#Text_Height + #Text_Line_Spacing)
        ForEach Line_Reference()
          If Line_Reference()\Line_Number = Line And R_X >= 0 And LastElement(Line_Reference()\Element()) And R_X < Line_Reference()\Element()\X + Line_Reference()\Element()\Width
            Line_Reference()\Highlighted | %10
          Else
            Line_Reference()\Highlighted & ~%10
          EndIf
        Next
        Canvas\Redraw = #True
        
    EndSelect
    
    If Canvas\Redraw
      Canvas\Redraw = #False
      Canvas_Redraw()
    EndIf
    
  EndProcedure
  
  Procedure Window_Event_SizeWindow()
    Protected Event_Window = EventWindow()
    Protected Event_Gadget = EventGadget()
    Protected Event_Type = EventType()
    
    Protected Width = WindowWidth(Event_Window)
    Protected Height = WindowHeight(Event_Window)
    
    ResizeGadget(Window\Canvas, 0, 0, Width, Height)
    
    Canvas_Redraw()
    
  EndProcedure
  
  Procedure Window_Event_CloseWindow()
    Protected Event_Window = EventWindow()
    Protected Event_Gadget = EventGadget()
    Protected Event_Type = EventType()
    
    Main\Quit = #True
  EndProcedure
  
  Procedure Window_Open()
    Protected Width, Height
    Protected i
    Protected Directory_ID
    
    If Window\ID
      SetActiveWindow(Window\ID)
      ProcedureReturn Window\ID
    EndIf
    
    Width = 400
    Height = 400
    
    Window\ID = OpenWindow(#PB_Any, 0, 0, Width, Height, "Assembler Visualizer", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget)
    If Not Window\ID
      ProcedureReturn #Null
    EndIf
    
    ; #### Gadgets
    Window\Canvas = CanvasGadget(#PB_Any, 0, 0, Width, Height, #PB_Canvas_Keyboard)
    
    Canvas\Redraw = #True
    
    ; #### Bind Events
    BindGadgetEvent(Window\Canvas, @Window_Event_Canvas())
    
    BindEvent(#PB_Event_SizeWindow, @Window_Event_SizeWindow(), Window\ID)
    BindEvent(#PB_Event_CloseWindow, @Window_Event_CloseWindow(), Window\ID)
    
    ProcedureReturn Window\ID
  EndProcedure
  
  Procedure Window_Close()
    If Window\ID
      
      UnbindGadgetEvent(Window\Canvas, @Window_Event_Canvas())
      
      UnbindEvent(#PB_Event_SizeWindow, @Window_Event_SizeWindow(), Window\ID)
      UnbindEvent(#PB_Event_CloseWindow, @Window_Event_CloseWindow(), Window\ID)
      
      CloseWindow(Window\ID)
      Window\ID = 0
      
    EndIf
  EndProcedure
  
  Procedure Load_Element_Dependency(*Assembler_File.Assembler::File, *Line_Reference.Line_Reference)
    Protected Influencer_Position
    Protected *Influencee_Element.Line_Reference_Element
    Protected *Influencer_Element.Line_Reference_Element
    Protected *Dependency.Assembler::Dependency
    
    ForEach *Line_Reference\Line\Dependency()
      *Dependency = *Line_Reference\Line\Dependency()
      ;If *Dependency\Influencee_Address\Type = Assembler::#Address_Type_Memory
      ;  Continue
      ;EndIf
      
      *Influencee_Element = SelectElement(*Line_Reference\Element(), 1)
      
      ForEach *Line_Reference\Element()
        If *Line_Reference\Element()\Address = *Dependency\Influencee_Address
          *Influencee_Element = *Line_Reference\Element()
          Break
        EndIf
      Next
      
      If *Influencee_Element
        
        PushListPosition(Line_Reference())
        
        ForEach Line_Reference()
          If Line_Reference()\Line = *Dependency\Influencer
            
            *Influencer_Element = SelectElement(Line_Reference()\Element(), 1)
            
            ForEach Line_Reference()\Element()
              If Line_Reference()\Element()\Address = *Dependency\Influencer_Address
                *Influencer_Element = Line_Reference()\Element()
                Break
              EndIf
            Next
            
            If *Influencer_Element
              
              AddElement(*Influencee_Element\Dependency_Virtual())
              *Influencee_Element\Dependency_Virtual() = *Dependency\Virtual
              AddElement(*Influencee_Element\Dependency())
              *Influencee_Element\Dependency() = *Influencer_Element
              
            EndIf
            
            Break
          EndIf
        Next
        
        PopListPosition(Line_Reference())
        
      EndIf
      
    Next
    
  EndProcedure
  
  Procedure Calculate_Flow_X(*Line_Reference_Flow.Line_Reference_Flow)
    Protected Max
    Protected Result
    
    If Not *Line_Reference_Flow\Done
      *Line_Reference_Flow\Done = #True
      
      ForEach *Line_Reference_Flow\Inside()
        Result = Calculate_Flow_X(*Line_Reference_Flow\Inside())
        If Max < Result
          Max = Result
        EndIf
      Next
      
      *Line_Reference_Flow\X = Max
      
    EndIf
    
    ProcedureReturn *Line_Reference_Flow\X + 1
  EndProcedure
  
  Procedure Load(*Assembler_File.Assembler::File)
    Protected *Line_Reference_Flow.Line_Reference_Flow
    
    ClearList(Line_Reference())
    
    ForEach *Assembler_File\Line_Container\Line()
      AddElement(Line_Reference())
      
      Assembler::Line_Compose(*Assembler_File\Line_Container, *Assembler_File\Line_Container\Line())
      
      ;Line_Reference()\Highlighted = #True
      Line_Reference()\Line_Number = ListIndex(Line_Reference())
      Line_Reference()\Line = *Assembler_File\Line_Container\Line()
      
      Select Line_Reference()\Line\Type
        Case Assembler::#Line_Type_Raw
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          If Line_Reference()\Line\Label
            Line_Reference()\Element()\Text = Line_Reference()\Line\Label + ": "
            Line_Reference()\Element()\Color = RGBA(150,150,255,255)
          EndIf
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          Line_Reference()\Element()\Text = Line_Reference()\Line\Raw_Minus_Label
          Line_Reference()\Element()\Color = RGBA(150,255,0,255)
          
        Case Assembler::#Line_Type_Instruction
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          If Line_Reference()\Line\Label
            Line_Reference()\Element()\Text = Line_Reference()\Line\Label + ": "
            Line_Reference()\Element()\Color = RGBA(150,150,255,255)
          EndIf
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          If Line_Reference()\Line\OpCode
            Line_Reference()\Element()\Text = Line_Reference()\Line\OpCode\Mnemonic + " "
            Line_Reference()\Element()\Color = RGBA(255,255,150,255)
          Else
            Line_Reference()\Element()\Text = Line_Reference()\Line\Raw_Instruction + " "
            Line_Reference()\Element()\Color = RGBA(255,255,0,255)
          EndIf
          
      EndSelect
      
      ForEach Line_Reference()\Line\Operand()
        
        If Line_Reference()\Line\Operand()\Address\Type = Assembler::#Address_Type_Memory
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          Line_Reference()\Element()\Address = Line_Reference()\Line\Operand()\Address
          Line_Reference()\Element()\Text = "["
          Line_Reference()\Element()\Color = RGBA(255,255,255,255)
          
          ForEach Line_Reference()\Line\Operand()\Address\Sub_Address()
            AddElement(Line_Reference()\Element())
            Line_Reference()\Element()\Parent = Line_Reference()
            Line_Reference()\Element()\Address = Line_Reference()\Line\Operand()\Address\Sub_Address()
            Line_Reference()\Element()\Text = Assembler::Operand_Compose(*Assembler_File\Line_Container, Line_Reference()\Line, Line_Reference()\Line\Operand()\Address\Sub_Address())
            Select Line_Reference()\Line\Operand()\Address\Sub_Address()\Type
              Case Assembler::#Address_Type_Immediate_Value : Line_Reference()\Element()\Color = RGBA(150,255,150,255)
              Case Assembler::#Address_Type_Immediate_Label : Line_Reference()\Element()\Color = RGBA(150,150,255,255)
              Case Assembler::#Address_Type_Register        : Line_Reference()\Element()\Color = RGBA(255,150,150,255)
            EndSelect
            If ListIndex(Line_Reference()\Line\Operand()\Address\Sub_Address()) < ListSize(Line_Reference()\Line\Operand()\Address\Sub_Address()) - 1
              AddElement(Line_Reference()\Element())
              Line_Reference()\Element()\Parent = Line_Reference()
              Line_Reference()\Element()\Text = "+"
              Line_Reference()\Element()\Color = RGBA(255,255,255,255)
            EndIf
          Next
          
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          Line_Reference()\Element()\Text = "]"
          Line_Reference()\Element()\Color = RGBA(255,255,255,255)
          
        Else
          
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          Line_Reference()\Element()\Address = Line_Reference()\Line\Operand()\Address
          Line_Reference()\Element()\Text = Assembler::Operand_Compose(*Assembler_File\Line_Container, Line_Reference()\Line, Line_Reference()\Line\Operand()\Address)
          Select Line_Reference()\Line\Operand()\Address\Type
            Case Assembler::#Address_Type_Immediate_Value : Line_Reference()\Element()\Color = RGBA(150,255,150,255)
            Case Assembler::#Address_Type_Immediate_Label : Line_Reference()\Element()\Color = RGBA(150,150,255,255)
            Case Assembler::#Address_Type_Register        : Line_Reference()\Element()\Color = RGBA(255,150,150,255)
          EndSelect
        EndIf
        
        If ListIndex(Line_Reference()\Line\Operand()) < ListSize(Line_Reference()\Line\Operand()) - 1
          AddElement(Line_Reference()\Element())
          Line_Reference()\Element()\Parent = Line_Reference()
          Line_Reference()\Element()\Text = ", "
          Line_Reference()\Element()\Color = RGBA(255,255,255,255)
        EndIf
      Next
      
    Next
    
    ForEach Line_Reference()
      Load_Element_Dependency(*Assembler_File, Line_Reference())
    Next
    
    ForEach Line_Reference()
      ForEach Line_Reference()\Line\Next_Line()
        ;If ListIndex(Line_Reference()\Line\Next_Line()) > 0
          AddElement(Line_Reference_Flow())
          
          Line_Reference_Flow()\Line_From = Line_Reference()
          Line_Reference_Flow()\Start_Line = Line_Reference()\Line_Number
          
          PushListPosition(Line_Reference())
          ForEach Line_Reference()
            If Line_Reference()\Line = Line_Reference_Flow()\Line_From\Line\Next_Line()
              Line_Reference_Flow()\Line_To = Line_Reference()
              Line_Reference_Flow()\End_Line = Line_Reference()\Line_Number
              Break
            EndIf
          Next
          PopListPosition(Line_Reference())
          
          If Line_Reference_Flow()\Start_Line > Line_Reference_Flow()\End_Line
            Swap Line_Reference_Flow()\Start_Line, Line_Reference_Flow()\End_Line
          EndIf
          
          Line_Reference_Flow()\Lines = Line_Reference_Flow()\End_Line - Line_Reference_Flow()\Start_Line
          
        ;EndIf
      Next
    Next
    
    SortStructuredList(Line_Reference_Flow(), #PB_Sort_Descending, OffsetOf(Line_Reference_Flow\Lines), TypeOf(Line_Reference_Flow\Lines))
    
    ForEach Line_Reference_Flow()
      *Line_Reference_Flow = Line_Reference_Flow()
      PushListPosition(Line_Reference_Flow())
      
      ForEach Line_Reference_Flow()
        If Line_Reference_Flow() <> *Line_Reference_Flow
          If (*Line_Reference_Flow\End_Line > Line_Reference_Flow()\Start_Line And *Line_Reference_Flow\End_Line < Line_Reference_Flow()\End_Line) Or (*Line_Reference_Flow\Start_Line > Line_Reference_Flow()\Start_Line And *Line_Reference_Flow\Start_Line < Line_Reference_Flow()\End_Line)
            AddElement(Line_Reference_Flow()\Inside())
            Line_Reference_Flow()\Inside() = *Line_Reference_Flow
          EndIf
        EndIf
      Next
      
      PopListPosition(Line_Reference_Flow())
    Next
    
    ForEach Line_Reference_Flow()
      If Not Line_Reference_Flow()\Done
        Calculate_Flow_X(Line_Reference_Flow())
      EndIf
    Next
    
    Canvas\Redraw = #True
  EndProcedure
  
  Procedure Main(*Assembler_File.Assembler::File)
    Window_Open()
    
    Main\Quit = #False
    
    Load(*Assembler_File)
    
    Repeat
      
      While WaitWindowEvent(10)
      Wend
      
      If Window\ID
        If Canvas\Redraw
          Canvas\Redraw = #False
          Canvas_Redraw()
        EndIf
      EndIf
      
    Until Main\Quit
    
    Window_Close()
  EndProcedure
  
  ; ################################################### Init ########################################################
  
  ; ################################################### Data Sections ###############################################
  
EndModule
; IDE Options = PureBasic 5.40 LTS (Windows - x64)
; CursorPosition = 18
; Folding = --
; EnableUnicode
; EnableXP