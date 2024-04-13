.386
.MODEL FLAT, stdcall

ExitProcess PROTO, dwExitCode: DWORD
GetStdHandle PROTO, param:DWORD
WriteConsoleA PROTO, param1:DWORD, param2:DWORD, param3:DWORD, param4:DWORD, param5:DWORD
.data 


string   db 13,10,"hello, Bruno.",13,10

.code

main proc c

local dwWritten:dword
local hConsole:dword

;comment #
;Exploration des LEA vs MOV 
    mov eax,dwWritten           ; contenu de la variable dwWritten ans eax
    lea eax,dwWritten           ; dwWritten est dans le stack (varaiable locale), adresse de dwWritten dans eax
    mov dwWritten,0AAAAAAAAh    ; valeur 0AAAAAAAAh copiée à l'adresse de dwWritten. Voir le CODE MACHINE
    mov dword ptr [eax],0CCCCCCCCh; fait la m^^eme chose, mais en utilisant le pointeur
    mov ebx,dwWritten           ; valeur récupérée dans ebx 
    lea eax,string              ; adresse de la string
    mov byte ptr [eax],41h       ; modification de la string par le pointeur (65 décimal = 41 hexa = "A")
    mov byte ptr [eax+1],41h
    mov byte ptr [eax+2],41h
    mov byte ptr [eax+3],41h    ; plus rapide : mov dword ptr [eax],41414141h ; 4 octet d'un coup
;#
    
    invoke  GetStdHandle, -11  ;STD_OUTPUT_HANDLE
    mov     hConsole, eax

    invoke  WriteConsoleA, hConsole, addr string, sizeof string, addr dwWritten, 0

    xor     eax,eax
    ret
main endp

;--- entry

mainCRTStartup proc c

    invoke  main
    invoke  ExitProcess, eax

mainCRTStartup endp

    END mainCRTStartup