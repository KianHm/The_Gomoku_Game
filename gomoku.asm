
.data
player1: 	.byte 'O'
player2: 	.byte 'X'
msg_p1: 	.asciiz "Player 1's turn!"
msg_p2: 	.asciiz "Player 2's turn!\n"
winner1:	.asciiz "Player 1 is winner!"
winner2:	.asciiz "Player 2 is winner!"
msg_row: 	.asciiz "Enter row: "
msg_col: 	.asciiz "Enter column: "
newLine: 	.asciiz "\n"
errormsg:	.asciiz "Invalid Input"

boardTot: 	.byte ' ', ' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', ' ', ' '
			.byte '1', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '1', ' '
			.byte '2', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '2', ' '
			.byte '3', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '3', ' '
			.byte '4', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '4', ' '
			.byte '5', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '5', ' '
			.byte '6', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '5', ' '
			.byte '7', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '7', ' '
			.byte '8', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '8', ' '
			.byte '9', ' ', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '9', ' '
			.byte '1', '0', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '1', '0'
			.byte '1', '1', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '1', '1'
			.byte '1', '2', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '1', '2'
			.byte '1', '3', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '1', '3'
			.byte '1', '4', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '1', '4'
			.byte '1', '5', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '1', '5'
			.byte ' ', ' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', ' ', ' '
.text
main:
	addi $t0, $zero, 16 		#BOARD_ROWS
	addi $t1, $zero, 18 		#BOARD_COLS
	addi $t2, $zero, 0 			#row index
	addi $t3, $zero, 0 			#column index
	addi $t4, $zero, 0 			#print index	
	
	la $a2, boardTot			#board 2d array address
	li $t5, 0					#start index
	li $t6, 19					#count of one row
	sub $sp,$sp,4
	sw $ra, 0($sp)				#save return addresses to sp
	jal PrintBoard				#call printboard function
	lw $ra, 0($sp)				#recover sp
	add $sp,$sp,4
	
	j player1Turn				#jmp to first turn
	
	li, $v0, 10 				#ending program
	syscall
	
PrintBoard:
	bgt $t4, 323, FINISHPOS		#all printed then finish
	#addi $t5, $t5, 1
	beq $t6, $t5, newLinePrint	#if printed 8 character then print new line
PrintRows: 						#Main game play loop
	bgt $t2, $t0, PrintColumn 	# using row-major formula
	mul $t1, $t1, $t2 			#B.A. + (i*n+j) * size
	add $t1, $t1, $t3 			#2D Address calculation
	mul $t1, $t1, 1
	add $t1, $a2, $t1
	li $v0, 4
	move $a0, $t1
	lb $a0, ($a0)				#PRINT CHARACTER SYSTEM CALL a0 is chracter
	li $v0, 11					#v0 is syscall number
	syscall
	addi $t3, $t3, 1			#add indexes
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	j PrintBoard
PrintColumn:					#check column
	addi $t2, $t2, 1
	addi $t3, $zero, 0			#add columns
	addi $t4, $t4, 1
	j PrintBoard				#jump to first position
newLinePrint:					#print newlines
	li $t5, 0
	la $a0, newLine				#new line \n print
	li $v0, 4
	syscall
	j PrintBoard				#jmp to first position
FINISHPOS:
	jr $ra						#return to caller address
	
