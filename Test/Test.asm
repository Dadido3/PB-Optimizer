format MS COFF
extrn _PB_CloseFile@4
extrn _PB_ConsoleColor@8
extrn _PB_ConsoleLocate@8
extrn _PB_ConsoleTitle@4
extrn _PB_CreateFile@8
extrn _PB_Date@0
extrn _PB_Date2@24
extrn _PB_Day@4
extrn _PB_Delay@4
extrn _PB_EnableGraphicalConsole@4
extrn _PB_FormatDate@12
extrn _PB_FreeFiles@0
extrn _PB_FreeFileSystem@0
extrn _PB_GetCurrentDirectory@4
extrn _PB_GetFilePart@8
extrn _PB_InitFile@0
extrn _PB_InitProcess@0
extrn _PB_InitRequester@0
extrn _PB_InputRequester@16
extrn _PB_Int@8
extrn _PB_Month@4
extrn _PB_OpenConsole@0
extrn _PB_ParseDate@8
extrn _PB_Print
extrn _PB_RSet2@16
extrn _PB_RunProgram@4
extrn _PB_RunProgram2@12
extrn _PB_Str@12
extrn _PB_StrF2@12
extrn _PB_WriteString@8
extrn _PB_Year@4
extrn _Beep@8
extrn _CoCreateInstance@20
extrn _CoInitialize@4
extrn _CoUninitialize@0
extrn _ExitProcess@4
extrn _GetModuleHandleA@4
extrn _HeapCreate@12
extrn _HeapDestroy@4
extrn _memset
extrn _SYS_CopyString@4
extrn _SYS_AllocateString4@8
extrn SYS_FastAllocateStringFree
extrn _SYS_FreeString@4
extrn PB_StringBase
extrn _SYS_InitString@0
extrn _SYS_FreeStrings@0
extrn _PB_StringBasePosition
public _PB_Instance
public _PB_ExecutableType
public _PB_OpenGLSubsystem
public _PB_MemoryBase
public PB_Instance
public PB_MemoryBase
public _PB_EndFunctions

macro pb_public symbol
{
 public  _#symbol
 public symbol
_#symbol:
symbol:
}

macro    pb_align value { rb (value-1) - ($-_PB_DataSection + value-1) mod value }
macro pb_bssalign value { rb (value-1) - ($-_PB_BSSSection  + value-1) mod value }

define ll_getendpointvolume_uuidof_mmdeviceenumerator l_uuidof_mmdeviceenumerator
define ll_getendpointvolume_uuidof_immdeviceenumerator l_uuidof_immdeviceenumerator
define ll_getendpointvolume_uuidof_immdeviceenumerator l_uuidof_immdeviceenumerator
define ll_getendpointvolume_uuidof_mmdeviceenumerator l_uuidof_mmdeviceenumerator
define ll_getendpointvolume_uuidof_iaudioendpointvolume l_uuidof_iaudioendpointvolume
define ll_getendpointvolume_uuidof_iaudioendpointvolume l_uuidof_iaudioendpointvolume
public PureBasicStart
section '.code' code readable executable align 4096
PureBasicStart:
 PUSH dword I_BSSEnd-I_BSSStart
 PUSH dword 0
 PUSH dword I_BSSStart
 CALL _memset
 ADD esp,12
 PUSH dword 0
 CALL _GetModuleHandleA@4
 MOV [_PB_Instance],eax
 PUSH dword 0
 PUSH dword 4096
 PUSH dword 0
 CALL _HeapCreate@12
 MOV [PB_MemoryBase],eax
 MOV eax,PB_DataSectionStart
 MOV dword [PB_DataPointer],eax
 CALL _SYS_InitString@0
 CALL _PB_InitFile@0
 CALL _PB_InitProcess@0
 CALL _PB_InitRequester@0
