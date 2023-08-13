
# unit selector
# detects unit_selection_areas on - LAYER 9

class_name UnitSelector
extends Node2D


# FIELDS ==========


@export var selection_area : Area2D

var hovered_units = {}
var selected_units = []


# CALLBACKS ==========


func _physics_process(delta):
	global_position = get_global_mouse_position()


func _input(event):
	
	if event.is_action_pressed("ui_lmb"):
		selected_units.clear()
		_select_hovered_units()
	
	if event.is_action_pressed("ui_rmb"):
		for unit in selected_units:
			unit.set_target(get_global_mouse_position())
			


# PUBLIC ==========



# PRIVATE ==========


# connected to area signal
func _on_select_area_entered(area):
	if area is UnitSelectionArea:
		hovered_units[area.unit_controller] = true


# connected to area signals 
func _on_select_area_exited(area):
	if area is UnitSelectionArea:
		hovered_units[area.unit_controller] = false


# adds units to selected array
func _select_hovered_units():
	for unit in hovered_units.keys():
		if hovered_units[unit] == true:
			print("selector tool selecting: ", unit)
			selected_units.append(unit)
