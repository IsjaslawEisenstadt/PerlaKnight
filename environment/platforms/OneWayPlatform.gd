tool
extends StaticBody2D
class_name OneWayPlatform

export var tile_width: int = 32

export var width: int = 0 setget set_width

var active: bool = true setget set_active

func set_width(new_width: int) -> void:
	# warning-ignore:integer_division
	new_width = int(max(int(new_width / tile_width) * tile_width, tile_width * 2))
	if width != new_width && has_node("MidTemplate"):
		width = new_width
		
		# warning-ignore:integer_division
		var num_tiles: int = new_width / tile_width
		
		for child in $MidPieces.get_children():
			$MidPieces.remove_child(child)
		
		for i in range(1, num_tiles - 1):
			var next_mid: Node = $MidTemplate.duplicate(0)
			$MidPieces.add_child(next_mid, true)
			next_mid.name = "Mid" + str(i)
			next_mid.visible = true
			next_mid.set_owner(self)
			next_mid.position.x = i * tile_width
		
		$RightEnd.position.x = (num_tiles - 1) * tile_width
		
		# warning-ignore:integer_division
		var collision_width: int = (num_tiles * tile_width) / 2
		$CollisionShape2D.position.x = collision_width
		$CollisionShape2D.shape.extents.x = collision_width

func _process(_delta: float) -> void:
	if !Engine.editor_hint:
		if Input.is_action_pressed("down"):
			if active:
				self.active = false
		else:
			if !active:
				self.active = true

func set_active(new_active: bool) -> void:
	active = new_active
	
	# player is at layer 11
	if active:
		collision_layer |= 1 << 10
	else:
		collision_layer &= ~(1 << 10)
