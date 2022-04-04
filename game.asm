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
ground: .word 16128
jump_state: .word -1
gravity_state: .word -1
health_end: .word 760
health_state: 6
.text 
 li $t0, BASE_ADDRESS # $t0 stores the base address for display 

 
.globl main
main:	
	jal draw_health
	jal decrease_health
	jal decrease_health
	jal draw_buzz
	#jal draw_alien
	jal draw_platform

main_while:
	lw $s0, bottom
	li $v0, 32 
	li $a0, 40   # Wait 40 milliseconds 
	syscall 
if_jump:
	lw $t0, jump_state		# $t0 = jump_state
	addi $t1, $zero, -1
	beq $t0, $t1, if_gravity
	
	jal buzz_jump
	j check_key
if_gravity:
	lw $t0, gravity_state		# $t0 = gravity_state
	addi $t1, $zero, -1
	beq $t0, $t1, check_key
	jal buzz_gravity
check_key:	
	li $t9, 0xffff0000  
	lw $t8, 0($t9) 
	bne $t8, 1, end_while
keypress_happened:
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before 
while_not_p:
	beq $t2, 0x70, END  # ASCII code of 'p' is 0x70
if_d:	beq $t2, 0x64, respond_to_d   # ASCII code of 'd' is 0x64 or 97
if_a:	beq $t2, 0x61, respond_to_a
if_w:	beq $t2, 0x77, respond_to_w
	j main_while
respond_to_d:
	jal move_right
	jal move_right
	j end_while

respond_to_a:
	jal move_left
	jal move_left
	j end_while
respond_to_w:
	jal bottom_check
	beq $v0, $zero, main_while
	la $t0, jump_state
	sw $zero, 0($t0)
	jal buzz_jump
	j end_while
end_while:
	lw $t0, bottom			# $t0 = bottom
	beq $s0, $t0, reset_val		# if old bottom equals new bottom no change
	jal erase_buzz			# erase old buzz
	jal draw_buzz			# draw new buzz
reset_val:
	jal bottom_check
	
	bne $v0, $zero, main_while
	
	addi $t0, $zero, -1
	lw $t1, jump_state
	bne $t1, $t0, main_while
	
	lw $t1, gravity_state
	bne $t1, $t0, main_while
	
	la $t1, gravity_state
	sw $zero, 0($t1)
	j main_while



move_right:
	lw $t0, bottom		# $t0 = bottom
	addi, $t0, $t0, 32	# $t0 = right bottom
	addi $t4, $zero, 256	# $t4 = 256
	addi $t3, $zero, 252	# $t3 = 252
	div $t0, $t4		# $t0 = $t0 % 256
	mfhi $t0	
	beq $t0, $t3, move_right_end		#if $t0 % 256 = 252 cannot move right
	
	lw $t0, bottom		# $t0 = bottom
	addi $t0, $t0, BASE_ADDRESS
	addi, $t0, $t0, 36	# $t0 = right bottom + 1 pixel
	addi $t3, $t0, -2560	# $t3= top right
	li $t1, 0x000000
	
while_right:	
	beq $t0, $t3, right
	lw $t2, 0($t0)
	bne $t2, $t1, move_right_end
	addi $t0, $t0, -256
	j while_right
	
right:
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, 4	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom

move_right_end:
	jr $ra	


move_left:
	lw $t0, bottom		# t0 = bottom
	addi $t4, $zero, 256
	div $t0, $t4
	mfhi $t0
	beq $t0, $zero, move_left_end
	
	lw $t0, bottom		# $t0 = bottom
	addi $t0, $t0, BASE_ADDRESS
	addi, $t0, $t0, -4	# $t0 = right bottom + 1 pixel
	addi $t3, $t0, -2560	# $t3= top right
	li $t1, 0x000000
	
while_left:	
	beq $t0, $t3, left
	lw $t2, 0($t0)
	bne $t2, $t1, move_left_end
	addi $t0, $t0, -256
	j while_left
	
left:
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, -4	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom

move_left_end:
	jr $ra

		
move_up:	
	lw $t0, bottom		# $t0 = bottom
	addi $t0, $t0, BASE_ADDRESS
	addi, $t0, $t0, -2560	# $t0 = right bottom + 1 pixel
	addi $t3, $t0, 36	# $t3= top right
	li $t1, 0x000000
	
while_up:	
	beq $t0, $t3, up
	lw $t2, 0($t0)
	bne $t2, $t1, move_up_end
	addi $t0, $t0, 4
	j while_up
	
up:
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, -256	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom

move_up_end:
	jr $ra
	
	
