
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
@export var target : UnitController
@export var state = STATE.IDLE



# CALLBACKS ==========



func _physics_process(delta):
	
	match state:
		STATE.IDLE: 
			rotor.rotate(0.01)
			pass
		STATE.AIMING: 
			if target == null:
				_set_idle()
			else:
				_aim_to_target(target.unit_model.position, delta)



# PUBLIC ==========



func set_target(target : UnitController):
	self.target = target
	_set_aiming()
	
#	print(self, " turret target set: ", self.target)


func release_target():
	_set_idle()



# PRIVATE ==========



# -- STATE HELPERS


func _set_idle():
	state = STATE.IDLE


func _set_aiming():
	state = STATE.AIMING


# -- CALLBACK FUNCTIONS


func _aim_to_target(target_position, delta):
	
	var target_rotation = rotor.global_position.angle_to_point(target_position)
	var rotation_delta = UtilFuncs.shortest_angle_distance(rotor.global_rotation, target_rotation)
	var rotation_displacement = sign(rotation_delta) * rotation_speed * delta
	
	# rotate towards target 
	if abs(rotation_delta) > abs(rotation_displacement):
		rotor.rotate(rotation_displacement)
	# rotate to target
	else:
		rotor.rotate(rotation_delta)
		emit_signal("aimed_at_target")
