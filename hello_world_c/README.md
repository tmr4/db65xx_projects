# Hello World in C for db65xx

## Build Notes

I've created a C library, `\Release\hello.lib`, to work with the C-based `Hello World example project`.  This is a really minimal library, basically just enough to support the `cprintf` function used in the program.

While it isn't hard to create a C library for a custom 65xx build, it isn't exactly straight forward creating one from scratch.  The cc65 documentation doesn't provide a lot of details on going about it.  In the end, I started with a library containing just the startup code required by db65xx, based on some cc65 library examples.  I then kept adding cc65's standard modules until `hello.c` would compile.

## Viewing Local Variables

The `hello.lib` file doesn't include the debug information needed to display local variables.  See the `sieve_c` project for the changes necessary to enable this.
