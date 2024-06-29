extends SpringArm3D 

@onready var camera_rotation : Vector2
@onready var sensitivity = Vector2(0.2 , 0.5)
@onready var camera = $Camera3D
var length

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	length = spring_length
	add_excluded_object(owner)


func _input(event):
	if OS.get_name() != "Android" :
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
			camera_rotation.x -= event.relative.y * sensitivity.x * get_physics_process_delta_time()
			camera_rotation.x = clamp(camera_rotation.x, -PI/2, PI/2)
			camera_rotation.y -= event.relative.x * sensitivity.y * get_physics_process_delta_time()
			rotation.x = camera_rotation.x
			rotation.y = camera_rotation.y
	
	if Input.is_action_pressed("SCROLLDOWN"):
		length = lerp(spring_length,8.0,0.1)
	if Input.is_action_pressed("SCROLLUP"):
		length = lerp(spring_length,2.0,0.1)
	spring_length = clamp(length,2,8)
	if Input.is_action_just_pressed("ui_cancel") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("ui_focus_next") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
