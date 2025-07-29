extends CharacterBody2D

@export var stats: PlayerStats
@onready var exchu = preload("res://resources/exchu_projectile.tres")
@onready var embrace = preload("res://resources/embrace_projectile.tres")
@onready var hanger = preload("res://resources/hanger_projectile.tres")
@onready var walking_audio = $AudioStreamPlayer2D
@onready var rage_bubble = preload("res://ui_scenes/rage_speech.tscn")
@onready var pop_up_dmg = preload("res://ui_scenes/pop_up_damage.tscn")
var selected_weapon: WeaponStats

@onready var bdamage = EnemyManager.enemy_list.bucko.damage
#Movement
var input := Vector2.ZERO
@onready var base_speed = stats.base_speed
@onready var current_speed = base_speed
#var is_moving := 

#State and health 
var current_health: float = 0.0
var is_invulnerable: bool = false
var is_bleeding: bool = false
var is_slowed: bool = false
var is_knockback: bool = false
var current_state = PlayerStateManager.PlayerState.IDLE
var added_attack_speed: float
var rage_started: bool = false
var not_hit := true
var hit_count := 0
var health_state = PlayerStateManager.PlayerState.FULLY_HEALED

#timers
var current_attack_delay := 1.25
var rage_cooling_timer := 5.0
var slow_timer := 2.0


#Timers 
var invulnerable_timer := 1.5
var current_attack_cd = 0.0
var bleeding_vulnerable: bool = true
var bleed_duration := 3.0
var bleed_tick_interval := 0.5
var bleed_timer := 0.0
var bleed_tick_timer := 0.0
var regen_timer := 10.0



#Signals
signal launch_projectile(pos, dir)
signal player_death


var bdmg = 10
func debug_label():
	var labl: String = "Rage State:%s\n" % PlayerStateManager.RageState.keys()[PlayerManager.player_rage_state]
	labl += "AtkSpd Current:%s\n" % added_attack_speed
	labl += "Current attack delay:%s\n" % current_attack_delay
	if selected_weapon:
		labl += "Current attack:%s\n" % selected_weapon.damage

	$"CanvasLayer/Debug Label".text = labl


func _ready() -> void:
	stats = PlayerManager.runtime_player_stats
	current_state = PlayerStateManager.PlayerState.CAN_ATTACK

#func rage_speech():
	#print('did this worked? ')
	#if not PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGING:
		#return
#
	#var bubble = $RageSpeech
	#bubble.target_node = self
	#bubble.show_speech()

func setup_stats():
	stats = PlayerManager.runtime_player_stats
	
	match WeaponsManager.weapon_selected:
		"exchu":
			selected_weapon = stats.weapon_listings[2]
			$Exchu.visible = true
			$Sprite2D.visible = false
		"hanger":
			selected_weapon = stats.weapon_listings[0]
			$Hanger.visible = true
			$Sprite2D.visible = false
		"embrace":
			selected_weapon = stats.weapon_listings[1]
			$Embrace.visible = true
			$Sprite2D.visible = false

	
	added_attack_speed = selected_weapon.attack_speed
	current_attack_delay = max(0.1, stats.base_attack_speed - added_attack_speed)
	current_health = stats.base_health
	PlayerManager.player_current_health = stats.base_health
	
func rage_modifier():
	if PlayerManager.on_rage and !rage_started:
		rage_started = true
		#rage_speech()
		
		selected_weapon.attack_speed += selected_weapon.rage_atkspd
		atk_spd_setter()
		
		await get_tree().create_timer(5.0).timeout
		
		
		selected_weapon.attack_speed -= selected_weapon.rage_atkspd
		atk_spd_setter()
		PlayerManager.player_rage_state = PlayerStateManager.RageState.STATS_REMOVED
		await get_tree().create_timer(3.0).timeout
		PlayerManager.player_rage_state = PlayerStateManager.RageState.RAGE_RECOVERING
		
	if PlayerManager.player_rage_state == PlayerStateManager.RageState.RAGE_RECOVERING:
		await get_tree().create_timer(7.0).timeout
		PlayerManager.player_rage_state = PlayerStateManager.RageState.RAGE_DONE
		
		$RageCoolingTimer.start()
		