;
 LEA ebp,[v_Main]
 MOV dword [ebp],1000
 CALL _PB_Date@0
 PUSH eax
 POP dword [ebp+4]
 PUSH dword 0
 PUSH dword 25
 PUSH dword 5
 CALL _PB_Date@0
 PUSH eax
 CALL _PB_Day@4
 MOV ebx,eax
 INC ebx
 PUSH ebx
 CALL _PB_Date@0
 PUSH eax
 CALL _PB_Month@4
 PUSH eax
 CALL _PB_Date@0
 PUSH eax
 CALL _PB_Year@4
 PUSH eax
 CALL _PB_Date2@24
 PUSH eax
 POP dword [ebp+8]
 MOV edx,[_PB_StringBasePosition]
 PUSH edx
 PUSH edx
 MOV edx,[_PB_StringBasePosition]
 PUSH edx
 PUSH edx
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+8]
 MOV eax,_S72
 PUSH eax
 CALL _PB_FormatDate@12
 INC dword [_PB_StringBasePosition]
 MOV eax,_S74
 PUSH eax
 MOV eax,_S73
 PUSH eax
 MOV edx,[PB_StringBase]
 ADD [esp+8],edx
 CALL _PB_InputRequester@16
 INC dword [_PB_StringBasePosition]
 MOV eax,_S72
 PUSH eax
 MOV edx,[PB_StringBase]
 ADD [esp+4],edx
 CALL _PB_ParseDate@8
 POP dword [_PB_StringBasePosition]
 PUSH eax
 POP dword [ebp+8]
 MOV edx,_S75
 LEA ecx,[ebp+16]
 CALL SYS_FastAllocateStringFree
 MOV edx,_S76
 LEA ecx,[ebp+16]
 CALL SYS_FastAllocateStringFree
 PUSH dword [ebp+8]
 CALL _Procedure10
 CALL _PB_OpenConsole@0
 PUSH dword 1
 CALL _PB_EnableGraphicalConsole@4
 CALL _Procedure8
 PUSH dword 500
 PUSH dword 1000
 CALL _Beep@8
_Repeat28:
 CALL _Procedure6
 LEA ebp,[v_Main]
 MOV ebx,dword [ebp+12]
 AND ebx,ebx
 JNE No0
 CALL _PB_Date@0
 MOV ebx,eax
 CMP ebx,dword [ebp+8]
 JL No0
Ok0:
 MOV eax,1
 JMP End0
No0:
 XOR eax,eax
End0:
 AND eax,eax
 JE _EndIf30
 LEA ebp,[v_Main]
 MOV dword [ebp+12],1
 PUSH dword 500
 PUSH dword 1000
 CALL _Beep@8
 PUSH dword 1048576000
 CALL _Procedure4
 LEA ebp,[v_Main]
 PUSH dword [ebp+16]
 CALL _PB_RunProgram@4
 AND eax,eax
 JE No1
 XOR eax,eax
 JMP Ok1
No1:
 MOV eax,1
Ok1:
 AND eax,eax
 JE _EndIf32
_Repeat33:
 MOV dword [v_i],25
 JMP _ForSkipDebug34
_For34:
_ForSkipDebug34:
 MOV eax,120
 CMP eax,dword [v_i]
 JL _Next35
 PUSH dword 1000
 PUSH dword [v_i]
 CALL _Beep@8
_NextContinue35:
 ADD dword [v_i],5
 JNO _For34
_Next35:
 JMP _Repeat33
_Until33:
_EndIf32:
_EndIf30:
 PUSH dword 1000
 CALL _PB_Delay@4
 JMP _Repeat28
_Until28:
_PB_EOP_NoValue:
 PUSH dword 0
_PB_EOP:
 CALL _PB_EndFunctions
 CALL _SYS_FreeStrings@0
 PUSH dword [PB_MemoryBase]
 CALL _HeapDestroy@4
 CALL _ExitProcess@4
_PB_EndFunctions:
 CALL _PB_FreeFileSystem@0
 CALL _PB_FreeFiles@0
 RET
