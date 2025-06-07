extends CharacterBody2D

const speed = 140
var vel = Vector2.ZERO
const friction = 2000
var dir = Vector2(0,1)

func _physics_process(delta):
	var input_vec = Vector2.ZERO
