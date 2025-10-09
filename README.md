## Virtual Machine Emulator

A comprehensive virtual machine emulator with arithmetic operation, string manipulation and memory management, matrix operations, and assembly instruction execution capabilities.

### Completed Features

- **Core Virtual Machine Architecture**
  - 6 General Purpose Registers (R0-R5)
  - Program Counter (EIP equivalent)
  - Status Flags (ZF, SF, OF, CF)
  - Call Stack for function calls
  - Data Stack for operations

- **Memory Management**
  - Virtual memory allocation and deallocation
  - Matrix memory management (A, B, C matrices)
  - Memory read/write operations
  - Address calculation for matrix elements

- **Instruction Set Architecture (ISA) Used need it in our own language**
  - Arithmetic: ADD, SUB, MOV
  - Memory: LOAD, STORE, ALLOC, FREE
  - Control Flow: JMP, JE, JNE, JL, JLE, CALL, RET
  - I/O: PRINT_STR, READ_INT, WRITE_INT, READ_CHAR
  - Matrix Operations: MATRIX_ALLOC_MEM, INPUT_MATRIX_A/B, MATRIX_ADD_OPERATION
  - System: CLRSC, HALT

- **User Interface Modules**
  - Main menu system with modular navigation
  - Calculator module framework
  - String operations module framework
  - Memory management module (fully implemented)
  - Proper module switching (option 5 returns to main menu)

- **Matrix Operations**
  - Dynamic matrix allocation
  - Matrix input/output
  - Matrix addition
  - Memory-efficient storage using base addresses

### Remaining Implementation

- **Calculator Module**
  - Addition procedure implementation
  - Subtraction procedure implementation  
  - Multiplication procedure implementation
  - Division procedure implementation

- **String Operations Module**
  - String reverse procedure
  - String concatenation procedure
  - String copy procedure
  - String comparison procedure

## Project Structure File
- AssemblyCode.asm : Holds the original assembly code
- VirtualEmulator.cpp : Holds the original emulator code
- Virtual_Emulator_GrpPrototype.cpp : Asimple prototype to get an idea on how the program will flow<br>
