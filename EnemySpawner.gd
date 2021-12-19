extends Node2D

var asteroid_scene = preload("res://Asteroid.tscn")
var spaceship_scene = preload("res://Spaceship.tscn")
var asteroids = 5
var spaceships = 2

var screen_size

var rng = RandomNumberGenerator.new()

func add_child_asteroid_to_array(asteroid_instance):
	asteroids += 1

func spawn_asteroid():
	asteroids += 1
	var asteroid_instance = asteroid_scene.instance()
	self.add_child(asteroid_instance)
	
func spawn_spaceship():
	spaceships += 1
	var spaceship_instance = spaceship_scene.instance()
	self.add_child(spaceship_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	rng.randomize()
	for n in range(5):
		if (n < 2):
			spawn_spaceship()
		spawn_asteroid()
	

func _on_Asteroids_children_spawned(instances):
	asteroids += instances

func _on_Asteroid_destroyed():
	asteroids -= 1
	print(asteroids)

func _process(delta):
	if spaceships < 2:
		spawn_spaceship()
		
	if asteroids < 5:
		spawn_asteroid()
