extends AnimationState
class_name PhysicsState

"""
A base class for all moving/falling states which provides sub classes with a move and fall function.
The behaviour of the move function can be changed with current_* variables.
"""

# Values lower than this will be considered as zero velocity
const VELOCITY_X_DEADZONE: float = 10.0
const GRAVITY: float = 750.0
# anything with a steeper angle than this won't be considered floor
# must be in radians
const MAX_FLOOR_ANGLE: float = deg2rad(45.0)
const FLOOR_DIRECTION := Vector2.UP
# how many slides move_and_slide will attempt
const MAX_SLIDES: int = 4
# the maximum distance to the ground for snapping
const SNAP_DISTANCE := Vector2(0, 5)
# can't fall faster than this
# TODO: implement this via friction/damping instead
const TERMINAL_VELOCITY: float = 550.0

export var move_speed: float = 10.0
export var move_damping: float = 0.5

var current_move_speed: float
var current_move_damping: float
var current_move_direction: int

var max_speed: float = 0.0

func _ready() -> void:
	var damping = pow(1.0 - move_damping, 1.0 / 6.0)
	var new_speed: float = move_speed * damping
	while new_speed - max_speed > 0.1:
		max_speed = new_speed
		new_speed = (new_speed + move_speed) * damping
	max_speed = new_speed

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)

	current_move_speed = move_speed
	current_move_damping = move_damping
	current_move_direction = host.InputController._get_move_direction()

func move(_delta: float):
	host.velocity.x += current_move_speed * current_move_direction
	host.velocity.x *= pow(1.0 - current_move_damping, 1.0 / 6.0)
	
	host.kickback_velocity *= pow(1.0 - 0.5, 1.0 / 6.0)

# adds gravity to the host velocity
# can optionally gravitate towards the floor angle instead of straight down
func fall(delta: float, gravitate_towards_floor: bool = false, friction: float = 0.0):
	var gravity = Vector2(0, GRAVITY * delta)

	# while not realistic, it feels better if the character always moves
	# at the same speed, regardless of the floor angle. that's why we need
	# to retrieve the current floor normal and rotate the gravity vector
	# by the floor normal angle minus the angle of the floor direction
	if gravitate_towards_floor && host.is_on_floor():
		for i in host.get_slide_count():
			var collision = host.get_slide_collision(i)
			# we need to know if the current collision is a floor
			if collision.normal.dot(FLOOR_DIRECTION) >= cos(MAX_FLOOR_ANGLE):
				gravity = gravity.rotated(collision.normal.angle() - FLOOR_DIRECTION.angle())
				break

	host.velocity += gravity * (1.0 - friction)
	host.velocity.y = min(host.velocity.y, TERMINAL_VELOCITY * (1.0 - friction))

func apply_velocity(with_snap: bool = true) -> void:
	var speed_diff: float = min((max_speed) - abs(host.velocity.x), 0.0)
	var kick_vel = Vector2(sign(host.kickback_velocity.x) * max(speed_diff, abs(host.kickback_velocity.x)), host.kickback_velocity.y)
	
	if with_snap:
		host.kickback_velocity = host.move_and_slide_with_snap(kick_vel, SNAP_DISTANCE, FLOOR_DIRECTION, true, MAX_SLIDES, MAX_FLOOR_ANGLE)
		host.velocity = host.move_and_slide_with_snap(host.velocity, SNAP_DISTANCE, FLOOR_DIRECTION, true, MAX_SLIDES, MAX_FLOOR_ANGLE)
	else:
		host.kickback_velocity = host.move_and_slide(kick_vel, FLOOR_DIRECTION, true)
		host.velocity = host.move_and_slide(host.velocity, FLOOR_DIRECTION, true)