func atk_spd_setter():
	added_attack_speed = selected_weapon.attack_speed
	current_attack_delay = max(0.1, stats.base_attack_speed - added_attack_speed)

func _get_input():
	input = Input.get_vector("left", "right", "top", "down")
	return input

func _physics_process(delta: float) -> void:
	debug_label()
	_regen(delta)
	_handle_movement()
	rage_modifier()
	handle_attack(delta)
	_handle_debuff(delta)
	
	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false
			health_state = PlayerStateManager.PlayerState.ATTACK_RECOVERY
			invulnerable_timer = 1.5
	

func _handle_debuff(delta):
	
	#change boss damage here 
	
	if is_slowed:
		current_speed = base_speed * EnemyManager.enemy_list.boss_one.slow_multiplier
		slow_timer -= delta
		if slow_timer <= 0:
			is_slowed = false
			current_speed = base_speed
			slow_timer = 2.0
	
	
	if is_bleeding:
		bleed_timer -= delta
		bleed_tick_timer -= delta
		
		if bleed_tick_timer <= 0:
			bleed_tick_timer = bleed_tick_interval
			current_health -= EnemyManager.enemy_list.boss_two.bleed_damage

		if bleed_timer <= 0:
			is_bleeding = false
	

func _handle_movement():
	_get_input()
	if stats and stats.selected_weapon:
		velocity = input * current_speed
		if velocity.length_squared() > 0.1:
			if !walking_audio.playing:
				walking_audio.play()
		elif walking_audio.playing:
			walking_audio.stop()
	if !is_knockback:
		move_and_slide()
	
	look_at(get_global_mouse_position()) 


func handle_attack(delta):
	# instantiate projectile here 
	

	var projectile_direction = (get_global_mouse_position() - global_position).normalized()
	var projectile_position = $ProjectileMarker.global_position
	
	if current_attack_cd > 0:
		current_attack_cd -= delta
		if current_attack_cd <= 0:
			current_state = PlayerStateManager.PlayerState.CAN_ATTACK
	
	if current_state == PlayerStateManager.PlayerState.CAN_ATTACK:
		if Input.is_action_just_pressed("primary(mouse)"):
			if WeaponsManager.weapon_selected == "exchu":
				$AnimationPlayer.play("exchu_attack")
			elif WeaponsManager.weapon_selected == "embrace":
				$AnimationPlayer.play("embrace_attack")
			elif WeaponsManager.weapon_selected == "hanger":
				$AnimationPlayer.play("hanger_attack")
			
			
			launch_projectile.emit(projectile_position, projectile_direction)
			current_state = PlayerStateManager.PlayerState.CANT_ATTACK
			current_attack_cd = current_attack_delay

#Health Stuff

