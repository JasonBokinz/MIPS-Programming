.data
ask_shape:    		.asciiz "Triangle(0) or Square(1) or Pyramid(2)? "
ask_size:		.asciiz "Required size? "
size_error_msg:		.asciiz "\nError: Size must be greater than zero.\n"
shape_error_msg:	.asciiz "\nError: Shape does not exist.\n"
star:			.asciiz "* "

.text
main:
	addi $sp, $sp, -12 	# allocate space on the stack
	sw $s0, 0($sp)		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $ra, 8($sp)		# preserve return address
	
    	li $v0, 4           	# syscall code for printing a string
    	la $a0, ask_shape   	# load address of ask_shape into $a0
    	syscall			# Ask the user for the choice of shape

	li $v0, 5   	# syscall code for reading an integer
    	syscall		# Read user's choice
    	move $s0, $v0	# $s0 contains the user's choice for shape
    	
    	move $a0, $s0	# move shape $a0 as an argument for each error	
    	blt $a0, 0, shape_error # if $s0 < 0, jump to shape_error
    	bgt $a0, 2, shape_error # if $s0 > 2, jump to shape_error

    	li $v0, 4           # syscall code for printing a string
    	la $a0, ask_size    # load address of ask_size into $a0
    	syscall		    # Ask the user for the size of the object

    	li $v0, 5      	# syscall code for reading an integer
    	syscall		# Read the size
    	move $s1, $v0  	# $s1 contains the user's choice for size
    	
    	# Check if the size is less than or equal to zero
    	move $a0, $s1	# move $a1 to $a0 as an argument for triangle, square, and pyramid
    	blez $a0, size_error # if size <= 0, jump to size_error

    	# Branch based on user's choice
    	beq $s0, 0, case_0 # branch to case_0 if shape ($s0) is 0
    	beq $s0, 1, case_1   # branch to case_1 if shape ($s0) is 1
    	beq $s0, 2, case_2  # branch to case_2 if shape ($s0) is 2
    	
    	case_0:
    		move $a0, $s1	# move size to $a0 as an argument for triangle
    		jal triangle	# jump and link to triangle
    		j end_switch		# jump to end_switch
    	case_1:
    		move $a0, $s1	# move size to $a0 as an argument for square
    		jal square	# jump and link to square
    		j end_switch		# jump to end_switch
    	case_2:
    		move $a0, $s1	# move size to $a0 as an argument for pyramid
    		jal pyramid	# jump and link to pyramid
    		j end_switch		#jump to end_switch
    	end_switch:
    		lw $s0, 0($sp)		# restore space for $s0
		lw $s1, 4($sp)		# restore space for $s1
    		lw $ra, 8($sp)		# restore return address
    		addi $sp, $sp, 12	# deallocate space on the stack
    		j exit
    	
	
triangle:
	addi $sp, $sp, -12 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $ra, 8($sp)		# preserve space for $ra
	move $s0, $a0		# move the $a0 which contains size into $s0
	li $s1, 0            	# $s1 = i
	li $a0, '\n'
    	li $v0, 11	     	# syscall code for printing a character
    	syscall
    	
	triangle_loop:
    		beq $s1, $s0, triangle_done 	# if current row number >= size, exit loop
    		addi $sp, $sp, -4 	# allocate space on the stack
    		sw $ra, 0($sp)		# store return address
    		addi $t1, $s1, 1	# number of stars is always i + 1
    		move $a0, $t1		# move current row number back into $a0
    		jal print_star_line     # jump and link to print_star_line
    		li $v0, 11           	# syscall code for printing a character
    		li $a0, '\n'         
    		syscall
    		addi  $s1, $s1, 1      	# increment current row number
    		lw $ra, 0($sp)		# load return address
    		addi $sp, $sp, 4	# deallocate space on stack
    		j triangle_loop
    		
    	triangle_done:
    		# Return is void
    		lw $s0, 0($sp) 		# restore space for $s0
		lw $s1, 4($sp) 		# restore space for $s1
		lw $ra, 8($sp) 		# restore space for $ra
		addi $sp, $sp, 12	# deallocate space on the stack
    		jr $ra
    	
