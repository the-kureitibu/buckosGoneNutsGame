extends Control

@export var speaker_name: Label
@export var dialogue_label: Label
@export var hbox_cont: HBoxContainer
@export var bg: TextureRect

var current_index := 0
var dialogue: Array
var is_last_dialogue:= false
var can_advance := false
var is_transitioning := false
@export var elder1: Sprite2D
@export var elder2: Sprite2D
@export var elder3: Sprite2D
@export var ami: Sprite2D


signal pre_dialogue_finished
signal finished
signal ready_for_next_wave

enum DialogueStates {
	PROLOGUE,
	PRE_START,
	READY_FOR_WAVE,
	DIALOG_DONE
}

var dialogue_state = DialogueStates.PROLOGUE

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

	if current_index == 1 and !GameManager.game_started:
		var tw = create_tween()
		tw.tween_property(bg, "modulate:a", 1.0, 1.0)
		$CanvasLayer/TextureRect.visible = true


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
	

	if idx["speaker"] == "Elder1":
		elder1.visible = true
		elder2.visible = false
		elder3.visible = false
		if idx.line == "...":
			$AnimationPlayer.play("elder_one_1")
		else:
			$AnimationPlayer.play("elder1")
		
	elif idx["speaker"] == "Elder2":
		elder1.visible = false
		elder2.visible = true
		elder3.visible = false
		if idx.line == "...":
			$AnimationPlayer.play("elder_two_2")
		else:
			$AnimationPlayer.play("elder2")

	elif idx["speaker"] == "Elder3":
		elder1.visible = false
		elder2.visible = false
		elder3.visible = true
		if idx.line == "...":
			$AnimationPlayer.play("elder_3_one")
		else:
			$AnimationPlayer.play("elder3")
			
	elif idx["speaker"] == "Elder1/Elder2":
		elder1.visible = true
		elder2.visible = true
		elder3.visible = true
		elder1.position.x = 400.0
		elder2.position.x = 460.0
		if idx.line == "...":
			$AnimationPlayer.play("elder_one_1")
			$AnimationPlayer.play("elder_two_2")
		else:
			$AnimationPlayer.play("elder1")
			$AnimationPlayer.play("elder2")
		
	elif idx["speaker"] == "Elder1/Elder2/Elder3":
		elder1.visible = true
		elder2.visible = true
		elder3.visible = true
		elder1.position.x = 400.0
		elder2.position.x = 460.0
		$AnimationPlayer.play("elder_one_1")
		$AnimationPlayer.play("elder_two_2")
		$AnimationPlayer.play("elder_3_one")

func _unhandled_input(_event: InputEvent) -> void:
	if not can_advance:
		return 
	
	if Input.is_action_just_pressed("next_dialogue"):
		current_index += 1
		if current_index < dialogue.size():
			_set_current_index(current_index)
		elif !GameManager.game_started and current_index >= dialogue.size():
			move_to_next_scene()
		else:
			current_index = 0
			finished.emit()
			queue_free()
		

func move_to_next_scene():
	is_transitioning = true
	can_advance = false
	speaker_name.text = ""
	dialogue_label.text = ""
	current_index = 0
	ami.visible = false
	elder1.visible = false
	elder2.visible = false
	elder3.visible = false
	$AnimationPlayer.stop()
	$CanvasLayer/TextureRect.visible = false
	$CanvasLayer/VBoxContainer2/Label.visible = false
	set_process_unhandled_input(false)
	await TransitionsManager.fade_in()
	get_tree().change_scene_to_file("res://ui_scenes/pre_and_post_dialogue.tscn")
	queue_free()

func _on_anim_finished(anim_name: String) -> void:
	can_advance = true
	$AnimationPlayer.disconnect("animation_finished", Callable(self, "_on_anim_finished"))



func run_wave_dialogue():
	
	if Input.is_action_just_pressed("next_dialogue"):
		current_index += 1
		if current_index < dialogue.size():
			_set_current_index(current_index)
		else:
			speaker_name.text = ""
			dialogue_label.text = ""
			current_index = 0
			await TransitionsManager.fade_in()
			get_tree().change_scene_to_file("res://ui_scenes/pre_and_post_dialogue.tscn")
			queue_free()
	
func pre_start_dialogue():
	dialogue = Dialogue.pre_game

func set_current_dialogue(wave: int, part: int):
	match [wave, part]:
		[1, 1]:
			dialogue = Dialogue.pre_wave_one
		[1, 2]:
			dialogue = Dialogue.post_wave_one
		[2, 1]:
			dialogue = Dialogue.pre_wave_two
		[2, 2]:
			dialogue = Dialogue.post_wave_two
		[3, 1]:
			dialogue = Dialogue.pre_wave_three
		_:
			dialogue = []
		
	current_index = 0
	if dialogue.size() > 0:
		_set_current_index(current_index)
		#run_wave_dialogue()
	else:
		push_error("Dialogue array empty for wave %d part %d" % [wave, part])


func _ready() -> void:
	await TransitionsManager.fade_out()
	if not $AnimationPlayer.is_connected("animation_finished", _on_anim_finished):
		$AnimationPlayer.connect("animation_finished", _on_anim_finished)
	
	
	ami.visible = false
	elder1.visible = false
	elder2.visible = false
	elder3.visible = false

	
	if !GameManager.game_started:
		dialogue = Dialogue.prologue

	if dialogue.is_empty():
		return

	_set_current_index(current_index)

	set_process(true)



func _on_pre_dialogue_finished() -> void:
	if dialogue_state == DialogueStates.PRE_START:
		await TransitionsManager.fade_in()
		speaker_name.text = ""
		dialogue_label.text = ""
		pre_start_dialogue()
		current_index = 0
		_set_current_index(current_index)
		GameManager.pre_game_start = true
		await TransitionsManager.fade_out()


#func _on_move_to_main_game() -> void:
	#move_to_main_level()


func _on_ready_for_next_wave() -> void:
	if not dialogue_state == DialogueStates.READY_FOR_WAVE:
		return
	
	if dialogue_state == DialogueStates.READY_FOR_WAVE:
		await TransitionsManager.fade_in()
		dialogue_state = DialogueStates.DIALOG_DONE
		print(DialogueStates.keys()[dialogue_state])
		get_tree().change_scene_to_file("res://scenes/level_parent.tscn")
		queue_free()