func got_hit(area: Area2D):
	if is_invulnerable:
		return
	
	if area.is_in_group('player_projectiles'):
		return
		
	health_state = PlayerStateManager.PlayerState.DAMAGED
	is_invulnerable = true
	invulnerable_timer = 1.5


	if area.is_in_group('enemy_hurtbox'):
		var source_name = area.get_parent().name
		var source = area.get_parent()
		var source_damage = source.damage
		var dmg = source_damage

		if source_name == 'Enemy':
			if source.is_dashing:
				var knockback_strengh := 600.0
				got_knockbacked(source, knockback_strengh)

		#if 'id_elder_one' in area:
			#dmg = EnemyManager.enemy_list.boss_one.damage
			#is_slowed = true
		#elif 'id_elder_two' in area:
			#dmg = EnemyManager.enemy_list.boss_two.damage
			#if !is_bleeding:
				#is_bleeding = true
				#bleed_timer = bleed_duration
				#bleed_tick_timer = bleed_tick_interval
		#elif 'id_elder_three' in area:
			#dmg = EnemyManager.enemy_list.boss_three.damage
			#if !is_bleeding:
				#is_bleeding = true
				#bleed_timer = bleed_duration
				#bleed_tick_timer = bleed_tick_interval

		current_health -= dmg
		if health_state == PlayerStateManager.PlayerState.DAMAGED:
			pop_up_damage(dmg, false)
			
		PlayerManager.apply_damage(current_health)
		
		
	if area.is_in_group('enemy_projectiles'):
		var src_damage = area.damage
		var elder_dmg = src_damage

		if 'id_elder_one' in area:
			is_slowed = true
		elif 'id_elder_two' in area:
			if !is_bleeding:
				is_bleeding = true
				bleed_timer = bleed_duration
				bleed_tick_timer = bleed_tick_interval
		elif 'id_elder_three' in area:
			if !is_bleeding:
				is_bleeding = true
				bleed_timer = bleed_duration
				bleed_tick_timer = bleed_tick_interval

		current_health -= elder_dmg
		if health_state == PlayerStateManager.PlayerState.DAMAGED:
			pop_up_damage(elder_dmg, false)
				
		PlayerManager.apply_damage(current_health)

		if current_health <= 0:
			die()

func pop_up_damage(damage, regen):
	var pop_up = pop_up_dmg.instantiate()
	get_tree().current_scene.add_child(pop_up)
	pop_up.position = $popup.global_position
	pop_up._show_damage(damage, regen)
	
	var tween = create_tween()
	tween.tween_property(pop_up, "position", global_position + _get_direction(), 0.75)

func _get_direction():
	return Vector2(randf_range(-1,1), -randf()) * 16

func die():
	if PlayerManager.on_rage:
		PlayerManager.on_rage = false
	
	if !$RageCoolingTimer.is_stopped():
		$RageCoolingTimer.stop()
	player_death.emit()

func _regen(delta):
	
	if !health_state == PlayerStateManager.PlayerState.ATTACK_RECOVERY:
		if regen_timer < 10.0:
			regen_timer = 10.0
		return
	
	if health_state == PlayerStateManager.PlayerState.ATTACK_RECOVERY:
		regen_timer -= delta
		
		if regen_timer <= 0:
			health_state = PlayerStateManager.PlayerState.HEALING
			$RegenTimer.start()
			regen_timer = 10.0




func got_knockbacked(source: Node2D, force: float):
	if is_knockback:
		return
	
	if !is_knockback:
		is_knockback = true
		velocity = (global_position - source.global_position).normalized() * force
		move_and_slide()
		
		Engine.time_scale = 0.3
		await get_tree().create_timer(0.08).timeout
		Engine.time_scale = 1.0

		await get_tree().create_timer(0.2).timeout
		is_knockback = false

func _on_hurt_box_body_entered(body: Node2D) -> void:

	if not body: return
	
	var knockback_direction = (global_position - body.global_position).normalized()

	if 'can_knockback' in body:
		velocity = knockback_direction * stats.repulsion_force
		

func _on_hurt_box_area_entered(area: Area2D) -> void:
	
	got_hit(area)

func test_dmg(damage):
	print(damage)

func _on_rage_cooling_timer_timeout() -> void:
	PlayerManager.rage -= PlayerManager.MAX_RAGE / 5
	
	
	if PlayerManager.rage <= 0:
		rage_started = false
		PlayerManager.on_rage = false
		PlayerManager.player_rage_state = PlayerStateManager.RageState.IDLE
		$RageCoolingTimer.stop()
	

func _on_regen_timer_timeout() -> void:
	if health_state != PlayerStateManager.PlayerState.HEALING:
		$RegenTimer.stop()
	
	if current_health < stats.base_health and health_state == PlayerStateManager.PlayerState.HEALING:
		current_health += 5.0
		pop_up_damage(5, true)
		PlayerManager.apply_damage(current_health)
		
	elif current_health == stats.base_health:
		health_state = PlayerStateManager.PlayerState.FULLY_HEALED
		$RegenTimer.stop()
		
