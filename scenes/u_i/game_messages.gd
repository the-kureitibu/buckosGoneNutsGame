extends CanvasLayer

@onready var banner_text: Label = $Label
var message_timer := 2.0

func animate_text():
	$AnimationPlayer.play("text_fade_in")
	await get_tree().create_timer(message_timer).timeout
	$AnimationPlayer.play("text_fade_out")
	await $AnimationPlayer.animation_finished


func game_over_text():
	
	banner_text.text = "You Died"
	await animate_text()

func wave_text(wave: int):
	
	match wave:
		1: 
			banner_text.text = "Wave 1"
			await animate_text()
		2:
			banner_text.text = "Wave 2"
			await animate_text()
		3: 
			banner_text.text = "Wave 3"
			await animate_text()


func ending_text():
	
	if Globals.true_end:
		banner_text.text = "True End"
		await animate_text()
		credit_text()
	if Globals.good_end:
		banner_text.text = "Good End"
		await animate_text()
		credit_text()
	if Globals.bad_end:
		banner_text.text = "Bad End"
		await animate_text()
		credit_text()


func credit_text():
	banner_text.text = "Credits: Thank you for playing"
	await animate_text()
	get_tree().change_scene_to_file("res://scenes/screens_and_dialogues/starting_menu.tscn")
	queue_free()
	
	
