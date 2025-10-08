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
    calcTitle     BYTE "--- Calculator Module ---", 0Dh, 0Ah, 0
    calcMenu      BYTE "Select operation:", 0Dh, 0Ah
                  BYTE "1. Addition", 0Dh, 0Ah
                  BYTE "2. Subtraction", 0Dh, 0Ah
                  BYTE "3. Multiplication", 0Dh, 0Ah
                  BYTE "4. Division", 0Dh, 0Ah
                  BYTE "Enter choice (1-4): ", 0
    enterFirst    BYTE "Enter first number: ", 0
    enterSecond   BYTE "Enter second number: ", 0
    calcResult    BYTE "Result: ", 0
    divByZeroMsg  BYTE "Error: Division by zero!", 0Dh, 0Ah, 0
    remainderMsg  BYTE " Remainder: ", 0
    
    ; String section  
    stringTitle   BYTE "--- String Operations Module ---", 0Dh, 0Ah, 0
    stringMenu    BYTE "Select string operation:", 0Dh, 0Ah
                  BYTE "1. String Reverse", 0Dh, 0Ah
                  BYTE "2. String Concatenation", 0Dh, 0Ah
                  BYTE "3. Copy String", 0Dh, 0Ah
                  BYTE "4. Compare Strings", 0Dh, 0Ah
                  BYTE "Enter choice (1-4): ", 0
                  
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
    memoryTitle   BYTE "--- Memory Management Module ---", 0Dh, 0Ah, 0
    memoryMenu    BYTE "Select memory operation:", 0Dh, 0Ah
                  BYTE "1. Create and Free 2D Matrix", 0Dh, 0Ah
                  BYTE "2. Add Two Matrices", 0Dh, 0Ah
                  BYTE "Enter choice (1-2): ", 0
                  
    matrixSizePrompt BYTE "Enter matrix size (n for n x n matrix): ", 0
    matrixElemPrompt BYTE "Enter element [", 0
    matrixElemPrompt2 BYTE "]: ", 0
    matrixCreatedMsg BYTE "Matrix successfully created and allocated!", 0Dh, 0Ah, 0
    matrixFreedMsg   BYTE "Matrix successfully freed from memory!", 0Dh, 0Ah, 0
    matrixAddResult  BYTE "Matrix addition result:", 0Dh, 0Ah, 0
    matrixDisplayRow BYTE "Row ", 0
    matrixDisplayCol BYTE ": ", 0
    spaceChar     BYTE " ", 0
    newline       BYTE 0Dh, 0Ah, 0
    
    ; Matrix pointers
    matrix1       DWORD 0
    matrix2       DWORD 0
    matrixResult  DWORD 0
    matrixSize    DWORD 0

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

; ==================== CALCULATOR MODULE ====================
CalculatorModule PROC
    mov edx, OFFSET calcTitle
    call WriteString
    call Crlf
    
    ; Display calculator operations menu
    mov edx, OFFSET calcMenu
    call WriteString
    call ReadInt            ; Read operation choice
    mov ebx, eax            ; Store choice in EBX
    
    ; Get first number from user
    ; Get second number from user
    
    ; Perform operation based on choice in EBX(compare input value with 1,2,3,4 and jump to respective label if equal)
    
    ; If invalid operation choice, default to addition
    jmp Addition
    
    Addition:
        jmp CalcEnd
    
    Subtraction:
        jmp CalcEnd
    
    Multiplication:
        jmp CalcEnd
    
    Division:
        ; Check for division by zero (if false perform division, if true, print error )
    

        jmp CalcEnd
    
    PerformDivision:
        call DisplayDivisionResult
    
    CalcEnd:
        call Crlf
        ret
    CalculatorModule ENDP

    ; Display regular result (for Add, Sub, Mul)
    DisplayResult PROC
    
        ret
    DisplayResult ENDP

    ; Display division result (quotient and remainder)
    DisplayDivisionResult PROC
    
        ret
DisplayDivisionResult ENDP

; ==================== STRING MODULE ====================
StringModule PROC
    mov edx, OFFSET stringTitle
    call WriteString
    call Crlf
    
    ; Display string operations menu
    mov edx, OFFSET stringMenu
    call WriteString
    call ReadInt
    mov ebx, eax           ; Store choice in EBX
    
    ; Perform operation based on choice in EBX(compare input value with 1,2,3,4 and jump to respective label if equal)
    
    
    ; Default to string reverse
    jmp StringReverse
    
    StringReverse:
        ; Get string input from user
        ; Display original string
        ; Reverse the string
        ; Display reversed string


        jmp StringEnd
    
    StringConcatenation:
        ; Get first string
        ; Get second string
        ; Concatenate strings
        ; Display result

        jmp StringEnd
    
    StringCopy:
        ; Get string to copy
        ; Copy string
        ; Display success message
        ; Display original
        ; Display copy

        jmp StringEnd
    
    StringCompare:
        ; Get first string
        ; Get second string
        ; Compare strings
        ; Display result

        jmp StringEnd
    
    StringsNotEqual:
        mov edx, OFFSET compareNotEqual
        call WriteString
    
    StringEnd:
        call Crlf
        ret

