# make test SYS=OSX-Chrome

test::
	mkdir -p results/
	rm -f results/$(SYS)-BlankCanvas.csv
	./dist/build/blank-canvas-mark/blank-canvas-mark --csv results/$(SYS)-BlankCanvas.csv -o tmp2.html


build::
	cabal sandbox init
	cabal sandbox add-source ../blank-canvas  # the latest version
	cabal sandbox add-source ../kansas-comet
	cabal sandbox add-source ../javascript-bridge
	cabal install --dependencies-only   
	cabal configure
	cabal build
	cabal install

results::
	echo 
