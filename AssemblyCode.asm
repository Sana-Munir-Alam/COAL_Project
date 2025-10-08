.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD     ; Written so that terminal doesnt close unless we tell it so


INCLUDE Irvine32.inc

.data
    ; Menu and UI strings
    welcomeMsg    BYTE "=== Virtual Machine with Memory Management ===", 0Dh, 0Ah, 0
    menuPrompt    BYTE "Please select an option:", 0Dh, 0Ah
                  BYTE "1. Calculator", 0Dh, 0Ah
                  BYTE "2. String Operations", 0Dh, 0Ah
                  BYTE "3. Memory Management", 0Dh, 0Ah
                  BYTE "4. Exit Program", 0Dh, 0Ah
                  BYTE "Enter your choice (1-4): ", 0
    invalidChoice BYTE "Invalid choice! Please enter 1-4.", 0Dh, 0Ah, 0
    continueMsg   BYTE "Press any key to continue...", 0Dh, 0Ah, 0
    
    ; Calculator section
    calcTitle     BYTE "===== Calculator Module =====", 0Dh, 0Ah, 0
    calcMenu      BYTE "Select operation:", 0Dh, 0Ah
                  BYTE "1. Addition", 0Dh, 0Ah
                  BYTE "2. Subtraction", 0Dh, 0Ah
                  BYTE "3. Multiplication", 0Dh, 0Ah
                  BYTE "4. Division", 0Dh, 0Ah
                  BYTE "5. Return to Main Menu", 0Dh, 0Ah
                  BYTE "Enter your choice (1-5): ", 0
    enterFirst    BYTE "Enter first number: ", 0
    enterSecond   BYTE "Enter second number: ", 0
    calcResult    BYTE "Result: ", 0
    divByZeroMsg  BYTE "Error: Division by zero!", 0Dh, 0Ah, 0
    remainderMsg  BYTE " Remainder: ", 0
    
    ; String section  
    stringTitle   BYTE "===== String Operations Module =====", 0Dh, 0Ah, 0
    stringMenu    BYTE "Select string operation:", 0Dh, 0Ah
                  BYTE "1. String Reverse", 0Dh, 0Ah
                  BYTE "2. String Concatenation", 0Dh, 0Ah
                  BYTE "3. Copy String", 0Dh, 0Ah
                  BYTE "4. Compare Strings", 0Dh, 0Ah
                  BYTE "5. Return to Main Menu", 0Dh, 0Ah
                  BYTE "Enter your choice (1-5): ", 0
                  
    stringPrompt1 BYTE "Enter first string: ", 0
    stringPrompt2 BYTE "Enter second string: ", 0
    originalStr   BYTE "Original string: ", 0
    reversedStr   BYTE "Reversed string: ", 0
    concatResult  BYTE "Concatenated string: ", 0
    copyResult    BYTE "Copied string: ", 0
    copySuccess   BYTE "String successfully copied to new variable!", 0Dh, 0Ah, 0
    compareEqual  BYTE "Strings are EQUAL!", 0Dh, 0Ah, 0
    compareNotEqual BYTE "Strings are NOT equal!", 0Dh, 0Ah, 0
    inputBuffer   BYTE 50 DUP(0)      ; Buffer for string input
    inputBuffer2  BYTE 50 DUP(0)      ; Second buffer for string operations
    copyBuffer    BYTE 50 DUP(0)      ; Buffer for copied string
    
    ; Memory management section
    menuTitle        BYTE "===== Memory Management Module =====", 0Dh, 0Ah, 0
    menuOption1      BYTE "1. Create Matrix", 0Dh, 0Ah
                     BYTE "2. Display Matrix", 0Dh, 0Ah
                     BYTE "3. Add Matrices", 0Dh, 0Ah
                     BYTE "4. Free Matrix Memory", 0Dh, 0Ah
                     BYTE "5. Return to Main Menu", 0Dh, 0Ah
                     BYTE "Enter your choice (1-5): ", 0
    
    ; Matrix operation strings
    matrixSizePrompt BYTE "Enter matrix size (n for n x n matrix): ", 0
    matrixElemPrompt BYTE "Enter element [", 0
    matrixElemPrompt2 BYTE "]: ", 0
    matrixCreatedMsg BYTE "Matrix successfully created and allocated!", 0Dh, 0Ah, 0
    matrixFreedMsg   BYTE "Matrix successfully freed from memory!", 0Dh, 0Ah, 0
    matrixAddResult  BYTE "Matrix addition result:", 0Dh, 0Ah, 0
    matrixDisplayRow BYTE "Row ", 0
    matrixDisplayCol BYTE ": ", 0
    spaceChar        BYTE " ", 0
    
    ; Error messages
    noMatrixMsg      BYTE "Error: No matrix allocated. Please create matrix first.", 0Dh, 0Ah, 0
    invalidChoiceMsg BYTE "Error: Invalid choice. Please try again.", 0Dh, 0Ah, 0
    
    ; Matrix pointers and size
    matrixA          DWORD 0    ; Pointer to first matrix
    matrixB          DWORD 0    ; Pointer to second matrix  
    matrixC          DWORD 0    ; Pointer to result matrix
    matrixSize       DWORD 0    ; Size of matrix (n)
    matrixAllocated  BYTE 0     ; Flag: 1 if memory allocated, 0 if not