_Procedure10:
 PS10=12
 XOR eax,eax
 PUSH eax
 PUSH eax
 MOV edx,_S31
 LEA ecx,[esp]
 CALL SYS_FastAllocateStringFree
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S32
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S33
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S34
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S35
 PUSH edx
 CALL _SYS_CopyString@4
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [esp+PS10+12]
 MOV eax,_S36
 PUSH eax
 CALL _PB_FormatDate@12
 POP eax
 MOV edx,_S37
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S38
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S39
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S40
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S41
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S42
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S43
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S44
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S45
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S46
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S47
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S48
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S49
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S50
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S51
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S52
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S53
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S54
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S55
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S56
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S57
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S58
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S59
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S60
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S61
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S62
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S63
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S64
 PUSH edx
 CALL _SYS_CopyString@4
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 CALL _PB_GetCurrentDirectory@4
 POP eax
 MOV edx,_S65
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S66
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S67
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV edx,dword [esp]
 PUSH dword [_PB_StringBasePosition]
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,_S68
 PUSH edx
 CALL _SYS_CopyString@4
 LEA eax,[esp+4]
 PUSH eax
 CALL _SYS_AllocateString4@8
 MOV eax,_S69
 PUSH eax
 PUSH dword -1
 CALL _PB_CreateFile@8
 MOV dword [esp+4],eax
 CMP dword [esp+4],0
 JE _EndIf27
 PUSH dword [esp]
 PUSH dword [esp+8]
 CALL _PB_WriteString@8
 PUSH dword [esp+4]
 CALL _PB_CloseFile@4
_EndIf27:
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 CALL _PB_GetCurrentDirectory@4
 INC dword [_PB_StringBasePosition]
 MOV eax,_S71
 PUSH eax
 MOV eax,_S70
 PUSH eax
 MOV edx,[PB_StringBase]
 ADD [esp+8],edx
 CALL _PB_RunProgram2@12
 POP dword [_PB_StringBasePosition]
_EndProcedureZero11:
 XOR eax,eax
_EndProcedure11:
 PUSH dword [esp]
 CALL _SYS_FreeString@4
 ADD esp,8
 RET 4
_Procedure2:
 PS2=4
 MOV eax,dword [esp+PS2+0]
 PUSH eax
 MOV eax,[eax]
 CALL dword [eax+8]
 CALL _CoUninitialize@0
_EndProcedureZero3:
 XOR eax,eax
_EndProcedure3:
 RET 4
_Procedure8:
 PUSH ebp
 PUSH ebx
 PUSH edi
 PS8=32
 XOR eax,eax
 PUSH eax
 PUSH eax
 PUSH eax
 PUSH eax
 MOV dword [esp],60
 MOV dword [esp+4],18
 PUSH dword 0
 PUSH dword 7
 CALL _PB_ConsoleColor@8
 PUSH dword 0
 PUSH dword 0
 CALL _PB_ConsoleLocate@8
 MOV eax,_S14
 PUSH eax
 CALL dword [_PB_Print]
 PUSH dword 0
 MOV ebx,dword [esp+4]
 DEC ebx
 PUSH ebx
 CALL _PB_ConsoleLocate@8
 MOV eax,_S15
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+4]
 DEC ebx
 PUSH ebx
 PUSH dword 0
 CALL _PB_ConsoleLocate@8
 MOV eax,_S16
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+4]
 DEC ebx
 PUSH ebx
 MOV ebx,dword [esp+4]
 DEC ebx
 PUSH ebx
 CALL _PB_ConsoleLocate@8
 MOV eax,_S17
 PUSH eax
 CALL dword [_PB_Print]
 MOV dword [esp+8],1
 JMP _ForSkipDebug10
_For10:
_ForSkipDebug10:
 MOV ebx,dword [esp]
 ADD ebx,-2
 CMP ebx,dword [esp+8]
 JL _Next11
 PUSH dword 0
 PUSH dword [esp+12]
 CALL _PB_ConsoleLocate@8
 MOV eax,_S18
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+4]
 DEC ebx
 PUSH ebx
 PUSH dword [esp+12]
 CALL _PB_ConsoleLocate@8
 MOV eax,_S18
 PUSH eax
 CALL dword [_PB_Print]
_NextContinue11:
 INC dword [esp+8]
 JNO _For10
_Next11:
 MOV dword [esp+12],1
 JMP _ForSkipDebug12
