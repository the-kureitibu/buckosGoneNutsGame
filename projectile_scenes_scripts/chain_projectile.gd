extends Area2D

const SEGMENT_SPACE: float = 64
const MAX_SEGMENT_LENGTH: int = 3
var segment_count := 0
var damage = 20
@export var segment_grow_time := 0.12
@onready var mid_chain: PackedScene = preload("res://projectile_scenes/chain_projectile_mid.tscn")
@onready var tip_chain: PackedScene = preload("res://projectile_scenes/chain_projectile_tip.tscn")
#@export var mid_chain2: ProjectileAttacks
#@onready var middle: PackedScene = mid_chain2.chain_attack["middle"]

var follow_target: Node2D
var fire_rotation: float

func _ready() -> void:
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	

func id_elder_three():
	return
	
func _process(_delta: float) -> void:
	if follow_target:
		global_position = follow_target.global_position


func start_extending_chain(marker: Node2D, target: Node2D):
	global_position = marker.global_position
	fire_rotation = (target.global_position - marker.global_position).angle()
	rotation = fire_rotation

	extend_chain()

func add_chain_tip():
	var tip_chains = tip_chain.instantiate()
	var offset = Vector2.RIGHT.rotated(fire_rotation) * SEGMENT_SPACE * (MAX_SEGMENT_LENGTH + 1)
	tip_chains.position = offset
		
	get_parent().add_child(tip_chains) 


func extend_chain():
	if segment_count < MAX_SEGMENT_LENGTH:
		segment_count += 1
		
		var mid_chains = mid_chain.instantiate()
		#Also, I should change the vector to global_position.rotated right?
		var offset = Vector2.RIGHT * SEGMENT_SPACE * segment_count
		mid_chains.position = offset
	
		add_child(mid_chains)
		
		mid_chains.scale = Vector2(0.0, 1.0)
		
		var tw = create_tween()
		tw.tween_property(mid_chains, "scale", Vector2.ONE, segment_grow_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

		var offset2 = Vector2.RIGHT * SEGMENT_SPACE * (segment_count + 1)
		$Sprite2D2.position = offset2
		
		await get_tree().create_timer(0.4).timeout
		extend_chain()
	else: 
		await get_tree().create_timer(1.0).timeout
		queue_free()




#func extend_chain():
	#if segment_count < MAX_SEGMENT_LENGTH:
		#segment_count += 1
		#
		#var mid_chains = mid_chain.instantiate()
		#
		##Also, I should change the vector to global_position.rotated right?
		#var offset = Vector2.RIGHT.rotated(rotation) * SEGMENT_SPACE * segment_count
		#mid_chains.global_position = global_position + offset
		#
		#mid_chains.follow_base = follow_target
		#
		#var global_offset = follow_target.global_position + offset
		#
		#var tween = create_tween()
		#tween.tween_property(
				#mid_chains, "global_position", offset,
				#0.4,  # duration
			#).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			#
			#
		#
		#add_child(mid_chains)
		#
		#var offset2 = Vector2.RIGHT.rotated(rotation) * SEGMENT_SPACE * (segment_count + 1)
		#$Sprite2D2.position = offset2
		#
		#await get_tree().create_timer(0.4). timeout
		#extend_chain()
	#else: 
		#await get_tree().create_timer(1.0).timeout
		#queue_free()
		#var tip_chains = tip_chain.instantiate()
		#var offset = Vector2.RIGHT.rotated(rotation) * SEGMENT_SPACE * (segment_count + 1)
		#tip_chains.position = offset
		#
		#$TipChain.add_child(tip_chains)
