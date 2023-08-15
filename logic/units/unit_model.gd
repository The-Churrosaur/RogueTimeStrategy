
# worldspace node for units
# handles kinematic movement


class_name UnitModel
extends CharacterBody2D



# FIELDS ==========


signal target_position_reached()
signal target_rotation_reached()


# do proper steering later
enum MOVEMENT_STATE {HALTED, MOVING, ROTATING, STEERING}

@export var speed = 2
@export var rotation_speed = 2
# how close to the target it has to be before chilling
@export var position_precision = 1

@export_category("Runtime")
@export var move_target : Vector2
@export var rotation_target : float
@export var movement_state = MOVEMENT_STATE.HALTED



# CALLBACKS ==========



func _physics_process(delta):
	
	match movement_state:
		MOVEMENT_STATE.MOVING: _move_to_target(move_target, delta)
		MOVEMENT_STATE.ROTATING: _rotate_to_target(rotation_target, delta)



# PUBLIC ==========



func rotate_and_move(target : Vector2):
	
	move_target = target
	rotation_target = position.angle_to_point(target)
	
	print("unit: moving to: ", target)
	print("rotation: ", rotation, ", ", rotation_target)
	
	_set_rotating()
	await target_rotation_reached
	_set_moving()


# PRIVATE ==========




# -- MOVEMENT STATE SETTERS:


func _set_halt():
	movement_state = MOVEMENT_STATE.HALTED


func _set_moving():
	movement_state = MOVEMENT_STATE.MOVING


func _set_rotating(): 
	movement_state = MOVEMENT_STATE.ROTATING


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


func _rotate_to_target(target_rotation, delta):
	
	# is there a simpler way to do this???
	
	# put current rotation and target rotation in reference frame of 0 to 360
	
	var mod_rotation = fmod(rotation, TAU)
	if mod_rotation < 0: mod_rotation += TAU
	
	var mod_target = fmod(target_rotation, TAU)
	if mod_target < 0: mod_target += TAU
	
	# get the three possible distances
	# (same hemisphere, rotating positive, rotating negative)
	
	var a = mod_target - mod_rotation
	var b = mod_target - mod_rotation - TAU
	var c = mod_target - mod_rotation + TAU 
	
	# use the smallest magnitude of the three as our desired rotation + sign
	
	var distances = {abs(a):a, abs(b):b, abs(c):c}
	
	var rotation_delta = distances[distances.keys().min()]
	var rotation_displacement = sign(rotation_delta) * rotation_speed * delta
	
	# rotate towards target 
	if abs(rotation_delta) > abs(rotation_displacement):
		rotate(rotation_displacement)
	# rotate to target
	else:
		rotate(rotation_delta)
		_set_halt()
		emit_signal("target_rotation_reached")

