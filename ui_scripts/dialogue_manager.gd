extends Control

@export var speaker_name: Label
@export var dialogue_label: Label
@export var hbox_cont: HBoxContainer

var current_index := 0
var dialogue: Array
var is_last_dialogue:= false
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
	var idx = dialogue[index]
	speaker_name.text = str(dialogue[current_index].speaker)
	dialogue_label.text = dialogue[current_index].line

	if idx["speaker"] == "Ami":
		hbox_cont.alignment = BoxContainer.ALIGNMENT_BEGIN
	else:
		hbox_cont.alignment = BoxContainer.ALIGNMENT_END


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_dialogue"):
		current_index += 1
		if current_index < dialogue.size():
			_set_current_index(current_index)
		elif !GameManager.game_started and current_index >= dialogue.size():
			speaker_name.text = ""
			dialogue_label.text = ""
			current_index = 0
			await TransitionsManager.fade_in()
			get_tree().change_scene_to_file("res://ui_scenes/pre_and_post_dialogue.tscn")
			queue_free()
		else:
			current_index = 0
			finished.emit()
			queue_free()
			
#
#func move_to_main_level():
	#if is_last_dialogue:
		#await TransitionsManager.fade_in()
		#get_tree().change_scene_to_file("res://scenes/level_parent.tscn")
		#queue_free()

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
	
	if !GameManager.game_started:
		dialogue = Dialogue.prologue

	if dialogue.is_empty():
		return

	_set_current_index(current_index)

	set_process(true)

	#
#func _process(delta: float) -> void:
	#dialogue_start(1, "pre")


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
