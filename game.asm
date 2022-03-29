##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: Shannon Budiman, 1006863770, budimans, shannon.budiman@mail.utoronto.ca
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4 (update this as needed)  
# - Unit height in pixels: 4 (update this as needed) 
# - Display width in pixels: 256 (update this as needed) 
# - Display height in pixels: 256 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 1/2/3 (choose the one the applies) 
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. (fill in the feature, if any) 
# 2. (fill in the feature, if any) 
# 3. (fill in the feature, if any) 
# ... (add more if necessary) 
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes / no / yes, and please share this project github link as well! 
# 
# Any additional information that the TA needs to know: 
# - (write here, if any) 
# 
##################################################################### 

# Bitmap display starter code 
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4           
# - Unit height in pixels: 4 
# - Display width in pixels: 256 
# - Display height in pixels: 256 
# - Base Address for Display: 0x10008000 ($gp) 
# 
.eqv  BASE_ADDRESS  0x10008000 
 

.data

bottom: .word 11024
state: .word 1
.text 
 li $t0, BASE_ADDRESS # $t0 stores the base address for display 
 
 #sw $t1, ($t0)
 #sw $t1, 4($t0)		# paint the bottom left unit red
 #sw $t1, 16128($t0)
 #sw $t1, 16132($t0)	# paint the pixel next to it red
 #sw $t3, 15888($t0)
 #sw $t1, 16140($t0)
 #sw $t1, 16144($t0)
 #sw $t1, 15872($t0)
 #sw $t1, 15616($t0)
 #sw $t1, 15364($t0)
 #sw $t1, 15112($t0)
 #sw $t1, 15888($t0)
 #sw $t1, 15632($t0)
 #sw $t1, 15372($t0)
 
   
 #sw $t1, 11008($t0)
 #sw $t1, 11024($t0)
 #sw $t1, 8448($t0)
 
.globl main
main:	
	li $v0, 32 
	li $a0, 40   # Wait 40 milliseconds 
	syscall 
	jal draw_buzz
check_key:	
	li $t9, 0xffff0000  
	lw $t8, 0($t9) 
	bne $t8, 1, check_key
keypress_happened:
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before 
while_not_p:
	beq $t2, 0x70, END  # ASCII code of 'p' is 0x70
if_d:	beq $t2, 0x64, respond_to_d   # ASCII code of 'd' is 0x64 or 97
if_a:	beq $t2, 0x61, respond_to_a
	j check_key
respond_to_d:
	jal erase_buzz
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, 4	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	j check_key

respond_to_a:
	jal erase_buzz
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, -4	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	j check_key	
j END
draw_buzz:
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display
 	li $t1, 0xff0000	# $t1 stores the red colour code 
 	li $t2, 0x00ff00	# $t2 stores the green colour code 
 	li $t3, 0xffffff	# $t3 stores the whitecolour code 
 	li $t4, 0x000000	# $t4 stores the black colour code 
 	li $t5, 0xa252c6	# $t5 stores purple
 	li $t6, 0xffd9b4	# $t6 stores peach
 	
	lw $t7, bottom
	add $t7, $t0, $t7	#at bottom pixel now
	
	addi $t7, $t7, 8	#at feet
	sw $t2, 0($t7)
	sw $t2, 4($t7)
	sw $t2, 12($t7)
	sw $t2, 16($t7)
	
	addi, $t7, $t7, -256	#second
	sw $t3, 0($t7)
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	sw $t3, 12($t7)
	sw $t3, 16($t7)
	
	addi, $t7, $t7, -256	#third
	sw $t2, 0($t7)
	sw $t4, 4($t7)
	sw $t4, 8($t7)
	sw $t4, 12($t7)
	sw $t2, 16($t7)
	
	addi, $t7, $t7, -256	#fourth
	sw $t3, 0($t7)
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	sw $t3, 12($t7)
	sw $t3, 16($t7)	 
	
	li $t4, 0x0000ff 	# $t4 stores the blue color code
	addi $t7, $t7, -264	#sixth
	sw $t3, 0($t7)
	sw $t2, 4($t7)
	sw $t3, 8($t7)
	sw $t4, 12($t7)
	sw $t2, 16($t7)
	sw $t1, 20($t7)
	sw $t3, 24($t7)
	sw $t2, 28($t7)
	sw $t3, 32($t7)
	
	addi $t7, $t7, -256	#seventh
	sw $t3, 0($t7)
	sw $t2, 4($t7)
	sw $t3, 8($t7)
	sw $t2, 12($t7)
	sw $t2, 16($t7)
	sw $t2, 20($t7)
	sw $t3, 24($t7)
	sw $t2, 28($t7)
	sw $t3, 32($t7)
	
	addi $t7, $t7, -252	#eigth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t6, 8($t7)
	sw $t6, 12($t7)
	sw $t6, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)
	
	li $t4, 0x000000	# $t4 stores the black colour code 
	addi $t7, $t7, -256	#ninth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t4, 8($t7)
	sw $t6, 12($t7)
	sw $t4, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)
	
	addi $t7, $t7, -256	#tenth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t6, 8($t7)
	sw $t6, 12($t7)
	sw $t6, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)

	addi $t7, $t7, -252	#eleventh
	sw $t5, 0($t7)
	sw $t5, 4($t7)
	sw $t5, 8($t7)
	sw $t5, 12($t7)
	sw $t5, 16($t7)

	jr $ra

