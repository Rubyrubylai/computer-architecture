.data

PInput:   .asciiz "Please select an integer number A from (0~10): "
PNewline: .asciiz "\n"
PTheEnd:  .asciiz "THE END"
PAmulti:  .asciiz "A * 2 = "
P6Star:   .asciiz "******"
P9Star:   .asciiz "*********"

.text
.globl main

main:

Loop:
la $a0, PInput
li $v0, 4
syscall

# 取得 input
li $v0, 5
syscall 

move $t0, $v0

# t0 == 0
beq $t0, $zero, End

# t0 < 0
slt $t1, $t0, $zero
bne $t1, $zero, Continue

# t0 > 10
li $t1, 10
slt $t2, $t1, $t0
bne $t2, $zero, Continue

# t0 == 7
li $t1, 7
beq $t0, $t1, PrintMulti

# for loop
li $t3, 0
ForLoop:
slt $t2, $t3, $t0
bne $t2, $zero, PrintStar

j Loop

# print "THE END"
End:
la $a0, PTheEnd
li $v0, 4
syscall
j Exit

# print "A * 2 = %d\n"
Continue:
j Loop

PrintMulti:
la $a0, PAmulti
li $v0, 4
syscall
sll $t2, $t0, 1
move $a0, $t2
li $v0, 1 
syscall
jal PrintNewline
j Loop

PrintStar:
la $a0, P6Star
li $v0, 4
syscall
move $a0, $t3
li $v0, 1
syscall
la $a0, P9Star
li $v0, 4
syscall
jal PrintNewline
addi $t3, $t3, 1
j ForLoop

PrintNewline:
la $a0, PNewline
li $v0, 4
syscall
jr $ra

Exit:
li $v0, 10
syscall
