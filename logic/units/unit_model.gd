
# worldspace node for units
# handles kinematic movement


# 'state machine' - while in idle, waits for new states to appear in the queue
# I bestow an edict that all states will naturally return to idle
# (FOLLOWING only returns to idle on command)


class_name UnitModel
extends CharacterBody2D



# FIELDS ==========



signal target_position_reached()
signal target_rotation_reached()


# steering turns towards the target while moving forwards
# following does not exit the following state unless otherwise prompted
enum MOVEMENT_STATE {IDLE, MOVING, ROTATING, STEERING, FOLLOWING}


@export var debug = false
@export var speed = 2
@export var rotation_speed = 1.5

@export_category("Runtime")
@export var move_target : Vector2
@export var move_node : Node2D

@export var movement_state = MOVEMENT_STATE.IDLE
@export var movement_queue : Array[MOVEMENT_STATE]



# CALLBACKS ==========



func _physics_process(delta):
	
	if move_node != null: move_target = move_node.global_position
	
	match movement_state:
		MOVEMENT_STATE.MOVING: _move_to_target(move_target, delta)
		MOVEMENT_STATE.ROTATING: _rotate_to_target(move_target, delta)
		MOVEMENT_STATE.STEERING: _steer_to_target(move_target, delta)
		MOVEMENT_STATE.FOLLOWING: _follow_target(move_target, delta)
		
		# if idle, check for next state
		MOVEMENT_STATE.IDLE: _check_update_state_queue()


# PUBLIC ==========



func set_target(target):
	
	if target is Vector2: 
		move_target = target
		move_node = null
	
	elif target is Node2D:
		move_node = target


func queue_state(state : MOVEMENT_STATE):
	movement_queue.append(state)


func rotate_and_move():
	_clear_state_queue()
	queue_state(MOVEMENT_STATE.ROTATING)
	queue_state(MOVEMENT_STATE.MOVING)


func steer_and_move():
	_clear_state_queue()
	queue_state(MOVEMENT_STATE.STEERING)
	queue_state(MOVEMENT_STATE.MOVING)


func follow_target():
	_clear_state_queue()
	queue_state(MOVEMENT_STATE.FOLLOWING)


func stop_following():
	if movement_state == MOVEMENT_STATE.FOLLOWING:
		_return_to_idle_state()


# PRIVATE ==========



# -- MOVEMENT STATE HELPERS:


func _clear_state_queue():
	movement_queue.clear()


# update the state from queue
func _check_update_state_queue():
	if !movement_queue.is_empty():
		var next_state = movement_queue.pop_front()
		_new_state_init(next_state)
		movement_state = next_state


# for behavior when state just changed
func _new_state_init(state : MOVEMENT_STATE):
	
	match state:
		MOVEMENT_STATE.MOVING: pass
		MOVEMENT_STATE.ROTATING: pass
		MOVEMENT_STATE.STEERING: pass
		MOVEMENT_STATE.FOLLOWING: pass


func _return_to_idle_state():
	movement_state = MOVEMENT_STATE.IDLE


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
		emit_signal("target_position_reached")
		_return_to_idle_state()


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
		emit_signal("target_rotation_reached")
		_return_to_idle_state()


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
		emit_signal("target_position_reached")
		_return_to_idle_state()


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


