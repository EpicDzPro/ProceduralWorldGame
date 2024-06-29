extends RigidBody3D

var SPEEDER = 1
const SPEED = 16.0
const JUMP_VELOCITY = 16.0
@onready var spring = $CameraFPSTPS
@onready var mesh = $Armature
@onready var play = $AnimationPlayer
@onready var Floor = $RayCast3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if Input.is_action_pressed("SHIFT"):
		SPEEDER = 2
	else:
		SPEEDER = 1

func _integrate_forces(state):
	var delta = get_physics_process_delta_time()
	# Handle Jump.
	if Input.is_action_pressed("UP") and Floor.is_colliding():
		linear_velocity.y = JUMP_VELOCITY
	if !Floor.is_colliding():
		SPEEDER = 0.5
	else:
		SPEEDER = 1
	

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACKWARD")
	var direction = (Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP,spring.rotation.y)).normalized()
	print(direction)
	var look_direction = -Vector2(direction.z,direction.x)
	if look_direction.length() > 0.5:
		mesh.rotation.y = look_direction.angle()
	if direction:
		play.play("Walk")
		linear_velocity.x = move_toward(linear_velocity.x,direction.x * SPEED * SPEEDER,100*delta)
		linear_velocity.z = move_toward(linear_velocity.z,direction.z * SPEED * SPEEDER,100*delta)
	else:
		play.play("RESET")
		linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED * 100 * delta)
		linear_velocity.z = move_toward(linear_velocity.z, 0, SPEED * 100 * delta)
