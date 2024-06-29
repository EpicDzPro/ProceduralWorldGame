extends Node3D

@onready var Random = RandomNumberGenerator.new()
@export var Chunk_Scene : PackedScene

@export var Assets : Array[PackedScene]
@export var Grass : PackedScene
@export var Fast_Noise_Spawn : FastNoiseLite
@export var Fast_Noise : FastNoiseLite
@export var Resolution = 16
@export var Terrain_Size = 256
@export var Terrain_Max_Height = 1024

@export var Viewer : Node3D
@export_range(2,32,2) var View_Distance = 8


var Terrain_Cordination = Vector2()
var Current_Cordination = Vector2()
var Viewer_Position = Vector2()
var Terrain_Chunks = {}
var Chunks_Visible = 0

@export var thread_count = 10
var threads = []



func _ready():
	for i in thread_count:
		threads.append(Thread.new())
	
	
	Random.randomize()
	Fast_Noise.seed = Random.randi_range(1000000000,9999999999)
	Fast_Noise_Spawn.seed = Random.randi_range(1000000000,9999999999)
	#Scatter.global_seed = random.randi_range(1000000000,9999999999)

func _physics_process(delta):
	Current_Cordination.x = roundi(Viewer_Position.x / Terrain_Size)
	Current_Cordination.y = roundi(Viewer_Position.y / Terrain_Size)
	Viewer_Position = Vector2(Viewer.global_position.x,Viewer.global_position.z)
	#generate_world()

func generate_world():
	for x in range(-View_Distance,View_Distance + 1):
		for y in range(-View_Distance,View_Distance + 1):
			
			Terrain_Cordination.x = Current_Cordination.x + x
			Terrain_Cordination.y = Current_Cordination.y + y
			
			var Distance = Vector2()
			Distance.x = abs(x)
			Distance.y = abs(y)
			
			if !Terrain_Chunks.has(Terrain_Cordination):
				
				var Chunk = Chunk_Scene.instantiate()
				add_child(Chunk)
				Chunk.global_position = Vector3(Terrain_Cordination.x * Terrain_Size ,0, Terrain_Cordination.y * Terrain_Size)
				
				Terrain_Chunks[Terrain_Cordination] = Chunk
				#Chunk.generate()
			elif !Terrain_Chunks[Terrain_Cordination].done:
				for thread in threads:
					if thread.is_started() == false:
						thread.start(Terrain_Chunks[Terrain_Cordination].generate.bind(Terrain_Cordination,thread))
						break;
			else:
				if Distance.x >= View_Distance or Distance.y >= View_Distance:
					Terrain_Chunks[Terrain_Cordination].hide_chunk()
				else:
					Terrain_Chunks[Terrain_Cordination].show_chunk()
				
				if Distance.x >= View_Distance/2 or Distance.y >= View_Distance/2:
					Terrain_Chunks[Terrain_Cordination].hide_children()
				else:
					Terrain_Chunks[Terrain_Cordination].show_children()
				


func _exit_tree():
	for thread in threads:
		if thread.is_alive():
			thread.wait_to_finish()
