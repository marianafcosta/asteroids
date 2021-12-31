extends Area2D

signal on_destroyed
signal on_children_spawned

var asteroid_scene = load("res://Asteroid.tscn")

var speed = 50
var direction
var variation = 3 # NOTE: Size of the asteroid, when it gets to 0, it doesn't duplicate when destroyed

var screen_size

var rng = RandomNumberGenerator.new()

func init(_variation):
	variation = _variation
	set_scale(Vector2(variation, variation))

func get_initial_direction():
	var center_of_screen = Vector2(rng.randf_range((screen_size.x / 2) - 200, (screen_size.x / 2) + 200), rng.randf_range((screen_size.y / 2) - 200, (screen_size.y / 2) + 200))
	return (center_of_screen - position).normalized()

func spawn_child_asteroids():
	var enemy_spawner = get_tree().get_root().get_node("Root/EnemySpawner")
	var asteroid_instance_1 = asteroid_scene.instance()
	var asteroid_instance_2 = asteroid_scene.instance()
	asteroid_instance_1.init(variation - 1)
	asteroid_instance_2.init(variation - 1)
	# TODO: Move this logic to the enemy spawner?
	enemy_spawner.add_child(asteroid_instance_1)
	enemy_spawner.add_child(asteroid_instance_2)
	asteroid_instance_1.global_position = position
	asteroid_instance_2.global_position = position
	asteroid_instance_1.direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1,1)).normalized()
	asteroid_instance_2.direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1,1)).normalized()
	emit_signal("on_children_spawned", 2)

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
	return x > screen_size.x + sprite_width || x < -sprite_width || y > screen_size.y + sprite_height || y < -sprite_height

func _ready():
	rng.randomize()
	screen_size = get_viewport_rect().size
	if (variation == 3):
		position = get_spawn_point()
	direction = get_initial_direction()
	self.connect("on_destroyed", get_tree().root.get_child(0), "_on_Asteroid_destroyed")
	self.connect("on_destroyed", get_tree().get_root().get_node("Root/EnemySpawner"), "_on_Asteroid_destroyed")
	self.connect("on_children_spawned", get_tree().get_root().get_node("Root/EnemySpawner"), "_on_Asteroid_children_spawned")

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

func _on_Asteroid_area_entered(area):
	# TODO The collisions in this frame are still detected, use something like a state machine to keep track of this?
	# NOTE Apparently Godot doesn't like disabling collision shapes in signal methods
	# https://www.reddit.com/r/godot/comments/aih2ce/having_problems_disabling_body_entered_signal/
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Sprite.visible = false
	emit_signal("on_destroyed")
	match(variation):
		3:
			$LargeExplosionSound.play()
			$Sprite.visible = false
			$ExplosionSprite.visible = true
			spawn_child_asteroids()
			$ExplosionAnimation.play("Explode")
			yield($ExplosionAnimation, "animation_finished")
			$ExplosionSprite.visible = false
			yield($LargeExplosionSound, "finished")
			self.queue_free()
		2:
			$MediumExplosionSound.play()
			$Sprite.visible = false
			$ExplosionSprite.visible = true
			spawn_child_asteroids()
			$ExplosionAnimation.play("Explode")
			yield($ExplosionAnimation, "animation_finished")
			$ExplosionSprite.visible = false
			yield($MediumExplosionSound, "finished")
			self.queue_free()
		1:
			$SmallExplosionSound.play()
			$Sprite.visible = false
			$ExplosionSprite.visible = true
			$ExplosionAnimation.play("Explode")
			# NOTE If the sound finishes first, the yield for the sound will never return
			# TODO Change this logic so that the order of the yields don't matter
			# Same for the above
			yield($ExplosionAnimation, "animation_finished")
			$ExplosionSprite.visible = false
			yield($SmallExplosionSound, "finished")
			self.queue_free()