_For12:
_ForSkipDebug12:
 MOV ebx,dword [esp+4]
 ADD ebx,-2
 CMP ebx,dword [esp+12]
 JL _Next13
 PUSH dword [esp+12]
 PUSH dword 0
 CALL _PB_ConsoleLocate@8
 MOV eax,_S19
 PUSH eax
 CALL dword [_PB_Print]
 PUSH dword [esp+12]
 MOV ebx,dword [esp+4]
 DEC ebx
 PUSH ebx
 CALL _PB_ConsoleLocate@8
 MOV eax,_S19
 PUSH eax
 CALL dword [_PB_Print]
_NextContinue13:
 INC dword [esp+12]
 JNO _For12
_Next13:
 MOV dword [esp+12],1
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV edx,_S20
 PUSH edx
 CALL _SYS_CopyString@4
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword 2
 LEA ebp,[v_Main]
 FILD dword [ebp]
 FDIV dword [F2]
 SUB esp,4
 FSTP dword [esp]
 CALL _PB_StrF2@12
 POP eax
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 MOV eax,_S21
 PUSH eax
 CALL dword [_PB_Print]
 MOV dword [esp+8],0
 JMP _ForSkipDebug14
_For14:
_ForSkipDebug14:
 MOV ebx,dword [esp]
 DEC ebx
 CMP ebx,dword [esp+8]
 JL _Next15
 PUSH dword [esp+12]
 PUSH dword [esp+12]
 CALL _PB_ConsoleLocate@8
 MOV ebx,dword [esp+8]
 AND ebx,ebx
 JNE _EndIf17
 MOV eax,_S22
 PUSH eax
 CALL dword [_PB_Print]
 JMP _EndIf16
_EndIf17:
 MOV ebx,dword [esp+8]
 MOV edi,dword [esp]
 DEC edi
 CMP ebx,edi
 JNE _EndIf18
 MOV eax,_S23
 PUSH eax
 CALL dword [_PB_Print]
 JMP _EndIf16
_EndIf18:
 MOV eax,_S24
 PUSH eax
 CALL dword [_PB_Print]
_EndIf16:
_NextContinue15:
 INC dword [esp+8]
 JNO _For14
_Next15:
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 7
 CALL _PB_ConsoleColor@8
 MOV eax,_S25
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 7
 CALL _PB_ConsoleColor@8
 MOV eax,_S26
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 7
 CALL _PB_ConsoleColor@8
 MOV eax,_S27
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 12
 CALL _PB_ConsoleColor@8
 MOV eax,_S28
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 12
 CALL _PB_ConsoleColor@8
 MOV eax,_S29
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword 0
 PUSH dword 7
 CALL _PB_ConsoleColor@8
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 MOV dword [esp+8],0
 JMP _ForSkipDebug20
_For20:
_ForSkipDebug20:
 MOV ebx,dword [esp]
 DEC ebx
 CMP ebx,dword [esp+8]
 JL _Next21
 PUSH dword [esp+12]
 PUSH dword [esp+12]
 CALL _PB_ConsoleLocate@8
 MOV ebx,dword [esp+8]
 AND ebx,ebx
 JNE _EndIf23
 MOV eax,_S22
 PUSH eax
 CALL dword [_PB_Print]
 JMP _EndIf22
_EndIf23:
 MOV ebx,dword [esp+8]
 MOV edi,dword [esp]
 DEC edi
 CMP ebx,edi
 JNE _EndIf24
 MOV eax,_S23
 PUSH eax
 CALL dword [_PB_Print]
 JMP _EndIf22
_EndIf24:
 MOV eax,_S24
 PUSH eax
 CALL dword [_PB_Print]
_EndIf22:
_NextContinue21:
 INC dword [esp+8]
 JNO _For20
_Next21:
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
 PUSH dword [esp+12]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 7
 CALL _PB_ConsoleColor@8
 MOV eax,_S30
 PUSH eax
 CALL dword [_PB_Print]
 MOV ebx,dword [esp+12]
 INC ebx
 MOV dword [esp+12],ebx
_EndProcedureZero9:
 XOR eax,eax
_EndProcedure9:
 ADD esp,16
 POP edi
 POP ebx
 POP ebp
 RET
