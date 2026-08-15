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

# execute madd
jal Madd

jal AbsSub

# print result
la $a0, PResult
li $v0, 4
syscall

move $a0, $v1
li $v0, 1
syscall

j Exit

# abs_sub(b, madd(a, c))
AbsSub:
# x >= y -> x < y
# $s1, $v1
slt $at, $s1, $v1
# else
bne $at, $zero, SetSubLargeY

# if x >= y
move $t1, $s1
j SubSmall

SetSubLargeY:
move $t1, $v1

SubSmall:
# x <= y -> x > y
slt $at, $v1, $s1
bne $at, $zero, SetSubSmallY

# if x <= y
move $t2, $s1
j Sub

SetSubSmallY:
move $t2, $v1

Sub:
sub $v1, $t1, $t2

jr $ra


# madd(a, c)
Madd:
move $t0, $zero

# x >= y -> x < y
slt $at, $s0, $s2
# else
bne $at, $zero, SetLargeY

# if x >= y
move $t1, $s0
j Small

SetLargeY:
move $t1, $s2

Small:
# x <= y -> x > y
slt $at, $s2, $s0
bne $at, $zero, SetSmallY

# if x <= y
move $t2, $s0
j Loop

SetSmallY:
move $t2, $s2

Loop:
# large < small
slt $at, $t1, $t2
bne $at, $zero, RetrurnMadd
add $t0, $t0, $t2
addi $t1, $t1, -1
j Loop

RetrurnMadd:
move $v1, $t0
jr $ra

Exit:
li $v0, 10
syscall
