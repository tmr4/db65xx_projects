# Sieve in C for db65xx

## Build Notes

I've created a C library, `\Release\sieve.lib`, to work with the C-based `Sieve of Eratosthenes` example project.  While more expansive than `hello.lib` in the `hello world` example project, this library is still pretty minimal, basically just enough to support the `sieve` function used in the program and allow changing the variable types as discussed in my [blog post](https://trobertson.site/6502-debugging-the-sieve-of-eratosthenes-with-the-vs-code-db65xx-debugging-extension/) that examines debugging this project.

While it isn't hard to create a C library for a custom 65xx build, it isn't exactly straight forward creating one from scratch.  The cc65 documentation doesn't provide a lot of details on going about it.  In the end, I started with a library containing just the startup code required by db65xx, based on some cc65 library examples.  I then kept adding cc65's standard modules until `sieve.c` would compile.

## Viewing Local Variables

Two additional steps are needed to view local variables in C functions:

* C functions must be declared using the `cdecl` or `__cdecl__` keywords when declaring C functions or use the `--all-cdecl` command line option when running cc65.

* Assemble the C library module `zeropage.s` with debug information enabled by specifying `.debuginfo +` at the beginning of the file or assembling it with the `-g` command line option.  I've done this for `sieve.lib`.

## Debugging Notes

While traditional debug stepping is now available in db65xx, inspecting C-based local variables is not yet available.  See the blog post linked above for work arounds.
