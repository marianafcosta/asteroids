extends Area2D

# TODO: Signal root to add to the score
signal on_destroyed

var speed = 50
var direction
var life = 3

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
	var sprite_half_width = self.get_node("Sprite").texture.get_width() / 2
	var sprite_half_height = self.get_node("Sprite").texture.get_height() / 2
	return (x > screen_size.x + sprite_half_width || x < -sprite_half_width || y > screen_size.y + sprite_half_height || y < -sprite_half_height)

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
	
	if (out_of_bounds(position.x, position.y)):
		self.queue_free()

func _on_Spaceship_area_entered(_area):
	life -= 1
	if (life <= 0):
		emit_signal("on_destroyed")
		self.queue_free()

func _on_Timer_timeout():
	$Timer.start()
	shoot()
