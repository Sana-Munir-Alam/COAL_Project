;-------------------------------------------------------------
;   Program: String Manipulation Menu
;   Author : Dev / Hashir
;   Description: Performs string operations like Reverse,
;                Concatenate, Copy, and Compare.
;                User can repeatedly choose options until Exit.
;   Assembler: MASM with Irvine32 library
;-------------------------------------------------------------

INCLUDE Irvine32.inc

.data
;----------------------------
; Menu and message strings
;----------------------------
menuMsg  BYTE "String Manipulation Menu",0Dh,0Ah,0
optMsg   BYTE "1. Reverse String",0Dh,0Ah,
               "2. Concatenate Strings",0Dh,0Ah,
               "3. Copy String",0Dh,0Ah,
               "4. Compare Strings",0Dh,0Ah,
               "5. Exit",0Dh,0Ah,
               "Enter choice: ",0
msg1     BYTE "Enter first string: ",0
msg2     BYTE "Enter second string: ",0
msgRes   BYTE "Result: ",0
equalMsg BYTE "Strings are equal.",0
notMsg   BYTE "Strings are NOT equal.",0

;----------------------------
; String storage buffers
;----------------------------
str1     BYTE 100 DUP(?)       ; first string buffer
str2     BYTE 100 DUP(?)       ; second string buffer
result   BYTE 200 DUP(?)       ; result buffer (larger for concatenation)
choice   BYTE ?                ; user’s choice (1–5)

.code
main PROC

;============================
; Main Menu Loop
;============================
MenuLoop:
    call Clrscr                ; clear screen for better readability
    mov edx, OFFSET menuMsg
    call WriteString           ; print title
    mov edx, OFFSET optMsg
    call WriteString           ; print options list

    call ReadChar              ; read user input (single character)
    sub al, '0'                ; convert ASCII to integer (e.g. '1' ? 1)
    mov choice, al
    call Crlf                  ; move to new line

    ; Choose operation based on user input
    cmp choice, 1
    je Reverse
    cmp choice, 2
    je Concat
    cmp choice, 3
    je CopyStr
    cmp choice, 4
    je Compare
    cmp choice, 5
    je ExitProgram
    jmp MenuLoop               ; invalid input ? redisplay menu

;============================
; 1. Reverse String
;============================
Reverse:
    mov edx, OFFSET msg1
    call WriteString           ; prompt for first string
    mov edx, OFFSET str1
    mov ecx, SIZEOF str1
    call ReadString            ; read string from user

    mov esi, OFFSET str1
    call StrLength             ; get string length
    mov ecx, eax               ; store length in ECX for loop count
    mov esi, OFFSET str1
    add esi, ecx               ; move to end of string
    dec esi                    ; point to last valid character
    mov edi, OFFSET result     ; destination buffer

RevLoop:
    mov al, [esi]              ; read character from end
    mov [edi], al              ; write to result
    dec esi                    ; move backward in source
    inc edi                    ; move forward in result
    loop RevLoop
    mov byte ptr [edi], 0      ; null-terminate the reversed string

    mov edx, OFFSET msgRes
    call WriteString
    mov edx, OFFSET result
    call WriteString           ; print reversed string
    call Crlf
    call WaitMsg               ; wait for user key before continuing
    jmp MenuLoop               ; return to menu

;============================
; 2. Concatenate Strings
;============================
Concat:
    mov edx, OFFSET msg1
    call WriteString
    mov edx, OFFSET str1
    mov ecx, SIZEOF str1
    call ReadString            ; read first string

    mov edx, OFFSET msg2
    call WriteString
    mov edx, OFFSET str2
    mov ecx, SIZEOF str2
    call ReadString            ; read second string

    push OFFSET result         ; dest = result
    push OFFSET str1           ; src = str1
    call MyStrCopy             ; copy first string into result

    push OFFSET result         ; dest = result (append to it)
    push OFFSET str2           ; src = str2
    call MyStrCat              ; concatenate second string

    mov edx, OFFSET msgRes
    call WriteString
    mov edx, OFFSET result
    call WriteString           ; display final concatenated string
    call Crlf
    call WaitMsg
    jmp MenuLoop

;============================
; 3. Copy String
;============================
CopyStr:
    mov edx, OFFSET msg1
    call WriteString
    mov edx, OFFSET str1
    mov ecx, SIZEOF str1
    call ReadString            ; read string to copy

    push OFFSET result
    push OFFSET str1
    call MyStrCopy             ; copy str1 ? result

    mov edx, OFFSET msgRes
    call WriteString
    mov edx, OFFSET result
    call WriteString           ; display copied string
    call Crlf
    call WaitMsg
    jmp MenuLoop

;============================
; 4. Compare Strings
;============================
Compare:
    mov edx, OFFSET msg1
    call WriteString
    mov edx, OFFSET str1
    mov ecx, SIZEOF str1
    call ReadString            ; read first string

    mov edx, OFFSET msg2
    call WriteString
    mov edx, OFFSET str2
    mov ecx, SIZEOF str2
    call ReadString            ; read second string

    push OFFSET str2           ; parameter 2
    push OFFSET str1           ; parameter 1
    call MyStrCompare          ; compare the two strings

    cmp eax, 0
    jne _notEqual
    mov edx, OFFSET equalMsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp MenuLoop

_notEqual:
    mov edx, OFFSET notMsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp MenuLoop

;============================
; Exit the program
;============================
ExitProgram:
    call Crlf
    exit
main ENDP

;=============================================================
;  Custom String Functions (Manual Implementation)
;=============================================================

;-------------------------------------------------------------
; MyStrCopy(dest, src)
; Copies string from src ? dest (including null terminator)
;-------------------------------------------------------------
MyStrCopy PROC
    push ebp
    mov ebp, esp
    mov esi, [ebp+8]     ; src
    mov edi, [ebp+12]    ; dest

_copyLoop:
    mov al, [esi]        ; copy character
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0            ; stop at null terminator
    jne _copyLoop

    pop ebp
    ret 8
MyStrCopy ENDP

;-------------------------------------------------------------
; MyStrCat(dest, src)
; Appends src to the end of dest
;-------------------------------------------------------------
MyStrCat PROC
    push ebp
    mov ebp, esp
    mov esi, [ebp+8]     ; src
    mov edi, [ebp+12]    ; dest

_findEnd:
    mov al, [edi]        ; find end of destination string
    cmp al, 0
    je _copyStart
    inc edi
    jmp _findEnd

_copyStart:
    mov al, [esi]        ; copy from src into dest
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne _copyStart

    pop ebp
    ret 8
MyStrCat ENDP

;-------------------------------------------------------------
; MyStrCompare(s1, s2)
; Returns:
;     EAX = 0 ? strings are equal
;     EAX = 1 ? strings are NOT equal
;-------------------------------------------------------------
MyStrCompare PROC
    push ebp
    mov ebp, esp
    mov esi, [ebp+8]     ; s1
    mov edi, [ebp+12]    ; s2

_cmpLoop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl           ; compare characters
    jne _notEq           ; mismatch found ? not equal
    cmp al, 0            ; reached null terminator?
    je _eq               ; yes ? strings equal
    inc esi
    inc edi
    jmp _cmpLoop         ; continue comparison

_eq:
    mov eax, 0
    jmp _done
_notEq:
    mov eax, 1
_done:
    pop ebp
    ret 8
MyStrCompare ENDP

END main
