extends Area3D


@onready var damages = owner.damage


func _on_body_entered(body):
	if body == null: return
	if body and body.has_method("take_damage"):
		var directions = global_position.direction_to(body.global_position)
		body.take_damage(damages , directions)
	if body and body.has_method("subtraction"):
		body.subtraction(global_position ,2)

func _on_body_exited(body):
	if body and body.has_method("replace"):
		body.replace()

func _on_area_entered(area):
	if area == null: return
	if area and area.has_method("parry"):
		var directions = global_position.direction_to(area.global_position)
		area.parry(damages , directions)
	



