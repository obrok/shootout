set terminal svg size 800,800 enhanced font 'Verdana,10'
set xrange [-100:100]
set yrange [-100:100]
plot 'positions.dat' using 1:2 with lines, 'positions.dat' using 3:4 with lines
