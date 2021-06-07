extends KinematicBody2D
class_name LootPickup

const GRAVITY: float = PhysicsState.GRAVITY

export var launch_force := Vector2(175.0, -300.0)
export(float, 0.0, 1.0) var bouncyness := 0.35
export(float, 0.0, 1.0) var horizontal_damping := 0.15

export var damping_epsilon: float = 20.0
export var wall_collision_fall_damping: float = 0.8

export var pickup_immunity_time: float = 0.4

var velocity: Vector2
var can_pickup: bool = false

func _launch(dir: int) -> void:
	velocity = Vector2(launch_force.x * dir, launch_force.y)
	yield(get_tree().create_timer(pickup_immunity_time, false), "timeout")
	can_pickup = true

func _can_pickup(_character) -> bool:
	return can_pickup

func _pickup(_character) -> void:
	queue_free()

func _physics_process(delta) -> void:
	velocity.y += GRAVITY * delta
	
	velocity.x *= pow(1.0 - horizontal_damping, delta * 10.0)
	if abs(velocity.x) > 0.0 && abs(velocity.x) < damping_epsilon:
		velocity.x = 0.0
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.normal == Vector2.UP:
			if sign(velocity.y) == 1:
				velocity.y = velocity.bounce(Vector2.UP).y * bouncyness
		elif collision.normal == Vector2.LEFT || collision.normal == Vector2.RIGHT:
			velocity.x = 0.0
			if sign(velocity.y) == -1:
				velocity.y *= wall_collision_fall_damping
