extends CanvasLayer

@onready var colorrect = $ColorRect
@onready var animation = $AnimationPlayer
@onready var busy := false
signal animation_finished

func fade_in():
	if busy:
		await animation.animation_finished()
	busy = true
	animation.play("fade_in")
	await animation.animation_finished()
	busy = false
	
func fade_out():
	if busy:
		await animation.animation_finished()
	busy = true
	animation.play("fade_out")
	await animation.animation_finished()
	busy = false
	animation_finished.emit()
	
