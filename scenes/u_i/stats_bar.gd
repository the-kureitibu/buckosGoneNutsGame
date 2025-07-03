extends Control

@export var rage_prog: TextureProgressBar
@export var health_bar: TextureProgressBar
@export var wave_progress: TextureProgressBar
@export var wave_count: Label
@export var enemy_remaining: Label

#update when signal received, run current count 

func _ready() -> void:
	Globals.stat_change.connect(update_stat)
	Globals.change_mobs_count.connect(update_remaining_mobs)
	update_health()
	update_ragebar()
	update_wave_count()
	update_total_mobs()
	update_remaining_mobs()
	
func update_stat():
	update_health()
	update_ragebar()
	update_wave_count()
	update_total_mobs()
	
func update_total_mobs():
	wave_progress.value = Globals.defeated_mobs
	
	if Globals.wave_1:
		wave_progress.max_value = int(Globals.W1_MAX_ENEMY_COUNT)
	if Globals.wave_2:
		wave_progress.max_value = int(Globals.W1_MAX_ENEMY_COUNT)
	if Globals.wave_3:
		wave_progress.max_value = int(Globals.W1_MAX_ENEMY_COUNT)
		

func update_remaining_mobs():
	enemy_remaining.text = str(Globals.defeated_mobs)
	wave_progress.value = Globals.defeated_mobs
	
	if Globals.defeated_mobs <= 99:
		enemy_remaining.text = str(Globals.defeated_mobs, '  ')
	elif Globals.defeated_mobs <= 9:
		enemy_remaining.text = str(Globals.defeated_mobs, '    ')
	

func update_health():
	health_bar.value = float(Globals.ami_health)


func update_ragebar():
	rage_prog.value = int(Globals.rage)

func update_wave_count():
	if Globals.wave_1:
		wave_count.text = str("Wave: 1")
	elif Globals.wave_2:
		wave_count.text = str("Wave: 2")
	elif Globals.wave_3:
		wave_count.text = str("Wave: 3")


func change_stats_color():
	pass
