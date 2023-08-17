
# unit logic, controls model
# central hub for communication between components

# note: modifiers directly change export vars on their respective components
#       or export vars here when applied or removed (no onready checking)


class_name UnitController
extends Node


# FIELDS ==========


@export_category("Debug")
@export var starting_pos = Vector2.ZERO

@export_category("Model")
@export var unit_model : UnitModel
@export var unit_turrets : Array[UnitTurret]
@export var unit_vision : UnitVision

@export_category("Components")
@export var unit_modifiers : UnitModifierManager
@export var health = 10
@export var stealth = 0.9
@export var subordinates : Array[UnitController]
@export var formation : UnitFormation


# CALLBACKS ==========


func _ready():
	unit_model.position = starting_pos


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
	unit_model.set_target(target)
	if formation != null: 
		_move_formation(target)
		_set_subordinate_move_targets()
	unit_model.steer_and_move()



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


func _move_formation(target : Vector2):
	formation.position = target
	formation.rotation = unit_model.position.angle_to_point(target)

func _set_subordinate_move_targets():
	for i in subordinates.size():
		var model = subordinates[i].unit_model
		model.set_target(formation.unit_nodes[i])
		model.follow_target()

