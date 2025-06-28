extends Area2D

var direction: Vector2 = Vector2.UP
var speed = 200

#Special

func _ready():
	#Globals.rage_ongoing.connect(rage_stat_increase)
	$AnimationPlayer.play("exchu_proj")
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale", Vector2(1.5,1.5), 0.5)

func rage_stat_increase():
	pass
	# stats dies down after 2 seconds during the 10 second cooling window 
func _process(delta: float) -> void:
	position += direction * speed * delta
	
	# Get better code for range, mainly setting a travelled distance from character 
	if Globals.outside_range == true:
		queue_free()
		Globals.outside_range = false
		

func _on_body_entered(body: Node2D) -> void:
	if 'hit' in body:
		body.hit()
				
	if Globals.rage < Globals.max_rage and Globals.rage_state == Globals.RageState.IDLE:
		Globals.rage += 1
		print(Globals.rage, 'global rage')
	if Globals.rage == Globals.max_rage and Globals.rage_state == Globals.RageState.IDLE and Globals.rage_state != Globals.RageState.RAGEDONE:
		Globals.rage_on = true
		print_debug(Globals.rage_on, ' raging?')
		print_debug('rage ongoing, cant gain rage')
		

	#if !$Timer.is_stopped():
		#print('timer on')
	#elif $Timer.is_stopped() and Globals.rage_on == false:
		#queue_free()
	#else:
	queue_free()

#func _exit_tree():
	#print_debug("Node is being removed from the scene!")

func _on_timer_timeout():
	pass