draw_buzz_left:
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display
 	li $t1, 0xff0000	# $t1 stores the red colour code 
 	li $t2, 0x00ff00	# $t2 stores the green colour code 
 	li $t3, 0xffffff	# $t3 stores the whitecolour code 
 	li $t4, 0x000000	# $t4 stores the black colour code 
 	li $t5, 0xa252c6	# $t5 stores purple
 	li $t6, 0xffd9b4	# $t6 stores peach
 	 
	lw $t7, bottom
	add $t7, $t0, $t7	#at bottom pixel now
	
	addi $t7, $t7, 8	#at feet
	sw $t2, 0($t7)
	sw $t2, 4($t7)
	
	addi, $t7, $t7, -256	#second
	sw $t3, 0($t7)
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	sw $t3, 12($t7)
	sw $t3, 16($t7)
	
	addi, $t7, $t7, -256	#third
	sw $t2, 0($t7)
	sw $t4, 4($t7)
	sw $t4, 8($t7)
	sw $t4, 12($t7)
	sw $t2, 16($t7)
	
	addi, $t7, $t7, -256	#fourth
	sw $t3, 0($t7)
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	sw $t3, 12($t7)
	sw $t3, 16($t7)	 
	
	li $t4, 0x0000ff 	# $t4 stores the blue color code
	addi $t7, $t7, -264	#sixth
	sw $t3, 0($t7)
	sw $t2, 4($t7)
	sw $t3, 8($t7)
	sw $t4, 12($t7)
	sw $t2, 16($t7)
	sw $t1, 20($t7)
	sw $t3, 24($t7)
	sw $t2, 28($t7)
	sw $t3, 32($t7)
	
	addi $t7, $t7, -256	#seventh
	sw $t3, 0($t7)
	sw $t2, 4($t7)
	sw $t3, 8($t7)
	sw $t2, 12($t7)
	sw $t2, 16($t7)
	sw $t2, 20($t7)
	sw $t3, 24($t7)
	sw $t2, 28($t7)
	sw $t3, 32($t7)
	
	addi $t7, $t7, -252	#eigth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t6, 8($t7)
	sw $t6, 12($t7)
	sw $t6, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)
	
	li $t4, 0x000000	# $t4 stores the black colour code 
	addi $t7, $t7, -256	#ninth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t4, 8($t7)
	sw $t6, 12($t7)
	sw $t4, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)
	
	addi $t7, $t7, -256	#tenth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t6, 8($t7)
	sw $t6, 12($t7)
	sw $t6, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)

	addi $t7, $t7, -252	#eleventh
	sw $t5, 0($t7)
	sw $t5, 4($t7)
	sw $t5, 8($t7)
	sw $t5, 12($t7)
	sw $t5, 16($t7)

	jr $ra
	
