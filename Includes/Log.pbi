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
; ##################################################### Module ######################################################

DeclareModule Log
  EnableExplicit
  
  ; ################################################### Public Constants ############################################
  Enumeration
    #Entry_Type_Info
    #Entry_Type_Optimization
    #Entry_Type_Warning
    #Entry_Type_Error
  EndEnumeration
  
  ; ################################################### Public Prototypes ###########################################
  
  ; ################################################### Public Structures ###########################################
  
  ; ################################################### Public Variables ############################################
  
  ; ################################################### Public Procedures (Declares) ################################
  Declare   File_Create()
  
  Declare   Entry_Add(Type, Source.s, Message.s)
  
EndDeclareModule

; ##################################################### Module (Private Part) #######################################

Module Log
  EnableExplicit
  
  UseModule Helper
  
  ; ################################################### Constants ###################################################
  
  ; ################################################### Structures ##################################################
  Structure Main
    Filename.s
    File.i
    
    Start_Time.i
  EndStructure
  
  ; ################################################### Variables ###################################################
  Global Main.Main
  
  ; ################################################### Init ########################################################
  Main\Start_Time = ElapsedMilliseconds()
  
  ; ################################################### Declares ####################################################
  
  ; ################################################### Procedures ##################################################
  Procedure File_Create()
    Main\Filename = Main::Main\Path_AppData + "Logs/Latest.txt"
    MakeSureDirectoryPathExists(Main\Filename)
    
    If Main\File
      CloseFile(Main\File)
      Main\File = 0
    EndIf
    
    Main\File = CreateFile(#PB_Any, Main\Filename, #PB_File_SharedRead | #PB_File_NoBuffering)
    
    WriteStringFormat(Main\File, #PB_UTF8)
    
    If Main\File
      WriteStringN(Main\File, "###############################################################", #PB_UTF8)
      WriteStringN(Main\File, "########              PB-Optimizer V"+StrD(Main::#Version*0.001,3)+"              ########", #PB_UTF8)
      WriteStringN(Main\File, "###############################################################", #PB_UTF8)
      WriteStringN(Main\File, "", #PB_UTF8)
    EndIf
  EndProcedure
  
  Procedure.s Entry_Type_2_String(Entry_Type)
    Select Entry_Type
      Case #Entry_Type_Info : ProcedureReturn "Info"
      Case #Entry_Type_Optimization : ProcedureReturn "Optimize"
      Case #Entry_Type_Warning : ProcedureReturn "Warning"
      Case #Entry_Type_Error : ProcedureReturn "Error"
      Default : ProcedureReturn "Unknown"
    EndSelect
  EndProcedure
  
  Procedure Entry_Add(Type, Source.s, Message.s)
    If Not Main\File
      ProcedureReturn #False
    EndIf
    
    WriteStringN(Main\File, RSet(StrD((ElapsedMilliseconds()-Main\Start_Time)/1000, 3), 6, "0") + " | " + LSet(Entry_Type_2_String(Type), 8) + " | " + LSet(Source, 20) + " | " + Message, #PB_UTF8)
    
    ProcedureReturn #True
  EndProcedure
  
EndModule
; IDE Options = PureBasic 5.41 LTS Beta 1 (Windows - x64)
; CursorPosition = 105
; FirstLine = 62
; Folding = -
; EnableUnicode
; EnableXP