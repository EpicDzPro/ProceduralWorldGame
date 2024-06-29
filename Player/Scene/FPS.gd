extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var fps = Engine.get_frames_per_second()
	var x = roundi(owner.global_position.x)
	var z = roundi(owner.global_position.z)
	var y = roundi(owner.global_position.y)
	text = "FPS:"+str(fps)+"\nX:"+str(x)+" Y:"+str(y)+" Z:"+str(z)+"\nSPEED:"+str(owner.velocity.length())
