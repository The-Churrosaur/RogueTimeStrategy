extends Node2D

# TESTING NODE SAVING

# NOTE - this works when you reload the tscn from code 
# but the saved scene does not load properly in editor


func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		
		print("saving!")
		
		_own_children(self)
		
		var packed = PackedScene.new()
		packed.pack(self)
	
		ResourceSaver.save(packed, "res://tests/testmodifier.tscn")
	
	if event.is_action_pressed("ui_down"):
		get_tree().change_scene_to_file("res://tests/testmodifier.tscn")


func _own_children(node : Node):
	for child in node.get_children():
		child.owner = self
		print("adding owner: ", child)
		_own_children(child)
