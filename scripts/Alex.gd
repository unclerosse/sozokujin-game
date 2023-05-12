extends CharacterBody2D


const SPEED = 120.0
@onready var direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * 1.5
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_wall():
		direction *= -1
		
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
