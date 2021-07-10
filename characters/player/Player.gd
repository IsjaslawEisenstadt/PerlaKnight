extends Character
class_name Player

signal rune_added(rune)
signal save_requested()
signal transition_requested(level_name, target_name)
# warning-ignore:unused_signal
signal restore_requested()
signal end_requested()

# this is pretty hacky, but it saves us from storing filepaths in our savefiles
const RUNE_RESOURCES_PATH: String = "res://environment/runes/resource"

onready var DoorCast: DoorCast = $Colliders/DoorCast
onready var LootPicker: Area2D = $Colliders/LootPicker

var closest_interaction: Interaction

var camera: Node2D

func _process(_delta: float) -> void:
	if StateMachine.alive:
		var loot_in_range: Array = LootPicker.get_overlapping_bodies()
		if !loot_in_range.empty():
			for loot in loot_in_range:
				assert(loot is LootPickup)
				if loot._can_pickup(self):
					if loot is HealthLootPickup:
						loot._pickup(self)

		if !is_in_sequence:
			var doorway: Doorway = DoorCast.get_doorway()
			if doorway:
				emit_signal("transition_requested", doorway.next_level, doorway.next_door)
				set_process(false)
				yield(get_tree(), "idle_frame")
				StateMachine.state_stack = []

func _interaction_process() -> void:
	if closest_interaction && is_instance_valid(closest_interaction):
		closest_interaction.hide_icons()
	
	closest_interaction = Interactor.get_closest_interaction(self)
	
	if closest_interaction && is_instance_valid(closest_interaction):
			closest_interaction.show_icons()
	
	if (closest_interaction 
		&& InputController._is_action_just_activated("interact") 
		&& StateMachine.get_current_state()._can_interact()):
		
		closest_interaction._interact(self)

func save_game(save_data: Dictionary, _level) -> void:
	save_data["current_health"] = current_health

func load_game(save_data: Dictionary, level) -> void:
	if "runes" in save_data:
		set_max_health(3, true)
		
		for rune_name in save_data.runes:
			if rune_name.begins_with("HealthRune"):
				rune_name = "HealthRune"
			var path = "%s/%s.tres" % [RUNE_RESOURCES_PATH, rune_name]
			add_rune(load(path), true)
	
	var health: int
	if "current_health" in save_data:
		health = save_data.current_health
	else:
		health = max_health # on new game
	
	if !"restore" in save_data:
		if "spawn_target" in save_data:
			start_sequence(level.SpawnTargets.get_node(save_data.spawn_target))
			save_data.erase("spawn_target")
			emit_signal("save_requested")
		elif save_data.get("checkpoint_level") == level.name && "checkpoint_name" in save_data:
			global_position = level.SpawnTargets.get_node(save_data.checkpoint_name).global_position
			# respawn with full health
			health = max_health
	self.current_health = health

func _set_current_health(new_health: int) -> void:
	._set_current_health(new_health)
	emit_signal("save_requested")

func add_rune(rune: Rune, override: bool = false) -> void:
	match rune.resource_name:
		"HealthRune":
			set_max_health(max_health + 1, override)
		"DashRune":
			dash_acquired = true
		"WallClimbRune":
			wall_climb_acquired = true
		"DoubleJumpRune":
			double_jump_acquired = true
	
	emit_signal("rune_added", rune)
	if !override:
		emit_signal("save_requested")

func _die() -> void:
	._die()
	yield(StateMachine.DeathState, "death_animation_finished")
	emit_signal("transition_requested", null, null)
