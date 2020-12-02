extends Node2D

export(String) var direction

const UNIT_SIZE = 96
const IDLE_DURATION = 1.0

var move_to = 0
var speed = 3.0
var follow = Vector2.ZERO
onready var platform = $Platform
onready var tween = $MoveTween

func _ready():
	if direction == "LEFT":
		move_to = Vector2.LEFT * 400
	if direction == "RIGHT":
		move_to = Vector2.RIGHT * 400
	if direction == "UP":
		move_to = Vector2.UP * 900
	_init_tween()

func _init_tween():
	var duration = move_to.length() / float(speed * UNIT_SIZE)
	tween.interpolate_property(self, "follow", follow, move_to, duration,tween.TRANS_LINEAR,tween.EASE_IN_OUT,IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, follow, duration, Tween.TRANS_LINEAR,tween.EASE_IN_OUT,duration + IDLE_DURATION)
	tween.start()	

func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)

