# bubble sort an array read from stdin to stdout
#
# we read up to 128 positive integers from stdin;
# if there are fewer than 128 integers, a negative
# integer can be used to mark the end of the input;
# we sort the array using bubble sort and finally
# print the sorted array back to stdout

sys_print_int = 1
sys_print_string = 4
sys_read_int = 5

SLOTS = 128	# at most 128 values
BYTES = 512	# need 128*4 bytes of space

	.text
main:
	sub	$sp, 4
	sw	$ra, 0($sp)

	li	$a0, SLOTS
	la	$a1, buffer
	jal	read_array
	ble	$v0, $zero, exit
	sw	$v0, used

	lw	$a0, used
	la	$a1, buffer
	jal	bubble_sort

	lw	$a0, used
	la	$a1, buffer
	jal	print_array
exit:
	lw	$ra, 0($sp)
	add	$sp, 4

	jr	$ra

# length = read_array(size, address)
# $v0                 $a0   $a1
read_array:
	sub	$sp, 16			# save used registers
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)

	move	$s0, $zero		# slots used
	move	$s1, $a1		# address in array
	move	$s2, $a0		# slots available
ra_loop:
	li	$v0, sys_read_int	# read next value
	syscall

	blt	$v0, $zero, ra_done	# break if we read < 0

	sw	$v0, ($s1)		# store value in array
	add	$s0, 1			# used++
	add	$s1, 4			# address++

	blt	$s0, $s2, ra_loop	# while used < available
ra_done:
	move	$v0, $s0		# return slots used

	lw	$ra, 0($sp)		# restore used registers
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, 16

	jr	$ra			# return

# bubble_sort(size, address)
#             $a0   $a1
bubble_sort:
	# your code here
	sub	$sp, 20			# save used register
    sw  $s3, 16($sp)
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)

    li  $s0, 0        # outer for loop iterations
outer_loop:
    move  $s1, $a1      # s1 has current address
    li  $s2, 1        # inner for loop iterations in s2
    li  $s3, 0        # value that holds if anything changes

inner_loop:
    jal cmp             #compare and /or swap
    add $s3, $s3, $v0   # update variable that sees if things have changed
    addi $s2, $s2, 1    #increment outer loop var
    addi $s1, $s1, 4    #increment outer loop var

    blt $s2, $a0, inner_loop    #go back to inner loop if not done
    beq $s3, $zero, finish  #if nothing changed, finish
    blt $s0, $a0, outer_loop #loop back if still more iterations to do
finish:
	lw	$ra, 0($sp)		# restore used registers
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
    sw  $s3, 16($sp)
	add	$sp, 20
	jr	$ra			# return

#swap value 
swap:
    sw  $t0, 4($s1)
    sw  $t1, 0($s1)
    li  $v0,  1         #put 1 in v0 if swap occured
    jr  $ra
#cmp value, swap if need to
cmp:
    lw  $t0, 0($s1)
    lw  $t1, 4($s1)
    blt $t1, $t0, swap
    li  $v0, 0          #put 0 in v0 if no swap occured
    jr  $ra

# print_array(size, address)
#             $a0   $a1
print_array:
	sub	$sp, 16			# save used registers
	sw	$s2, 12($sp)
	sw	$s1, 8($sp)
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)

	move	$s0, $zero		# current slot
	move	$s1, $a1		# address in array
	move	$s2, $a0		# slots used
pa_loop:
	bge	$s0, $s2, pa_done	# while current < used

	lw	$a0, ($s1)		# load value in array
	jal	print_int		# and print it

	add	$s0, 1			# current++
	add	$s1, 4			# address++

	b	pa_loop
pa_done:
	lw	$ra, 0($sp)		# restore used registers
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, 16

	jr	$ra			# return

# print_int(value)
#           $a0
print_int:
	li	$v0, sys_print_int
	syscall

	la	$a0, lf
	li	$v0, sys_print_string
	syscall

	jr	$ra

# print_string(string)
#              $a0
print_string:
	li	$v0, sys_print_string
	syscall

	la	$a0, lf
	li	$v0, sys_print_string
	syscall

	jr	$ra

	.data
buffer:
	.space	BYTES		# array of 4-byte integers
used:
	.word	0		# used slots in array
lf:
	.asciiz	"\n"

	.end
