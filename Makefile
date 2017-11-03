.PHONY: run

shootout: *.pony
	ponyc

run: shootout
	./shootout > positions.dat && gnuplot plot.plt > plot.html && open plot.html
