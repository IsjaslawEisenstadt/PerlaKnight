extends KinematicBody2D
class_name LootPickup

var player: Player

export (float) var force_acceleration:= 200
export (float) var max_force := 1000.0
export (float) var gravity = 1000
var force := 0.0

var velocity: Vector2

func _on_influence(player) -> void:
	self.player = player
	
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(0, false)
func _on_pickup(player) -> void:
	pass

func _physics_process(delta):
	if player:
		if force < max_force:
			force += force_acceleration * delta
		move_and_slide(position.direction_to(player.LootPickupRange.global_position) * force)
	else:
		velocity.y += gravity * delta
		
		if !is_on_floor():
			move_and_slide(velocity, Vector2(0,-1))
