# N-Queens in C for db65xx

## Build Notes

I've created a C library, `\Release\nqueens.lib`, to work with the C-based `N-Queens` example project.  This library adds modules to `sieve.lib` in the `sieve_c` example project, to support `STDIN` input and some other functions as discussed in my [blog post](https://trobertson.site/c-coding-tripped-up-by-a-carraige-return/) that examines the problems I had adding input to this project.

While it isn't hard to create a C library for a custom 65xx build, it isn't exactly straight forward creating one from scratch.  The cc65 documentation doesn't provide a lot of details on going about it.  In the end, I started with a library containing just the startup code required by db65xx, based on some cc65 library examples.  I then kept adding cc65's standard modules until `nqueens` would compile.

## Viewing Local Variables

Two additional steps are needed to view local variables in C functions:

* C functions must be declared using the `cdecl` or `__cdecl__` keywords when declaring C functions or use the `--all-cdecl` command line option when running cc65.

* Assemble the C library module `zeropage.s` with debug information enabled by specifying `.debuginfo +` at the beginning of the file or assembling it with the `-g` command line option.  I've done this for `nqueens.lib`.
