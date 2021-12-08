extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var asteroid = self.get_node("Asteroid")
	asteroid.global_position.x = 100
	asteroid.global_position.y = 100
	
	print("hi")
	
	print(asteroid.position.x)
	print(asteroid.global_position.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
