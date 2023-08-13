
# held by unit controller, signals up when hit
# also handles armor, damage, and recommends modifiers to the unit controller

class_name UnitHitbox
extends Area2D


# FIELDS ==========


# read by enemy vision etc.
@export var unit_controller : UnitController
