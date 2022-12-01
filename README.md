# db65xx Example Projects

Here are a few example projects to try out with the [VS Code db65xx extension](https://marketplace.visualstudio.com/items?itemName=TRobertson.db65xx).

## Projects

### Basic terminal I/O

Example of integrated terminal I/O.  Prints `Hello world!` to the terminal and accepts keyboard input into a 256-character circular input buffer.

* [hello_world](https://github.com/tmr4/db65xx_projects/tree/main/hello_world)

### Interrupt driven I/O

Example of interrupt driven I/O.  Uses the 65C22 shift register for keyboard input and the 65C51 for terminal output and file input.

* [int_io](https://github.com/tmr4/db65xx_projects/tree/main/int_io)

### 32-bit Floating Point Package Test

Example of using the [32-bit floating point package](https://github.com/tmr4/fp32).  The test adds the value `1.1234` to the floating-point stack.  Inspect `[FPSP:FPSP+7]` in the Watch pane or Debug Console to see the value on the top of the floating-point stack.

* [fp32](https://github.com/tmr4/db65xx_projects/tree/main/fp32)

### Play chess with Toledo Atomchess 6502

Play chess with a cc65 port of Óscar Toledo's [Toledo Atomchess 6502](https://github.com/nanochess/Atomchess-6502).

* [chess](https://github.com/tmr4/db65xx_projects/tree/main/chess)

### C-based Hello World

Example of C-based debugging.

* [hello_world_c](https://github.com/tmr4/db65xx_projects/tree/main/hello_world_c)

## Building the Example Projects

NMake build tasks are provided for each project.  Just open an example project in VS Code and press `shift-ctl-B` to build it.  Start debugging with `F5`.

You may need to modify a project's `tasks.json` and `Makefile` if you use different build tools.

These projects assume your CC65 executables are located in `c:\cc65`.  If this isn't the case you'll need to edit the `E` variable in the Makefile for each project.  For example edit line 1  in [hello world Makefile](hello_world\Release\Makefile) for the location of your cc65 executables.

C-based projects assume you've set the `CC65_INC` and/or `CC65_HOME` environment variable(s) to indicate the location of cc65 include files.  If not, you'll need to modify the cc65 inference rule in the `Makefile` as appropriate.

## Screenshots

### Basic terminal I/O

![Screenshot of db65xx debugger](https://trobertson.site/wp-content/uploads/2022/11/db65xx_hw.png)

### Interrupt driven I/O

![Screenshot of db65xx debugger](https://trobertson.site/wp-content/uploads/2022/11/db65xx_int_io.png)

### 32-bit Floating Point Package Test

![Screenshot of db65xx debugger running with floating-point package](https://trobertson.site/wp-content/uploads/2022/11/db65xx_fp32.png)

### Play chess with Toledo Atomchess 6502

![Screenshot of db65xx debugger running Toledo Atomchess 6502](https://trobertson.site/wp-content/uploads/2022/11/chess.png)

### C-based Hello World

![Screenshot of db65xx debugger running with floating-point package](https://trobertson.site/wp-content/uploads/2022/12/hello_c.png)
