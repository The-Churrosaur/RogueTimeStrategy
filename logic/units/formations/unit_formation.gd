
# provides a physical template for units to path to
# overrideable


class_name UnitFormation
extends Node2D



# FIELDS ==========



# units will travel to these points
# populated by controller top down, with commander at [0] 
@export var unit_nodes : Array[Node2D]
