# make test SYS=OSX-Chrome

test::
	mkdir -p results/
	./dist/build/blank-canvas-mark/blank-canvas-mark -u results/$(SYS)-BlankCanvas.csv


build::
	cabal sandbox init
	cabal sandbox add-source ../blank-canvas  # the latest version
	cabal sandbox add-source ../kansas-comet
	cabal install --dependencies-only   
	cabal configure
	cabal build
	cabal install

results::
	echo 
