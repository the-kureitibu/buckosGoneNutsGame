extends Area2D

const SEGMENT_SPACE: float = 64
const MAX_SEGMENT_LENGTH: int = 3
var segment_count := 0
@onready var mid_chain: PackedScene = preload("res://projectile_scenes/chain_projectile_mid.tscn")
@onready var tip_chain: PackedScene = preload("res://projectile_scenes/chain_projectile_tip.tscn")

func _ready() -> void:
	#place_chain_tip()
	await get_tree().create_timer(2.0).timeout
	start_extending_chain()
	
func start_extending_chain():
	extend_chain()

func place_chain_tip():
	var tip_chain = tip_chain.instantiate()
	var offset = Vector2.RIGHT.rotated(rotation) * SEGMENT_SPACE * (MAX_SEGMENT_LENGTH + 1) 
	tip_chain.position = offset
		
	add_child(tip_chain) 
	await get_tree().create_timer(0.1). timeout
	extend_chain()


func extend_chain():
	if segment_count < MAX_SEGMENT_LENGTH:
		segment_count += 1
		
		var mid_chains = mid_chain.instantiate()
		var offset = Vector2.RIGHT.rotated(rotation) * SEGMENT_SPACE * segment_count
		var offset2 = Vector2.RIGHT.rotated(rotation) * SEGMENT_SPACE * (segment_count + 1)
		mid_chains.position = offset
		
		var tween = create_tween()
		tween.tween_property(
				mid_chains, "global_position", offset,
				0.15,  # duration
			).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
		
		$MiddleChains.add_child(mid_chains)
		$Sprite2D2.position = offset2
		await get_tree().create_timer(0.1). timeout
		extend_chain()
		
		
	#else: 
		#var tip_chains = tip_chain.instantiate()
		#var offset = Vector2.RIGHT.rotated(rotation) * SEGMENT_SPACE * (segment_count + 1)
		#tip_chains.position = offset
		#
		#$TipChain.add_child(tip_chains)
