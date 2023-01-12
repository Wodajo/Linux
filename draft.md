
#### compiler
A `compiler` creates `machine code` that runs on a processor with a specific `Instruction Set Architecture` (`ISA`), which is `processor-dependent`

`Compilers` are also `platform-dependent`.
That is, a compiler can convert C++, for example, to machine code that’s targeted at a platform that is running the Linux OS

A `cross-compiler`, however, can generate code for a platform other than the one it runs on itself.

Choosing a compiler then, means that first you need to know the `ISA`, `operating system`, AND the `programming language` that you plan to use.


#### assembler
An `assembler` translates a program written in `assembly language` into `machine code` (aka `object code`)

It's effectively a compiler for the assembly language, but can also be used interactively like an interpreter

