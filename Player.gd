extends Area2D

signal on_game_over
signal on_life_lost

export var acceleration = 300
export var inertia = 100
export var max_speed = 200
export var angular_speed = 2 # NOTE: Radians

var screen_size

var direction = Vector2(0, 1) # NOTE: Facing down
var speed = 0
var projectiles = []
var lives = 3

var projectile_scene = preload("res://Projectile.tscn")

func respawn():
	position.y = screen_size.y / 2
	position.x = screen_size.x / 2
	speed = 0
	var initial_direction = Vector2(0, 1)
	self.rotate(direction.angle_to(initial_direction))
	direction = initial_direction

func shoot():
	var projectile_instance = projectile_scene.instance()
	projectile_instance.init(direction)
	get_tree().get_root().add_child(projectile_instance)
	projectile_instance.global_position.x = position.x
	projectile_instance.global_position.y = position.y
	projectiles.append(projectile_instance)

func _ready():
	# TODO: Rename this signal to be more generic
	screen_size = get_viewport_rect().size
	self.connect("on_life_lost", get_tree().root.get_node("Root/UI"), "_on_Player_life_lost")
	self.connect("on_game_over", get_tree().root.get_node("Root/UI"), "_on_Player_game_over")
	emit_signal("on_life_lost", lives)

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
	
	if Input.is_action_just_pressed("ui_accept"):
		shoot()


func _on_Player_area_entered(area):
	lives -= 1
	emit_signal("on_life_lost", lives)
	if (lives <= 0):
		emit_signal("on_game_over")
		self.queue_free()
		
	respawn()
