extends Area2D

@export var speed: int = 400
@export var radius: float = 20:
	set(value):
		radius = value
		queue_redraw()
		
var velocity: Vector2 = Vector2(0, -1)

var top_left: Vector2
var bottom_right: Vector2

func _draw():
	draw_circle(Vector2(0, 0), radius, Color.CRIMSON)
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape

func _ready():
	var viewport_rect: Rect2 = get_viewport_rect()
	top_left = viewport_rect.position + Vector2(radius, radius)
	bottom_right = viewport_rect.end - Vector2(radius, radius)
	
func _check_boundaries():
	var collision_point: Vector2 = Vector2(0,0)
	if position.x < top_left.x:
		collision_point = Vector2(-1, 0)
	elif position.x > bottom_right.x:
		collision_point = Vector2(1, 0)
	elif position.y < top_left.y:
		collision_point = Vector2(0, -1)
	elif position.y > bottom_right.y:
		collision_point = Vector2(0, 1)
		
	if collision_point != Vector2(0, 0):
		adjust_rotation_degrees(get_angle_to(position + collision_point))
	
func adjust_rotation_degrees(angle_of_incidence):
	var diff = fmod(rad_to_deg(angle_of_incidence), 90)
	print("---")
	print("degrees")
	print(rad_to_deg(angle_of_incidence))
	rotation_degrees = fmod(rotation_degrees + 180 + (2 * diff), 360)

func _process(delta) -> void:
	position += transform.x * speed * delta
	_check_boundaries()
	
func _on_area_entered(area: Area2D):
	if area.is_in_group("vaus"):
		var vaus: Vaus = area as Vaus
		var offset = position.x - vaus.position.x
		var relative_offset = offset / (vaus.width/2)
		rotation_degrees = 270 + (80 * relative_offset)
	elif area.is_in_group("blocks"):
		var block: Block = area as Block
		var distance = area.position - position
		if (distance.x - (block.width - block.height) / 2) > distance.y:
			# Side
			if position.x < area.position.x:
				adjust_rotation_degrees(get_angle_to(position + Vector2(1, 0)))
			else:
				adjust_rotation_degrees(get_angle_to(position + Vector2(-1, 0)))
		else:
			# Above/Below
			if position.y < area.position.y:
				adjust_rotation_degrees(get_angle_to(position + Vector2(0, 1)))
			else:
				adjust_rotation_degrees(get_angle_to(position + Vector2(0, -1)))
		
		area.queue_free()

