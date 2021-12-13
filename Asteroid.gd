extends Area2D

# TODO: Signal root to add to the score
signal on_destroyed

var speed = 50
var direction
var first_time_out_of_bounds = true

var screen_size

var rng = RandomNumberGenerator.new()

func out_of_bounds(x, y):
	var sprite_width = self.get_node("Sprite").texture.get_width()
	var sprite_height = self.get_node("Sprite").texture.get_height()
	var is_out_of_bounds = x > screen_size.x + sprite_width || x < -sprite_width || y > screen_size.y + sprite_height || y < -sprite_height
	if (first_time_out_of_bounds):
		first_time_out_of_bounds = false
	return is_out_of_bounds

func _ready():
	rng.randomize()
	# TODO: The direction will go to a random point within the bounds of the screen
	direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	screen_size = get_viewport_rect().size
	self.connect("on_destroyed", get_tree().root.get_child(0), "_on_Asteroid_destroyed")

func _process(delta):
	var velocity = direction * speed
	position += velocity * delta
	
	if (out_of_bounds(position.x, position.y) && !first_time_out_of_bounds):
		self.queue_free()

func _on_Asteroid_area_entered(area):
	emit_signal("on_destroyed")
	self.queue_free()
