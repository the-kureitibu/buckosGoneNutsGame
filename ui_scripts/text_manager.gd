extends Node2D

@onready var text_label = $CanvasLayer/MarginContainer/VBoxContainer/Label
@onready var animation = $AnimationPlayer

func wave_announcer(wave: int):
	
	animation.play("fade_in")
	text_label.text = "Wave:%s" % wave
	await animation.animation_finished
	
	await get_tree().create_timer(2.0).timeou
	animation.play("fade_in")
	await animation.animation_finished
	# play animation here

func ending_announcer():
	
	if GameManager.true_end:
		text_label.text = "True End"
	elif GameManager.bad_end:
		text_label.text = "True End"
	elif GameManager.good_end:
		text_label.text = "True End"

func credits_announcer():
	text_label.text = "Thank you for playing! Don't forget to try out games made by other buckos!"


func _on_back_to_menu_pressed() -> void:
	pass # pass scene back to menu 
