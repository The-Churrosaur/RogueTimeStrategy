
# monitors periodically for unit hitboxes
# populates list which is ready by controller

class_name UnitVision
extends Area2D


# FIELDS ==========


signal unit_reported(unit : UnitController)

@export var refresh_vision_timer : Timer

@export_category("Runtime")
@export var visible_units : Array[UnitController]


# PUBLIC =========


# compares stealth and optics values 
# does not check if unit is in the vision area
func can_see(other_unit : UnitController) -> bool:
	
	return true


# PRIVATE ==========


func _check_area():
	
	var areas = get_overlapping_areas()
	
	visible_units.clear()
	for area in areas:
		if area is UnitHitbox:
			var unit = area.unit_controller
			if can_see(unit):
				visible_units.append(unit)
	
	