player1Turn:
	li $v0, 4
	la $a0, msg_p1 				#printing string, user's input
	syscall
	
	li $v0, 4
	la $a0, newLine				#new line \n print
	syscall
	
	li $v0, 4
	la $a0, msg_row
	syscall
		
	li $v0, 5
	syscall

	move $a3, $v0
	
	li $v0, 4
	la $a0, msg_col
	syscall
		
	li $v0, 5
	syscall
	
	move $a1, $v0
	move $a0, $a3
	
	li $t7, 'O'					#player's code O
	
	sub $sp,$sp,4
	sw $ra, 0($sp)				#save return address to sp
	jal saveToboard				#save number to board array
	lw $ra, 0($sp)
	add $sp,$sp,4				#recover sp
	
	li $t0, 1
	beq $t7, $t0, player1Turn
	
	addi $t0, $zero, 16 		#BOARD_ROWS
	addi $t1, $zero, 18 		#BOARD_COLS
	addi $t2, $zero, 0			#row index
	addi $t3, $zero, 0 			#column index
	addi $t4, $zero, 0 			#print index
	
	la $a2, boardTot			#board 2d array address
	li $t5, 0					#start index
	li $t6, 19					#count of one row
	
	sub $sp,$sp,4
	sw $ra, 0($sp)				#save return addresses to sp
	jal PrintBoard				#call printboard function
	lw $ra, 0($sp)				#recover sp
	add $sp,$sp,4
	
	sub $sp,$sp,4
	sw $ra, 0($sp)				#save return address to sp
	jal checkWinner				#check winner
	lw $ra, 0($sp)				#recover sp.
	add $sp,$sp,4
	
	li $t0, 0
	beq $v0, $t0, player2Turn	#if there is no winner then goto next player
	
	li, $v0, 10 				#ending program	
	syscall
	
player2Turn:

	li $v0, 4
	la $a0, msg_p2 				#printing string, user's input
	syscall
	
	li $v0, 4
	la $a0, newLine				#new line \n print
	syscall
	
	li $v0, 4
	la $a0, msg_row				#new line \n print
	syscall
		
	li $v0, 5
	syscall

	move $a3, $v0
	
	li $v0, 4
	la $a0, msg_col				#new line \n print
	syscall
		
	li $v0, 5
	syscall
	
	move $a1, $v0
	move $a0, $a3
	
	li $t7, 'X'					#player's code X
	
	sub $sp,$sp,4
	sw $ra, 0($sp)				#save return address to sp
	jal saveToboard				#save B's data to board
	lw $ra, 0($sp)				#recover sp
	add $sp,$sp,4
	
	li $t0, 1
	beq $t7, $t0, player2Turn
	
	addi $t0, $zero, 16 		#BOARD_ROWS
	addi $t1, $zero, 18 		#BOARD_COLS
	addi $t2, $zero, 0 		#row index
	addi $t3, $zero, 0 			#column index
	addi $t4, $zero, 0 			#print index
	
	la $a2, boardTot			#board 2d array address
	li $t5, 0					#start index
	li $t6, 19					#count of one row
	
	sub $sp,$sp,4
	sw $ra, 0($sp)								#save return address to sp
	jal PrintBoard								#print board
	lw $ra, 0($sp)								#recover sp
	add $sp,$sp,4
	
	sub $sp,$sp,4
	sw $ra, 0($sp)								#save return address to sp
	jal checkWinner								#check winner
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4
	
	li $t0, 0
	beq $v0, $t0, player1Turn					#if there is no winner then goto next player'sturn

	li, $v0, 10 								#ending program	
	syscall
	
saveToboard:									#save data to board array
	la $a2,boardTot
	addi $t1, $zero, 17							#numbers of row
	addi $t0, $zero, 19     
	
	bgt $a0, 15, INVALID_INPUT					#if we input index larger then 15 error
	blt $a0, 0, INVALID_INPUT					#if we input index larger then 0 error
	bgt $a1, 15, INVALID_INPUT					#if we input index larger then 15 error
	blt $a1, 0, INVALID_INPUT					#if we input index larger then 0 error
	addi $t2, $zero, 1							#init vals
NEXT:	
	mul $t4, $t0, $a0							#get current possition
	add $t4, $t4, $a1
	add $t4, $t4, $t2
	add $t4, $a2, $t4
	lb $t2, ($t4)								#get possition value
	li $t3, '.'		
	bne $t2, $t3, INVALID_INPUT						#check empty 'o' else found next pos
	sb $t7, ($t4)								#if empty, we put data to that position.
	j FINI
INVALID_INPUT:
	li $v0, 4
	la $a0, errormsg 							#printing string, user's input
	syscall
	
	li $v0, 4
	la $a0, newLine								#new line \n print
	syscall
	
	li $t7, 1
