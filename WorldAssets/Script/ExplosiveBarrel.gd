extends RigidBody3D

@onready var Fire = preload("res://assets/FireBall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damages, directions):
	var fire = Fire.instantiate()
	get_tree().root.add_child(fire)
	fire.position = global_position
	queue_free()
