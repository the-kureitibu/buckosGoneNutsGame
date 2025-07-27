extends Control

@export var target_node: Node2D
@export var y_offset := Vector2(0, -50) 

func _ready() -> void:
	if target_node:
		global_position = target_node.global_position + y_offset
	$VBoxContainer/HBoxContainer/NinePatchRect.visible = false

func show_speech():
	$VBoxContainer/HBoxContainer/NinePatchRect.visible = true
	self.modulate = Color(1, 1, 1, 1)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 4.0)
	
	await get_tree().create_timer(4.0).timeout
	$VBoxContainer/HBoxContainer/NinePatchRect.visible = false

func _process(_delta: float) -> void:
	if not target_node:
		return
	
	if target_node:
		global_position = target_node.global_position + y_offset
