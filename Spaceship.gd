extends Area2D

# TODO: Signal root to add to the score
signal on_destroyed

var speed = 50
var direction
var life = 3

var screen_size

var projectile_scene = preload("res://EnemyProjectile.tscn")

var rng = RandomNumberGenerator.new()

func get_initial_direction():
	# NOTE: Change this to be any direction pointing to any point in the screen (to make it easier)
	var center_of_screen = Vector2(rng.randf_range((screen_size.x / 2) - 20, (screen_size.x / 2) + 20), rng.randf_range((screen_size.y / 2) - 20, (screen_size.y / 2) + 20))
	return (center_of_screen - position).normalized()

func get_spawn_point():
	var x = 0
	var y = 0
	
	var sprite_width = get_node("Sprite").texture.get_width()
	var sprite_height = get_node("Sprite").texture.get_height()
	var spawn_direction = rng.randi_range(0, 1)
	var edges_x = [0, screen_size.x]
	var edges_y = [0, screen_size.y]
	var zero_or_one = randi() % 2
	var extra_sprite_padding = 0
	
	if spawn_direction == 0: # NOTE: Will spawn either to the left or the right of the screen
		x = edges_x[zero_or_one]
		if x == 0:
			extra_sprite_padding = -sprite_width
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
		
	print(Vector2(x,y))
	return Vector2(x,y)
	
func shoot():
	var projectile_instance = projectile_scene.instance()
	projectile_instance.init(Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized())
	get_tree().get_root().add_child(projectile_instance)
	projectile_instance.global_position.x = position.x
	projectile_instance.global_position.y = position.y
	$ProjectileSound.play()

func out_of_bounds(x, y):
	var sprite_width = self.get_node("Sprite").texture.get_width()
	var sprite_height = self.get_node("Sprite").texture.get_height()
	return x > screen_size.x + sprite_width || x < -sprite_width || y > screen_size.y + sprite_height || y < -sprite_height

func _ready():
	screen_size = get_viewport_rect().size
	rng.randomize()
	global_position = get_spawn_point()
	direction = get_initial_direction()
	self.rotate(Vector2(0,1).angle_to(direction))
	$Timer.start()
	self.connect("on_destroyed", get_tree().root.get_child(0), "_on_Spaceship_destroyed")

func _process(delta):
	var velocity = direction * speed
	var new_position = position + velocity * delta
	var sprite_width = self.get_node("Sprite").texture.get_width()
	var sprite_height = self.get_node("Sprite").texture.get_height()
	
	if (out_of_bounds(new_position.x, new_position.y)):
		if new_position.x < 0 - sprite_width:
			position.x = screen_size.x + sprite_width
		elif new_position.x > screen_size.x + sprite_width:
			position.x = 0 - sprite_width
		else:
			position.x = new_position.x
			
		if new_position.y < 0 - sprite_height:
			position.y = screen_size.y + sprite_height
		elif new_position.y > screen_size.y + sprite_height:
			position.y = 0 - sprite_height
		else:
			position.y = new_position.y
	else:
		position = new_position

func _on_Spaceship_area_entered(_area):
	life -= 1
	if (life <= 0):
		emit_signal("on_destroyed")
		$ExplosionSound.play()
		# TODO Deactivate shooting when sound is playing
		yield($ExplosionSound, "finished")
		self.queue_free()

func _on_Timer_timeout():
	$Timer.start()
	shoot()
