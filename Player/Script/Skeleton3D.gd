extends Skeleton3D

@onready var distance
@export var forward : RayCast3D
@onready var left = $LeftHand
@onready var right = $RightHand



func stretchl():
	if forward.is_colliding():
		var origin = forward.global_position
		var point = forward.get_collision_point()
		distance = roundi(origin.distance_to(point))
	else:
		distance = 128
	var tw = create_tween()
	
	
	tw.tween_property(self, "bones/3/position:y",distance,0.1).set_ease(Tween.EASE_IN)
	
	tw.parallel().tween_property(self, "bones/3/scale",Vector3(8,8,8),0.1).set_ease(Tween.EASE_IN)
	tw.parallel().tween_property(self, "bones/4/scale",Vector3(4,4,4),0.1).set_ease(Tween.EASE_IN)
	
	tw.tween_property(self, "bones/3/position:y",1.1,0.05)
	
	tw.parallel().tween_property(self, "bones/3/scale",Vector3(1,1,1),0.05)
	tw.parallel().tween_property(self, "bones/4/scale",Vector3(1,1,1),0.05)
	

func stretchr():
	if forward.is_colliding():
		var origin = forward.global_position
		var point = forward.get_collision_point()
		distance = roundi(origin.distance_to(point))
	else:
		distance = 128
	
	var tw = create_tween()
	tw.tween_property(self, "bones/21/position:y",distance,0.1).set_ease(Tween.EASE_IN)
	
	tw.parallel().tween_property(self, "bones/21/scale",Vector3(8,8,8),0.1).set_ease(Tween.EASE_IN)
	tw.parallel().tween_property(self, "bones/22/scale",Vector3(4,4,4),0.1).set_ease(Tween.EASE_IN)
	
	tw.tween_property(self, "bones/21/position:y",1.1,0.05)
	
	tw.parallel().tween_property(self, "bones/21/scale",Vector3(1,1,1),0.05)
	tw.parallel().tween_property(self, "bones/22/scale",Vector3(1,1,1),0.05)
	

