extends Node2D

var asteroid_scene = preload("res://Asteroid/Asteroid.tscn")
var spaceship_scene = preload("res://Spaceship/Spaceship.tscn")
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

func init():
	rng.randomize()
	for n in range(5):
		if (n < 2):
			spawn_spaceship()
		spawn_asteroid()

func _ready():
	screen_size = get_viewport_rect().size
	get_tree().get_root().get_node("Root/UI/Restart").connect("pressed", self, "_on_Restart_pressed")
	init()

func _on_Asteroid_children_spawned(instances):
	asteroids += instances

func _on_Asteroid_destroyed():
	# TODO: Possible race condition because of the method above
	asteroids -= 1

func _process(delta):
	if spaceships < 2:
		spawn_spaceship()
		
	if asteroids < 5:
		spawn_asteroid()

func _on_Restart_pressed():
	var children = self.get_children()
	for child_idx in range(0, children.size() - 1):
		children[child_idx].queue_free()
	asteroids = 5
	spaceships = 2
	init()
