
# unit logic, controls model
# central hub for communication between components

# note: modifiers directly change export vars on their respective components
#       or export vars here when applied or removed (no onready checking)


class_name UnitController
extends Node


# FIELDS ==========


@export_category("Model")
@export var unit_model : UnitModel
@export var unit_turrets : Array[UnitTurret]
@export var unit_vision : UnitVision

@export_category("Components")
@export var unit_modifiers : UnitModifierManager
@export var health = 10
@export var stealth = 0.9
@export var subordinates : Array[UnitController]


# CALLBACKS ==========


func _ready():
	pass


func _input(event):
	
	# works
	
#	if event.is_action_pressed("ui_accept"):
#		var modifier = SlowModifier.new()
#		modifier.name = "slow"
#		add_modifier(modifier)
	pass


# PUBLIC ==========


func add_modifier(modifier : UnitModifier):
	unit_modifiers.add_child(modifier)
	modifier.add_modifier(self)


func move(target: Vector2):
	unit_model.steer_and_move(target)


# PRIVATE ==========


# todo connect 
func _on_unit_hitbox_entered():
	pass


func _on_targeting_timer():
	_set_targets()


func _set_targets():
	
	# temp
	var units = unit_vision.visible_units
	for turret in unit_turrets:
		turret.set_target(units.front())
	
