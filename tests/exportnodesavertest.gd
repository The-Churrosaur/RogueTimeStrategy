extends Node2D


@export var holder : Node


func _ready():
	var sprite = Sprite2D.new()
	add_child(sprite)
	sprite.owner = self
	sprite.name = "testo"
	
	holder.node = sprite
	
	var packed = PackedScene.new()
	packed.pack(self)
	
	ResourceSaver.save(packed, "res://tests/testpacked.tscn")
