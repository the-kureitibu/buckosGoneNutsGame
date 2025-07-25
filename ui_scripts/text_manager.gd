extends Node2D

@export var text_label: Label
@export var animation: AnimationPlayer

func wave_announcer(wave: int):
	
	#await get_tree().process_frames()
	await get_tree().process_frame
	text_label.text = "Wave: %s" % wave
	animation.play("fade_in")
	await animation.animation_finished
	
	await get_tree().create_timer(2.0).timeout
	
	
	animation.play("fade_out")
	await animation.animation_finished
	queue_free()
	# play animation here

func death_announce():
	
	await get_tree().process_frame
	text_label.text = "You've failed, Spidor"
	animation.play("fade_in")
	await animation.animation_finished
	
	await get_tree().create_timer(2.0).timeout
	
	animation.play("fade_out")
	await animation.animation_finished
	queue_free()

func ending_announcer():
	
	if GameManager.true_end:
		await get_tree().process_frame
		text_label.text = "True End"
		animation.play("fade_in")
		await animation.animation_finished
		await get_tree().create_timer(2.0).timeout
		
		animation.play("fade_out")
		await animation.animation_finished
		
		text_label.text = "Thank you for playing! Don't forget to try out games made by other buckos!"
		credits_announcer()
	
	elif GameManager.bad_end:
		await get_tree().process_frame
		text_label.text = "Bad End"
		animation.play("fade_in")
		await animation.animation_finished
		await get_tree().create_timer(2.0).timeout
		
		animation.play("fade_out")
		await animation.animation_finished
		
		text_label.text = "Thank you for playing! Don't forget to try out games made by other buckos!"
		credits_announcer()
	
	elif GameManager.good_end:
		await get_tree().process_frame
		text_label.text = "Good End"
		animation.play("fade_in")
		
		await animation.animation_finished
		
		await get_tree().create_timer(2.0).timeout
		
		animation.play("fade_out")
		await animation.animation_finished
		$CanvasLayer/MarginContainer/VBoxContainer/Label.visible = false
		credits_announcer()



func credits_announcer():
	
	animation.play("fade_in")
	$CanvasLayer/MarginContainer/VBoxContainer/Label2.visible = true 
	await get_tree().create_timer(0.5).timeout
	$"CanvasLayer/MarginContainer/VBoxContainer/Back to Menu".visible = true


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://ui_scenes/starting_menu.tscn")
	#manual change scene here 
	queue_free()
