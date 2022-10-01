class_name Enemy extends "Mob.gd"

# child nodes
onready var nav_agent = $NavigationAgent2D
onready var sight_range = $SightRange

# ai stuff
enum STATE {
	IDLE,
	MOVE,
	ATTACK,
	FLEE
}
var state = STATE.IDLE

func create(x, y):
	position.x = x
	position.y = y
	speed = 100

func _physics_process(delta):
	var move_direction = position.direction_to(nav_agent.get_next_location())
	velocity = move_direction * speed
	nav_agent.set_velocity(velocity)
	
func _process(delta):
	._process(delta)
	
	target = nav_agent.get_next_location()
	
func process_ai(player):
	nav_agent.set_target_location(player.global_position)
		
func arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if !arrived_at_location():
		velocity = move_and_slide(safe_velocity)
