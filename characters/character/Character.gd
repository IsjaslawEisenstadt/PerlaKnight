extends KinematicBody2D
class_name Character

signal health_changed(current_health)
signal max_health_changed(max_health)
signal character_turned(new_look_direction)

onready var AnimationPlayer := $AnimationPlayer
onready var HurtPlayer := $HurtPlayer
onready var InputController: InputController = $InputController setget ,_get_input_controller
onready var StateMachine := $StateMachine
onready var Colliders := $Colliders
onready var Perception := $Colliders/Perception
onready var Interactor := $Colliders/Interactor
onready var AttackHitBoxCollider := get_node_or_null("Colliders/AttackHitbox/AttackCollisionShape") as CollisionShape2D
onready var Sounds := $Sounds

export var max_health: int = 4 setget set_max_health

export var dash_acquired: bool = false
export var double_jump_acquired: bool = false
export var wall_climb_acquired: bool = false

var velocity := Vector2.ZERO
var kickback_velocity := Vector2.ZERO
var move_speed_factor: float = 1.0

var look_direction: int = 1 setget set_look_direction
var current_health: int = max_health setget _set_current_health
var invincible: bool = false

# wallclimb dash resets require this flag, DashState updates it
var can_dash: bool = dash_acquired setget set_can_dash
var can_double_jump: bool = double_jump_acquired setget set_can_double_jump

var audio_player_cache: Dictionary = {}

func _ready() -> void:
	# warning-ignore:return_value_discarded
	AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	StateMachine.start()

func _process(delta: float) -> void:
	if StateMachine.alive:
		InputController._input_process(delta)
		
		_interaction_process()
	
		if double_jump_acquired && !can_double_jump && is_on_floor():
			can_double_jump = true

	StateMachine._state_machine_process(delta)

# meant to be overridden by the player, because she needs to know her
# closest interaction before pressing a button
func _interaction_process() -> void:
	if (InputController._is_action_just_activated("interact") 
		&& StateMachine.get_current_state()._can_interact()):
		var closest_interaction: Interaction = Interactor.get_closest_interaction(self)
		if closest_interaction:
			closest_interaction._interact(self)

func _physics_process(delta: float) -> void:
	if StateMachine.alive:
		InputController._input_physics_process(delta)
	StateMachine._state_machine_physics_process(delta)

func play_animation(animation_name: String, speed: float = 1.0) -> void:
	if AnimationPlayer.has_animation(animation_name) && !HurtPlayer.is_hurt_anim_playing():
		# a convention to reset certain tracks before playing a new animation
		if AnimationPlayer.has_animation("reset_pose"):
			AnimationPlayer.play("reset_pose")
			# makes sure the values are set
			AnimationPlayer.advance(0)
		AnimationPlayer.play(animation_name, -1, speed)
		AnimationPlayer.advance(0)

func on_animation_finished(animation_name: String) -> void:
	var current_state = StateMachine.get_current_state()
	if current_state:
		current_state.call("_on_animation_finished", animation_name)

func set_look_direction(new_look_direction: int) -> void:
	assert(look_direction == 1 || look_direction == -1)
	
	if look_direction != new_look_direction:
		look_direction = new_look_direction
		for child in get_children():
			if child is Node2D:
				child.scale.x = sign(look_direction)
		emit_signal("character_turned")

func _set_current_health(new_health: int) -> void:
	assert(new_health >= 0 && new_health <= max_health)
	
	current_health = new_health
	if current_health <= 0:
		StateMachine.die()
	
	emit_signal("health_changed", current_health)

func set_max_health(new_max_health: int) -> void:
	assert(new_max_health > 0)
	
	max_health = new_max_health
	self.current_health = max_health
	emit_signal("max_health_changed", max_health)

func hit(attacker: Node2D, damage: int) -> void:
	if !invincible && StateMachine.alive:
		self.current_health -= damage
		HurtPlayer.hurt(attacker)

# can be overridden to dynamically switch between different input controllers
func _get_input_controller() -> InputController:
	return InputController

func set_can_dash(new_can_dash: bool) -> void:
	can_dash = dash_acquired && new_can_dash

func set_can_double_jump(new_can_double_jump: bool) -> void:
	can_double_jump = double_jump_acquired && new_can_double_jump

func set_attack_shape_enabled(enabled: bool) -> void:
	if AttackHitBoxCollider:
		AttackHitBoxCollider.disabled = !enabled

func play_sound(player_name: String) -> void:
	if player_name in audio_player_cache:
		audio_player_cache[player_name]._play()
	else:
		var player := Sounds.get_node_or_null(player_name) as AudioStreamPlayer2D
		if player:
			audio_player_cache[player_name] = player
			player._play()

func is_playing_sound(player_name: String) -> bool:
	if player_name in audio_player_cache:
		return audio_player_cache[player_name].playing
	
	var player := Sounds.get_node_or_null(player_name) as AudioStreamPlayer2D
	if player:
		audio_player_cache[player_name] = player
		return player.playing
	
	return false