square:
	addi $sp, $sp, -12 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $ra, 8($sp)		# preserve space for $ra
    	move $s0, $a0	     # $s0 the number of stars per row based on $a0
    	li $s1, 0            # initialize current row number
    	move $t0, $s0	     # moving numver of stars into $s2
    	li $a0, '\n'
    	li $v0, 11	     # syscall code for printing a character
    	syscall
	square_loop:
    		beq $s1, $s0, square_done 	# if current row number >= size, exit loop
    		addi $sp, $sp, -4 	# allocate space on the stack
    		sw $ra, 0($sp)		# store return address
    		move $a0, $t0		# move number of stars back into $a0
    		jal print_star_line      # jump and link to print_star_line and save/load $ra
    		li $a0, '\n'
    		li $v0, 11	     # syscall code for printing a character
    		syscall
    		addi $s1, $s1, 1      # increment loop counter
    		move $t0, $s0	     # re-initialize number of stars per row into $s2
    		lw $ra, 0($sp)		# load return address
    		addi $sp, $sp, 4	# deallocate space on the stack
    		j square_loop
    	square_done:
    		# Return is void
    		lw $s0, 0($sp) 		# restore space for $s0
		lw $s1, 4($sp) 		# restore space for $s1
		lw $ra, 8($sp) 		# restore space for $ra
		addi $sp, $sp, 12	# deallocate space on the stack
    		jr $ra

pyramid:
	addi $sp, $sp, -8 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $ra, 4($sp) 		# preserve space for $ra
	move $s0, $a0	     # $s0 the number of stars per row based on $a0
    	li $t0, 0            # initialize i
    	addi $s0, $s0, 1
    	
	each_row:
        	bge $t0, $s0, pyramid_done 	# if i >= height, exit loop
        	sub $t1, $s0, $t0       # n - i
        
		prepend_space:
      			bgtz $t1, print_spaces # if j > 0, print spaces
      			li $t2, 0        # j = 0
       			j add_stars

		print_spaces:
			li $v0, 11		# syscall code for printing a string
       			li $a0, ' '
       			syscall
       			addi $t1, $t1, -1	# decrement number of stars per row
       			j prepend_space

		add_stars:
   			bge $t2, $t0, row_done # if j > i, exit loop
   			la $a0, star
			li $v0, 4           # syscall code for printing a string
      			syscall
 			addi $t2, $t2, 1	# increment j
    			j add_stars
    		
		row_done:
			li $v0, 11		# syscall code for printing a character
        		li $a0, '\n'
        		syscall
        		addi $t0, $t0, 1         # increment i
        		j each_row
        pyramid_done:
        	# Return is void
        	lw $s0, 0($sp) 		# restore space for $s0
        	lw $ra, 4($sp) 		# restore space for $ra
		addi $sp, $sp, 8	# deallocate space on the stack
        	jr $ra
	
print_star_line:
	addi $sp, $sp, -4 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	move $s0, $a0	# move the argument for number of stars to $s0
	li $a0, '*'
	li $v0, 11         # syscall code for printing a character
	print_loop:
    		beq $s0, $zero, print_done # if $s0 is zero, exit loop
    		syscall
    		addi $s0, $s0, -1     # decrement number of lines
    		j print_loop
	print_done:
		# Return is void
		lw $s0, 0($sp) 		# preserve space for $s0
		addi $sp, $sp, 4 	# deallocate space on the stack
    		jr $ra
        
size_error:
	li $v0, 4
	la $a0, size_error_msg	# syscall code for print a string of the error message
	syscall
	# Return is void
	lw $s0, 0($sp)		# restore space for $s0
	lw $s1, 4($sp)		# restore space for $s1
    	lw $ra, 8($sp)		# restore return address
    	addi $sp, $sp, 12	# deallocate space on the stack
	j exit

shape_error:
	li $v0, 4
	la $a0, shape_error_msg	# syscall code for print a string of the error message
	syscall
	# Return is void
	lw $s0, 0($sp)		# restore space for $s0
	lw $s1, 4($sp)		# restore space for $s1
    	lw $ra, 8($sp)		# restore return address
    	addi $sp, $sp, 12	# deallocate space on the stack
	j exit

exit:
	# Exit program
    	li $v0, 10           # syscall code for exit
    	syscall
