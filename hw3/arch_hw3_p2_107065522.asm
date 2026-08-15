.data
PInputA: .asciiz "input a: "
PInputB: .asciiz "input b: "
PAns:    .asciiz "ans: "

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

# call re
move $a0, $s0
jal Re
move $s2, $v0

# answer c
la $a0, PAns
li $v0, 4
syscall

move $a0, $s2
li $v0, 1
syscall

j Exit

Re:
# 儲存 stack
addi $sp, $sp, -16
sw $ra, 4($sp)
sw $a0, 0($sp)

# x < 2
slti $t0, $a0, 2
bne $t0, $zero, XSmallerThan2

# x * x
lw $a0, 0($sp)
mul $t1, $a0, $a0 # 跳走之後 $t1 會變，所以要存下來
sw $t1, 8($sp)

# x * re(x - 1)
lw $a0, 0($sp)
addi $a0, $a0, -1
jal Re
lw $t0, 0($sp)
mul $t2, $t0, $v0
sw $t2, 12($sp)

# (x - 1) * re(x - 2)
lw $a0, 0($sp)
addi $a0, $a0, -2
jal Re
lw $t0, 0($sp)
addi $t0, $t0, -1
mul $t3, $t0, $v0

# 相加
lw $t1, 8($sp)
lw $t2, 12($sp)
add $v0, $t1, $t2
add $v0, $v0, $t3
lw $ra, 4($sp)
addi $sp, $sp, 16
jr $ra

XSmallerThan2:
beq $a0, 1, XEqual1

li $v0, 0

# 恢復 stack
lw $ra, 4($sp)
addi $sp, $sp, 16
jr $ra

XEqual1:
li $v0, 1

# 恢復 stack
lw $ra, 4($sp)
addi $sp, $sp, 16
jr $ra

Exit:
li $v0, 10
syscall
