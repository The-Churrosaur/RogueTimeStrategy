extends Node2D

@export var scene : PackedScene

func _ready():
	get_tree().change_scene_to_packed(scene)