_Procedure6:
 PUSH ebp
 PUSH ebx
 PS6=60
 MOV edx,12
.ClearLoop:
 SUB esp,4
 MOV dword [esp],0
 DEC edx
 JNZ .ClearLoop
 MOV dword [esp],60
 MOV dword [esp+4],18
 MOV dword [esp+8],1
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 PUSH dword [esp+8]
 PUSH dword 23
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 LEA ebp,[v_Main]
 PUSH dword [ebp+4]
 MOV eax,_S1
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 26
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+4]
 MOV eax,_S2
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 29
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+4]
 MOV eax,_S3
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 34
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+4]
 MOV eax,_S4
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 37
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+4]
 MOV eax,_S5
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 PUSH dword [esp+8]
 PUSH dword 23
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+8]
 MOV eax,_S1
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 26
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+8]
 MOV eax,_S2
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 29
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+8]
 MOV eax,_S3
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 34
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+8]
 MOV eax,_S4
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 37
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+8]
 MOV eax,_S5
 PUSH eax
 CALL _PB_FormatDate@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 PUSH dword [esp+8]
 PUSH dword 10
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [ebp+16]
 CALL _PB_GetFilePart@8
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 PUSH dword [esp+8]
 PUSH dword 38
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 FILD dword [ebp+8]
 SUB esp,8
 FSTP qword [esp+0]
 CALL _PB_Date@0
 FLD qword [esp+0]
 ADD esp,8
 MOV dword [esp-4],eax
 FISUB dword [esp-4]
 FADD qword [D1]
 FILD dword [ebp+8]
 FISUB dword [ebp+4]
 FADD qword [D1]
 FDIVP st1,st0
 FCHS
 FADD qword [D2]
 FSTP qword [esp+12]
 FLD qword [esp+12]
 FCOMP qword [D1]
 FNSTSW ax
 TEST ah,1h
 JE _EndIf2
 FLD qword [D1]
 FSTP qword [esp+12]
_EndIf2:
 FLD qword [esp+12]
 FCOMP qword [D2]
 FNSTSW ax
 TEST ah,41h
 JNE _EndIf4
 FLD qword [D2]
 FSTP qword [esp+12]
_EndIf4:
 LEA ebp,[v_Main]
 MOV ebx,dword [ebp+8]
 CALL _PB_Date@0
 SUB ebx,eax
 MOV dword [esp+20],ebx
 MOV ebx,dword [esp+20]
 AND ebx,ebx
 JGE _EndIf6
 MOV dword [esp+20],0
_EndIf6:
_While7:
 MOV ebx,dword [esp+20]
 CMP ebx,60
 JL _Wend7
 MOV ebx,dword [esp+20]
 ADD ebx,-60
 MOV dword [esp+20],ebx
 MOV ebx,dword [esp+24]
 INC ebx
 MOV dword [esp+24],ebx
 JMP _While7
_Wend7:
_While8:
 MOV ebx,dword [esp+24]
 CMP ebx,60
 JL _Wend8
 MOV ebx,dword [esp+24]
 ADD ebx,-60
 MOV dword [esp+24],ebx
 MOV ebx,dword [esp+28]
 INC ebx
 MOV dword [esp+28],ebx
 JMP _While8
_Wend8:
_While9:
 MOV ebx,dword [esp+28]
 CMP ebx,24
 JL _Wend9
 MOV ebx,dword [esp+28]
 ADD ebx,-24
 MOV dword [esp+28],ebx
 MOV ebx,dword [esp+32]
 INC ebx
 MOV dword [esp+32],ebx
 JMP _While9
