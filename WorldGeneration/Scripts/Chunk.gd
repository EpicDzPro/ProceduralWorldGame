extends MeshInstance3D

@onready var Random = RandomNumberGenerator.new()
#@onready var Water = $Ocean
#@onready var Water_Exsist = false

@export var Assets : Array[PackedScene]
@export var Grass : PackedScene
@export var Fast_Noise_Spawn : FastNoiseLite
@export var Fast_Noise : FastNoiseLite
@export var Resolution = 16
@export var Terrain_Size = 256
@export var Terrain_Max_Height = 1024

var done = false


var Terrain_Coordinations = Vector2()
var res = Resolution

var normal_points = []
var assets_points = []
var grass_points = []


var mdt = MeshDataTool.new()
var mesher = ArrayMesh.new()
var box = PlaneMesh.new()

#var dino : Thread
var mute = Mutex.new()

func generate(Terrain_Cordination,thread=null):
	done = true
	var gp = Vector3(Terrain_Cordination.x * Terrain_Size,0,Terrain_Cordination.y * Terrain_Size)
	#Random.randomize()
	#dino = Thread.new()
	#dino.start(generate_terrian.bind(gp))
#func generate_terrian(gp):
	box.size.x = Terrain_Size
	box.size.y = Terrain_Size
	box.subdivide_depth = Resolution
	box.subdivide_width = Resolution
	mesher.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,box.get_mesh_arrays())
	mdt.create_from_surface(mesher,0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		var y = Fast_Noise.get_noise_2d(vertex.x + gp.x ,vertex.z + gp.z) * Terrain_Max_Height
		vertex.y = clampf(y,-y/8,y/8)
		mdt.set_vertex(i, vertex)
		#call_deferred("spawen_grass",vertex)
		if Random.randi_range(0,Resolution*2) == 8 and vertex.y > 0:
			call_deferred("spawen_assets",vertex)
	mesher.clear_surfaces()
	mdt.commit_to_surface(mesher)
	call_deferred("show_chunk")
	call_deferred("thread_complete",thread)


func thread_complete(thread):
	if thread != null:
		thread.wait_to_finish()
	
	mesh = mesher
	create_trimesh_collision()

func spawen_assets(vertex):
	var asset = Assets[Random.randi()% Assets.size()].instantiate()
	asset.position = vertex
	asset.rotation.y = Random.randf_range(-PI,PI)
	add_child(asset)

func spawen_grass(vertex):
	var grass = Grass.instantiate()
	grass.position = vertex
	grass.rotation.y = Random.randf_range(-PI,PI)
	add_child(grass)

func hide_chunk():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func show_chunk():
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT


func hide_children():
	for child in get_children():
		if !(child is MeshInstance3D):
			child.visible = false
	
func show_children():
	for child in get_children():
		if !(child is MeshInstance3D):
			child.visible = true



#func _exit_tree():
#	dino.wait_to_finish()
