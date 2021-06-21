extends IdleState
class_name RandomIdleState

export(Array, String) var random_animations := []
export var random_animation_wait_time: float = 1.5
export var random_animation_wait_deviation: float = 0.5

var random_animation_wait_timer: Timer

func _ready() -> void:
	if !random_animations.empty():
		random_animation_wait_timer = Timer.new()
		random_animation_wait_timer.one_shot = true
		add_child(random_animation_wait_timer)
		random_animation_wait_timer.connect("timeout", self, "on_random_animation")

func get_random_wait_time() -> float:
	return rand_range(random_animation_wait_time - random_animation_wait_deviation,
					  random_animation_wait_time + random_animation_wait_deviation)

func on_random_animation() -> void:
	play_animation(random_animations[randi() % random_animations.size()])

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	if random_animation_wait_timer:
		random_animation_wait_timer.start(get_random_wait_time())

func _state_exit(next_state: State, params: Dictionary = {}) -> void:
	._state_exit(next_state, params)
	if random_animation_wait_timer:
		random_animation_wait_timer.stop()

func _on_animation_finished(finished_animation_name: String) -> void:
	play_animation()
	._on_animation_finished(finished_animation_name)
	if random_animation_wait_timer:
		random_animation_wait_timer.start(get_random_wait_time())
