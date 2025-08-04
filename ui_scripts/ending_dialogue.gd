extends Control


@export var speaker_name: Label
@export var dialogue_label: Label
@export var hbox_cont: HBoxContainer
@onready var text: PackedScene = preload("res://ui_scenes/text_manager.tscn")
@export var elder1: Sprite2D
@export var elder2: Sprite2D
@export var elder3: Sprite2D
@export var ami: Sprite2D
@export var bg_bad_end: TextureRect
@export var bg_true_end: TextureRect


var current_index := 0
var dialogue: Array
var is_last_dialogue:= false
var can_advance := false
var is_transitioning := false


func _on_anim_finished(anim_name: String) -> void:
	can_advance = true
	$AnimationPlayer.disconnect("animation_finished", Callable(self, "_on_anim_finished"))


func _set_current_index(index: int):
	if not $AnimationPlayer.is_connected("animation_finished", _on_anim_finished):
		$AnimationPlayer.connect("animation_finished", _on_anim_finished)
	
	can_advance = false
	
	var idx = dialogue[index]
	speaker_name.text = str(dialogue[current_index].speaker)
	dialogue_label.text = dialogue[current_index].line

	if idx["speaker"] == "Ami":
		ami.visible = true
		hbox_cont.alignment = BoxContainer.ALIGNMENT_BEGIN
	else:
		hbox_cont.alignment = BoxContainer.ALIGNMENT_END

	if idx["speaker"] == "Ami" and idx["emotion"] == "happy":
		$AnimationPlayer.play("ami_happy")
	if idx["speaker"] == "Ami" and idx["emotion"] == "monkas":
		ami.position.x = 68.0
		$AnimationPlayer.play("ami_monkas")
	if idx["speaker"] == "Ami" and idx["emotion"] == "angry":
		ami.position.x = 65.0
		$AnimationPlayer.play("ami_angry")
	if idx["speaker"] == "Ami" and idx["emotion"] == "annoyed":
		ami.position.x = 70.0
		$AnimationPlayer.play("ami_annoyed")
	
	if GameManager.bad_end:
		var tw = create_tween()
		tw.tween_property(bg_bad_end, "modulate:a", 1.0, 1.0)
		bg_bad_end.visible = true
	if GameManager.true_end:
		var tw = create_tween()
		tw.tween_property(bg_true_end, "modulate:a", 1.0, 1.0)
		bg_true_end.visible = true


	if idx["speaker"] == "Elder1":
		elder1.visible = true
		elder2.visible = false
		elder3.visible = false
		elder1.position.x = 548.5
		if idx.line == "...":
			$AnimationPlayer.play("elder1_1")
		else:
			$AnimationPlayer.play("elder1")
		
	elif idx["speaker"] == "Elder2":
		elder1.visible = false
		elder2.visible = true
		elder3.visible = false
		elder2.position.x = 548.5
		if idx.line == "...":
			$AnimationPlayer.play("elder2_1")
		else:
			$AnimationPlayer.play("elder2")

	elif idx["speaker"] == "Elder3":
		elder1.visible = false
		elder2.visible = false
		elder3.visible = true
		if idx.line == "...":
			$AnimationPlayer.play("elder3_1")
		else:
			$AnimationPlayer.play("elder3")
			
	elif idx["speaker"] == "Elder1/Elder2":
		elder1.visible = true
		elder2.visible = true
		elder3.visible = true
		if idx.line == "...":
			$AnimationPlayer.play("elder1_1")
			$AnimationPlayer.play("elder2_1")
		else:
			$AnimationPlayer.play("elder1")
			$AnimationPlayer.play("elder2")
		
	elif idx["speaker"] == "Elder1/Elder2/Elder3":
		elder1.visible = true
		elder2.visible = true
		elder3.visible = true
		elder1.position.x = 399.0
		elder2.position.x = 459.0
		$AnimationPlayer.play("all_elders")


func _unhandled_input(event: InputEvent) -> void:

	if not can_advance:
		return
	
	if Input.is_action_just_pressed("next_dialogue"):
		current_index += 1
		if current_index < dialogue.size():
			_set_current_index(current_index)
		else:
			can_advance = false
			play_and_wait($AnimationPlayer, "hide_canvas")
			is_transitioning = true
			var end_text = text.instantiate()
			add_child(end_text)
			end_text.ending_announcer()


func play_and_wait(anim_player: AnimationPlayer, anim_name: String) -> void:
	anim_player.play(anim_name)
	await anim_player.animation_finished

func run_final_dialogue():

	current_index = 0
	if dialogue.size() > 0:
		_set_current_index(current_index)
		##run_wave_dialogue()
	else:
		push_error("Dialogue array empty for wave %d part %d")
#

func _ready() -> void:
	await TransitionsManager.fade_out()
	if not $AnimationPlayer.is_connected("animation_finished", _on_anim_finished):
		$AnimationPlayer.connect("animation_finished", _on_anim_finished)
	
	ami.visible = false
	elder1.visible = false 
	elder2.visible = false
	elder3.visible = false
	
	#GameManager.bad_end = true
	#GameManager.good_end = true
	#GameManager.true_end = true
	
	if GameManager.bad_end:
		dialogue = Dialogue.bad_end
	if GameManager.true_end:
		dialogue = Dialogue.true_end
	if GameManager.good_end:
		dialogue = Dialogue.good_end

	if dialogue.is_empty():
		return

	run_final_dialogue()

	set_process(true)



	
