extends CharacterBody2D


const SPEED = 80.0
var direction = 1;
const floor = Vector2(0,-1)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$enemy.play("run")
	
func _process(delta):
	
	velocity.x = direction * SPEED
	
	#$enemy.play("run")
	if not $RayCast2D2.is_colliding():
		
		
		#await get_tree().create_timer(2.0).timeout
		direction *= -1
		
		$RayCast2D2.position.x *= -1
		#$enemy.play("turn")
		$enemy.flip_h = bool(1-direction)
	#velocity.y += gravity
	move_and_slide()
