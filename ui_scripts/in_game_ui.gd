extends CanvasLayer

#Progress Bars
@export var health_bar: TextureProgressBar
@export var wave_bar: TextureProgressBar
@export var rage_bar: TextureProgressBar

#Labels
@export var wave_counter: Label
@export var wave_remain_counter: Label

#Player and Waves 
@export var waves: WaveStats
@export var player_stats: PlayerStats
var player_max_rage: int = 0
var player_base_health: float = 0.0

func _ready() -> void:
	PlayerManager.health_change.connect(update_player_health)
	PlayerManager.rage_change.connect(update_player_rage)
	GameManager.update_wave_count.connect(update_wave)
	player_base_health = player_stats.base_health
	player_max_rage = player_stats.max_rage
	main_stats_getter()
	update_wave()
	update_player_health()
	update_player_rage()
	
func _process(delta: float) -> void:
	debug_label()


func debug_label():
	var labl: String = "current wave:%s\n" % wave_counter.text
	labl += "current wave mobs count:%s\n" % wave_remain_counter.text
	labl += "current player health :%s\n" % player_base_health
	labl += "current rage value:%s\n" % rage_bar.value
	$Debug.text = labl
	
func update_player_health():
	health_bar.value = player_base_health

func update_player_rage():
	rage_bar.value = PlayerManager.rage

func update_wave():
	wave_bar.value = GameManager.current_wave_mobs
	wave_remain_counter.text = str(GameManager.current_wave_mobs)
	wave_counter.text = str(GameManager.current_wave)

func main_stats_getter():
	health_bar.value = player_base_health
	health_bar.max_value = player_base_health
	rage_bar.max_value = player_max_rage
	rage_bar.value = PlayerManager.rage
	wave_bar.value = GameManager.current_wave_mobs
	wave_bar.max_value = GameManager.current_wave_mobs
	wave_remain_counter.text = str(GameManager.current_wave_mobs)
	wave_counter.text = str("Wave: ", GameManager.current_wave)