.code
main PROC
    call DisplayWelcomeMessage
    
    MenuLoop:
        call DisplayMenu
        call ReadUserChoice
        call ExecuteChoice
    
        ; After each operation, pause and return to menu
        mov edx, OFFSET continueMsg
        call WriteString
        call ReadChar           ; Wait for key press
        call Clrscr             ; Clear screen for fresh menu
        jmp MenuLoop
    
main ENDP

; Display welcome message
DisplayWelcomeMessage PROC
    mov edx, OFFSET welcomeMsg
    call WriteString
    call Crlf
    ret
DisplayWelcomeMessage ENDP

; Display the main menu
DisplayMenu PROC
    mov edx, OFFSET menuPrompt
    call WriteString
    ret
DisplayMenu ENDP

; Read user input (1-4)
ReadUserChoice PROC
    call ReadInt            ; Read integer into EAX
    ret
ReadUserChoice ENDP

; Execute based on user choice in EAX
ExecuteChoice PROC
    cmp eax, 1
    je CalculatorSection
    cmp eax, 2
    je StringSection
    cmp eax, 3
    je MemorySection
    cmp eax, 4
    je ExitProgram
    
    ; Invalid choice
    mov edx, OFFSET invalidChoice
    call WriteString
    ret
    
    CalculatorSection:
        call CalculatorModule
        ret
    
    StringSection:
        call StringModule
        ret
    
    MemorySection:
        call MemoryModule
        ret
    
    ExitProgram:
        INVOKE ExitProcess, 0
ExecuteChoice ENDP







;; ==================== CALCULATOR MODULE ====================
; Main procedure for arithmetic operation
; Handles Addition, Subtraction, Multiplication, Division
; ============================================================
CalculatorModule PROC
    ; Main menu loop for calculator operations
    CalcMenuLoop:
        call DisplayCalcMenu      ; Display calculator menu options to user
        call ReadInt              ; Read user's menu choice as integer
        call Crlf                 ; Print New Line
        
        ; Compare user input with menu options and jump to appropriate handler
        cmp eax, 1                ; Check if user selected option 1
        je Addition               ; Jump to Addition handler
        cmp eax, 2                ; Check if user selected option 2  
        je Subtraction            ; Jump to Subtraction handler
        cmp eax, 3                ; Check if user selected option 3
        je Multiplication         ; Jump to Multiplication handler
        cmp eax, 4                ; Check if user selected option 4
        je Division               ; Jump to Division handler
        cmp eax, 5                ; Check if user selected option 5
        je CalcEnd                ; Jump to Exit handler
        
        ; ========== INVALID INPUT HANDLER ==========
        ; Display error message for invalid menu selection
        mov edx, OFFSET invalidChoiceMsg  ; Load address of error message
        call WriteString                  ; Display the error message

        jmp CalcMenuLoop                  ; Return to menu to allow user to try again

    ; ========== MENU OPTION HANDLERS ==========
    Addition:
        call AdditionProcedure       ; Call procedure to perform addition
        jmp CalcMenuLoop             ; Return to main menu after completion

    Subtraction:
        call SubtractionProcedure    ; Call procedure to perform subtraction
        jmp CalcMenuLoop             ; Return to main menu after completion

    Multiplication:
        call MultiplicationProcedure ; Call procedure to perform multiplication
        jmp CalcMenuLoop             ; Return to main menu after completion

    Division:
        call DivisionProcedure       ; Call procedure to perform division
        jmp CalcMenuLoop             ; Return to main menu after completion

    CalcEnd:                         ; ========== EXIT HANDLER ==========
        ret                          ; Return from CalculatorModule procedure

