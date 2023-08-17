
# worldspace node for units
# handles kinematic movement


class_name UnitModel
extends CharacterBody2D



# FIELDS ==========


signal target_position_reached()
signal target_rotation_reached()


# steering turns towards the target while moving forwards
# following does not exit the following state unless otherwise prompted
enum MOVEMENT_STATE {HALTED, MOVING, ROTATING, STEERING, FOLLOWING}

@export var debug = false
@export var speed = 2
@export var rotation_speed = 1.5
# how close to the target it has to be before chilling
@export var position_precision = 1

@export_category("Runtime")
@export var move_target : Vector2
# populates target from node if not null
# being given a target manually- overrides and sets move_node to null 
@export var move_node : Node2D
@export var movement_state = MOVEMENT_STATE.HALTED



# CALLBACKS ==========



func _physics_process(delta):
	
	if move_node != null: move_target = move_node.global_position
	
	match movement_state:
		MOVEMENT_STATE.MOVING: _move_to_target(move_target, delta)
		MOVEMENT_STATE.ROTATING: _rotate_to_target(move_target, delta)
		MOVEMENT_STATE.STEERING: _steer_to_target(move_target, delta)
		MOVEMENT_STATE.FOLLOWING: _follow_target(move_target, delta)



# PUBLIC ==========


func set_target(target):
	
	if target is Vector2: 
		move_target = target
		move_node = null
	
	elif target is Node2D:
		print("node target set")
		move_node = target


func rotate_and_move():
	
	_set_rotating()
	await target_rotation_reached
	_set_moving()


func steer_and_move():
	
	_set_steering()
	await target_rotation_reached
	_set_moving()


func follow_target():
	
	if move_node == null: return
	_set_following()


# PRIVATE ==========




# -- MOVEMENT STATE SETTERS:


func _set_halt():
	movement_state = MOVEMENT_STATE.HALTED


func _set_moving():
	movement_state = MOVEMENT_STATE.MOVING


func _set_rotating(): 
	movement_state = MOVEMENT_STATE.ROTATING


func _set_steering():
	movement_state = MOVEMENT_STATE.STEERING


func _set_following():
	movement_state = MOVEMENT_STATE.FOLLOWING


# -- MOVMENT TIMESTEP FUNCTIONS


func _move_to_target(target, delta):
	
	var to_target : Vector2 = target - position
	var displacement = to_target.normalized() * speed
	
	# move towards target
	if abs(displacement) < abs(to_target):
		move_and_collide(displacement)
	# move to target
	else:
		move_and_collide(to_target)
		_set_halt()
		emit_signal("target_position_reached")


func _rotate_to_target(target, delta):
	
	var target_rotation = global_position.angle_to_point(target)
	
	var rotation_delta = UtilFuncs.shortest_angle_distance(rotation, target_rotation)
	var rotation_displacement = sign(rotation_delta) * rotation_speed * delta
	
	if debug:
		print(target_rotation, ", ", rotation_delta)
	
	# rotate towards target 
	if abs(rotation_delta) > abs(rotation_displacement):
		rotate(rotation_displacement)
	# rotate to target
	else:
		rotate(rotation_delta)
		_set_halt()
		emit_signal("target_rotation_reached")


func _steer_to_target(target, delta):
	
	# rotate towards target
	
	var target_rotation = global_position.angle_to_point(target)
	var rotation_delta = UtilFuncs.shortest_angle_distance(rotation, target_rotation)
	var rotation_displacement = sign(rotation_delta) * rotation_speed * delta
	
	# only rotate if you won't jitter
	
	if abs(rotation_delta) > abs(rotation_displacement):
		rotate(rotation_displacement)
	
	# move forward until you hit the target
	
	var to_target : Vector2 = target - position
	var displacement = transform.x * speed
	
	if abs(displacement) < abs(to_target):
		move_and_collide(displacement)
	else:
		move_and_collide(to_target)
		_set_halt()
		emit_signal("target_position_reached")


func _follow_target(target, delta):
	
	# rotate towards target
	
	var target_rotation = global_position.angle_to_point(target)
	var rotation_delta = UtilFuncs.shortest_angle_distance(rotation, target_rotation)
	var rotation_displacement = sign(rotation_delta) * rotation_speed * delta
	
	# only rotate if you won't jitter
	
	if abs(rotation_delta) > abs(rotation_displacement):
		rotate(rotation_displacement)
	
	# keep moving, don't jitter
	
	var to_target : Vector2 = target - position
	var displacement = transform.x * speed
	
	if abs(displacement) < abs(to_target):
		move_and_collide(displacement)
