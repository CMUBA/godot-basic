extends Area2D

@export var value := 1
@export var bob_height := 5.0
@export var bob_speed := 3.0

var initial_position: Vector2
var time := 0.0

func _ready():
	initial_position = position
	set_meta("value", value)

func _process(delta: float) -> void:
	time += delta
	position.y = initial_position.y + sin(time * bob_speed) * bob_height 