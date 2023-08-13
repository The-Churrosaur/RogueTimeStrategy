
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

@export_category("Components")
@export var unit_modifiers : UnitModifierManager
@export var health = 10
@export var stealth = 0.9
@export var subordinates : Array[UnitController]


# CALLBACKS ==========


func _ready():
	unit_model.set_target(Vector2(500,500))


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


func set_target(target : Vector2):
	unit_model.set_target(target) 


# PRIVATE ==========


# connect through editor
func _on_unit_hitbox_entered():
	pass
