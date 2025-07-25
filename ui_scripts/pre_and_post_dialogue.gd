extends Control

@export var speaker_name: Label
@export var dialogue_label: Label
@export var hbox_cont: HBoxContainer
@export var elder1: Sprite2D
@export var elder2: Sprite2D
@export var elder3: Sprite2D
@onready var audio = $AudioStreamPlayer
@export var ami: Sprite2D

var current_index := 0
var dialogue: Array
var is_last_dialogue:= false

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
		elder1.position.x = 400.0
		elder2.position.x = 460.0
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
		elder1.position.x = 423.0
		elder2.position.x = 482.0
		#$AnimationPlayer.play("elder_one_1")
		#$AnimationPlayer.play("elder_two_2")
		#$AnimationPlayer.play("elder_3_one")


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_dialogue"):
		current_index += 1
		if current_index < dialogue.size():
			_set_current_index(current_index)
		elif current_index == dialogue.size():
			if !audio.playing:
				audio.play()
			else:
				if audio.playing:
					audio.stop()
		else:
			speaker_name.text = ""
			dialogue_label.text = ""
			current_index = 0
			ami.visible = false
			elder1.visible = false 
			elder2.visible = false
			elder3.visible = false
			await TransitionsManager.fade_in()
			get_tree().change_scene_to_file("res://scenes/level_parent.tscn")
			queue_free()
	
	
func _ready() -> void:
	await TransitionsManager.fade_out()
	ami.visible = false
	elder1.visible = false 
	elder2.visible = false
	elder3.visible = false
	
	if !GameManager.game_started:
		dialogue = Dialogue.pre_game

	if dialogue.is_empty():
		return

	_set_current_index(current_index)

	set_process(true)


func _on_ready_for_next_wave() -> void:
	if GameManager.game_started:
		return


	
