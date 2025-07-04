extends Area2D

var direction: Vector2 = Vector2.UP
var speed = 200

func _ready() -> void:
	$AnimationPlayer.play("hanger_projectile")
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale", Vector2(1.5,1.5), 0.5)
	$QFreeTimer.start()

func _process(delta: float) -> void:
	position += direction * speed * delta
	print(position)
	
# Get better code for range, mainly setting a travelled distance from character 
	if Globals.outside_range == true:
		queue_free()
		Globals.outside_range = false
		

func rage_stat_increase():
	pass
	# stats dies down after 2 seconds during the 10 second cooling window 

func _on_body_entered(body: Node2D) -> void:
	var damage = 0
	damage = Globals.hanger_wep.Damage
	
	if 'hit' in body:
		body.hit(damage)
				
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


func _on_q_free_timer_timeout() -> void:
	queue_free()
