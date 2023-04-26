extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var vel = Vector2()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta*2

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	animate()
	
func animate():
	if velocity.x == 0:
		$Sprite.play("idle")
	elif velocity.y == 0 and $RayCast2D.is_colliding() and velocity.x != 0:
		$Sprite.play("run")
		if velocity.x > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
