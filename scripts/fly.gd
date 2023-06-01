extends "res://scripts/BasicEnemy.gd"

func is_right(value: float) -> bool:
	if value >= 0:
		return false
	return true

@onready var _StartPoint = position

func _ready():
	Speed = 420.0
	MaxHealth = 20.0
	CurrentHealth = MaxHealth
	Damage = 30.0
		
	Sprite = $Sprite
	Vision = $VisionArea
	EnemyTimer = $EnemyTimer
	
	Sprite.play("fly")

func search():
	var direction = (Target.global_position - global_position).normalized()
	velocity.x = direction.x * Speed
	velocity.y = direction.y * Speed 
	
	Sprite.flip_h = is_right(direction.x)

	move_and_slide()

func _on_vision_area_body_exited(body):
	pass

func idle(delta):
	pass
	

func _on_attack_area_body_entered(body):
	if body.name != "player":
		return
	if not Cooldown:
		body.hurt(Damage)
		EnemyTimer.start()
		Cooldown = true
		

func _on_timer_timeout():
	Cooldown = false
