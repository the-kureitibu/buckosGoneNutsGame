extends Node2D

@onready var dialogue_sc = preload("res://ui_scenes/dialogue_manager.tscn")

func _ready() -> void:
	if PlayerManager.player_died:
		PlayerManager.reset_stats()
		GameManager.reset_stats()
		await TransitionsManager.fade_out()

func _on_start_pressed() -> void:

	if GameManager.restart_game:
		GameManager.restart_game = false
		await TransitionsManager.fade_in()
		var new_sc = dialogue_sc.instantiate()
		var tree = get_tree()
		var cur_scene = tree.get_current_scene()
		tree.get_root().add_child(new_sc)
		tree.get_root().remove_child(cur_scene)
		tree.set_current_scene(new_sc)
		return 
	
	else:
		await TransitionsManager.fade_in()
		get_tree().change_scene_to_file("res://ui_scenes/dialogue_manager.tscn")
		queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()