move_down:	
	lw $t0, bottom		# $t0 = bottom
	addi $t0, $t0, BASE_ADDRESS
	addi, $t0, $t0, 256	# $t0 = right bottom + 1 pixel
	addi $t3, $t0, 36	# $t3= top right
	li $t1, 0x000000
	
while_down:	
	beq $t0, $t3, down
	lw $t2, 0($t0)
	bne $t2, $t1, move_down_end
	addi $t0, $t0, 4
	j while_down
	
down:
	lw $t0, bottom		# t0 = bottom
	addi $t1, $t0, 256	# $t1 = bottom + 4
	la $t0, bottom		# $t0 = address of bottom
	sw $t1, 0($t0)		# store $t1 into bottom

move_down_end:
	jr $ra		
	
	
bottom_check:
	lw $t0, bottom		# $t0 = bottom
	addi $t0, $t0, BASE_ADDRESS
	addi $t0, $t0, 256
	addi $t3, $t0, 36
	li $t1, 0x000000
while_bottom:	
	beq $t0, $t3, bottom_false
	lw $t2, 0($t0)
	bne $t2, $t1, bottom_true
	addi $t0, $t0, 4
	j while_bottom
	
bottom_false:
	addi $v0, $zero, 0
	j bottom_check_end
bottom_true:
	addi $v0, $zero, 1
bottom_check_end:
	jr $ra
	
	
top_check:
	lw $t0, bottom		# $t0 = bottom
	addi $t0, $t0, BASE_ADDRESS
	addi $t0, $t0, -2560
	addi $t2, $t0, 36
	li $t1, 0x000000
while_top:	
	beq $t0, $t2, top_false
	lw $t2, 0($t0)
	bne $t2, $t1, top_true
	addi $t0, $t0, 4
top_false:
	addi $v0, $zero, 0
	j bottom_check_end
top_true:
	addi $v0, $zero, 1
top_check_end:
	jr $ra

		
draw_platform:
	li $t1, 0xffffff 	# $t1 stores the white colour code
	
	lw, $t0, ground
	addi $t0, $t0, BASE_ADDRESS
	
	addi $t2, $zero, 16384
	addi $t2, $t2, BASE_ADDRESS

platform_while_1:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, platform_while_1

	addi $t0, $t0, -260
	addi $t2, $t2, -516
	
platform_while_2:
	sw $t1, 0($t0)
	addi $t0, $t0, -4
	bne $t0, $t2, platform_while_2
	#addi $t0, $t0, -1716
	
	#sw $t1, 0($t0)
	#sw $t1, 4($t0)
	#sw $t1, 8($t0)
	#sw $t1, 12($t0)
	#sw $t1, 16($t0)
	#sw $t1, 20($t0)
	#sw $t1, 24($t0)
	#sw $t1, 28($t0)
	#sw $t1, 32($t0)
	
	#addi $t0, $t0, -256
	
	#sw $t1, 0($t0)
	#sw $t1, 4($t0)
	#sw $t1, 8($t0)
	#sw $t1, 12($t0)
	#sw $t1, 16($t0)
	#sw $t1, 20($t0)
	#sw $t1, 24($t0)
	#sw $t1, 28($t0)
	#sw $t1, 32($t0)
	
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
	
draw_health:
	li $t0, 0xff0000	# $t0 stores red colour code
	li $t2, 0xffffff	# $t2 stores white colour code
	lw $t1, health_end
	addi $t1, $t1, BASE_ADDRESS
	
	addi $t1, $t1, -4	# start of health
	
	sw $t0, 0($t1)		# first layer
	sw $t0, -4($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	
	
	addi $t1, $t1, 324	# second layer
	sw $t0, 0($t1)
	sw $t2, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	sw $t0, -20($t1)
	sw $t0, -24($t1)

	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t2, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	sw $t0, -20($t1)
	sw $t0, -24($t1)

	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t2, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	sw $t0, -20($t1)
	sw $t0, -24($t1)
	
	addi $t1, $t1, 320	# third layer
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	sw $t0, -20($t1)
	sw $t0, -24($t1)

	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	sw $t0, -20($t1)
	sw $t0, -24($t1)

	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	sw $t0, -20($t1)
	sw $t0, -24($t1)
	
	addi $t1, $t1, 316	# fourth layer
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	sw $t0, -12($t1)
	sw $t0, -16($t1)
	
	addi $t1, $t1, 316	# fourth layer
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)
	sw $t0, -4($t1)
	sw $t0, -8($t1)
	
	addi $t1, $t1, 316	# fourth layer
	sw $t0, 0($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)
	
	addi $t1, $t1, -32
	sw $t0, 0($t1)

	jr $ra
	
