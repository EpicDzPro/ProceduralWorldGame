using Godot;
using System;
using System.Collections.Generic;

public partial class Skeleton3DPhysics : Skeleton3D
{
	[Export]private	Skeleton3D TargetSkeleton;
	[Export]private	float LinearSpringStiffness = 1200;
	[Export]private	float LinearSpringDamping = 40;
	[Export]private	float AngularSpringStiffness = 4000;
	[Export]private	float AngularSpringDamping = 80;
	
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		PhysicalBonesStartSimulation();
	}


    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
	{
		for(int i=0;i<GetChildCount();i++)
		{
			
			var b = GetChildOrNull<PhysicalBone3D>(i);
			if(b == null)
			{
				continue;
			}
			Transform3D target_transform = TargetSkeleton.GlobalTransform * TargetSkeleton.GetBoneGlobalPose(b.GetBoneId());
			Transform3D current_transform = GlobalTransform * GetBoneGlobalPose(b.GetBoneId());
			Basis rotation_difference = target_transform.Basis * current_transform.Basis.Inverse();

			Vector3 position_difference = target_transform.Origin - current_transform.Origin;
			if(position_difference.LengthSquared() > 1.0)
			{
				b.GlobalPosition = target_transform.Origin;
			}
			else
			{
				Vector3 force = hookes_law(position_difference, b.LinearVelocity, LinearSpringStiffness, LinearSpringDamping);
				force = force.LimitLength(99999);
				b.LinearVelocity += force * (float)delta;
			}

			var torque = hookes_law(rotation_difference.GetEuler(), b.AngularVelocity, AngularSpringStiffness, AngularSpringDamping);
			torque = torque.LimitLength(99999);
		
			b.AngularVelocity += torque * (float)delta;
		}
	}
	public Vector3 hookes_law(Vector3 displacement,Vector3 current_velocity,float stiffness,float damping)
	{
		return (stiffness * displacement) - (damping * current_velocity);
	}
}
