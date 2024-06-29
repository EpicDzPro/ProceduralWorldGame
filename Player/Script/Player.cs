using Godot;
using System;
using System.Security;

public partial class Player : CharacterBody3D
{
	private SpringArm3D CameraSpring;
	private Node3D Armature;
	private AnimationTree Animation;
	private AnimationTree Animation2;
	private bool fly = true;
	private int Speeder = 0;
	private float Speed = 4.0f;
	private float JumpVelocity = 8.0f;
	private float walker = 0.0f;
	private float f = 0.0f;

	
	public float gravity = ProjectSettings.GetSetting("physics/3d/default_gravity").AsSingle();

    public override void _Ready()
    {
        CameraSpring = GetNode<SpringArm3D>("CameraFPSTPS");
		Animation = GetNode<AnimationTree>("AnimationTree");
		Armature = GetNode<Node3D>("Armature");
    }

	public void _input(InputEvent @event)
	{
		if(Input.IsActionJustPressed("FLY"))
		{
			fly = !fly;
			
		}
		if(Input.IsActionPressed("SHIFT"))
		{
			Speeder = 1;
			Animation.Set("parameters/Jumping/blend_amount",1);
		}
		else if(fly)
		{
			Speeder = 1;
			Speed = 4.0f;
			Animation.Set("parameters/Jumping/blend_amount",1);
		}
		else
		{
			Speeder = 0;
		}
	}
    public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		RenderingServer.GlobalShaderParameterSet("player_pos",GlobalPosition);


		if(!IsOnFloor() && !fly)
		{
			velocity.Y -= gravity * (float)delta * 2.0f;
		}
		else
		{
			velocity.Y = 0;
		}


		if(Input.IsActionPressed("UP") && IsOnFloor() || fly && Input.IsActionPressed("UP"))
		{
			velocity.Y = Mathf.Lerp(velocity.Y,JumpVelocity,1);
			Animation.Set("parameters/Jumping/blend_amount",1);
			
		}
		else
		{
			Animation.Set("parameters/Jumping/blend_amount",0);
		}
		if(Input.IsActionPressed("DOWN") && fly)
		{
			velocity.Y = Mathf.Lerp(velocity.Y,-JumpVelocity,1);
		}


		Vector2 inputDir = Input.GetVector("LEFT", "RIGHT", "FORWARD", "BACKWARD");
		Vector3 direction = new Vector3(inputDir.X, 0, inputDir.Y).Rotated(new Vector3(0,1,0),CameraSpring.Rotation.Y);
		direction = direction.Normalized();
		Vector2 lookdirection = - new Vector2(direction.Z,direction.X);

		Animation.Set("parameters/Walking/blend_amount",Mathf.Lerp((float)Animation.Get("parameters/Walking/blend_amount"),lookdirection.Length(),0.05));
		Animation.Set("parameters/Runing/blend_amount",Mathf.Lerp((float)Animation.Get("parameters/Runing/blend_amount"),Speeder,0.1));

		if(lookdirection.Length() > 0.5)
		{
			Armature.Rotation = Armature.Rotation with{Y = (float)Mathf.LerpAngle(Armature.Rotation.Y,lookdirection.Angle(),0.1)};
		}

		if(direction != Vector3.Zero)
		{
			velocity.X = (float)Mathf.Lerp(velocity.X,direction.X * (Speed + 4 * Speed * Speeder),0.05+Speeder);
			velocity.Z = (float)Mathf.Lerp(velocity.Z,direction.Z * (Speed + 4 * Speed * Speeder),0.05+Speeder);
			f += (float)delta*8;
			walker = Mathf.Lerp(walker,Mathf.Sin(f),1-Mathf.Abs(Mathf.Sin(f)));
		}
		else
		{
			velocity.X = 0;
			velocity.Z = 0;
			f=0;
			walker = 0;
			
		}

		Velocity = velocity;
		MoveAndSlide();
	}

}
