extends KinematicBody2D
class_name LootPickup

export var force_acceleration: float = 200.0
export var max_force: float = 1000.0
export var gravity: float = 1000.0

var force := 0.0
var velocity: Vector2
var player: Player

func _is_collectible() -> bool:
	return false
	
func _on_influence(player) -> void:
	self.player = player
	
	if _is_collectible():
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(0, false)
		
func _on_pickup(player) -> void:
	pass
		
func pickup(player) -> void:
	_on_pickup(player)
	queue_free()

func _physics_process(delta) -> void:
	if player && _is_collectible():
		if force < max_force:
			force += force_acceleration * delta
		move_and_slide(position.direction_to(player.LootPickupRange.global_position) * force)
	else:
		velocity.y += gravity * delta
		
		if !is_on_floor():
			move_and_slide(velocity, Vector2(0,-1))
