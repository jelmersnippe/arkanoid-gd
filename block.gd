extends Area2D

class_name Block

@export var color: Color = Color.AQUA:
	set(value):
		color = value
		queue_redraw()
		
@export var height: int = 20:
	set(value):
		height = value
		_update_collision_shape()
		queue_redraw()
		
@export var width: int = 100:
	set(value):
		width = value
		_update_collision_shape()
		queue_redraw()

func _draw():
	draw_rect(Rect2(-width/2.0, -height/2.0, width, height), color)

func _ready():
	_update_collision_shape()

func _process(delta: float) -> void:
	pass

func _update_collision_shape() -> void:
	var shape = RectangleShape2D.new()
	shape.size = Vector2(width, height)
	$CollisionShape2D.shape = shape
