PB-Optimizer
=====

This is going to be an optimizer for the FAsm output of PureBasic.
This includes a parser for FAsm files, an analyzer and (later) algorithms to optimize the code.
The analyzer examines the control flow and generates a list of dependencies between the instructions.
Afterwards, this information can be used by the optimizer.

**Planned optimizations:**
- Removing of not executed code
- Removing of code which has no influence
- Inlining of subroutines
- Inlining of PeekX and PokeX and other PB functions

Visualization of the control flow and dependencies:
![<Image missing>](https://raw.githubusercontent.com/Dadido3/PB-Optimizer/master/Screenshots/Dependencies.png)

## License
This software is released under the [GPL](./License/GNU GPL v2.0.txt).
