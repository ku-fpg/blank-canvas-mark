blank-canvas-mark
=================

benchmarks for blank canvas

## To run Haskell

    $ make build
    $ make test SYS=OSX-Chrome

To access blank-canvas, use the URL:

   http://localhost:3000/?width=800&height=600

Other ways of running tests:

    $ ./dist/build/blank-canvas-mark/blank-canvas-mark -o foo.html -u foo.csv
OR
    $ ./dist/build/blank-canvas-mark/blank-canvas-mark -o foo.html -u foo.csv Bezier



## To run JavaScript

JavaScript automatically defaults to a canvas of 800x600

### OS X
    $ cd js
    $ open benchmark.html

To run a single test, use URL with dut

    file:///.../benchmark.html?dut=Bezier

### Linux/BSD
    $ cd js
    $ xdg-open benchmark.html


### To look at results

    $ python -m SimpleHTTPServer
    $ open http://localhost:8000/summary/results.html


