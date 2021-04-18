extends KinematicBody2D
class_name Character

onready var Sprite := $Sprite
onready var CollisionShape := $CollisionShape2D
onready var AnimationPlayer := $AnimationPlayer
onready var InputController := $InputController
onready var StateMachine := $StateMachine
onready var InteractionRay := get_node_or_null("InteractionRay") as RayCast2D

export var dash_acquired: bool = false
export var double_jump_acquired: bool = false

var velocity := Vector2.ZERO
var look_direction: int = 1 setget set_look_direction

var can_double_jump: bool = double_jump_acquired

func _ready() -> void:
	# warning-ignore:return_value_discarded
	AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	InputController._start(self)
	StateMachine.start()

func _process(delta: float):
	InputController._input_process(delta)

	if (InputController._is_action_just_activated("interact") 
		&& StateMachine.get_current_state()._can_interact() 
		&& InteractionRay.is_colliding()):
			var interaction := InteractionRay.get_collider()
			assert(interaction is Interaction)
			if interaction._can_interact(self):
				interaction._interact(self)
	
	if double_jump_acquired && !can_double_jump && is_on_floor():
		can_double_jump = true

	StateMachine._state_machine_process(delta)

func _physics_process(delta: float):
	StateMachine._state_machine_physics_process(delta)

func play_animation(animation_name: String, speed: float = 1.0) -> void:
	if AnimationPlayer.current_animation != animation_name && AnimationPlayer.has_animation(animation_name):
		AnimationPlayer.play(animation_name, -1, speed)

func set_look_direction(new_look_direction: int) -> void:
	look_direction = new_look_direction
	Sprite.flip_h = look_direction == -1
	Sprite.offset.x = abs(Sprite.offset.x) * look_direction
	assert(look_direction == 1 || look_direction == -1)

func on_animation_finished(animation_name: String) -> void:
	var current_state = StateMachine.get_current_state()
	if current_state:
		current_state.call("_on_animation_finished", animation_name)
