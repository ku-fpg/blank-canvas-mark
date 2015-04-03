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



### Environment


To use a weak remote monad

    $ BLANK_WEAK=1 ./dist/build/blank-canvas-mark/blank-canvas-mark 

To create a version of the benchmark that be be used across networks

   $ BLANK_REMOTE=1 ./dist/build/blank-canvas-mark/blank-canvas-mark 


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

## Results format

We store our results internally as json records. For each point, we use the following format.

##### Required

Field | Values | Notes
------|--------|------
test     | "blank-canvas-mark"         | Name of test set; required.
os       | "OSX" or "Linux"            | OS test run on
browser  | "Chrome" or "Firefox"       | 
platform | "Blank Canvas" or "JavaScript" | 
options  | "weak" and/or "web-sockets" | Optional 
name     | "Bezier", ...               | Name of specific benchmark
time     | (clock) runtime             | The data point, a mean
ub / lb  |  upper and lower bound on mean | 
confidence | 0.95                      | confidence in the mean
hash     | "ABC123"                    | Hash of specific device under test
raw      | {...}                       | Raw results to reproduce quality of mean
outliers | {...}                       | Quality of test data

The hash it there so we can compare like with like.

##### Optional

 * `_id`: optional unique id for each line
 * `report`: (individual report from criterion)


