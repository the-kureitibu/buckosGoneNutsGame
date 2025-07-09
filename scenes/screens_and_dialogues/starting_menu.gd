extends Node2D

@onready var transition = $CanvasLayer/Transition/ColorRect/AnimationPlayer


func _on_button_start_pressed() -> void:
	#transition.get_parent().get_node("ColorRect").color.a = 00000000
	transition.play("fade_in")
	await transition.animation_finished
	get_tree().change_scene_to_file("res://scenes/Scenes/level.tscn")

func _on_button_quit_pressed() -> void:
	get_tree().quit()