CalculatorModule ENDP

; =============================================
; Display Calculator Menu
; =============================================
DisplayCalcMenu PROC
    mov edx, OFFSET calcTitle        ; Load address of calculator title string
    call WriteString                 ; Display the calculator title
    call Crlf                        ; Output new line
    
    mov edx, OFFSET calcMenu         ; Load address of calculator menu string
    call WriteString                 ; Display the menu options
    
    ret                              ; Return from procedure
DisplayCalcMenu ENDP

; =============================================
; Calculator Procedure
; =============================================
AdditionProcedure PROC
    ret
AdditionProcedure ENDP

SubtractionProcedure PROC
    ret
SubtractionProcedure ENDP

MultiplicationProcedure PROC
    ret
MultiplicationProcedure ENDP

DivisionProcedure PROC
    ret
DivisionProcedure ENDP






;; ==================== STRING MANIPULATION MODULE ====================
; Main procedure for string manipulation operation
; Handles string reverse, concatination, copy, and compare
; ============================================================

StringModule PROC
    ; Main menu loop for string operations
    StringMenuLoop:
        call DisplayStringMenu     ; Display string operations menu to user
        call ReadInt               ; Read user's menu choice as integer
        call Crlf                  ; Print New Line
        
        ; Compare user input with menu options and jump to appropriate handler
        cmp eax, 1                 ; Check if user selected option 1
        je StringReverse           ; Jump to String Reverse handler
        cmp eax, 2                 ; Check if user selected option 2  
        je StringConcatenation     ; Jump to String Concatenation handler
        cmp eax, 3                 ; Check if user selected option 3
        je StringCopy              ; Jump to String Copy handler
        cmp eax, 4                 ; Check if user selected option 4
        je StringCompare           ; Jump to String Compare handler
        cmp eax, 5                 ; Check if user selected option 5
        je StringEnd               ; Jump to Exit handler
        
        ; ========== INVALID INPUT HANDLER ==========
        ; Display error message for invalid menu selection
        mov edx, OFFSET invalidChoiceMsg  ; Load address of error message
        call WriteString                  ; Display the error message

        jmp StringMenuLoop                ; Return to menu to allow user to try again

    ; ========== MENU OPTION HANDLERS ==========
    
    StringReverse:
        call StringReverseProcedure       ; Call procedure to reverse string
        jmp StringMenuLoop                ; Return to main menu after completion

    StringConcatenation:
        call StringConcatenationProcedure ; Call procedure to concatenate strings
        jmp StringMenuLoop                ; Return to main menu after completion

    StringCopy:
        call StringCopyProcedure          ; Call procedure to copy string
        jmp StringMenuLoop                ; Return to main menu after completion

    StringCompare:
        call StringCompareProcedure       ; Call procedure to compare strings
        jmp StringMenuLoop                ; Return to main menu after completion

    StringEnd:                            ; ========== EXIT HANDLER ==========
        ret                               ; Return from StringModule procedure

StringModule ENDP

; =============================================
; Display String Menu
; =============================================
DisplayStringMenu PROC
    mov edx, OFFSET stringTitle    ; Load address of string title string
    call WriteString               ; Display the string title
    call Crlf                      ; Output new line
    
    mov edx, OFFSET stringMenu     ; Load address of string menu string
    call WriteString               ; Display the menu options
    
    ret                            ; Return from procedure
DisplayStringMenu ENDP

; =============================================
; String Operation Procedures
; =============================================

StringReverseProcedure PROC
    ; ESI points to the string to reverse
    ; TODO: Implement string reversal logic here
    ; Steps:
    ; 1. Find string length (scan for null terminator)
    ; 2. Set up pointers: beginning and end of string
    ; 3. Swap characters until pointers meet
    
    ; For now, just return without modifying the string
    ret
