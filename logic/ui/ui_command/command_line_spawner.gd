
# draws lines from a unit to its subordinates


class_name CommandLineSpawner
extends Node2D



# FIELDS ==========



@export var unit_controller : UnitController
@export var line2D_template : PackedScene

@export_category("Runtime")
@export var lines : Array[Line2D]



# CALLBACKS ==========



func _ready():
	setup_lines()


func _process(delta):
	
	# draw the lines
	_draw_lines()



# PUBLIC ==========



func setup_lines():
	
	for line in lines: line.queue_free()
	lines.clear()
	
	for unit in unit_controller.subordinates:
		var line = line2D_template.instantiate()
		add_child(line)
		lines.append(line)



# PRIVATE ==========



func _draw_lines():
	
	var pos_a = unit_controller.unit_model.position
	for i in lines.size():
		var pos_b = unit_controller.subordinates.keys()[i].unit_model.position
		var line = lines[i]
		line.set_point_position(0, pos_a)
		line.set_point_position(1, pos_b)


func _on_controller_subordinates_changed(subordinate):
	setup_lines()
