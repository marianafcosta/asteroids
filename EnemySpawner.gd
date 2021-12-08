extends Node2D

var asteroid_scene = preload("res://Asteroid.tscn")
var asteroids = []

var screen_size

var rng = RandomNumberGenerator.new()

func spawn_asteroid():
	var asteroid_instance = asteroid_scene.instance()
	self.add_child(asteroid_instance)
	asteroid_instance.global_position.x = rng.randf_range(0, screen_size.x)
	asteroid_instance.global_position.y = rng.randf_range(0, screen_size.y)
	asteroids.append(asteroid_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	rng.randomize()
	var asteroid_instance
	for n in range(10):
		spawn_asteroid()
	

func _process(delta):
	for i in range(0, asteroids.size()):
		if !is_instance_valid(asteroids[i]):
			asteroids.remove(i)
			spawn_asteroid()
