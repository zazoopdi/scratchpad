extends Control

var pen_down : bool = false
var can_draw : bool = true


func _ready() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true, 0)
	
	#Comment out the below if you want borders
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true, 0)

	get_viewport().transparent_bg = true

func _process(delta) -> void:
	if pen_down:
		var new_dot = MeshInstance2D.new()
		new_dot.mesh = SphereMesh.new()
		new_dot.scale = Vector2(20, 20)
		new_dot.modulate = $ButtonContainer/ButtonBox/ColorPickerButton.color
		new_dot.position = get_global_mouse_position()
		new_dot.add_to_group("dots")
		add_child(new_dot)

func _input(event):
	if event is InputEventMouseButton and event.pressed and !pen_down and can_draw:
		pen_down = true

	elif event is InputEventMouseButton and !event.pressed and pen_down:
		pen_down = false #effectively = pen_up


func clear_page():
	for node in get_tree().get_nodes_in_group("dots"):
		node.queue_free()
		
func erase():
	#probably need some sort of area2d to capture dots
	#which will mean adding a collision to each of the dots, lol
	pass

func _pop_out_control() -> void:
	can_draw = false
	var move_tween = get_tree().create_tween()
	move_tween.tween_property($ButtonContainer, "position", Vector2(1700, 400), 0.1)


func _pop_in_control() -> void: #gets called when hovering over buttons, sadface
	can_draw = true
	var move_tween = get_tree().create_tween()
	move_tween.tween_property($ButtonContainer, "position", Vector2(1850, 400), 0.1)