_Wend9:
 PUSH dword [esp+8]
 PUSH dword 11
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S6
 PUSH eax
 PUSH dword 6
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword 2
 FLD qword [esp+44]
 FMUL dword [F1]
 SUB esp,4
 FSTP dword [esp]
 CALL _PB_StrF2@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 23
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S6
 PUSH eax
 PUSH dword 5
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,dword [esp+60]
 CDQ
 PUSH edx
 PUSH eax
 CALL _PB_Str@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 33
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S6
 PUSH eax
 PUSH dword 3
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,dword [esp+56]
 CDQ
 PUSH edx
 PUSH eax
 CALL _PB_Str@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 42
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S6
 PUSH eax
 PUSH dword 3
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,dword [esp+52]
 CDQ
 PUSH edx
 PUSH eax
 CALL _PB_Str@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 PUSH dword [esp+8]
 PUSH dword 49
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S6
 PUSH eax
 PUSH dword 3
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,dword [esp+48]
 CDQ
 PUSH edx
 PUSH eax
 CALL _PB_Str@12
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 MOV ebx,dword [esp+8]
 INC ebx
 MOV dword [esp+8],ebx
 MOV ebx,dword [esp]
 ADD ebx,-4
 MOV dword [esp+36],ebx
 FLD qword [esp+12]
 FIMUL dword [esp+36]
 FSTP qword [esp+40]
 PUSH dword [esp+8]
 PUSH dword 2
 CALL _PB_ConsoleLocate@8
 PUSH dword 0
 PUSH dword 10
 CALL _PB_ConsoleColor@8
 FLD qword [esp+40]
 FMUL qword [D3]
 SUB esp,8
 FSTP qword [esp]
 CALL _PB_Int@8
 MOV ebx,eax
 MOV eax,ebx
 MOV ecx,4
 CDQ
 IDIV ecx
 MOV ebx,edx
 PUSH ebx
 XOR ebx,ebx
 CMP ebx,[esp]
 JNE _Case1
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S8
 PUSH eax
 LEA edx,[esp+60]
 PUSH dword [edx+4]
 PUSH dword [edx]
 CALL _PB_Int@8
 PUSH eax
 MOV eax,_S7
 PUSH eax
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 JMP _EndSelect1
_Case1:
 MOV ebx,1
 CMP ebx,[esp]
 JNE _Case2
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S8
 PUSH eax
 LEA edx,[esp+60]
 PUSH dword [edx+4]
 PUSH dword [edx]
 CALL _PB_Int@8
 MOV ebx,eax
 INC ebx
 PUSH ebx
 MOV eax,_S9
 PUSH eax
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 JMP _EndSelect1
_Case2:
 MOV ebx,2
 CMP ebx,[esp]
 JNE _Case3
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S8
 PUSH eax
 LEA edx,[esp+60]
 PUSH dword [edx+4]
 PUSH dword [edx]
 CALL _PB_Int@8
 MOV ebx,eax
 INC ebx
 PUSH ebx
 MOV eax,_S10
 PUSH eax
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
 JMP _EndSelect1
_Case3:
 MOV ebx,3
 CMP ebx,[esp]
 JNE _Case4
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV eax,_S8
 PUSH eax
 LEA edx,[esp+60]
 PUSH dword [edx+4]
 PUSH dword [edx]
 CALL _PB_Int@8
 MOV ebx,eax
 INC ebx
 PUSH ebx
 MOV eax,_S11
 PUSH eax
 CALL _PB_RSet2@16
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL dword [_PB_Print]
 POP dword [_PB_StringBasePosition]
_Case4:
_EndSelect1:
 POP eax
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 MOV edx,_S12
 PUSH edx
 CALL _SYS_CopyString@4
 PUSH dword [_PB_StringBasePosition]
 PUSH dword [_PB_StringBasePosition]
 PUSH dword 2
 FLD qword [esp+32]
 FMUL dword [F1]
 SUB esp,4
 FSTP dword [esp]
 CALL _PB_StrF2@12
 POP eax
 MOV edx,_S13
 PUSH edx
 CALL _SYS_CopyString@4
 MOV edx,[PB_StringBase]
 ADD [esp+0],edx
 CALL _PB_ConsoleTitle@4
 POP dword [_PB_StringBasePosition]
_EndProcedureZero7:
 XOR eax,eax
_EndProcedure7:
 ADD esp,48
 POP ebx
 POP ebp
 RET