FINI:
	jr $ra										#return to caller

checkWinner:									#check winner function
	la $a2,boardTot								#board array address
	addi $t1, $zero, 0
	addi $t2, $zero, 0							#init variables
	
MOVENEXT1:										#this is check for horizontal part
	addi $t0, $zero, 19							# get first address of data
	mul $t0, $t1, $t0							# from array(0,0) check like this
	add $t0, $t0, 0
	add $t0, $t0, $t2
	add $t0, $a2, $t0
	
	sub $sp,$sp,4								#save return address to sp
	sw $ra, 0($sp)
	jal CHECK_HORIZONTAL						#check horizontal same 	
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4
	
	li $t0, 1									#next address check 
	beq $v0, $t0, FOUND							#if found finish
	li $t0, 14
	addi $t2, $t2, 1							#check avaible index
	blt $t2, $t0, MOVENEXT1
	li $t2, 0
	addi $t1, $t1, 1							#check available index
	li $t0, 16
	beq $t1, $t0, MOVENEXTSERACH2				#if not found then goto next search method
	j MOVENEXT1									#loop to first position
	
MOVENEXTSERACH2:
    addi $t1, $zero, 0							#init loop variables
	addi $t2, $zero, 0
	
MOVENEXT2:
	addi $t0, $zero, 19							#this is vertical find
	mul $t0, $t1, $t0							# from (0,0) we find like this
	add $t0, $t0, 1
	add $t0, $t0, $t2
	add $t0, $a2, $t0
	
	sub $sp,$sp,4
	sw $ra, 0($sp)								#save return address to sp
	jal CHECK_VERTICAL							#find vertical
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4
	
	li $t0, 1
	beq $v0, $t0, FOUND							#check available start index
	li $t0, 18									#if found finish
	addi $t2, $t2, 1
	blt $t2, $t0, MOVENEXT2						#goto firstpositon
	li $t2, 0
	addi $t1, $t1, 1
	li $t0, 12
	beq $t1, $t0, MOVENEXTSERACH3				#we start from here
	j MOVENEXT2
	
MOVENEXTSERACH3:								#check next search
	addi $t1, $zero, 0							#init indexes
	addi $t2, $zero, 0	
MOVENEXT3:
	addi $t0, $zero, 19							# from start point, we find 
	mul $t0, $t1, $t0
	add $t0, $t0, 1
	add $t0, $t0, $t2
	add $t0, $a2, $t0
	
	sub $sp,$sp,4								#save return address to sp
	sw $ra, 0($sp)
	jal CHECK_DIAG								#check diag same
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4
	
	li $t0, 1
	beq $v0, $t0, FOUND							#check available and set first index
	li $t0, 14									#if found finish
	addi $t2, $t2, 1
	blt $t2, $t0, MOVENEXT3						#go to first position
	li $t2, 0
	addi $t1, $t1, 1					
	li $t0, 12
	beq $t1, $t0, MOVENEXTSERACH4				#if not found then goto next search
	j MOVENEXT3
	
MOVENEXTSERACH4:								#next search
	addi $t1, $zero, 17							#this is for diag search also reverse direction
	addi $t2, $zero, 0							#init vals
MOVENEXT4:
	addi $t0, $zero, 19							#from start, we find
	mul $t0, $t1, $t0
	add $t0, $t0, 1
	add $t0, $t0, $t2
	add $t0, $a2, $t0
	
	sub $sp,$sp,4								#save return address to sp
	sw $ra, 0($sp)
	jal CHECK_DIAG1								#check diag
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4
	
	li $t0, 1
	beq $v0, $t0, FOUND							#if found finish
	li $t0, 14
	addi $t2, $t2, 1
	blt $t2, $t0, MOVENEXT4						#not found then check start index
	li $t2, 0
	sub $t1, $t1, 1
	li $t0, 3
	beq $t1, $t0, NOTFOUND						#not found
	j MOVENEXT4	
	
FOUND:     
	li $v0, 1									#this is found position. return value is 1
	move $v1, $t3								#character is v3
	jr $ra
