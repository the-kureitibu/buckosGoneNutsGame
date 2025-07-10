extends Node2D

@onready var transition = $CanvasLayer/Transition/ColorRect/AnimationPlayer
#var dialogue_scene: Node

func _ready() -> void:
	if Globals.ami_health == 0:
		transition.play("fade_out")

func _on_button_start_pressed() -> void:
	DialogueStates.current_dialogue_type = "pre_start"
	transition.play("fade_in")
	await transition.animation_finished
	get_tree().change_scene_to_file("res://scenes/screens_and_dialogues/interactions.tscn")
	
	#dialogue_scene.connect("dialogue_done", _on_dialog_done)


func _on_button_quit_pressed() -> void:
	get_tree().quit()
	
#func _on_dialog_done():