StringReverseProcedure ENDP

StringConcatenationProcedure PROC
    ; ESI = first string, EDI = second string
    ; TODO: Implement string comparison logic here
    ; Steps:
    ; 1. Loop through both strings, comparing characters at each position
    ; 2. If characters differ, return 1 (not equal)
    ; 3. If null terminator is reached in both, return 0 (equal)
    ; 4. If one string ends before the other, return 1 (not equal)

    ; For now, just return without modifying the string
    ret
StringConcatenationProcedure ENDP

StringCopyProcedure PROC
    ; ESI = source string, EDI = destination buffer
    ; TODO: Implement string copy logic here
    ; Steps:
    ; 1. Check that destination buffer is valid/writable
    ; 2. Read a character from the source (ESI)
    ; 3. Write it to the destination (EDI)
    ; 4. Increment both pointers
    ; 5. If character was null terminator, stop
    ; 6. Otherwise, repeat from step 2
    
    ; For now, just return without modifying the string
    ret
StringCopyProcedure ENDP

StringCompareProcedure PROC
    ; ESI = first string, EDI = second string
    ; TODO: Implement string concatenation logic here
    ; Steps:
    ; 1. Find the null terminator of the first string (ESI)
    ; 2. Copy the second string (EDI) starting at that position
    ; 3. Ensure the final string is null-terminated

    ; For now, just return without modifying the string
    ret
StringCompareProcedure ENDP






;; ==================== MEMORY MANAGEMENT MODULE ====================
; Main procedure for memory management operations
; Handles matrix creation, display, addition, and memory management
; ===================================================================

MemoryModule PROC
    ; Main menu loop for memory management operations
    MemoryMenuLoop:
        call DisplayMemoryMenu  ; Display memory management menu options to user
        call ReadInt            ; Read user's menu choice as integer
        call Crlf               ; Print New Line
        
        ; Compare user input with menu options and jump to appropriate handler
        cmp eax, 1              ; Check if user selected option 1
        je CreateMatrix             ; Jump to Create Matrix handler
        cmp eax, 2              ; Check if user selected option 2  
        je DisplayMatrix            ; Jump to Display Matrix handler
        cmp eax, 3              ; Check if user selected option 3
        je AddMatrices              ; Jump to Matrix Addition handler
        cmp eax, 4              ; Check if user selected option 4
        je FreeMemory               ; Jump to Free Memory handler
        cmp eax, 5              ; Check if user selected option 5
        je MemoryEnd                ; Jump to Exit handler
        
        ; ========== INVALID INPUT HANDLER ==========
        ; Display error message for invalid menu selection
        mov edx, OFFSET invalidChoiceMsg  ; Load address of error message
        call WriteString                  ; Display the error message

        jmp MemoryMenuLoop                ; Return to menu to allow user to try again

    ; ========== MENU OPTION HANDLERS ==========
    
    CreateMatrix:
        call CreateMatrixProcedure       ; Call procedure to create a new matrix in memory
        jmp MemoryMenuLoop               ; Return to main menu after completion

    DisplayMatrix:
        call DisplayMatrixProcedure      ; Call procedure to display matrix contents
        jmp MemoryMenuLoop               ; Return to main menu after completion

    AddMatrices:
        call MatrixAdditionProcedure     ; Call procedure to perform matrix addition operation
        jmp MemoryMenuLoop               ; Return to main menu after completion

    FreeMemory:
        call FreeMemoryProcedure         ; Call procedure to free allocated matrix memory
        jmp MemoryMenuLoop               ; Return to main menu after completion

    MemoryEnd:                           ; ========== CLEANUP AND EXIT HANDLER ==========
        ; Check if any matrices are currently allocated before exiting
        cmp matrixAllocated, 0           ; Compare allocation flag with 0
        je NoCleanupNeeded               ; Skip cleanup if no matrices allocated
        
        ; Clean up all allocated matrix memory before exiting module
        call FreeAllMatrices             ; Free any allocated memory
    
    NoCleanupNeeded:
        ret                              ; Return from MemoryModule procedure

MemoryModule ENDP

