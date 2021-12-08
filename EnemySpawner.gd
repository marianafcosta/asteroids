extends Node2D

var asteroid_scene = preload("res://Asteroid.tscn")
var asteroids = []

var screen_size

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	rng.randomize()
	var asteroid_instance
	for n in range(10):
		asteroid_instance = asteroid_scene.instance()
		add_child(asteroid_instance)
		
		asteroid_instance.global_position.x = rng.randf_range(0, screen_size.x)
		asteroid_instance.global_position.y = rng.randf_range(0, screen_size.y)
		
		asteroids.push_back(asteroid_instance)
	


func _process(delta):
	pass
