.data
PInputA: .asciiz "input a:"
PInputB: .asciiz "input b:"
PInputC: .asciiz "input c:"
PResult: .asciiz "result = "

.text

main:

move $s0, $zero
move $s1, $zero
move $s2, $zero
move $s3, $zero

# input A
la $a0, PInputA
li $v0, 4
syscall

li $v0, 5
syscall
move $s0, $v0

# input B
la $a0, PInputB
li $v0, 4
syscall

li $v0, 5
syscall
move $s1, $v0

# input C
la $a0, PInputC
li $v0, 4
syscall

li $v0, 5
syscall
move $s2, $v0

# d = abs_sub(b, madd(a, c))
move $a0, $s0
move $a1, $s2
jal Madd

move $a0, $s1
move $a1, $v0
jal AbsSub
move $s3, $v0

# print result
la $a0, PResult
li $v0, 4
syscall

move $a0, $s3
li $v0, 1
syscall

j Exit

# abs_sub(b, madd(a, c))
AbsSub:
# return (x >= y) ? x - y : y - x
slt $t3, $a0, $a1
bne $t3, $zero, SubYMinusX

sub $v0, $a0, $a1
jr $ra

SubYMinusX:
sub $v0, $a1, $a0
jr $ra


# madd(a, c)
Madd:
move $t0, $zero

# x >= y -> x < y
slt $t3, $a0, $a1
# else
bne $t3, $zero, SetLargeY

# if x >= y
move $t1, $a0
j Small

SetLargeY:
move $t1, $a1

Small:
# x <= y -> x > y
slt $t3, $a1, $a0
bne $t3, $zero, SetSmallY

# if x <= y
move $t2, $a0
j Loop

SetSmallY:
move $t2, $a1

Loop:
# large < small
slt $t3, $t1, $t2
bne $t3, $zero, ReturnMadd
add $t0, $t0, $t2
addi $t1, $t1, -1
j Loop

ReturnMadd:
move $v0, $t0
jr $ra

Exit:
li $v0, 10
syscall
