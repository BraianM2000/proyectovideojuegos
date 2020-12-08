extends KinematicBody2D

export(float) var GRAVITY = 20
export(float) var SPEED = 180
export(float) var JUMPFORCE = 500

const UP = Vector2(0, -1)
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
	