NOTFOUND:
	li $v0, 0									#not found then return value 0
	move $v1, $t3								#character v3
	jr $ra
	
CHECKSAME:										#check same function
	beq $t3, $t4, SAME1							# value is t3, t4, t5, t6, t7
	li $v0, 0									#we have to check all value is same
	jr $ra										#diffrent then return value 0
SAME1:											#if same goto next compuare
	beq $t3, $t5, SAME2
	li $v0, 0									#diffrent then return value 0
	jr $ra										#return to caller
SAME2:
	beq $t3, $t6, SAME3							#if same goto next compuare
	li $v0, 0									#diffrent then return value 0
	jr $ra										#return to caller
SAME3:
	beq $t3, $t7, SAME4							#if same goto next compuare
	li $v0, 0									#diffrent then return value 0
	jr $ra										#return to caller
SAME4:
	li $t7, 'O'									#check not empty
	beq $t3, $t7, PLAYER1WINNER					#if same goto next compuare
	li $t7, 'X'									#check not empty
	beq $t3, $t7, PLAYER2WINNER						#if same goto next compuare
	li $v0, 0									#diffrent then return value 0
	jr $ra
	
PLAYER1WINNER:
	li $v0, 4
	la $a0, winner1 							#printing "Player 1 is winner!"
	syscall
	
	li $v0, 4
	la $a0, newLine								#new line \n print
	syscall
	li $v0, 1									#all same, return value is 1
	jr $ra										#return to caller
	
PLAYER2WINNER:
	li $v0, 4
	la $a0, winner2 							#printing "Player 1 is winner!"
	syscall
	
	li $v0, 4
	la $a0, newLine								#new line \n print
	syscall
	li $v0, 1									#all same, return value is 1
	jr $ra										#return to caller

CHECK_HORIZONTAL:								#compuare horizontal same
	lb $t3, ($t0)
	add $t0, $t0, 1
	lb $t4, ($t0)
	add $t0, $t0, 1
	lb $t5, ($t0)
	add $t0, $t0, 1
	lb $t6, ($t0)
	add $t0, $t0, 1
	lb $t7, ($t0)
	
	sub $sp,$sp,4								#save return address to sp
	sw $ra, 0($sp)
	jal CHECKSAME								#check same function call
	lw $ra, 0($sp)
	add $sp,$sp,4								#recover sp.
	
	jr $ra
	
CHECK_VERTICAL:									#check vertical function
												# check vertically check
	lb $t3, ($t0)
	add $t0, $t0, 19
	lb $t4, ($t0)
	add $t0, $t0, 19
	lb $t5, ($t0)
	add $t0, $t0, 19
	lb $t6, ($t0)
	add $t0, $t0, 19
	lb $t7, ($t0)
	
	sub $sp,$sp,4
	sw $ra, 0($sp)								#save return address to sp
	jal CHECKSAME								#call checksame function
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4

	jr $ra
	
CHECK_DIAG:										#check diag function
												#get four element from start and compare
	lb $t3, ($t0)
	add $t0, $t0, 20
	lb $t4, ($t0)
	add $t0, $t0, 20
	lb $t5, ($t0)
	add $t0, $t0, 20
	lb $t6, ($t0)
	add $t0, $t0, 20
	lb $t7, ($t0)
	
	sub $sp,$sp,4
	sw $ra, 0($sp)								#save return address to sp
	jal CHECKSAME								#check same fucnction
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4
	
	jr $ra

CHECK_DIAG1:									#check diag function.
												#get four element from start and compare
	lb $t3, ($t0)
	sub $t0, $t0, 18
	lb $t4, ($t0)
	sub $t0, $t0, 18
	lb $t5, ($t0)
	sub $t0, $t0, 18
	lb $t6, ($t0)
	sub $t0, $t0, 18
	lb $t7, ($t0)
	
	sub $sp,$sp,4
	sw $ra, 0($sp)								#save return address to sp
	jal CHECKSAME								#check function
	lw $ra, 0($sp)								#recover sp.
	add $sp,$sp,4
	
	jr $ra
