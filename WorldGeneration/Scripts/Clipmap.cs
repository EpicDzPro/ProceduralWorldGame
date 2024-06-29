using Godot;
using System;

public partial class Clipmap : MeshInstance3D
{
	private WorldT Root;
	private PlaneMesh Plane = new PlaneMesh();
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Root = GetParent<WorldT>();
		SetMdt();

	}
	public void SetMdt()
	{
		Plane.Size = new Vector2(Root.ChunkSize * Root.ViewDistance,Root.ChunkSize * Root.ViewDistance);
	}
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//GenerateMesh();
		GlobalPosition = Root.Viewer.GlobalPosition.Snapped(new Vector3(8,10000,8));
	}
}
