.data
  M:      .space 400  		# int M[][] The matrix
  V:      .space 400  		# int V[]   The vector
  C:      .space 400  		# int C[] : The output vector
  m:      .word 10   		  # m is an int whose value is at most 10
                     		  # max value for rows and columns
  col_m: .word 2          # columns for matrix M: This should not be more than 10
  row_m: .word 2          # rows for matrix M:    This should not be more than 10
                          # (col_m * row_m) * 4 <= M
  col_v: .word 1          # colums for vector V. For a vector, the column is always one
  row_v: .word 2          # rows for vector V. This should not be more than 10
                          # (col_v * row_v) * 4 <= V
                          
promptM:		.asciiz "Enter Matrix element "
promptV:		.asciiz "Enter Vector element "
result:			.asciiz "Resulting Vector = ["
equals:			.asciiz " = "
dimension_error_msg:	.asciiz "NOT WORKABLE BECAUSE OF THE DIMENSIONS"
memory_error_msg:	.asciiz "NOT WORKABLE BECAUSE OF THE MEMORY"
separator:		.asciiz ", "
split_str:		.asciiz "------------------------------------------\n"

.text
main:
	addi $sp, $sp, -4 	# allocate space on the stack
	sw $ra, 0($sp)		# store return address
	
	# Check for errors (dimension_eror)
	lw $a0, col_m
	ble $a0, $zero, dimension_error	# if col_m <= 0
	lw $a0, row_m
	ble $a0, $zero, dimension_error	# if row_m <= 0
	lw $a0, col_v
	bne $a0, 1, dimension_error	# if col_v != 1
	lw $a0, row_v
	ble $a0, $zero, dimension_error	# if row_v <= 0
	
	lw $a0, col_m	# load col_m as an argument $a0 for dimension error
	lw $a1, row_v	# load row_v as an argument $a1 for dimension error
	bne $a0, $a1, dimension_error	# if col_m != row_v then MVM isn't possible

	# Check for errors (memory_vector_error)
	lw $t0, col_v		# load col_v as an argument $a1 for dimension error
	lw $t1, row_v		# load row_v as an argument $a1 for dimension error
	mul $t2, $t0, $t1	# store (col_v * row_v) as $t2
	sll $a0, $t2 2		# store (col_v * row_v) * 4 as argument $a0 for memory_error
	bgt $a0, 400, memory_error	# if (col_v * row_v) * 4 <= M, memory_vector_error
	
	# Check for errors (memory_matrix_error)
	lw $t0, row_m		# load row_m as $t0
	lw $t1, col_m		# load col_m as $t1
	mul $t2, $t0, $t1	# store (col_m * row_m) as $t2
	sll $a0, $t2 2		# store (col_m * row_m) * 4 as argument $a0 for memory_error
	bgt $a0, 400, memory_error	# if (col_m * row_m) * 4 <= M, memory_matrix_error
	
	lw $a0, row_m	# load row_m as an argument $a0 for read_matrix
	lw $a1, col_m	# load col_m as an argument $a1 for read_matrix
	jal read_matrix	# jump and link to read_matrix
	
	jal split 	# jump and link to split to separate M and V more clear
	
	lw $a0, row_v	# load row_v as argument $a0 for read_vector
	jal read_vector	# jump and link to read_vector
	
	lw $a0, row_m	# load row_m as an argument $a0 for MVM
	lw $a1, col_m	# load col_m as an argument $a1 for MVM
	la $a2, M	# load address of matrix M as argument $a2 for MVM
	la $a3, V	# load address of vector V as argument $a3 for MVM
	jal MVM		# jump and link to MVM
	
	jal split 	# jump and link to split to separate from the resulting C more clear
	
	lw $a0, row_m	# load row_m as an argument $a0 for print_vector
	la $a1, C	# load address of vector C as an argument $a1 for print_vector
	jal print_vector	# jump and link to MVM
	
	lw $ra, 0($sp)		# load return address
    	addi $sp, $sp, 4	# deallocate space on the stack
	
	j exit	# jump to exit


