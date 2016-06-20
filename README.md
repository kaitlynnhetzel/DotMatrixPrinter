# DotMatrixPrinter
A Dot-Matrix Printer written in Assembly (MIPS)

<h1> Overview </h1>
<p>Written for: Computer Organization and Assembly Language </p>
<p>Product: A dot-matrix esque virtual printer, written in Assembly (MIPS)</p>

<p>In this Dot Matrix printer, the program reads in a text file and then outputs on the virtual printer the contents of the file, pixel by pixel. <p>
<p> Each letter is about 5 individual pixels across and 8 individual pixels down. When the progra reads in the text from the file, it converts the letter
into the correct pixels using the charts up at the top of the program file. With this chart, the pixels are marked in binary, with a 1 meaning a black
pixel, and 0 meaning a white pixel. For an example, say we want the letter H </p>

<p> In the end, we want our H to look something like this (simplified for easier viewing): </p>
<p>
10010</p>
<p>
11110  
</p> <p>
10010
</p>

<p> If you look where the 1s are, you can see the shape of a H take form! <p>

<p> We feed these binary numbers to the printer GUI, and we can see our text being printed out on virtual paper! </p>




