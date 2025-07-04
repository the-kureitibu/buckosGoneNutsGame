extends Area2D

var direction: Vector2 = Vector2.UP
var directTwo: Vector2 = Vector2.RIGHT
var directThree: Vector2 = Vector2.LEFT
var speed := 100

@export var proj_image1: Sprite2D
@export var proj_image2: Sprite2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$AnimationPlayer.play("elder_proj1")
	
	position += direction * speed * delta



func r_projectile(delta):

	var marker_r = $MarkerRight
	proj_image1.position = marker_r.global_position
	
	proj_image1.position += directTwo * speed * delta
	
func l_projectile(delta):
	var marker_f = $MarkerLeft
	proj_image2.position = marker_f.global_position
	
	proj_image2.position += directThree * speed * delta
