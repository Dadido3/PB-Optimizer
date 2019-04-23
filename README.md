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

Visualization of the control flow and dependencies:

![control flow and dependencies][img dependencies]

## License

This software is released under the [GPL].

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS                                
------------------------------------------------------------------------------>

[GPL]: ./License/GNU%20GPL%20v2.0.txt "View the GNU GPL license text"

[img dependencies]: ./Screenshots/Dependencies.png "Visualization of the control flow and dependencies"

[FAsm]: https://flatassembler.net/ "Visit FAsm website"
[PureBasic]: https://www.purebasic.com/ "Visit PureBasic website"
