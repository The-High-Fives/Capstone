# Code Compilation

## To easily convert code to assembly for our compiler, use the following steps:

### 1. Congregate all the C source code into one file
All "#include" statements in C translate into pasting the code from that file anyway, so just paste away, but always do it in the following order:

    utils.h
    defs.h      (if needed)
    levels.h    (if needed)
    main.c      (or whichever file that has the main function in the case of testing)
    utils.c
    game.c      (if needed)
    levels.c    (if needed)

Then, remove any functions or definitions that aren't needed for the code being run (this is to cut down on the number of instructions which will make everything take less time and be a little more efficient)


### 2. Go to [GodBolt](https://godbolt.org/) and paste the C code.
Make sure to set the compiler on the right to be "RISC-V (32-bits) 8.2.0"

### 3. Go to [RISC-V Assembler](https://riscvasm.lucasteske.dev/) and paste the assembly from GodBolt.
Change the first line of the assembly after "main:" to be "lui sp,16" instead of "addi sp,sp,-16"

### 4. Copy the "Code Hex Dump" from the RISC-V assembler into a ".hex" file
Make sure the file extension is ".hex"

### 5. Run the python script found in this folder with the filename of the ".hex" file as a command line input
As a sanity check, make sure the number of lines in your original ".hex" file matches the newly created files (if the new files are longer, delete them and try again)

### 6. Done
Now, "init0.hex"-"init3.hex" should be ready to use!