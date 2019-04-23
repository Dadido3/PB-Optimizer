# PB-Optimizer

This is going to be an optimizer for the [FAsm] output of [PureBasic].
This includes a parser for FAsm files, an analyzer and (later) algorithms to optimize the code.
The analyzer examines the control flow and generates a list of dependencies between the instructions.
Afterwards, this information can be used by the optimizer.

**Planned optimizations:**

- Removing of not executed code
- Removing of code which has no influence
- Inlining of subroutines
- Inlining of PeekX and PokeX and other PB functions

## State

Development has stopped, and the software is not in a usable state.
Code analysis works, and the software is able to generate a dependency graph, even though a lot of opcodes are missing.
The analyzer is also able to calculate the stack pointer offset, but there are problems when the offset is manipulated inside a loop, or if a function with pushed parameters is called.

Here is a visualization of some assembly code:

![control flow and dependencies][img dependencies]

The stack pointer offset (In red) at the label `_For20` is misscalculated, because it's not known how the function calls inside that loop manipulate the stack pointer.

## Usage

Beside the fact, that it's not in a usable state yet.
The way this optimizer was meant to be used, was to replace the `fasm.exe` inside PureBasic's compiler directory.

But you can just compile it, or start it inside the repository folder. It will then parse, analyze and visualize the file `Test/Test.asm`.

## License

This software is released under the [GPLv3].

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

[GPLv3]: ./LICENSE "View the GNU GPL license text"

[img dependencies]: ./Screenshots/deps.gif "Visualization of the control flow and dependencies"

[FAsm]: https://flatassembler.net/ "Visit FAsm website"
[PureBasic]: https://www.purebasic.com/ "Visit PureBasic website"
