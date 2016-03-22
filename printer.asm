.data
                      #    # " !       ' & % $     + * ) (     / . - ,     3 2 1 0     7 6 5 4     ; : 9 8     ? > = <     C B A @     G F E D     K J I H     O N M L     S R Q P     W V U T     [ Z Y X     _ ^ ] \     c b a `     g f e d     k j i h     0 n m l     s r q p     w v u t     { z y x     | } ~ <-
	line1:	.word	0x50502000, 0x2040c020, 0x00002020, 0x00000000, 0x70702070, 0xf870f810, 0x00007070, 0x70000000,	0x70f07070, 0x70f8f8f0, 0x88087088, 0x70888880, 0x70f070f0, 0x888888f8, 0x70f88888, 0x00207000, 0x00800020, 0x00300008, 0x80102080, 0x00000060, 0x00000000, 0x00000040, 0x10000000, 0x00404020
	line2:	.word	0x50502000, 0x20a0c878, 0x20a81040, 0x08000000, 0x88886088, 0x08888030, 0x00008888, 0x88400010, 0x88888888, 0x88808088, 0x90082088, 0x8888d880, 0x88888888, 0x88888820, 0x40088888, 0x00501080, 0x00800020, 0x00400008, 0x80000080, 0x00000020, 0x00000000, 0x00000040, 0x20000000, 0x00a82020
	line3:	.word	0xf8502000, 0x20a01080, 0x20701040, 0x10000000, 0x08082098, 0x1080f050, 0x20208888, 0x0820f820, 0x80888898, 0x80808088, 0xa0082088, 0x88c8a880, 0x80888888, 0x88888820, 0x40105050, 0x00881040, 0x70f07010, 0x70e07078, 0x903060f0, 0x70f8f020, 0x78b878f0, 0xa88888f0, 0x20f88888, 0x00102020
	line4:	.word	0x50002000, 0x00402070, 0xf8d81040, 0x2000f800, 0x301020a8, 0x20f80890, 0x00007870, 0x30100040, 0x80f088a8, 0x80f0f088, 0xc00820f8, 0x88a88880, 0x70f088f0, 0x88888820, 0x40202020, 0x00001020, 0x88880800, 0x88408888, 0xa0102088, 0x8888a820, 0x80488888, 0xa8888840, 0x40108850, 0x00001020
	line5:	.word	0xf8002000, 0x00a84008, 0x20701040, 0x40000030, 0x082020c8, 0x208808f8, 0x20200888, 0x2020f820, 0x8088f898, 0xb8808088, 0xa0882088, 0x88988880, 0x08a08880, 0xa8888820, 0x40402050, 0x00001010, 0x80887800, 0x8840f888, 0xc0102088, 0x8888a820, 0x70408888, 0xa8508840, 0x20208820, 0x00002020
	line6:	.word	0x50000000, 0x009098f0, 0x20a81040, 0x80000030, 0x88402088, 0x20888810, 0x20008888, 0x00400010, 0x88888880, 0x88808088, 0x90882088, 0x88888880, 0x88909880, 0xd8508820, 0x40802088, 0x00001008, 0x80888800, 0x78408088, 0xa0102088, 0x8888a820, 0x084078f0, 0xa8508840, 0x20407850, 0x00002020
	line7:	.word	0x50002000, 0x00681820, 0x00002020, 0x00200010, 0x70f87070, 0x20707010, 0x00007070, 0x20000000, 0x70f08878, 0x7080f8f0, 0x88707088, 0x708888f8, 0x70887880, 0x88207020, 0x70f82088, 0xf8007000, 0x78f07800, 0x08407878, 0x90907088, 0x7088a870, 0xf0400880, 0x50207830, 0x10f80888, 0x00004020
	line8:	.word	0x00000000, 0x00000000, 0x00000000, 0x00000020, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xf0000000, 0x00600000, 0x00000000, 0x00000880, 0x00000000, 0x00007000, 0x00000000
	
	word: .space 80
	space: .asciiz " "
	enter: .asciiz "Please enter a filename: "
	filename: .space 100
	fnf: .asciiz "I'm sorry, I was unable to locate your file. Check your file locations and try again"
	
