extends Node2D


func _on_start_pressed() -> void:

	await TransitionsManager.fade_in()
	get_tree().change_scene_to_file("res://ui_scenes/dialogue_manager.tscn")
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()
