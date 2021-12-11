extends Area2D

var speed = 50
var direction
var life = 3

var screen_size

var rng = RandomNumberGenerator.new()

func out_of_bounds(x, y):
	var sprite_half_width = self.get_node("Sprite").texture.get_width() / 2
	var sprite_half_height = self.get_node("Sprite").texture.get_height() / 2
	return (x > screen_size.x + sprite_half_width || x < -sprite_half_width || y > screen_size.y + sprite_half_height || y < -sprite_half_height)

func _ready():
	rng.randomize()
	direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = direction * speed
	position += velocity * delta
	
	if (out_of_bounds(position.x, position.y)):
		self.queue_free()


func _on_Spaceship_area_entered(area):
	life -= 1
	if (life <= 0):
		self.queue_free()