.text
#has user enter name of file
fileEntry:
	li $v0, 4
	la $a0, enter
	syscall
	
	li $v0,8        #take in input
        la $a0, filename #load byte space into address
        li $a1, 20      # allot the byte space for string
        syscall
        lb $s3, space
        addi $t1, $zero, 0
#looks for newline char
lookForNewLine:
	lb $t7, filename($t1)
 	beq $t7, 10, replaceNewLine
 	addi $t1, $t1, 1
 	j lookForNewLine
#replaces nl char	
replaceNewLine:
	sb $s3, filename($t1)
	j openFile
	
openFile:
 	###############################################################
 	 # Open a file
 	 li   $v0, 13       # system call for open file
 	 la   $a0, filename      # input file name
 	 li   $a1, 0        # Open for reading (flags are 0: read, 1: write)
 	 li   $a2, 0        # mode is ignored
 	 syscall            # open a file (file descriptor returned in $v0)
 	 move $s6, $v0      # save the file descriptor 
 	 bltz $v0, no
 	 ##############################################################
actualNewLine:
	addi $s7, $zero, 0
	addi $s0, $zero, 0
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	addi $t2, $zero, 0 
	addi $t8, $zero, 0 
bufferRead:
  	# Read from file just opened
 	 li   $v0, 14       # system call for read from file
 	 move $a0, $s6      # file descriptor 
 	 la   $a1, word($s7)   # address of buffer from which to read 
 	 li   $a2, 1      # hardcoded buffer length
 	 syscall            # write to file
 	 lb $t0, word($s7)
 	 beq $t0, 10, doNotInclude
 	 addi $s7,$s7, 1
 	 b bufferRead
doNotInclude:
	lb $s3, space
	sb $s3, word($s7) 
	addi $s7, $s7, 1 
	beq $s7, 80, lineOne
        j doNotInclude
  	
lineOne:
	addi $t0, $zero, 0 #placeholder for character
	
