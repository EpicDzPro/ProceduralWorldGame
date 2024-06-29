using Godot;
using System;
using System.Collections.Generic;
using System.Threading;

public partial class WorldT : Node3D
{
	[Export] public int ChunkSize = 16;
	[Export] public int Resolution = 8;
	[Export] public int MaxHeight = 16;
	[Export] public int Workers = 4;
	[Export] public Node3D Viewer;
	[Export] private PackedScene ChunkScene;
	[Export] public FastNoiseLite FastNoise;
	[Export] public PackedScene[] Assets;
	[Export(PropertyHint.Range,"4,32,2")] public int ViewDistance = 8;

	private Vector2 ChunkCoordination;
	private Vector2 CurrentCoordination;
	public Vector2 ViewerCoordination;
	private Dictionary<Vector2,Chunk> Chunks = new Dictionary<Vector2,Chunk>();



	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		ViewerCoordination = new Vector2(Viewer.GlobalPosition.X,Viewer.GlobalPosition.Z).Snapped(new Vector2(16,16));
		CurrentCoordination =  (ViewerCoordination / ChunkSize).Round();
		GenerateWorld();
	}
	public void GenerateWorld()
	{
		for(int x=-ViewDistance;x<=ViewDistance;x++)
		{
			for(int y=-ViewDistance;y<=ViewDistance;y++)
			{
				ChunkCoordination = new Vector2(x + CurrentCoordination.X,y + CurrentCoordination.Y);
					
				Vector2 Distance;
				Distance = new Vector2(Mathf.Abs(x),Mathf.Abs(y));
				if(!Chunks.ContainsKey(ChunkCoordination))
				{
					Chunk NewChunk = ChunkScene.Instantiate() as Chunk;
					AddChild(NewChunk);
					NewChunk.Offset = new Vector3(ChunkCoordination.X * ChunkSize,0,ChunkCoordination.Y * ChunkSize);
					NewChunk.GlobalPosition = NewChunk.Offset;
					NewChunk.ChunkSize = ChunkSize;
					NewChunk.Resolution = Resolution;
					NewChunk.MaxHeight = MaxHeight;
					Chunks.Add(ChunkCoordination,NewChunk);

					
				}
				else
				{
					Chunk OldChunk = Chunks[ChunkCoordination];
					if(Distance.X >= ViewDistance || Distance.Y >= ViewDistance)
					{
						OldChunk.Hiding();
					}
					
					else
					{
						
						Chunks[ChunkCoordination].Showing();
						if(!OldChunk.done && Workers>0)
						{
							OldChunk.done = true;
							Workers--;
							Thread thread = new (()=>{OldChunk.GenerateChunk();});
							thread.Start();
							//OldChunk.GenerateChunk();
						}
						
					}
					
				}
				
			}
		}
	}
}
