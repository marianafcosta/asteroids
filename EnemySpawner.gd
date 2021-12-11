extends Node2D

var asteroid_scene = preload("res://Asteroid.tscn")
var spaceship_scene = preload("res://Spaceship.tscn")
var asteroids = []
var spaceships = []

var screen_size

var rng = RandomNumberGenerator.new()

func spawn_asteroid():
	var asteroid_instance = asteroid_scene.instance()
	self.add_child(asteroid_instance)
	asteroid_instance.global_position.x = rng.randf_range(0, screen_size.x)
	asteroid_instance.global_position.y = rng.randf_range(0, screen_size.y)
	asteroids.append(asteroid_instance)
	
func spawn_spaceship():
	var spaceship_instance = spaceship_scene.instance()
	self.add_child(spaceship_instance)
	spaceship_instance.global_position.x = rng.randf_range(0, screen_size.x)
	spaceship_instance.global_position.y = rng.randf_range(0, screen_size.y)
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
