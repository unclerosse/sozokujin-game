extends "res://scripts/BasicEnemy.gd"

func is_right(value: float) -> bool:
	if value >= 0:
		return false
	return true

func _ready():
	Speed = 420.0
	MaxHealth = 50.0
	CurrentHealth = MaxHealth
	Damage = 30.0
	Cooldown = true
	
	HPBar.max_value = MaxHealth

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

func death():
	StateMachine.travel("death")
	velocity = Vector2.ZERO
	if StateMachine.get_current_node() == "End":
		self.queue_free()
		

func _on_attack_area_body_entered(body):
	if body.name != "player" or CurrentState != "normal" or CurrentStatus == -1:
		return
	if not Cooldown:
		body.hurt(Damage)
		EnemyTimer.start()
		Cooldown = true
	if Cooldown and EnemyTimer.is_stopped():
		EnemyTimer.start()
		

func _on_timer_timeout():
	Cooldown = false