newLine:
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineOne:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line1($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineOne
	bne $t6, 5, getLineOne
lastCharLineOne:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line1($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineOnePart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line1($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line1($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineOnePart3
	jal printMe
	beq $t7, 5, lineTwo
	addi $t0, $t0, 1
	j getLineOne
getLineOnePart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l1p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line1($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineOnePart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l1p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l1p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line1($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l1p1
	jr $ra
	
lineTwo:
	addi $t0, $zero, 0 #placeholder for character
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineTwo:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line2($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineTwo
	bne $t6, 5, getLineTwo
lastCharLineTwo:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line2($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineTwoPart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line2($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line2($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineTwoPart3
	jal printMe
	beq $t7, 5, lineThree
	addi $t0, $t0, 1
	j getLineTwo
getLineTwoPart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l2p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line2($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineTwoPart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l2p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l2p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line2($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l2p1
	jr $ra
lineThree:
	addi $t0, $zero, 0 #placeholder for character
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineThree:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line3($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineThree
	bne $t6, 5, getLineThree
lastCharLineThree:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line3($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineThreePart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line3($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line3($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineThreePart3
	jal printMe
	beq $t7, 5, lineFour
	addi $t0, $t0, 1
	j getLineThree
getLineThreePart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l3p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line3($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineThreePart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l3p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l3p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line3($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l3p1
	jr $ra
	
lineFour:
	addi $t0, $zero, 0 #placeholder for character
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineFour:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line4($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineFour
	bne $t6, 5, getLineFour
lastCharLineFour:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line4($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineFourPart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line4($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line4($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineFourPart3
	jal printMe
	beq $t7, 5, lineFive
	addi $t0, $t0, 1
	j getLineFour
getLineFourPart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l4p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line4($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineFourPart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l4p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l4p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line4($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l4p1
	jr $ra	
	
lineFive:
	addi $t0, $zero, 0 #placeholder for character
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineFive:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line5($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineFive
	bne $t6, 5, getLineFive
lastCharLineFive:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line5($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineFivePart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line5($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line5($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineFivePart3
	jal printMe
	beq $t7, 5, lineSix
	addi $t0, $t0, 1
	j getLineFive
getLineFivePart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l4p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line5($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineFivePart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l5p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l5p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line5($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l5p1
	jr $ra	

lineSix:
	addi $t0, $zero, 0 #placeholder for character
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineSix:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line6($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineSix
	bne $t6, 5, getLineSix
lastCharLineSix:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line6($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineSixPart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line6($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line6($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineSixPart3
	jal printMe
	beq $t7, 5, lineSeven
	addi $t0, $t0, 1
	j getLineSix
getLineSixPart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l6p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line6($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineSixPart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l6p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l6p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line6($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l6p1
	jr $ra	

lineSeven:
	addi $t0, $zero, 0 #placeholder for character
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineSeven:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line7($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineSeven
	bne $t6, 5, getLineSeven
lastCharLineSeven:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line7($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineSevenPart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line7($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line7($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineSevenPart3
	jal printMe
	beq $t7, 5, lineEight
	addi $t0, $t0, 1
	j getLineSeven
getLineSevenPart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l7p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line7($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineSevenPart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l7p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l7p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line7($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l7p1
	jr $ra	

lineEight:
	addi $t0, $zero, 0 #placeholder for character
	addi $t6, $zero, 0 #counter for the program
	addi $t7, $zero, 0 #counter for line on printer 	
getLineEight:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line8($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	beq $t6, 5, lastCharLineEight
	bne $t6, 5, getLineEight
lastCharLineEight:
	sll $t8, $t8, 2     #add first two bits of the next character to t8
	lb $t1, word($t0)
	srl $t1, $t1, 6
	andi $t1, $t1, 3
	or $t8, $t8, $t1
	jal printMe        #print and refresh t8
	lb $t1, word($t0)  #add last four bits of that character to first 4 bits of t8
	sub $t1, $t1, 32
	lb $t2, line8($t1) 
	sll $t2, $t2, 26
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	addi $t0, $t0, 1 
	addi $t6, $zero, 1
	jal getLineEightPart2
	sll $t8, $t8, 4
	lb $t1, word($t0) #add first four bits of the next character to last 4 of $t8
	sub $t1, $t1, 32
	lb $t2, line8($t1)
	sll $t2, $t2, 24
	srl $t2, $t2, 28
	or $t8, $t8, $t2
	jal printMe
	lb $t1, word($t0)#add last two bits of that character to beginning of t8
	sub $t1, $t1, 32
	lb $t2, line8($t1)
	sll $t2, $t2, 28
	srl $t2, $t2, 30 
	or $t8, $t8, $t2
	addi $t6, $t6, 1
	jal getLineEightPart3
	jal printMe
	beq $t7, 5, done
	addi $t0, $t0, 1
	j getLineEight
getLineEightPart3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t0, $t0, 1
	jal l8p1
	sll $t8, $t8, 6
	lb $t1, word($t0)
	lb $t5, word($t1)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line8($t1)
	andi $t2, $t2, 255
	srl $t2, $t2, 2 
	or $t8, $t8, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	addi $t7, $t7, 1 
	jr $ra
	
getLineEightPart2:
	addi  $sp, $sp, -4
	sw $ra, 0($sp)
	jal l8p1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
l8p1:
	addi $t9, $zero, 0
	sll $t8, $t8, 8    #make room for character byte 
	lb $t1, word($t0)
	sub $t1, $t1, 32   #get place in ascii table
	lb $t2, line8($t1)
	andi $t2, $t2, 255
	or $t8, $t8, $t2   #put the character in t8 to be printed
	srl $t8, $t8, 2    #do not need two last bits
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	bne $t6, 5, l8p1
	jr $ra	

printMe:
	addi $t9, $zero, 1
	addi $t8, $zero, 0
	addi $t6, $zero, 0 
	jr $ra
done:
	addi $t8, $zero, 0
	addi $t9, $zero, 1
	addi $s0, $s0, 1
	blt $s0, 75, done
	b actualNewLine
finish:
	li $v0, 10
	syscall
#if the program cant find file, then exit and have user fix file locations
no:
	li $v0, 4
	la $a0, fnf
	syscall
	
	li $v0, 10
	syscall
	
