extends Area2D

@export var speed: int = 400
@export var radius: float = 20:
	set(value):
		radius = value
		queue_redraw()

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
	print(top_left)
	bottom_right = viewport_rect.end - Vector2(radius, radius)
	print(bottom_right)

func _process(delta) -> void:
	var new_position = position + transform.x * speed * delta

	var center: int = 0
	if position.x < top_left.x:
		print("Passed left")
		center = 180
	elif position.x > bottom_right.x:
		print("Passed right")
		center = 0
	elif position.y < top_left.y:
        print("Passed top")
		center = 270
	elif position.y > bottom_right.y:
		print("Passed bottom")
		center = 90
	else:
		position = new_position
		return

	var relative_angle: float = rotation_degrees - center
	_ricochet(relative_angle)

	position += transform.x * speed * delta

func _on_area_entered(area: Area2D):
	print(area.get_groups())
	if area.is_in_group("vaus"):
		var vaus = area as Vaus
		var offset = position.x - vaus.position.x
		var relative_offset = offset / (vaus.width/2)
		rotation_degrees = 270 + (80 * relative_offset)
	elif area.is_in_group("blocks"):
		var shape: RectangleShape2D = area.get_node("CollisionShape2D").shape
		var center = 0
		if position.x > area.position.x - shape.size.x/2 and position.x < area.position.x + shape.size.x/2:
			# above or below
			if position.y > area.position.y:
				print("Hit below")
				# hit below
				center = 270
			else:
				print("Hit above")
				# hit above
				center = 90
		elif position.x > area.position.x:
			print("Hit right")
			# hit right
			center = 0
		else:
			print("Hit left")
			# hit left
			center = 180

		var relative_angle: float = rotation_degrees - center
		_ricochet(relative_angle)

func _ricochet(incoming_angle: float):
	# +180 to reverse the ball
	# + relative_angle * 2 to ricochet to the complement of the incoming angle
	# +360 to ensure a positive angle
	rotation_degrees = rotation_degrees + 360 + 180 - (incoming_angle * 2)
	rotation_degrees = fmod(rotation_degrees + 360, 360)

