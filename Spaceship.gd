extends Area2D

# TODO: Signal root to add to the score
signal on_destroyed

var speed = 50
var direction
var life = 3
var first_time_out_of_bounds = true

var screen_size

var projectile_scene = preload("res://EnemyProjectile.tscn")

var rng = RandomNumberGenerator.new()

func shoot():
	var projectile_instance = projectile_scene.instance()
	projectile_instance.init(Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized())
	get_tree().get_root().add_child(projectile_instance)
	projectile_instance.global_position.x = position.x
	projectile_instance.global_position.y = position.y

func out_of_bounds(x, y):
	var sprite_width = self.get_node("Sprite").texture.get_width()
	var sprite_height = self.get_node("Sprite").texture.get_height()
	var is_out_of_bounds = x > screen_size.x + sprite_width || x < -sprite_width || y > screen_size.y + sprite_height || y < -sprite_height
	if (first_time_out_of_bounds):
		first_time_out_of_bounds = false
	return is_out_of_bounds

func _ready():
	rng.randomize()
	direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	self.rotate(Vector2(0,1).angle_to(direction))
	screen_size = get_viewport_rect().size
	$Timer.start()
	self.connect("on_destroyed", get_tree().root.get_child(0), "_on_Spaceship_destroyed")


func _process(delta):
	var velocity = direction * speed
	position += velocity * delta
	
	if (out_of_bounds(position.x, position.y) && !first_time_out_of_bounds):
		self.queue_free()

func _on_Spaceship_area_entered(_area):
	life -= 1
	if (life <= 0):
		emit_signal("on_destroyed")
		self.queue_free()

func _on_Timer_timeout():
	$Timer.start()
	shoot()
