extends Node2D


@export var speaker_name: Label
@export var dialogue: Label
@export var hbox_cont: HBoxContainer


func just_lr(Speaker: String):
	if Speaker == "Ami":
		hbox_cont.alignment = BoxContainer.ALIGNMENT_BEGIN
	else:
		hbox_cont.alignment = BoxContainer.ALIGNMENT_END
