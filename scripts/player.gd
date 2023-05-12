extends CharacterBody2D


const SPEED = 450.0
const JUMP_VELOCITY = -780.0 

var multiplier = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var vel = Vector2()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * 1.8

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("player_left", "player_right")
	velocity.x = direction * SPEED * multiplier
	
	var right = Input.is_action_pressed("player_right")
	var left = Input.is_action_pressed("player_left")
	
	if (right or left) and $Timer.time_left == 0:
		$Timer.start()
	elif $Timer.time_left != 0 and not (right or left):
		multiplier = 1.0
		$Timer.stop()
		
	move_and_slide()
	animate()
	
func animate():
	if velocity.x == 0:
		$Sprite.play("idle")
	
	elif velocity.y == 0 and is_on_floor() and velocity.x != 0:
		$Sprite.play("run")
		if velocity.x > 0:
			$Sprite.flip_h = false
			$Sprite.set_offset( Vector2(0, 0) )
		else:
			$Sprite.flip_h = true
			$Sprite.set_offset( Vector2(-12, 0) )
	
	elif velocity.y != 0:
		$Sprite.play("idle")
		if velocity.x > 0:
			$Sprite.flip_h = false
			$Sprite.set_offset( Vector2(0, 0) )
		else:
			$Sprite.flip_h = true
			$Sprite.set_offset( Vector2(-12, 0) )


func _on_Timer_timeout():
	multiplier = 1.4
	print(multiplier)
