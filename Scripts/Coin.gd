extends Area2D

@export var value: int = 1

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D):
	if body.has_method("collect_coin"):
		body.collect_coin(value)
		queue_free() 