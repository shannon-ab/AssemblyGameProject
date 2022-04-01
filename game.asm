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

bottom: .word 15620
state: .word 1
ground: .word 16132
jump_state: .word -1
gravity_state: .word -1
.text 
 li $t0, BASE_ADDRESS # $t0 stores the base address for display 

 
.globl main
main:	
	jal draw_buzz
	#jal draw_alien
	jal draw_platform
if_jump:
	li $v0, 32 
	li $a0, 40   # Wait 40 milliseconds 
	syscall 
	
	lw $t0, jump_state		# $t0 = jump_state
	addi $t1, $zero, -1
	beq $t0, $t1, if_gravity
	jal buzz_jump
if_gravity:
	lw $t0, gravity_state		# $t0 = gravity_state
	addi $t1, $zero, -1
	beq $t0, $t1, check_key
	jal buzz_gravity
check_key:	
	li $t9, 0xffff0000  
	lw $t8, 0($t9) 
	bne $t8, 1, if_jump
keypress_happened:
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before 
while_not_p:
	beq $t2, 0x70, END  # ASCII code of 'p' is 0x70
if_d:	beq $t2, 0x64, respond_to_d   # ASCII code of 'd' is 0x64 or 97
if_a:	beq $t2, 0x61, respond_to_a
if_w:	beq $t2, 0x77, respond_to_w
	j if_jump
respond_to_d:
	lw $t0, bottom		# t0 = bottom
	addi, $t0, $t0, 32
	addi $t4, $zero, 256
	addi $t3, $zero, 252
	div $t0, $t4
	mfhi $t0
	beq $t0, $t3, check_key
	
	jal erase_buzz
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, 4	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	j if_jump

respond_to_a:
	lw $t0, bottom		# t0 = bottom
	addi $t4, $zero, 256
	div $t0, $t4
	mfhi $t0
	beq $t0, $zero, check_key
	
	jal erase_buzz
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, -4	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	j if_jump
respond_to_w:	
	la $t0, jump_state
	sw $zero, 0($t0)
	jal buzz_jump
	j if_jump	
j END

draw_platform:
	li $t1, 0xffffff 	# $t1 stores the white colour code
	
	lw, $t0, ground
	addi $t0, $t0, BASE_ADDRESS
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	
	addi $t0, $t0, -256

	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	jr $ra
	
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

draw_alien:
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display
 	li $t2, 0x00ff00	# $t2 stores the green colour code 
 	li $t3, 0xffffff	# $t3 stores the whitecolour code 
 	li $t4, 0x000000	# $t4 stores the black colour code 
 	li $t5, 0xa252c6	# $t5 stores purple

 	
	lw $t7, bottom
	add $t7, $t0, $t7	#at bottom pixel now
	
	li $t1, 0x0000ff	# $t1 stores the blue colour code
	sw $t1, 0($t7)		# drawing left foot
	sw $t1, 4($t7)
	sw $t1, 8($t7)
	sw $t1, 16($t7)
	sw $t1, 20($t7)		#drawing right foot
	sw $t1, 24($t7)
	
	addi $t7, $t7, -252
	li $t1, 0x87ceeb	# $t1 stores the sky blue colour code
	sw $t1, 0($t7)		
	sw $t1, 4($t7)
	sw $t1, 8($t7)
	sw $t1, 12($t7)
	sw $t1, 16($t7)		
	
	addi $t7, $t7, -256
	li $t1, 0x0000ff	# $t1 stores the sky blue colour code
	sw $t1, 0($t7)		
	sw $t1, 4($t7)
	sw $t1, 8($t7)
	sw $t1, 12($t7)
	sw $t1, 16($t7)		

	addi $t7, $t7, -260
	li $t1, 0x87ceeb	# $t1 stores the sky blue colour code
	sw $t1, 0($t7)		
	sw $t1, 4($t7)
	sw $t1, 8($t7)
	sw $t1, 12($t7)
	sw $t1, 16($t7)		
	sw $t1, 20($t7)
	sw $t1, 24($t7)

	addi $t7, $t7, -252	# purple layer
	sw $t5, 0($t7)		
	sw $t5, 4($t7)
	sw $t5, 8($t7)
	sw $t5, 12($t7)
	sw $t5, 16($t7)		

	addi $t7, $t7, -256	# green
	sw $t2, 0($t7)		
	sw $t2, 4($t7)
	sw $t2, 8($t7)
	sw $t2, 12($t7)
	sw $t2, 16($t7)		

	addi $t7, $t7, -260
	sw $t2, 0($t7)		
	sw $t2, 4($t7)
	sw $t2, 8($t7)
	sw $t2, 12($t7)
	sw $t2, 16($t7)	
	sw $t2, 20($t7)
	sw $t2, 24($t7)

	addi $t7, $t7, -256
	sw $t2, 0($t7)		
	sw $t2, 4($t7)
	sw $t2, 8($t7)
	sw $t2, 12($t7)
	sw $t2, 16($t7)	
	sw $t2, 20($t7)
	sw $t2, 24($t7)
	

	addi $t7, $t7, -256
	sw $t2, 0($t7)		
	sw $t2, 12($t7)	
	sw $t2, 24($t7)	

	addi $t7, $t7, -256	
	sw $t2, 12($t7)	
	
	jr $ra
	