draw_buzz_right:
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display
 	li $t1, 0xff0000	# $t1 stores the red colour code 
 	li $t2, 0x00ff00	# $t2 stores the green colour code 
 	li $t3, 0xffffff	# $t3 stores the whitecolour code 
 	li $t4, 0x000000	# $t4 stores the black colour code 
 	li $t5, 0xa252c6	# $t5 stores purple
 	li $t6, 0xffd9b4	# $t6 stores peach
 	 
	lw $t7, bottom
	add $t7, $t0, $t7	#at bottom pixel now
	
	addi $t7, $t7, 8	#at feet
	sw $t2, 12($t7)
	sw $t2, 16($t7)
	
	addi, $t7, $t7, -256	#second
	sw $t3, 0($t7)
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	sw $t3, 12($t7)
	sw $t3, 16($t7)
	
	addi, $t7, $t7, -256	#third
	sw $t2, 0($t7)
	sw $t4, 4($t7)
	sw $t4, 8($t7)
	sw $t4, 12($t7)
	sw $t2, 16($t7)
	
	addi, $t7, $t7, -256	#fourth
	sw $t3, 0($t7)
	sw $t3, 4($t7)
	sw $t3, 8($t7)
	sw $t3, 12($t7)
	sw $t3, 16($t7)	 
	
	li $t4, 0x0000ff 	# $t4 stores the blue color code
	addi $t7, $t7, -264	#sixth
	sw $t3, 0($t7)
	sw $t2, 4($t7)
	sw $t3, 8($t7)
	sw $t4, 12($t7)
	sw $t2, 16($t7)
	sw $t1, 20($t7)
	sw $t3, 24($t7)
	sw $t2, 28($t7)
	sw $t3, 32($t7)
	
	addi $t7, $t7, -256	#seventh
	sw $t3, 0($t7)
	sw $t2, 4($t7)
	sw $t3, 8($t7)
	sw $t2, 12($t7)
	sw $t2, 16($t7)
	sw $t2, 20($t7)
	sw $t3, 24($t7)
	sw $t2, 28($t7)
	sw $t3, 32($t7)
	
	addi $t7, $t7, -252	#eigth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t6, 8($t7)
	sw $t6, 12($t7)
	sw $t6, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)
	
	li $t4, 0x000000	# $t4 stores the black colour code 
	addi $t7, $t7, -256	#ninth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t4, 8($t7)
	sw $t6, 12($t7)
	sw $t4, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)
	
	addi $t7, $t7, -256	#tenth
	sw $t5, 0($t7)
	sw $t6, 4($t7)
	sw $t6, 8($t7)
	sw $t6, 12($t7)
	sw $t6, 16($t7)
	sw $t6, 20($t7)
	sw $t5, 24($t7)

	addi $t7, $t7, -252	#eleventh
	sw $t5, 0($t7)
	sw $t5, 4($t7)
	sw $t5, 8($t7)
	sw $t5, 12($t7)
	sw $t5, 16($t7)

	jr $ra
erase_buzz:
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display
 	li $t4, 0x000000	# $t4 stores the black colour code 
 	
	lw $t7, bottom
	add $t7, $t0, $t7	#at bottom pixel now
	add $t0, $zero, $zero	#load zero into $t0
	addi $t1, $t7, -2560	#$t1 = bottom-2560 
	
loop:	beq $t7, $t1, erase_end
	sw $t4, 0($t7)
	sw $t4, 4($t7)
	sw $t4, 8($t7)
	sw $t4, 12($t7)
	sw $t4, 16($t7)
	sw $t4, 20($t7)
	sw $t4, 24($t7)
	sw $t4, 28($t7)
	sw $t4, 32($t7)
	
	addi $t7, $t7, -256 # go to row above
	j loop

erase_end:
	jr $ra

 END:
 	li $v0, 10 # terminate the program gracefully 
 	syscall 
	
	