read_matrix:
	addi $sp, $sp, -12 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $s2, 8($sp)		# preserve space for $s2
	move $s0, $a0	# move argument (row_m) into $s0
	move $s1, $a1	# move argument (col_m) into $s1
	la $s2, M	# move the address of M into $s3
	li $t0, 0	# initialize row index
	li $t1, 1	# element counter
	matrix_row_loop:
		beq $t0, $s0, read_done	# if row index = row_m, jump to read_done
		li $t2, 0	# initialize column index
		matrix_column_loop:
			li $v0, 4
			la $a0, promptM		# Prompt user for M element
			syscall			# Print prompt
	
			# Print element counter
			move $a0, $t1	# $a0 element counter
			li $v0, 1
			syscall		# print element counter
	
			# Print ending to prompt
			la $a0, equals	# $a0 = = ' = '
			li $v0, 4
			syscall		# print ' = '
	
    			mul $t3, $t0, $s1       # $t3 is (row_index * number_of_columns)
    			add $t3, $t3, $t2       # $t3 is (row_index * number_of_columns) + column_index
    			sll $t3, $t3, 2       	# $t3 is $t3 multiplyied by 4 for byte offset
    			add $t3, $t3, $s2	# $t3 is the address of M[row_index][column_index]
			li $v0, 5
			syscall			# Ask user for input of element value into M
			sw $v0, 0($t3)  	# Store the input into M
	
			addi $t1, $t1, 1	# element counter++
			addi $t2, $t2, 1	# column index++
			
			blt $t2, $s1, matrix_column_loop # if column index < col_m, jump back to matrix_column_loop
	
			addi $t0, $t0, 1	# row index++
			j matrix_row_loop	# jump to matrix_row_loop
		read_done:
			move $v0, $s2		# return the address of matrix M
			lw $s0, 0($sp) 		# restore space for $s0
			lw $s1, 4($sp) 		# restore space for $s1
			lw $s2, 8($sp) 		# restore space for $s2
			addi $sp, $sp, 12	# deallocate space on the stack
			jr $ra
			
split:
	li $v0, 4
	la $a0, split_str	# store split line as $a0
	syscall		# print split line
	jr $ra
	
read_vector:
	addi $sp, $sp, -8 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	move $s0, $a0		# move argument (row_v) into $s0
	la $s1, V	# load addres of V as $s1
	li $t0, 0	# i
	vector_loop:
		beq $t0, $s0, vector_done # if i = row, jump to vector_done
		li $v0, 4
		la $a0, promptV		# Prompt user for V element
		syscall
	
		li $v0, 1
		addi $a0, $t0, 1	# a0 is i + 1
		syscall	# print i + 1
	
		li $v0, 4
		la $a0, equals	# a0 is ' = '
		syscall	# Print equals
	
        	sll $t1, $t0, 2		 # $t1 is index multiplyied by 4 for byte offset
    		add $t1, $t1, $s1   	 # $t1 is the address of V[i]
    		li $v0, 5
		syscall			# Ask user for input of element value into V
		sw $v0, 0($t1)  	# Store the input into V
    	
    		addi $t0, $t0, 1	# i++
        	j vector_loop		# jump to vector_loop
        vector_done:
        	move $v0, $s1		# return the address of vector V
		lw $s0, 0($sp) 		# restore space for $s0
		lw $s1, 4($sp) 		# restore space for $s1
		addi $sp, $sp, 8	# deallocate space on the stack
        	jr $ra
	