; =============================================
; Display Menu
; =============================================
DisplayMemoryMenu PROC
    mov edx, OFFSET menuTitle        ; Load address of menu title string
    call WriteString                 ; Display the menu title
    call Crlf                        ; Output new line
    
    mov edx, OFFSET menuOption1      ; Load address of menu option string
    call WriteString                 ; Display the menu option
    
    ret                              ; Return from procedure
DisplayMemoryMenu ENDP

; =============================================
; Create Matrix Procedure - FIXED VERSION [Definately Final ONE]
; =============================================
CreateMatrixProcedure PROC
    ; Free existing matrices if any
    cmp matrixAllocated, 0                ; Check if matrices are currently allocated
    je NoFreeNeeded                       ; Skip freeing if no matrices exist
    call FreeAllMatrices                  ; Free any previously allocated matrices

    NoFreeNeeded:
        ; Get matrix size from user
        mov edx, OFFSET matrixSizePrompt  ; Load address of size prompt message
        call WriteString                  ; Ask user for matrix size
        call ReadInt                      ; Read integer input from user
        mov matrixSize, eax               ; Store the matrix size
    
        ; Calculate total memory needed: n * n * 4 bytes (for DWORD elements)
        mov eax, matrixSize               ; Load matrix size into EAX
        mul matrixSize                    ; Multiply EAX by matrixSize (EAX = n * n)
        mov ebx, eax                      ; Save element count in EBX
        shl eax, 2                        ; Multiply by 4 (shift left 2 = ×4 for DWORD size)
        mov edx, eax                      ; Save total byte size in EDX
    
        ; Allocate memory for matrix A
        call GetProcessHeap               ; Get handle to process heap
        push 8                            ; Push HEAP_ZERO_MEMORY flag (initialize to zero)
        push edx                          ; Push size in bytes to allocate
        push eax                          ; Push heap handle
        call HeapAlloc                    ; Allocate memory block
        mov matrixA, eax                  ; Store pointer to allocated memory for matrix A
    
        ; Allocate memory for matrix B
        call GetProcessHeap               ; Get handle to process heap
        push 8                            ; Push HEAP_ZERO_MEMORY flag
        push edx                          ; Push size in bytes to allocate
        push eax                          ; Push heap handle
        call HeapAlloc                    ; Allocate memory block
        mov matrixB, eax                  ; Store pointer to allocated memory for matrix B
    
        ; Allocate memory for matrix C (result)
        call GetProcessHeap               ; Get handle to process heap
        push 8                            ; Push HEAP_ZERO_MEMORY flag
        push edx                          ; Push size in bytes to allocate
        push eax                          ; Push heap handle
        call HeapAlloc                    ; Allocate memory block
        mov matrixC, eax                  ; Store pointer to allocated memory for matrix C
    
        ; Input values for matrix A
        mov edx, OFFSET matrixDisplayRow  ; Load address of matrix display prefix
        call WriteString                  ; Display the prefix text
        mov al, 'A'                       ; Load 'A' character for matrix identifier
        call WriteChar                    ; Display matrix identifier
        mov al, ':'                       ; Load colon character
        call WriteChar                    ; Display colon
        call Crlf                         ; Output new line
        mov esi, matrixA                  ; Load pointer to matrix A into ESI
        call InputMatrixValues            ; Call procedure to input matrix values
    
        ; Input values for matrix B
        mov edx, OFFSET matrixDisplayRow  ; Load address of matrix display prefix
        call WriteString                  ; Display the prefix text
        mov al, 'B'                       ; Load 'B' character for matrix identifier
        call WriteChar                    ; Display matrix identifier
        mov al, ':'                       ; Load colon character
        call WriteChar                    ; Display colon
        call Crlf                         ; Output new line
        mov esi, matrixB                  ; Load pointer to matrix B into ESI
        call InputMatrixValues            ; Call procedure to input matrix values
    
        mov matrixAllocated, 1            ; Set allocation flag to indicate matrices exist
        mov edx, OFFSET matrixCreatedMsg  ; Load address of success message
        call WriteString                  ; Display creation success message
        call Crlf                         ; Output new line
    
        ret                               ; Return from procedure
CreateMatrixProcedure ENDP

