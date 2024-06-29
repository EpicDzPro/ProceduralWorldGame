using Godot;
using System;
using Godot.Collections;
public partial class Chunk : StaticBody3D
{
	public int ChunkSize = 16;
	public int Resolution = 16;
	public int MaxHeight = 16;
	public Vector3 Offset = Vector3.Zero;
	public Boolean done = false;
	private WorldT Root;
	private Godot.Collections.Array MeshData;
	private Vector3[] vertices;
	private Vector3[] normals;
	private ConcavePolygonShape3D Shape = new();
	private PlaneMesh Surface = new();
	private MeshInstance3D Instance;
	private ArrayMesh Mesher = new();
	[Export]private FastNoiseLite fast;
	[Export] public PackedScene Grass;

	
	public override void _Ready()
	{
		Instance = GetNode<MeshInstance3D>("MeshInstance3D");
		Instance.Mesh = Mesher;
		Root = GetParent<WorldT>();


	}

	public void GenerateChunk()
	{
		Surface.Size = Vector2.One * ChunkSize;
		Surface.SubdivideDepth = Resolution - 1;
		Surface.SubdivideWidth = Resolution - 1;
		
		MeshData = Surface.GetMeshArrays();

		vertices = (Vector3[])MeshData[(int)Mesh.ArrayType.Vertex];
		normals = (Vector3[])MeshData[(int)Mesh.ArrayType.Normal];
		
		for(int i=0;i<vertices.Length;i++)
		{
			float gx = vertices[i].X + Offset.X;
			float gz = vertices[i].Z + Offset.Z;
			float noise = Root.FastNoise.GetNoise2D(gx,gz) * MaxHeight;

			float xx = Root.FastNoise.GetNoise2D(gx + 2f,gz) * MaxHeight;
			float yy = Root.FastNoise.GetNoise2D(gx,gz + 2f) * MaxHeight;
			Vector3 tx = (new Vector3(gx,gz,noise)- new Vector3(gx + 2f,gz,xx)).Normalized();
			Vector3 ty = (new Vector3(gx,gz,noise)- new Vector3(gx,gz + 2f,yy)).Normalized();
			
			vertices[i] = vertices[i] with{Y = noise};
			normals[i] = tx.Cross(ty).Normalized();
			
			CallDeferred("AssetsSpawn",new Vector3(gx,noise,gz));
		}
		
		CallDeferred("Finished");
	}
	public void Finished()
	{

		MeshData[(int)Mesh.ArrayType.Vertex] = vertices;
		MeshData[(int)Mesh.ArrayType.Normal] = normals;

		Mesher.ClearSurfaces();
		Mesher.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles,MeshData);
		Instance.CreateTrimeshCollision();
		Root.Workers++;
	}
	public void AssetsSpawn(Vector3 Vertex)
	{
		Random rando = new Random();
		if(rando.Next(0,1024*2) == 4)
		{
			StaticBody3D assets = Root.Assets[rando.Next(0,Root.Assets.Length)].Instantiate<StaticBody3D>();
			Root.AddChild(assets);
			assets.Position = Vertex;
		}
		//Node3D grass = Root.Grass.Instantiate<Node3D>();
		//AddChild(grass);
		//grass.Position = Vertex;
		//grass.RotationDegrees = RotationDegrees with{Y = rando.Next(0,180)};
	}


	public void Hiding()
	{
		Visible = false;
	}
	public void Showing()
	{
		Visible = true;
	}
}
