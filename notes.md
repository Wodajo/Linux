#### compiler
A `compiler` creates `machine code` that runs on a processor with a specific `Instruction Set Architecture` (`ISA`), which is `processor-dependent`

`Compilers` are also `platform-dependent`.
That is, a compiler can convert C++, for example, to machine code that’s targeted at a platform that is running the Linux OS

A `cross-compiler`, however, can generate code for a platform other than the one it runs on itself.

Choosing a compiler then, means that first you need to know the `ISA`, `operating system`, AND the `programming language` that you plan to use.


#### assembler
An `assembler` translates a program written in `assembly language` into `machine code` (aka `object code`)

It's effectively a compiler for the assembly language, but can also be used interactively like an interpreter




`clipgrab` - gui for `yt-dlp`



To pipe:
```
 celldweller.xspf
'Enemy (from the series Arcane League of Legends).mp3'
'Imagine Dragons - Bones (Official Lyric Video).mp3'
'The Glitch Mob - Drink the Sea (10 Year Anniversary Full Album Visual).mp3'
'yt1s.com -Celldweller Wish Upon A Blackstar Full Album HD.mp3'
'yt1s.com -IndustrialElectronic Rock Celldweller End Of An Empire 2015 Full album.mp3'
'yt1s.com - Scandroid Scandroid Full Album.mp3'
```
into `file` use:
`find . -print0 | xargs -0 file`

