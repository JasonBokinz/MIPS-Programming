.data
promptA:  		.asciiz "A["
promptB:  		.asciiz "B["
endprompt:		.asciiz "]="
error_large_msg:	.asciiz "Error: Element size too large."
error_small_msg:	.asciiz "Error: Element size too small."

.align 2
pinA: .space    400 # We will not change this
pinB: .space    400 # We will not change this
num: .word 	3  # We can change this 
              # n x 4 <= 400 This is the constraint

.text
main:
	addi $sp, $sp, -4 	# allocate space on the stack
	sw $ra, 0($sp)		# preserve return address
	
    	lw $a0, num		# Store the value for num as an argument for each size error
    	bgt $a0, 100, error_large	# Error case when n * 4 > 400
    	ble $a0, 0, error_small		# Error case when n <= 0
    	
	lw $a0, num	# Store the value for num into $a2
    	jal read_arrays	# jump and link to prompt user to read each array with arguments $a0-$a1

	lw $a0, num	# Store the value for num into $a2
    	jal swap_arrays	# jump and link to swap array A and array B with arguments $a0-$a1
    	
	lw $a0, num	# Store the value for num into $a2
    	jal print_arrays
    	
    	lw $ra, 0($sp)		# preserve return address
    	addi $sp, $sp, 4	# deallocate space on the stack
    	
    	j exit	# jump to exit
    	

read_arrays:
	addi $sp, $sp, -12 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $s2, 8($sp)		# preserve space for $s2
	la $s0, pinA	# move address of pinA into $s0
	la $s1, pinB	# move address of pinB into $s1
	move $s2, $a0	# move argument (num) into $s2
	li $t0, 0       # i = 0
	read_loop:
		beq $t0, $s2, read_done	# i = num, jump to read_done
			
        	li $v0, 4        		# System call code for print_strl
        	la $a0, promptA			# Prompt for Array A
        	syscall
        
        	li $v0, 1        	# System call code for print_int
        	addi $a0, $t0, 1	# print i + 1
    		syscall
    	
    		li $v0, 4        # System call code for print_strl
        	la $a0, endprompt
        	syscall
        
        	# Calculate the address of A[i] and store into A[i]
        	sll $t1, $t0, 2		 # Multiply index by 4 to get the byte offset
    		add $t1, $t1, $s0   	 # Add the offest to the address of array A
    		li $v0, 5            	# System call code for read_int
    		syscall			# Read integer
    		sw $v0, 0($t1)       	# Store the input value into A[i]
    		
    		li $v0, 4        	# System call code for print_strl
        	la $a0, promptB		# Prompt for Array B
        	syscall
        	
        	li $v0, 1        	# System call code for print_int
    		addi $a0, $t0, 1	# print i + 1
    		syscall
    		
    		li $v0, 4        # System call code for print_strl
        	la $a0, endprompt
        	syscall
        
        	# Calculate the address of B[i] and store into B[i]
    		sll $t1, $t0, 2		# Multiply index by 4 to get the byte offset
    		add $t1, $t1, $s1       # Add the offset to the address of array B
    		li $v0, 5            	# System call code for read_int
    		syscall			# Read integer into B[i]
    		sw $v0, 0($t1)       	# Store the input value in array B
        
        	addi $t0, $t0, 1	# Increment i
        	j read_loop
	read_done:
		move $v0, $s0	# return the address of array A
    		move $v1, $s1	# return the adress of array B
    		lw $s0, 0($sp) 		# restore space for $s0
		lw $s1, 4($sp) 		# restore space for $s1
		lw $s2, 8($sp) 		# restore space for $s2
		addi $sp, $sp, 12	# deallocate space on the stack
		jr $ra
	
swap_arrays:
	addi $sp, $sp, -12 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $s2, 8($sp)		# preserve space for $s2
	la $s0, pinA	# move address of pinA into $s0
	la $s1, pinB	# move address of pinB into $s1
	move $s2, $a0	# move argument (num) into $s2
	li $t0, 0	# i = 0
	swap_loop:
		beq $t0, $s2, swap_done	# i = num, jump to swap_done
	
		# Calculate the address of A[i] and load into $t2
    		sll $t1, $t0, 2		# Multiply index by 4 to get the byte offset
    		add $t1, $t1, $s0    	# Add the offset to the address of array A
    		lw $t2, 0($t1)		# Load A[i] into $t2

    		# Calculate the address of B[i] and load into $t4
    		sll $t3, $t0, 2		# Multiply index by 4 to get the byte offset
    		add $t3, $t3, $s1    # Add the offset to the address of array B
    		lw $t4, 0($t3)

    		# Swap A[i] and B[i]
    		sw $t4, 0($t1)       # Store B[i] in A[i]
    		sw $t2, 0($t3)       # Store A[i] in B[i]

    		addi $t0, $t0, 1	# i++
    		j swap_loop		# jump to beginning of loop
    	swap_done:
    		move $v0, $s0	# return the address of array A
    		move $v1, $s1	# return the adress of array B
    		lw $s0, 0($sp) 		# restore space for $s0
		lw $s1, 4($sp) 		# restore space for $s1
		lw $s2, 8($sp) 		# restore space for $s2
		addi $sp, $sp, 12	# deallocate space on the stack
    		jr $ra
    	
print_arrays:
	addi $sp, $sp, -12 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $s2, 8($sp)		# preserve space for $s2
	la $s0, pinA	# move address of pinA into $s0
	la $s1, pinB	# move address of pinB into $s1
	move $s2, $a0	# move argument (num) into $s2
	li $t0, 0	# initialize - = 0
	print_loop:
		beq $t0, $s2, print_done
	
    		sll $t1, $t0, 2       	# Multiply index by 4 to get the byte offset
    		add $t1, $t1, $s0     	# Add the offset to the address of array A
    		li $v0, 1             	# System call code for print_int
    		lw $a0, 0($t1)        	# Load the value from memory into $a0
    		syscall			# Print A[i]

    		li $v0, 11            	# syscall code for printing a character
    		li $a0, ' '
    		syscall			# Print space

    		sll $t1, $t0, 2       	# Multiply index by 4 to get the byte offset
    		add $t1, $t1, $s1     	# Add the offset to the address of array B

    		li $v0, 1             	# System call code for print_int
    		lw $a0, 0($t1)        	# Load the value from memory
    		syscall			# Print B[i]

    		li $v0, 11           	# System call code for printing a character
    		li $a0, '|'	      	
    		syscall			# Print separator

		addi $t0, $t0, 1	# i++
    		j print_loop		# jump to beginning of loop
    	print_done:
    		# Return is void
    		lw $s0, 0($sp) 		# restore space for $s0
		lw $s1, 4($sp) 		# restore space for $s1
		lw $s2, 8($sp) 		# restore space for $s2
		addi $sp, $sp, 12	# deallocate space on the stack
    		jr $ra
    
error_large:
	li $v0, 4	# System call code for string
	la $a0, error_large_msg	
	syscall		# print error message
	lw $ra, 0($sp)		# restore return address
    	addi $sp, $sp, 4	# deallocate space on the stack
	j exit

error_small:
	li $v0, 4	# System call code for string
	la $a0, error_small_msg	# store error message
	syscall		# print error message
	lw $ra, 0($sp)		# restore return address
    	addi $sp, $sp, 4	# deallocate space on the stack
	j exit

exit:
    	li $v0, 10			# System call code for exiting
    	syscall
