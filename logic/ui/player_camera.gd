
# zooms in and out


class_name PlayerCamera
extends Camera2D


# FIELDS ==========


@export var zoom_in_amount = 0.9
@export var zoom_out_amount = 1.1


# CALLBACKS ==========


func _input(event):
	if event.is_action_pressed("ui_scroll_down"):
		zoom_in()
	if event.is_action_pressed("ui_scroll_up"):
		zoom_out()


# PUBLIC ==========


func zoom_in():
	_tween_zoom(zoom_in_amount)


func zoom_out():
	_tween_zoom(zoom_out_amount)


# PRIVATE ==========


func _tween_zoom(amount):
	var tween = get_tree().create_tween()
	zoom *= amount
