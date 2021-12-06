extends Area2D


export var speed = 100
export var angular_speed = 1 # NOTE: Radians
var direction = Vector2(0, 1)
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	var should_move = Input.is_action_pressed("ui_up");
	var rotation = 0;
	
	if Input.is_action_pressed("ui_left"):
		rotation = -(angular_speed * delta) # NOTE: Angle that it should rotate
	if Input.is_action_pressed("ui_right"):
		rotation = angular_speed * delta
	
	var old_x = direction.x
	var old_y = direction.y
	
	self.rotate(rotation)
	
	direction.x = old_x * cos(rotation) - old_y * sin(rotation)
	direction.y = old_x * sin(rotation) + old_y * cos(rotation)
	
	if should_move:
		velocity = direction.normalized() * speed
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
	
	# NOTES
	# -> The player always starts turned down
	# -> So the initial direction will always be (0,1)
	# -> a = delta_v / delta_t
	# -> delta_v = v - v0
	# -> v = v0 + a * delta_t
	# -> The direction is always a unit vector
	# -> Need to check out rotational movement equations
	