; =============================================
; Input Matrix Values
; =============================================
InputMatrixValues PROC
    mov ecx, matrixSize    ; Set outer loop counter for rows
    mov edi, 0             ; Initialize row index to 0
    
    RowLoop:
        push ecx               ; Save outer loop counter
        mov ecx, matrixSize    ; Set inner loop counter for columns
        mov ebx, 0             ; Initialize column index to 0
        
        ColLoop:
            ; Display prompt for element
            push edx                            ; Save EDX register
            mov edx, OFFSET matrixElemPrompt    ; Load address of element prompt part 1
            call WriteString                    ; Display "Enter element ["
            
            ; Display row index, col index
            mov eax, edi                        ; Load current row index
            call WriteDec                       ; Display row number
            mov al, ','                         ; Load comma character
            call WriteChar                      ; Display comma
            mov eax, ebx                        ; Load current column index
            call WriteDec                       ; Display column number
            
            mov edx, OFFSET matrixElemPrompt2   ; Load address of element prompt part 2
            call WriteString                    ; Display "]: "
            pop edx                             ; Restore EDX register
            
            ; Read integer value
            call ReadInt           ; Read integer input from user
            mov [esi], eax         ; Store value in current matrix position
            
            ; Move to next element
            add esi, 4             ; Advance pointer to next DWORD element
            inc ebx                ; Increment column index
            loop ColLoop           ; Continue inner loop for columns
            
        inc edi                ; Increment row index
        pop ecx                ; Restore outer loop counter
        loop RowLoop           ; Continue outer loop for rows
        
        ret                    ; Return from procedure
InputMatrixValues ENDP

; =============================================
; Display Matrix Procedure
; =============================================
DisplayMatrixProcedure PROC
    cmp matrixAllocated, 0          ; Check if matrices are allocated
    jne MatricesAllocated          ; Jump if matrices exist
    
    mov edx, OFFSET noMatrixMsg     ; Load address of error message
    call WriteString                ; Display "No matrices created" message
    ret                             ; Return early
    
    MatricesAllocated:
        ; Display matrix A
        mov edx, OFFSET matrixDisplayRow    ; Load address of display prefix
        call WriteString                    ; Display "Matrix "
        mov al, 'A'                         ; Load matrix identifier 'A'
        call WriteChar                      ; Display 'A'
        mov al, ':'                         ; Load colon character
        call WriteChar                      ; Display ':'
        call Crlf                           ; Output new line
        
        mov esi, matrixA                    ; Load pointer to matrix A
        call DisplaySingleMatrix            ; Display matrix A contents
        call Crlf                           ; Output blank line
        
        ; Display matrix B
        mov edx, OFFSET matrixDisplayRow    ; Load address of display prefix
        call WriteString                    ; Display "Matrix "
        mov al, 'B'                         ; Load matrix identifier 'B'
        call WriteChar                      ; Display 'B'
        mov al, ':'                         ; Load colon character
        call WriteChar                      ; Display ':'
        call Crlf                           ; Output new line
        
        mov esi, matrixB                    ; Load pointer to matrix B
        call DisplaySingleMatrix            ; Display matrix B contents
        call Crlf                           ; Output blank line

        ret                                 ; Return from procedure
DisplayMatrixProcedure ENDP

; =============================================
; Display Single Matrix
; =============================================
DisplaySingleMatrix PROC
    mov ecx, matrixSize    ; Set outer loop counter for rows
    mov edi, 0             ; Initialize row index to 0
    
display_RowLoop:
    push ecx               ; Save outer loop counter
    
    ; Display row label
    mov edx, OFFSET matrixDisplayRow    ; Load address of display prefix
    call WriteString                    ; Display "Matrix "
    mov eax, edi                        ; Load current row index
    call WriteDec                       ; Display row number
    mov edx, OFFSET matrixDisplayCol    ; Load address of column separator
    call WriteString                    ; Display "]: "
    
    mov ecx, matrixSize                 ; Set inner loop counter for columns
    
    DisplayColLoop:
        mov eax, [esi]                  ; Load current matrix element
        call WriteInt                   ; Display the integer value
        mov edx, OFFSET spaceChar       ; Load address of space character
        call WriteString                ; Display space between elements
        
        add esi, 4                      ; Advance pointer to next DWORD element
        loop DisplayColLoop             ; Continue inner loop for columns
        call Crlf                       ; Output new line after each row

        inc edi                         ; Increment row index
        pop ecx                         ; Restore outer loop counter
        loop display_RowLoop            ; Continue outer loop for rows
    
    ret                                 ; Return from procedure
