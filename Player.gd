extends Area2D

export var acceleration = 200
export var inertia = 100
export var max_speed = 200
export var angular_speed = 2 # NOTE: Radians

var screen_size

var direction = Vector2(0, 1)
var speed = 0

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	var rotation = 0;
	
	if Input.is_action_pressed("ui_up"):
		speed += acceleration * delta
	else:
		speed -= inertia * delta
		
	speed = clamp(speed, 0, max_speed)
	
	if Input.is_action_pressed("ui_left"):
		rotation = -(angular_speed * delta) # NOTE: Angle that it should rotate by
	if Input.is_action_pressed("ui_right"):
		rotation = angular_speed * delta
	
	var old_x = direction.x
	var old_y = direction.y
	
	self.rotate(rotation)
	
	direction.x = old_x * cos(rotation) - old_y * sin(rotation)
	direction.y = old_x * sin(rotation) + old_y * cos(rotation)
	
	velocity = direction.normalized() * speed
	if speed > 0:
		var new_position = position + velocity * delta
		var sprite_half_width = self.get_node("Sprite").texture.get_width() / 2
		var sprite_half_height = self.get_node("Sprite").texture.get_height() / 2
		
		if new_position.x < 0 - sprite_half_width:
			position.x = screen_size.x + sprite_half_width
		elif new_position.x > screen_size.x + sprite_half_width:
			position.x = 0 - sprite_half_width
		else:
			position.x = new_position.x
			
		if new_position.y < 0 - sprite_half_height:
			position.y = screen_size.y + sprite_half_height
		elif new_position.y > screen_size.y + sprite_half_height:
			position.y = 0 - sprite_half_height
		else:
			position.y = new_position.y
		
	# NOTES
	# -> The player always starts turned down
	# -> So the initial direction will always be (0,1)
	# -> a = delta_v / delta_t
	# -> delta_v = v - v0
	# -> v = v0 + a * delta_t
	# -> The direction is always a unit vector
	# -> Need to check out rotational movement equations
	