_Procedure0:
 PUSH ebp
 PS0=20
 XOR eax,eax
 PUSH eax
 PUSH eax
 PUSH eax
 PUSH dword 0
 CALL _CoInitialize@4
 LEA eax,[esp]
 PUSH eax
 MOV ebp,ll_getendpointvolume_uuidof_immdeviceenumerator
 PUSH ebp
 PUSH dword 1
 PUSH dword 0
 MOV ebp,ll_getendpointvolume_uuidof_mmdeviceenumerator
 PUSH ebp
 CALL _CoCreateInstance@20
 MOV dword [esp+4],eax
 LEA eax,[esp+8]
 PUSH eax
 PUSH dword 0
 PUSH dword 0
 MOV eax,dword [esp+12]
 PUSH eax
 MOV eax,[eax]
 CALL dword [eax+16]
 MOV dword [esp+4],eax
 MOV eax,dword [esp]
 PUSH eax
 MOV eax,[eax]
 CALL dword [eax+8]
 PUSH dword [esp+PS0+0]
 PUSH dword 0
 PUSH dword 1
 MOV ebp,ll_getendpointvolume_uuidof_iaudioendpointvolume
 PUSH ebp
 MOV eax,dword [esp+24]
 PUSH eax
 MOV eax,[eax]
 CALL dword [eax+12]
 MOV dword [esp+4],eax
 MOV eax,dword [esp+8]
 PUSH eax
 MOV eax,[eax]
 CALL dword [eax+8]
 MOV eax,dword [esp+PS0+0]
 JMP _EndProcedure1
_EndProcedureZero1:
 XOR eax,eax
_EndProcedure1:
 ADD esp,12
 POP ebp
 RET 4
_Procedure4:
 PS4=8
 XOR eax,eax
 PUSH eax
 LEA eax,[esp]
 PUSH eax
 CALL _Procedure0
 PUSH dword 0
 PUSH dword [esp+PS4+4]
 MOV eax,dword [esp+8]
 PUSH eax
 MOV eax,[eax]
 CALL dword [eax+28]
 PUSH dword 0
 PUSH dword 0
 MOV eax,dword [esp+8]
 PUSH eax
 MOV eax,[eax]
 CALL dword [eax+56]
 PUSH dword [esp]
 CALL _Procedure2
_EndProcedureZero5:
 XOR eax,eax
_EndProcedure5:
 ADD esp,4
 RET 4
section '.data' data readable writeable
_PB_DataSection:
_PB_OpenGLSubsystem: db 0
pb_public PB_DEBUGGER_LineNumber
 dd -1
pb_public PB_DEBUGGER_IncludedFiles
 dd 0
pb_public PB_DEBUGGER_FileName
 db 0
pb_public PB_Compiler_Unicode
 dd 0
pb_public PB_Compiler_Thread
 dd 0
pb_public PB_Compiler_Purifier
 dd 0
pb_public PB_Compiler_Debugger
 dd 0
