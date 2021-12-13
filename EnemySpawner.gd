extends Node2D

var asteroid_scene = preload("res://Asteroid.tscn")
var spaceship_scene = preload("res://Spaceship.tscn")
var asteroids = []
var spaceships = []

var screen_size

var rng = RandomNumberGenerator.new()

func get_spawn_point(sprite_width, sprite_height):
	var x
	var y
	
	var spawn_direction = rng.randi_range(0, 1)
	var edges_x = [0, screen_size.x]
	var edges_y = [0, screen_size.y]
	var zero_or_one = randi() % 2
	var extra_sprite_padding
	
	if spawn_direction == 0: # NOTE: Will spawn either to the left or the right of the screen
		x = edges_x[zero_or_one]
		if x == 0:
			extra_sprite_padding = - sprite_width
		else:
			extra_sprite_padding = sprite_width
		x += extra_sprite_padding
		
		y = rng.randf_range(0, screen_size.y)
	else: # NOTE: Will spawn either on the top or the bottom of the screen
		x = rng.randf_range(0, screen_size.x)
		
		y = edges_y[zero_or_one]
		if y == 0:
			extra_sprite_padding = - sprite_height
		else:
			extra_sprite_padding = sprite_height
		y += extra_sprite_padding
		
	return Vector2(x,y)

func spawn_asteroid():
	var asteroid_instance = asteroid_scene.instance()
	self.add_child(asteroid_instance)
	var asteroid_sprite = asteroid_instance.get_node("Sprite").texture
	asteroid_instance.global_position = get_spawn_point(asteroid_sprite.get_width(), asteroid_sprite.get_height())
	asteroids.append(asteroid_instance)
	
func spawn_spaceship():
	var spaceship_instance = spaceship_scene.instance()
	self.add_child(spaceship_instance)
	var spaceship_sprite = spaceship_instance.get_node("Sprite").texture
	spaceship_instance.global_position = get_spawn_point(spaceship_sprite.get_width(), spaceship_sprite.get_height())
	spaceships.append(spaceship_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	rng.randomize()
	for n in range(10):
		if (n < 2):
			spawn_spaceship()
		spawn_asteroid()
	

func _process(delta):
	for i in range(0, spaceships.size()):
		if !is_instance_valid(spaceships[i]):
			spaceships.remove(i)
			spawn_spaceship()
			
	for i in range(0, asteroids.size()):
		if !is_instance_valid(asteroids[i]):
			asteroids.remove(i)
			spawn_asteroid()
