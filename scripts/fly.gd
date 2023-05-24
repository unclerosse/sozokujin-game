extends "res://scripts/BasicEnemy.gd"

func is_right(value: float) -> bool:
	if value >= 0:
		return false
	return true


func _ready():
	Speed = 450.0
	MaxHealth = 60.0
	CurrentHealth = MaxHealth
	Damage = 30.0
	
	Sprite = $Sprite
	Vision = $VisionArea
	
	Sprite.play("fly")

func search():
	var direction = (Target.global_position - global_position).normalized()
	velocity.x = direction.x * Speed
	velocity.y = direction.y * Speed 
	
	Sprite.flip_h = is_right(direction.x)

	
	move_and_slide()

func _on_vision_area_body_exited(body):
	pass

func idle():
	pass