_PB_ExecutableType: dd 0
public _SYS_StaticStringStart
_SYS_StaticStringStart:
_S7: db 0
_S74: db "Choose Wakeup-Time",0
_S6: db " ",0
_S13: db "%",0
_S67: db "  </Actions>",13,10,0
_S27: db "File:",0
_S69: db "Schedule.xml",0
_S50: db "      <RestartOnIdle>false</RestartOnIdle>",13,10,0
_S52: db "    <AllowStartOnDemand>true</AllowStartOnDemand>",13,10,0
_S32: db "<Task version=",34,"1.3",34," xmlns=",34,"http://schemas.microsoft.com/windows/2004/02/mit/task",34,">",13,10,0
_S43: db "    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>",13,10,0
_S20: db "Wecker v",0
_S9: db "°",0
_S10: db "±",0
_S11: db "²",0
_S23: db "¶",0
_S19: db "º",0
_S15: db "»",0
_S17: db "¼",0
_S24: db "Ä",0
_S22: db "Ç",0
_S16: db "È",0
_S14: db "É",0
_S18: db "Í",0
_S35: db "      <StartBoundary>",0
_S55: db "    <RunOnlyIfIdle>false</RunOnlyIfIdle>",13,10,0
_S8: db "Û",0
_S2: db "%mm",0
_S63: db "    <Exec>",13,10,0
_S70: db "schtasks.exe",0
_S58: db "    <WakeToRun>true</WakeToRun>",13,10,0
_S56: db "    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>",13,10,0
_S39: db "    </TimeTrigger>",13,10,0
_S75: db "D:\Eigenes\Eigene Musik\Normal\Whiplash\06 - Caravan.m4a",0
_S44: db "    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>",13,10,0
_S57: db "    <UseUnifiedSchedulingEngine>false</UseUnifiedSchedulingEngine>",13,10,0
_S73: db "Wecker",0
_S46: db "    <StartWhenAvailable>true</StartWhenAvailable>",13,10,0
_S45: db "    <AllowHardTerminate>true</AllowHardTerminate>",13,10,0
_S33: db "  <Triggers>",13,10,0
_S51: db "    </IdleSettings>",13,10,0
_S53: db "    <Enabled>true</Enabled>",13,10,0
_S38: db "      <Enabled>true</Enabled>",13,10,0
_S66: db "    </Exec>",13,10,0
_S42: db "    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>",13,10,0
_S48: db "    <IdleSettings>",13,10,0
_S40: db "  </Triggers>",13,10,0
_S31: db "<?xml version=",34,"1.0",34," encoding=",34,"UTF-16",34,"?>",13,10,0
_S1: db "%dd",0
_S28: db "              Automatic startup programmed,",0
_S76: db "D:\Eigenes\Eigene Musik\Spiele\Undertale\05 - Ruins.flac",0
_S34: db "    <TimeTrigger>",13,10,0
_S64: db "      <Command>",34,0
_S21: db "by David Vogel (Dadido3)",0
_S54: db "    <Hidden>false</Hidden>",13,10,0
_S47: db "    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>",13,10,0
_S12: db "Wecker ",0
_S29: db "             go into hibernation if you want.",0
_S41: db "  <Settings>",13,10,0
_S59: db "    <ExecutionTimeLimit>P3D</ExecutionTimeLimit>",13,10,0
_S26: db "Alarm:                 .  .       :  ",0
_S49: db "      <StopOnIdleEnd>false</StopOnIdleEnd>",13,10,0
_S36: db "%yyyy-%mm-%ddT%hh:%ii:%ss",0
_S25: db "Start:                 .  .       :  ",0
_S68: db "</Task>",13,10,0
_S72: db "%dd.%mm.%yyyy %hh:%ii",0
_S71: db "/Create /TN WakeUpAlarm /XML Schedule.xml /F",0
_S4: db "%hh",0
_S3: db "%yyyy",0
_S62: db "  <Actions Context=",34,"Author",34,">",13,10,0
_S37: db "</StartBoundary>",13,10,0
_S61: db "  </Settings>",13,10,0
_S60: db "    <Priority>7</Priority>",13,10,0
_S5: db "%ii",0
_S30: db "Progress:       % ETC      days    hours    min    sec",0
_S65: db "Dummy.exe",34,"</Command>",13,10,0
pb_public PB_NullString
 db 0
public _SYS_StaticStringEnd
_SYS_StaticStringEnd:
align 4
F1: dd 1120403456
F2: dd 1148846080
D1: dd 0,0
D2: dd 0,1072693248
D3: dd 0,1074790400
align 4
align 4
s_s:
 dd 0
 dd -1
s_main:
 dd 16
 dd -1
align 4
section '.bss' readable writeable
_PB_BSSSection:
align 4
I_BSSStart:
_PB_MemoryBase:
PB_MemoryBase: rd 1
_PB_Instance:
PB_Instance: rd 1
align 4
PB_DataPointer rd 1
v_i rd 1
align 4
v_Main rb 20
align 4
align 4
align 4
I_BSSEnd:
section '.data' data readable writeable
l_uuidof_iaudioendpointvolume:
PB_DataSectionStart:
 dd 1558129794
 dw 33822,17734
 db 151,34,12,247,64,120,34,154
l_uuidof_mmdeviceenumerator:
 dd -1126300779
 dw 58671,18044
 db 142,61,196,87,146,145,105,46
l_uuidof_immdeviceenumerator:
 dd -1453955886
 dw 38420
 dw 20277
 db 167,70,222,141,182,54,23,230
SYS_EndDataSection:
