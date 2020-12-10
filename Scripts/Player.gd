extends KinematicBody2D

export(float) var GRAVITY = 1000
export(float) var SPEED = 200
export(float) var JUMPFORCE = 500

var statePlayer = {
	"isJumping": false,
	"isAttacking": false,
	"isMoving": false,
	"isIdle": true,
	"isFacingRight": true,
	"isFacingLeft": true,
}

onready var slashPlayer = {
	"slashRight": $SlashRight,
	"animationSlashRight": $SlashRight/AnimationPlayer,
	"enemyCollision": null,
	"slashLeft": $SlashLeft,
	"animationSlashLeft": $SlashLeft/AnimationPlayer,
}

onready var player = {
	"playerSprite": $Sprite,
	"animationPlayer": $AnimationPlayer
}

var motion = Vector2(0, 0)

onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var slash = $Slash

func _physics_process(delta):
		
	var friction = false
	motion.y += GRAVITY * delta		
	
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(68):
		statePlayer["isFacingRight"] = true
		statePlayer["isFacingLeft"] = false
		statePlayer["isMoving"] = true
	elif Input.is_action_pressed("ui_left") or Input.is_key_pressed(65):
		statePlayer["isFacingRight"] = false
		statePlayer["isFacingLeft"] = true
		statePlayer["isMoving"] = true
	else:
		statePlayer["isMoving"] = false
	
	if statePlayer["isMoving"] and !statePlayer["isAttacking"]:
		if statePlayer["isFacingRight"]:
			motion.x = SPEED
			sprite.scale.x = 1.5
		else:
			motion.x = -SPEED
			sprite.scale.x = -1.5
		if is_on_floor():		
			player["animationPlayer"].play("RunPlayer")
	
	if is_on_floor():
		statePlayer["isJumping"] = Input.is_action_just_pressed("ui_up") or Input.is_key_pressed(87)	
		if !statePlayer["isJumping"]:
			
			if Input.is_key_pressed(32) and !statePlayer["isAttacking"] and !statePlayer["isMoving"]:
				statePlayer["isAttacking"] = true
				setAnimationSlash(true)
				player["animationPlayer"].play("AttackPlayer")
		else:
			friction = false
			motion.y = -JUMPFORCE
			player["animationPlayer"].play("JumpPlayer")
			
	if !statePlayer["isMoving"] and !statePlayer["isJumping"] and !statePlayer["isAttacking"]:
			friction = true
			player["animationPlayer"].play("IdlePlayer")
			
	if statePlayer["isAttacking"] and slashPlayer["enemyCollision"] != null:
					slashPlayer["enemyCollision"].queue_free()
			
	if friction:
		motion.x = lerp(motion.x, 0, 0.2)
	else:
		motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide_with_snap(motion, Vector2.DOWN, Vector2.UP)


func setAnimationSlash(state):
	if statePlayer["isFacingRight"]:
		slashPlayer["slashRight"].set_process(state)
		slashPlayer["slashRight"].set_physics_process(state)
	else:
		slashPlayer["slashLeft"].set_process(state)
		slashPlayer["slashLeft"].set_physics_process(state)
	if state:
		if statePlayer["isFacingRight"]:
			slashPlayer["animationSlashRight"].play("Slash")
		else:
			slashPlayer["animationSlashLeft"].play("Slash")
		

	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		if statePlayer["isAttacking"]:
			body.queue_free()
		else:
			queue_free()
		
		
	if body.is_in_group("Spikes"):
		queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	statePlayer["isAttacking"] = false
	setAnimationSlash(false)


func _on_SlashRight_body_entered(body):
	if body.is_in_group("Enemy"):
		slashPlayer["enemyCollision"] = body


func _on_SlashLeft_body_entered(body):
	if body.is_in_group("Enemy"):
		slashPlayer["enemyCollision"] = body
