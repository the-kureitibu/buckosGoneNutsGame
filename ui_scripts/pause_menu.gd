extends CanvasLayer

@onready var menu: PackedScene = preload("res://ui_scenes/starting_menu.tscn")

func _ready() -> void:
	$".".visible = false
	print($CloseContainer/HBoxContainer/XButton.is_connected("pressed", _on_x_button_pressed))
	print($MainPauseContainer/VBoxContainer/MainBackground/VBoxContainer/Quit.is_connected("pressed", _on_quit_pressed))
	print($MainPauseContainer/VBoxContainer/MainBackground/VBoxContainer/MainMenu.is_connected("pressed", _on_main_menu_pressed))

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		$".".visible = true
		get_tree().paused = true

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	GameManager.restart_game = true
	GameManager.back_to_menu_clicked = true

	await TransitionsManager.fade_in()
	var new_sc = menu.instantiate()
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(new_sc)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(new_sc)
	return 


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_x_button_pressed() -> void:
	$AnimationPlayer.play("closing")
	await $AnimationPlayer.animation_finished
	$".".visible = false
	get_tree().paused = false
