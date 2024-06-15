extends Area2D

class_name Vaus

@export var speed: int = 400

var height: int = 20
@export var width: int = 100:
	set(value):
		width = value
		queue_redraw()
		
var left_screen_x: float
var right_screen_x: float
var min_x: float
var max_x: float

func _draw():
	min_x = left_screen_x + width/2.0
	max_x = right_screen_x - width/2.0
	var shape = RectangleShape2D.new()
	shape.size = Vector2(width, height)
	$CollisionShape2D.shape = shape
	draw_rect(Rect2(-width/2.0, -height/2.0, width, height), Color.BLACK)

func _ready():
	var screen_rect: Rect2 = get_viewport_rect()
	left_screen_x = screen_rect.position.x
	right_screen_x = screen_rect.end.x

func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		position.x -= speed * delta
		if position.x < min_x:
			position.x = min_x
	elif Input.is_action_pressed("right"):
		position.x += speed * delta
		if position.x > max_x:
			position.x = max_x
