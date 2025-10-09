Updated the assembly code with Memory Segment Module, and its complete...
have also updated menu, that each module option 5 has to be selcted to shift different modules. <br>
otherwise you can remain within the slected module and use it's option eg being in calculator module<br>
and you can select option od add/su/mul/div multiple times. selecting exit will send you back to main menu<br>
where you can select a different module let's say string or memory management


<br><br>
I have uploaded the main Virtual_Emulator.cpp file.
It has the complete menu flowing, along with flags, 6 general purpose register, memroy management,<br>
and matrix dealing using base addresses and stack for keeping track of labels, program counter to move through instruction<br>
plus it has fetch decode execute proerly working. Once your calculator and string part is written we will add it in here<br>

<br>
File Types:
AssemblyCode.asm : \t Holds the original assembly code<br>
VirtualEmulator.cpp : \t Holds the original emulator code<br>
Virtual_Emulator_GrpPrototype.cpp : \t a simple prototype to get an idea on how the program will flow<br>

<br>
Things need to be done.
1- Create an ISA
2- Will need to update Emulator according to it (make sure the program doesnt crash)
