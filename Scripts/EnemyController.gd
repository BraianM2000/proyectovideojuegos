extends KinematicBody2D

export(float) var SPEED = 120
export(float) var positioninit  = 0
export(float) var positionfinal  = 0
var facingRight = true
var motion = Vector2(0, 0)

onready var sprite = $Sprite
onready var animation = $AnimationPlayer

func _ready():
	animation.play("GoblinRun")

func _process(delta):
			
	if facingRight:
		if get_transform().origin.x > positionfinal:
			facingRight = false
			sprite.scale.x = -1
		else:
			motion.x = SPEED
	else:
		if get_transform().origin.x < positioninit:
			facingRight = true
			sprite.scale.x = 1
		else:
			motion.x = -SPEED
	move_and_slide(motion, Vector2.UP)
