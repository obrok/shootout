.PHONY: run

run: shootout
	./shootout

shootout: main.cpp libshootout.a shootout.h
	g++ -o shootout -L. -lponyrt -lshootout main.cpp

libshootout.a: *.pony
	ponyc -l

shootout.h: *.pony
	ponyc -l
