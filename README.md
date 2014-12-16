blank-canvas-mark
=================

benchmarks for blank canvas

## To run Haskell

    $ cabal build
    $ ./dist/build/blank-canvas-mark/blank-canvas-mark -o foo.html -u foo.csv

or

    $ ./dist/build/blank-canvas-mark/blank-canvas-mark -o foo.html -u foo.csv Bezier


## To run JavaScript

### OS X
    $ cd js
    $ open benchmark.html

To run a single test, use URL with dut

    file:///.../benchmark.html?dut=Bezier

### Linux/BSD
    $ cd js
    $ xdg-open benchmark.html
