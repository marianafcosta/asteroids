extends Area2D

signal on_destroyed

var asteroid_scene = load("res://Asteroid.tscn")

var speed = 50
var direction
var first_time_out_of_bounds = true
var variation = 3 # NOTE: Size of the asteroid, when it gets to 0, it doesn't duplicate when destroyed

var screen_size

var rng = RandomNumberGenerator.new()

func init(_variation):
	variation = _variation
	set_scale(Vector2(variation, variation))

func get_initial_direction():
	var center_of_screen = Vector2(rng.randf_range((screen_size.x / 2) - 200, (screen_size.x / 2) + 200), rng.randf_range((screen_size.y / 2) - 200, (screen_size.y / 2) + 200))
	return (center_of_screen - position).normalized()

func get_spawn_point():
	var x
	var y
	
	var sprite_width = get_node("Sprite").texture.get_width()
	var sprite_height = get_node("Sprite").texture.get_height()
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

func out_of_bounds(x, y):
	var sprite_width = self.get_node("Sprite").texture.get_width()
	var sprite_height = self.get_node("Sprite").texture.get_height()
	var is_out_of_bounds = x > screen_size.x + sprite_width || x < -sprite_width || y > screen_size.y + sprite_height || y < -sprite_height
	if (first_time_out_of_bounds):
		first_time_out_of_bounds = false
	return is_out_of_bounds

func _ready():
	rng.randomize()
	screen_size = get_viewport_rect().size
	if (variation == 3):
		position = get_spawn_point()
	direction = get_initial_direction()
	self.connect("on_destroyed", get_tree().root.get_child(0), "_on_Asteroid_destroyed")

func _process(delta):
	var velocity = direction * speed
	position += velocity * delta
	
	if (out_of_bounds(position.x, position.y) && !first_time_out_of_bounds):
		self.queue_free()

func _on_Asteroid_area_entered(area):
	emit_signal("on_destroyed")
	if (variation > 1):
		# NOTE: I can emit a signal with an array of new instances to also keep track of the smaller asteroids
		var enemy_spawner = get_tree().get_root().get_node("Root/EnemySpawner")
		var asteroid_instance_1 = asteroid_scene.instance()
		var asteroid_instance_2 = asteroid_scene.instance()
		asteroid_instance_1.init(variation - 1)
		asteroid_instance_2.init(variation - 1)
		enemy_spawner.add_child(asteroid_instance_1)
		enemy_spawner.add_child(asteroid_instance_2)
		asteroid_instance_1.global_position = position
		asteroid_instance_2.global_position = position
		asteroid_instance_1.direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1,1)).normalized()
		asteroid_instance_2.direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1,1)).normalized()
	self.queue_free()
