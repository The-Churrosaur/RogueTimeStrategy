
# autoloaded utility functions

class_name MyUtilFuncs
extends Node


# 2D MATH =====


# returns the shortest path from angle to target angle 
func shortest_angle_distance(angle, target_angle) -> float:
	
	# is there a simpler way to do this???
	
	# put current rotation and target rotation in reference frame of 0 to 360
	
	var mod_rotation = fmod(angle, TAU)
	if mod_rotation < 0: mod_rotation += TAU
	
	var mod_target = fmod(target_angle, TAU)
	if mod_target < 0: mod_target += TAU
	
	# get the three possible distances
	# (same hemisphere, overrotating positive, overrotating negative)
	
	var a = mod_target - mod_rotation
	var b = mod_target - mod_rotation - TAU
	var c = mod_target - mod_rotation + TAU 
	
	# use the smallest magnitude of the three as our desired rotation + sign
	
	var distances = {abs(a):a, abs(b):b, abs(c):c}
	var rotation_delta = distances[distances.keys().min()]
	
	return rotation_delta