DisplaySingleMatrix ENDP

; =============================================
; Matrix Addition Procedure
; =============================================
MatrixAdditionProcedure PROC
    cmp matrixAllocated, 0         ; Check if matrices are allocated
    jne AdditionPossible           ; Jump if matrices exist
    
    mov edx, OFFSET noMatrixMsg    ; Load address of error message
    call WriteString               ; Display "No matrices created" message
    ret                            ; Return early
    
    AdditionPossible:
        ; Perform matrix addition: C = A + B
        mov esi, matrixA      ; Load pointer to matrix A
        mov edi, matrixB      ; Load pointer to matrix B  
        mov ebx, matrixC      ; Load pointer to matrix C (result)
        
        ; Calculate total elements
        mov eax, matrixSize   ; Load matrix size
        mul matrixSize        ; Multiply size by itself (EAX = n * n)
        mov ecx, eax          ; Set loop counter to total elements
        
        AdditionLoop:
            mov eax, [esi]        ; Get element from matrix A
            add eax, [edi]        ; Add element from matrix B
            mov [ebx], eax        ; Store result in matrix C
            
            ; Move to next elements
            add esi, 4            ; Advance matrix A pointer
            add edi, 4            ; Advance matrix B pointer
            add ebx, 4            ; Advance matrix C pointer
            loop AdditionLoop     ; Continue for all elements
        
        ; Display result
        mov edx, OFFSET matrixAddResult    ; Load address of result message
        call WriteString                   ; Display "Matrix C (A+B):"
        
        mov esi, matrixC                   ; Load pointer to result matrix
        call DisplaySingleMatrix           ; Display the resulting matrix
        call Crlf                          ; Output blank line

        ret                   ; Return from procedure
MatrixAdditionProcedure ENDP

; =============================================
; Free Memory Procedure
; =============================================
FreeMemoryProcedure PROC
    cmp matrixAllocated, 0    ; Check if matrices are allocated
    jne FreeMatrices          ; Jump if matrices exist
    
    mov edx, OFFSET noMatrixMsg    ; Load address of error message
    call WriteString               ; Display "No matrices created" message
    ret                            ; Return early
    
    FreeMatrices:
        call FreeAllMatrices              ; Call procedure to free all matrices
        mov edx, OFFSET matrixFreedMsg    ; Load address of success message
        call WriteString                  ; Display "Matrices freed" message
    
    ret                               ; Return from procedure
FreeMemoryProcedure ENDP

; =============================================
; Free All Matrices - FIXED VERSION
; =============================================
FreeAllMatrices PROC
    ; Free matrix A
    cmp matrixA, 0              ; Check if matrix A exists
    je free_matrixB             ; Skip if matrix A is null
    
    call GetProcessHeap         ; Get handle to process heap
    push 0                      ; No flags for HeapFree
    push matrixA                ; Pointer to memory block to free
    push eax                    ; Heap handle
    call HeapFree               ; Free matrix A memory
    mov matrixA, 0              ; Clear matrix A pointer
    
    free_matrixB:
        cmp matrixB, 0          ; Check if matrix B exists
        je free_matrixC         ; Skip if matrix B is null
    
        call GetProcessHeap     ; Get handle to process heap
        push 0                  ; No flags for HeapFree
        push matrixB            ; Pointer to memory block to free
        push eax                ; Heap handle
        call HeapFree           ; Free matrix B memory
        mov matrixB, 0          ; Clear matrix B pointer
    
    free_matrixC:
        cmp matrixC, 0          ; Check if matrix C exists
        je free_complete        ; Skip if matrix C is null
    
        call GetProcessHeap     ; Get handle to process heap
        push 0                  ; No flags for HeapFree
        push matrixC            ; Pointer to memory block to free
        push eax                ; Heap handle
        call HeapFree           ; Free matrix C memory
        mov matrixC, 0          ; Clear matrix C pointer
    
    free_complete:
        mov matrixAllocated, 0    ; Clear allocation flag
        ret                       ; Return from procedure
FreeAllMatrices ENDP

END main
