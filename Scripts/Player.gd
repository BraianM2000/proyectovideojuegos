extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 170
const JUMPFORCE = 450
var FACING_RIGHT = true
var motion = Vector2()


func _physics_process(delta):
	
	motion.y += GRAVITY

	
	if FACING_RIGHT:
		$Sprite.scale.x = 1
	else: 
		$Sprite.scale.x = -1
	
	if Input.is_action_pressed("ui_right"):
		FACING_RIGHT = true
		motion.x = SPEED
		$AnimationPlayer.play("RunPlayer")
	elif Input.is_action_pressed("ui_left"):
		FACING_RIGHT = false
		motion.x = -SPEED
		$AnimationPlayer.play("RunPlayer")
	else:
		$AnimationPlayer.play("IdlePlayer")
		motion.x = 0
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMPFORCE
	
	motion = move_and_slide(motion, UP)
	
