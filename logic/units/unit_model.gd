
# worldspace node for units
# handles kinematic movement

class_name UnitModel
extends CharacterBody2D


# FIELDS ==========


@export var speed = 2

var move_target : Vector2


# CALLBACKS ==========


func _physics_process(delta):
	_move_to_target(move_target)


# PUBLIC ==========


func set_target(move_target : Vector2):
	self.move_target = move_target


# PRIVATE ==========


func _move_to_target(target):
	
	var to_target : Vector2 = target - position
	move_and_collide(to_target.normalized() * speed)
