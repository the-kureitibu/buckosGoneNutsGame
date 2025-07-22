extends Control


@export var speaker_name: Label
@export var dialogue_label: Label
@export var hbox_cont: HBoxContainer
@onready var text: PackedScene = preload("res://ui_scenes/text_manager.tscn")

var current_index := 0
var dialogue: Array
var is_last_dialogue:= false


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
		else:
			$AnimationPlayer.play("hide_canvas")
			await $AnimationPlayer.animation_finished
			var end_text = text.instantiate()
			add_child(end_text)
			end_text.ending_announcer()

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



	