buzz_jump: 
	addi $sp, $sp, -4		# save $ra onto the stack
	sw $ra, 0($sp)
	
	jal erase_buzz			# call erase_buzz
	
	lw $t1, bottom			# $t1 = bottom
	lw $t2, jump_state		# $t2 = jump_state
	addi $t3, $zero, 1
	
	beq $t2, $zero, jump_zero	# if jump_state == 0, go to jump_zero
	
	beq $t2, $t3, jump_one 		# if jump_state == 1, go to jump_one
	
	addi $t3, $zero, 2
	beq $t2, $t3, jump_two
	
	addi $t3, $zero, 3
	beq $t2, $t3, jump_three
	
	addi $t3, $zero, 4
	beq $t2, $t3, jump_four
	
	addi $t3, $zero, 5
	beq $t2, $t3, jump_five

	addi $t3, $zero, 6
	beq $t2, $t3, jump_six
	
	addi $t3, $zero, 8
	beq $t2, $t3, jump_eight

	addi $t3, $zero, 13
	beq $t2, $t3, jump_thirt
	
	jal draw_buzz
	j increment		#not equal to any of above jump states, jump to increment
jump_zero:	
	addi $t1, $t1, -1280
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j increment
jump_one:
	addi $t1, $t1, -1024
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j increment
	
jump_two:
	addi $t1, $t1, -768
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j increment
	
jump_three:
	addi $t1, $t1, -512
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j increment
	
jump_four:
	addi $t1, $t1, -512
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j increment

jump_five:
	addi $t1, $t1, -256
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz

	j increment

jump_six:
	addi $t1, $t1, -256
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz

	j increment

jump_eight:
	addi $t1, $t1, -256
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz

	j increment
jump_thirt:
	jal draw_buzz
	addi $t2, $zero, -1	# $t2 = -1
	la $t0, jump_state	# $t0 = address of jump_state
	sw $t2, 0($t0)		# jump_state = -1
	
	la $t0, gravity_state
	sw $zero, 0($t0)	#gravity_state = 0
	j end_jump
increment:
	lw $t2, jump_state	# $t2 = jump_state
	addi $t2, $t2, 1	# $t2 += 1
	la $t0, jump_state	# $t0 = address of jump_state
	sw $t2, 0($t0)		# jump_state += 1 
end_jump:	
	lw $ra, 0($sp)		# get saved $ra off stack
	addi $sp, $sp, 4
	jr $ra
	
buzz_gravity:
	addi $sp, $sp, -4		# save $ra onto the stack
	sw $ra, 0($sp)
	
	jal erase_buzz			# call erase_buzz
	
	lw $t1, bottom			# $t1 = bottom
	lw $t2, gravity_state		# $t2 = jump_state
	
	beq $t2, $zero, gravity_zero	# if jump_state == 0, go to jump_zero
	
	addi $t3, $zero, 2
	beq $t2, $t3, gravity_two
	
	addi $t3, $zero, 3
	beq $t2, $t3, gravity_three
	
	addi $t3, $zero, 4
	beq $t2, $t3, gravity_four
	
	addi $t3, $zero, 5
	beq $t2, $t3, gravity_five

	addi $t3, $zero, 6
	beq $t2, $t3, gravity_six
	
	addi $t3, $zero, 7
	beq $t2, $t3, gravity_seven
	
	addi $t3, $zero, 8
	beq $t2, $t3, gravity_eight
	
	jal draw_buzz
	j gravity_increment		#not equal to any of above gravity states, jump to increment
gravity_zero:	
	addi $t1, $t1, 256
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j gravity_increment

gravity_two:
	addi $t1, $t1, 256
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j gravity_increment
	
gravity_three:
	addi $t1, $t1, 256
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j gravity_increment
	
gravity_four:
	addi $t1, $t1, 512
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz
	
	j gravity_increment

gravity_five:
	addi $t1, $t1, 512
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz

	j gravity_increment

gravity_six:
	addi $t1, $t1, 768
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz

	j gravity_increment

gravity_seven:
	addi $t1, $t1, 1024
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz

	j gravity_increment
	
gravity_eight:
	addi $t1, $t1, 1280
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom
	jal draw_buzz

	addi $t2, $zero, -1	# $t2 = -1
	la $t0, gravity_state	# $t0 = address of gravity_state
	sw $t2, 0($t0)		# gravity_state = -1
	j end_gravity
	
gravity_increment:
	lw $t2, gravity_state	# $t2 = jump_state
	addi $t2, $t2, 1	# $t2 += 1
	la $t0, gravity_state	# $t0 = address of jump_state
	sw $t2, 0($t0)		# jump_state += 1 
	
end_gravity:	
	lw $ra, 0($sp)		# get saved $ra off stack
	addi $sp, $sp, 4
	jr $ra
	
 END:
 	li $v0, 10 # terminate the program gracefully 
 	syscall 
	
	