MVM:
	addi $sp, $sp, -20 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	sw $s2, 8($sp)		# preserve space for $s2
	sw $s3, 12($sp)		# preserve space for $s3
	sw $s4, 16($sp)		# preserve space for $s4
	move $s0, $a0	# move arugment (row_m) into $s0
	move $s1, $a1	# move arugment (col_m) into $s1
	move $s2, $a2	# move arugment (address of M) into $s2
	move $s3, $a3	# move arugment (address of V) into $s3
	la $s4, C	# load addres of C as $s4
	li $t0, 0	# row index	
	row_loop_MVM:
		beq $t0, $s0, MVM_done	# if row index = row_m, jump to MVM_done
		li $t1, 0	# column index
		li $t2, 0        # sum
		column_loop_MVM:
    			mul $t3, $t0, $s1       # $t3 is row_index * number_of_columns
    			add $t3, $t3, $t1       # $t3 is (row_index * number_of_columns) + column_index
    			sll $t3, $t3, 2       	# $t3 is $t3 multiplyied by 4 for byte offset
    			add $t3, $t3, $s2	# $t3 is the address of M[row_index][column_index]
    			lw $t4, 0($t3)		# Load M[row_index][column_index] into $t4
    	
    			sll $t3, $t1, 2		# $t3 is column index multiplyied by 4 for byte offset
    			add $t3, $t3, $s3	# $t3 is the address of V[column_index]
    			lw $t5, 0($t3)		# Load V[col_index] into $t5
    	
    			mul $t3, $t4, $t5	# $t3 is M[row index][column index] * V[column index]
    			add $t2, $t2, $t3	# sum = sum + M[row index][column index] * V[column index]
    	
			addi $t1, $t1, 1	# column index++
			blt $t1, $s1, column_loop_MVM # if column index < col_m, jump to column_loop_MVM
	
    			sll $t3, $t0, 2		# $t3 is row index multiplyied by 4 for byte offset
    			add $t3, $t3, $s4	# $t3 is the address of C[row_index]
			sw $t2, 0($t3)		# Store updated sum in C[row_index] in $t2
	
			addi $t0, $t0, 1	#increment row index
			j row_loop_MVM
		MVM_done:
			move $v0, $s4		# return the address of vector C
			lw $s0, 0($sp) 		# restore space for $s0
			lw $s1, 4($sp) 		# restore space for $s1
			lw $s2, 8($sp) 		# restore space for $s2
			lw $s3, 12($sp) 	# restore space for $s3
			lw $s4, 16($sp) 	# restore space for $s4
			addi $sp, $sp, 20	# deallocate space on the stack
			jr $ra
print_vector:
	addi $sp, $sp, -8 	# allocate space on the stack
	sw $s0, 0($sp) 		# preserve space for $s0
	sw $s1, 4($sp)		# preserve space for $s1
	move $s0, $a0	# move arugment (row_v) into $s0
	move $s1, $a1	# move arugment (address of C) into $s1
	li $t0, 0	# initialize i
	
	li $v0, 4
	la $a0, result	# Resulting Vector = [
	syscall		# print message above
	print_loop:
		beq $t0, $s0, end_loop	# if i = row_v, jump to end_loop
		sll $t1, $t0, 2		# $t1 is i multiplyied by 4 for byte offset
		add $t1, $t1, $s1	# $t1 is the address of C[i]
		lw $a0, 0($t1)
		li $v0, 1             # System call code for print_int
    		syscall
	
		addi $t2, $s0, -1	# $t2 is i - 1
		beq $t0, $t2, end_loop	# if i = (row_m -1), jump to end_loop (don't add separator)
		li $v0, 4	# value type for string
		la $a0, separator	# Print separator
		syscall
	
		addi $t0, $t0, 1	# i++
		j print_loop	# jump to print_loop
	end_loop:
		li $v0, 11	# value type for character
		li $a0, ']'
		syscall		# Print ]
		# Return is void
		lw $s0, 0($sp) 		# restore space for $s0
		lw $s1, 4($sp) 		# restore space for $s1
		addi $sp, $sp, 8	# deallocate space on the stack
		jr $ra
	
	j exit

dimension_error:
	# Print error message for dimension not workable
	li $v0, 4
	la $a0, dimension_error_msg
	syscall
	lw $ra, 0($sp)		# load return address
    	addi $sp, $sp, 4	# deallocate space on the stack
	j exit

memory_error:
	# Print error message for memory not workable
	li $v0, 4
	la $a0, memory_error_msg
	syscall
	lw $ra, 0($sp)		# load return address
    	addi $sp, $sp, 4	# deallocate space on the stack
	j exit

exit:                     # This is code to terminate the program -- don't mess with this!
  	addi $v0, $0, 10      	# system call code 10 for exit
  	syscall               	# exit the program
