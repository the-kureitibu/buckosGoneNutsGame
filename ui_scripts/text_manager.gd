extends Node2D

@export var text_label: Label
@export var text_label_creds: Label
@export var animation: AnimationPlayer

func wave_announcer(wave: int):
	

	text_label.text = "Wave: %s" % wave
	await get_tree().process_frame
	play_and_wait(animation, "fade_in")
	await get_tree().create_timer(2.0).timeout
	
	play_and_wait(animation, "fade_out")
	queue_free()
	# play animation here

func play_and_wait(anim_player: AnimationPlayer, anim_name: String) -> void:

	anim_player.play(anim_name)
	await anim_player.animation_finished

func death_announce():
	
	
	text_label.text = "You've failed, Spidor"
	await get_tree().process_frame
	play_and_wait(animation, "fade_in")
	
	await get_tree().create_timer(2.0).timeout
	
	play_and_wait(animation, "fade_out")
	queue_free()

func ending_announcer():
	
	if GameManager.true_end:
		text_label.text = "True End"
	elif GameManager.bad_end:
		text_label.text = "Bad End"
	elif GameManager.good_end:
		text_label.text = "Good End"
	
	

	await get_tree().process_frame
	play_and_wait(animation, "fade_in")
	await get_tree().create_timer(2.0).timeout
	play_and_wait(animation, "fade_out")

	$CanvasLayer/MarginContainer/VBoxContainer/Label.visible = false
	#text_label.text = "Thank you for playing! Don't forget to try out games made by other buckos!"
	await get_tree().process_frame
	await credits_announcer()
	



func credits_announcer():
	
	play_and_wait(animation, "fade_in")
	$CanvasLayer/MarginContainer/VBoxContainer/Label2.visible = true 
	await get_tree().create_timer(0.5).timeout
	$"CanvasLayer/MarginContainer/VBoxContainer/Back to Menu".visible = true


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://ui_scenes/starting_menu.tscn")
	#manual change scene here 
	queue_free()
