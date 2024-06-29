extends CharacterBody3D

var fly = true
var SPEEDER = 0
const SPEED = 8.0
const JUMP_VELOCITY = 8.0
@onready var spring = $CameraFPSTPS
@onready var mesh = $Armature
@onready var play = $AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if Input.is_action_just_pressed("FLY"):
		fly = !fly

func _physics_process(delta):
	if Input.is_action_pressed("SHIFT") or fly:
		SPEEDER = 1
	else:
		SPEEDER = 0
	play.set("parameters/running/blend_amount",SPEEDER)
	# Add the gravity.
	if not is_on_floor() and !fly:
		velocity.y -= gravity * delta * 2
	else:
		velocity.y = 0

	# Handle Jump.
	if Input.is_action_pressed("UP") and is_on_floor() or fly and Input.is_action_pressed("UP"):
		velocity.y = lerp(velocity.y,JUMP_VELOCITY * SPEEDER,1)
	if Input.is_action_pressed("DOWN") and fly:
		velocity.y = lerp(velocity.y,-JUMP_VELOCITY * SPEEDER,1)
	

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACKWARD")
	var direction = (Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP,spring.rotation.y)).normalized()
	var look_direction = -Vector2(direction.z,direction.x)
	play.set("parameters/walking/blend_amount",lerp(play.get("parameters/walking/blend_amount"),look_direction.length(),0.1))
	if look_direction.length() > 0.5:
		
		mesh.rotation.y = lerp_angle(mesh.rotation.y,look_direction.angle(),0.1)
	if direction:
		velocity.x = lerp(velocity.x,direction.x * ( SPEED + SPEEDER + SPEED),0.1)
		velocity.z = lerp(velocity.z,direction.z * ( SPEED + SPEEDER + SPEED),0.1)
	else:
		velocity.x = 0
		velocity.z = 0
	move_and_slide()
