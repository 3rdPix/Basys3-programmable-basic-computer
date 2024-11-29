| Instruction            | arg1      | arg2      | Description                                                               |
|------------------------|-----------|-----------|---------------------------------------------------------------------------|
| MOV                    | A         | B         | Moves the value of regB into regA                                         |
|                        | B         | B         | Moves the value of regA into regB                                         |
|                        | A         | Literal   | Saves Literal into regA                                                   |
|                        | B         | Literal   | Saves Literal into regB                                                   |
|                        | A         | (Lit)     | Moves into regA the value found in Mem[Lit]                               |
|                        | B         | (Lit)     | Moves into regB the value found in Mem[Lit]                               |
|                        | (Lit)     | A         | Saves the value of regA into Mem[Lit]                                     |
|                        | (Lit)     | B         | Saves the value of regB into Mem[Lit]                                     |
|                        | A         | (B)       | Moves into regA the value found in Mem[B]                                 |
|                        | B         | (B)       | Moves into regB the value found in Mem[B]                                 |
|                        | (B)       | A         | Saves the value of regA into Mem[B]                                       |
|                        | (B)       | Literal   | Saves the value of Literal into Mem[B]                                    |
| ADD, SUB, AND, OR, XOR | A         | B         | Saves the value of regA op regB into regA                                 |
|                        | B         | A         | Saves the value of regA op regB into regB                                 |
|                        | A         | Literal   | Saves the value of regA op Literal into regA                              |
|                        | B         | Literal   | Saves the value of regA op Literal into regB                              |
|                        | A         | (Literal) | Saves the value of regA op Mem[Literal] into regA                         |
|                        | B         | (Literal) | Saves the value of regA op Mem[Literal] into regB                         |
|                        | (Literal) |           | Saves the value of regA op regB into Mem[Literal]                         |
|                        | A         | (B)       | Saves the value of regA op Mem[B] into regA                               |
|                        | B         | (B)       | Saves the value of regA op Mem[B] into regB                               |
| NOT, SHL, SHR          | A         |           | Saves the value or op regA into regA                                      |
|                        | B         | A         | Saves the value of op regA into regB                                      |
|                        | (Literal) | A         | Saves the value of op regA into Mem[Literal]                              |
|                        | (B)       | A         | Saves the value of op regA into Mem[B]                                    |
| INC                    | A         |           | Saves regA + 1 into regA                                                  |
|                        | B         |           | Saves regB +1 into regB                                                   |
|                        | (Literal) |           | Saves Mem[Literal] + 1 into Mem[Literal]                                  |
|                        | (B)       |           | Saves Mem[B] + 1 into Mem[B]                                              |
| DEC                    | A         |           | Saves A – 1 into regA                                                     |
| CMP                    | A         | B         | Performs a comparative SUB A, B without altering regA or regB             |
|                        | A         | Literal   | Performs a comparative SUB A, Literal without altering regA or regB       |
|                        | A         | (Literal) | Performs a comparative SUB A, Mem[Literal] without altering regA or regB  |
|                        | A         | (B)       | Performs a comparative SUB A, Mem[B] without altering regA or regB        |
| JMP                    | Literal   |           | Inconditional jump into ROM[Literal]                                      |
| JEQ                    | Literal   |           | Jump if equal into ROM[Literal]                                           |
| JNE                    | Literal   |           | Jump if not equal into ROM[Literal]                                       |
| JGT                    | Literal   |           | Jump if greater than into ROM[Literal]                                    |
| JGE                    | Literal   |           | Jump if greater or equal into ROM[Literal]                                |
| JLT                    | Literal   |           | Jump if less than into ROM[Literal]                                       |
| JLE                    | Literal   |           | Jump if less or equal into ROM[Literal]                                   |
| JCR                    | Literal   |           | Jump if the comparison instruction produced a carried bit                 |
| PUSH                   | A         |           | Saves the value of regA into Mem[SP]                                      |
|                        | B         |           | Saves the value of regB into Mem[SP]                                      |
| POP                    | A         |           | Saves the value of Mem[SP] into regA                                      |
|                        | B         |           | Saves the value of Mem[SP] into regB                                      |
| CALL                   | Literal   |           | Saves ROM[current address] into Mem[SP] and loads jumps into ROM[Literal] |
| RET                    |           |           | Jumps into ROM[Mem[SP]]                                                   |
| NOP                    |           |           | Does nothing                                                              |
