extends Control

@onready var sensitivity = Vector2(0.2 , 0.5)


func _gui_input(event):
	#if OS.get_name() == "Android" :
		if event is InputEventScreenDrag :
			owner.camera_rotation.x -= event.relative.y * owner.sensitivity.x * get_physics_process_delta_time()
			owner.camera_rotation.x = clamp(owner.camera_rotation.x, -PI/2, PI/2)
			owner.camera_rotation.y -= event.relative.x * owner.sensitivity.y * get_physics_process_delta_time()
			owner.rotation.x = owner.camera_rotation.x
			owner.rotation.y = owner.camera_rotation.y
