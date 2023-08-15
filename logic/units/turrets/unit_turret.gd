
# holds, aims, and fires weapons

class_name UnitTurret
extends Node2D



# FIELDS ==========



enum STATE {IDLE, AIMING}

signal aimed_at_target()


@export var weapons : Array[UnitWeapon]
# spins this node
@export var rotor : Node2D
@export var rotation_speed = 2

@export_category("Runtime")
@export var target : UnitModel
@export var state = STATE.IDLE



# CALLBACKS ==========


# PUBLIC ==========



func set_target(target : UnitModel):
	self.target = target



# PRIVATE ==========



# -- STATE HELPERS


func _set_idle():
	state = STATE.IDLE


func _set_aiming():
	state = STATE.AIMING


# -- CALLBACK FUNCTIONS


func _aim_to_target(target, delta):
	
	var target_rotation = rotor.position.angle_to(target)
	var rotation_delta = UtilFuncs.shortest_angle_distance(rotor.rotation, target_rotation)
	var rotation_displacement = sign(rotation_delta) * rotation_speed * delta
	
	# rotate towards target 
	if abs(rotation_delta) > abs(rotation_displacement):
		rotate(rotation_displacement)
	# rotate to target
	else:
		rotate(rotation_delta)
		emit_signal("aimed_at_target")
