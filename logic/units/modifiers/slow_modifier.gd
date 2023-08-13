
# test modifier, should slow the vehicle
# TODO as signal when possible?

class_name SlowModifier
extends UnitModifier


@export var old_velocity : int 
@export var slow_velocity = 2


func add_modifier(controller : UnitController):
	old_velocity = controller.unit_model.speed
	controller.unit_model.speed = slow_velocity

func remove_modifier(controller : UnitController):
	controller.unit_model.speed = old_velocity


# properly saves and loads

#@export var i = 0
#func _process(delta):
#	i+= 1
#	print(i)
#	print(get_parent())