StringModule ENDP

; String reversal function
ReverseString PROC
    ; ESI points to the string to reverse
    ; TODO: Implement string reversal logic here
    ; Steps:
    ; 1. Find string length (scan for null terminator)
    ; 2. Set up pointers: beginning and end of string
    ; 3. Swap characters until pointers meet
    
    ; For now, just return without modifying the string
    ret
ReverseString ENDP

; String concatenation function
ConcatenateStrings PROC
    ; ESI = first string, EDI = second string
    ; TODO: Implement string comparison logic here
    ; Steps:
    ; 1. Loop through both strings, comparing characters at each position
    ; 2. If characters differ, return 1 (not equal)
    ; 3. If null terminator is reached in both, return 0 (equal)
    ; 4. If one string ends before the other, return 1 (not equal)

    ; For now, just return without modifying the string
    ret
ConcatenateStrings ENDP

; String copy function
CopyString PROC
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
CopyString ENDP

; String comparison function
CompareStrings PROC
    ; ESI = first string, EDI = second string
    ; TODO: Implement string concatenation logic here
    ; Steps:
    ; 1. Find the null terminator of the first string (ESI)
    ; 2. Copy the second string (EDI) starting at that position
    ; 3. Ensure the final string is null-terminated

    ; For now, just return without modifying the string
    ret
CompareStrings ENDP

; ==================== MEMORY MANAGEMENT MODULE ====================
MemoryModule PROC
    mov edx, OFFSET memoryTitle
    call WriteString
    call Crlf
    
    ; Display memory operations menu
    mov edx, OFFSET memoryMenu
    call WriteString
    call ReadInt
    mov ebx, eax           ; Store choice in EBX
    
    cmp ebx, 1
    je CreateFreeMatrix
    cmp ebx, 2
    je AddMatrices
    
    ; Default to create/free matrix
    jmp CreateFreeMatrix
    
CreateFreeMatrix:
    call CreateAndFreeMatrix
    jmp MemoryEnd
    
AddMatrices:
    call AddTwoMatrices
    
MemoryEnd:
    call Crlf
    ret
MemoryModule ENDP

; Create and free matrix procedure
CreateAndFreeMatrix PROC
    ; TODO: Implement matrix creation and cleanup logic here
    ; Steps:
    ; 1. Get matrix dimensions from user
    ; 2. Calculate memory required (rows × columns × element_size)
    ; 3. Allocate memory for the matrix
    ; 4. Initialize matrix with values (optional pattern)
    ; 5. Display the created matrix
    ; 6. Free the allocated memory
    
    ; For now, just return without matrix operations
    ret
CreateAndFreeMatrix ENDP

; Add two matrices procedure
AddTwoMatrices PROC
    ; TODO: Implement matrix addition logic here
    ; Steps:
    ; 1. Get matrix dimensions from user (must be same for both matrices)
    ; 2. Allocate memory for three matrices: two inputs and one result
    ; 3. Fill input matrices with values (user input or generated)
    ; 4. Perform element-wise addition: result[i,j] = matrix1[i,j] + matrix2[i,j]
    ; 5. Display the resulting matrix
    ; 6. Free all allocated memory
    
    ; For now, just return without matrix operations
    ret
AddTwoMatrices ENDP

; Fill matrices with values
FillMatricesWithValues PROC
    ; TODO: Implement matrix value initialization logic here
    ; Steps:
    ; 1. For each matrix element position (row, column):
    ; 2. Calculate value for first matrix (e.g., pattern-based)
    ; 3. Calculate value for second matrix (e.g., different pattern)
    ; 4. Store values in respective matrix memory locations
    ; 5. Continue until all elements are filled
    
    ; For now, just return without filling matrices
    ret
FillMatricesWithValues ENDP

; Perform matrix addition
PerformMatrixAddition PROC
    ; TODO: Implement matrix arithmetic logic here
    ; Steps:
    ; 1. Verify matrices have compatible dimensions
    ; 2. Iterate through each element position (row, column):
    ; 3. Load corresponding elements from both input matrices
    ; 4. Add the elements together
    ; 5. Store result in corresponding position of result matrix
    ; 6. Continue until all elements are processed
    
    ; For now, just return without performing addition
    ret
PerformMatrixAddition ENDP

; Display matrix procedure
DisplayMatrix PROC
    ; EAX points to the matrix to display
    ; TODO: Implement matrix display logic here
    ; Steps:
    ; 1. Iterate through each row of the matrix
    ; 2. For each row, display row header/label
    ; 3. Iterate through each column in the current row
    ; 4. Format and display each matrix element
    ; 5. Add proper spacing between elements
    ; 6. Move to next line after each row
    ; 7. Continue until entire matrix is displayed

    ; For now, just return without displaying
    ret
DisplayMatrix ENDP

END main
