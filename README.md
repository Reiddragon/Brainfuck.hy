# Brainfuck.hy
A Brainfuck interpreter written in Hy that's doing some probably really stupid shit

## Now for some behaviour details
- 30k cells holding uint8 values
    - the values wrap around when they overflow or underflow
    - the data pointer wraps around at the tape's ends

## ok but how does this work?
Glad you asked, in a very stupid way!
tl;dr: it "compiles" the code to a tree structure, with each loop being a nested Python list, this means I can just rely on the Python recursion stack for all the arbitrary jumps I need to do in the code
for details check the comments in the code :P