decrease_health:
	lw $t0, health_state
	
	li $t4, 0x000000
	lw $t2, health_end
	addi $t2, $t2, BASE_ADDRESS
	addi $t3, $t2, 1536
	
	addi $t1, $zero, 6
	beq $t0, $t1, decrease_six
	
	addi $t1, $zero, 5
	beq $t0, $t1, decrease_five
	
	addi $t1, $zero, 4
	beq $t0, $t1, decrease_four
	
	addi $t1, $zero, 3
	beq $t0, $t1, decrease_three
	
	addi $t1, $zero, 2
	beq $t0, $t1, decrease_two
	
	addi $t1, $zero, 1
	beq $t0, $t1, decrease_one
	
decrease_six:
	
while_dec_six:
	beq $t3, $t2, health_end_6
	sw $t4, 0($t2)
	sw $t4, -4($t2)
	sw $t4, -8($t2)
	addi $t2, $t2, 256
	j while_dec_six
	
health_end_6:
	la $t5, health_end
	lw $t6, health_end
	addi $t6, $t6, -12
	sw $t6, 0($t5)
	
	j decrement
decrease_five:
	
while_dec_five:
	beq $t3, $t2, health_end_5
	sw $t4, 0($t2)
	sw $t4, -4($t2)
	sw $t4, -8($t2)
	sw $t4, -12($t2)
	addi $t2, $t2, 256
	j while_dec_five
health_end_5:
	la $t5, health_end
	lw $t6, health_end
	addi $t6, $t6, -20
	sw $t6, 0($t5)
	
	j decrement
decrease_four:
decrease_three:
decrease_two:
decrease_one:
decrement:
	la $t5, health_state
	addi $t0, $t0, -1
	sw $t0, 0($t5)
decrease_end:
	jr $ra
erase_buzz:
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display
 	li $t4, 0x000000	# $t4 stores the black colour code 
 	
	add $t7, $zero, $s0	#$t7 = old_bottom
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

	jal top_check
	bne $v0, $zero, jump_elev
	
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
	
	addi $t3, $zero, 7
	beq $t2, $t3, jump_seven

	addi $t3, $zero, 8
	beq $t2, $t3, jump_eight
	
	addi $t3, $zero, 9
	beq $t2, $t3, jump_nine
	
	addi $t3, $zero, 11
	beq $t2, $t3, jump_elev

	j increment		#not equal to any of above jump states, jump to increment
jump_zero:	
	jal move_up
	jal move_up
	jal move_up
	jal move_up
	jal move_up

	j increment
jump_one:
	jal move_up
	jal move_up
	jal move_up
	jal move_up

	j increment
	
jump_two:
	jal move_up
	jal move_up
	jal move_up
	
	j increment
	
jump_three:
	jal move_up
	jal move_up
	
	j increment
	
jump_four:
	jal move_up
	jal move_up
	
	j increment

jump_five:
	jal move_up

	j increment

jump_six:
	jal move_up

	j increment

jump_seven:
	jal move_up

	j increment
	
jump_eight:
	jal move_up

	j increment
	
jump_nine:
	jal move_up

	j increment

jump_elev:
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
	
	jal bottom_check
	bne $v0, $zero, bottom_bound
	
	li $v0, 1
    	li $a0, 9
    	syscall
	
	lw $t1, bottom			# $t1 = bottom
	lw $t2, gravity_state		# $t2 = jump_state
	
	beq $t2, $zero, gravity_zero	# if jump_state == 0, go to jump_zero
	
	addi $t3, $zero, 1
	beq $t2, $t3, gravity_one
	
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
	bge $t2, $t3, gravity_eight
	
	j gravity_increment		#not equal to any of above gravity states, jump to increment
gravity_zero:	
	jal move_down
	
	j gravity_increment

gravity_one:	
	jal move_down
	
	j gravity_increment

gravity_two:
	jal move_down
	
	j gravity_increment
	
gravity_three:	
	jal move_down
	
	j gravity_increment

gravity_four:
	jal move_down
	jal move_down
	
	j gravity_increment
	
gravity_five:
	jal move_down
	jal move_down
	
	j gravity_increment
	
gravity_six:
	jal move_down
	jal move_down
	jal move_down
	
	j gravity_increment
	
gravity_seven:
	jal move_down
	jal move_down
	jal move_down
	jal move_down
	
	j gravity_increment

gravity_eight:
	jal move_down
	jal move_down
	jal move_down
	jal move_down
	jal move_down

	j end_gravity

bottom_bound:
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
	sw $t0, 0($t1) 
 	li $v0, 1
 	syscall
 	li $v0, 10 # terminate the program gracefully 
 	syscall 
	
	
