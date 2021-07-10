extends GameState
class_name MainMenu

onready var Transition := $".."/Transition
onready var PlayState := $"../.."/PlayState

onready var ContinueButton := $Content/Buttons/ContinueButton
onready var ExitButton := $Content/Buttons/ExitButton

export(Array, PackedScene) var backgrounds: Array

var background

func _ready() -> void:
	if OS.has_feature("HTML5"):
		ExitButton.visible = false

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)
	
	if !backgrounds.empty():
		background = backgrounds[randi() % backgrounds.size()].instance()
		add_child(background)

	if PlayState.has_save_data():
		ContinueButton.grab_focus()
	else:
		ContinueButton.disabled = true
		ContinueButton.focus_mode = Control.FOCUS_NONE
	
	if "credits" in params:
		Transition.end()
		$Content.visible = false
		$Credits.start_scroll()
		$Credits.visible = true

func _state_exit(next_state: State, params: Dictionary = {}) -> void:
	._state_exit(next_state, params)
	remove_child(background)
	background.queue_free()

func start_game(enter_play_mode: int = PlayState.EnterPlayMode.NEW_GAME) -> void:
	Transition.start("fade")
	yield(Transition, "transition_finished")
	state_machine._push_state(PlayState, {"enter_play_mode": enter_play_mode})

func can_press() -> bool:
	return !Transition.is_playing()

func on_continue_pressed() -> void:
	if can_press():
		start_game(PlayState.EnterPlayMode.LOAD_GAME)

func on_new_game_pressed() -> void:
	if can_press():
		start_game()

func on_exit_pressed() -> void:
	if can_press():
		get_tree().quit()

func on_credits_pressed() -> void:
	Transition.start("alpha")
	yield(Transition, "transition_finished")
	Transition.end()
	$Content.visible = false
	$Credits.start_scroll()
	$Credits.visible = true

func on_credits_finished() -> void:
	Transition.start("alpha")
	yield(Transition, "transition_finished")
	Transition.end()
	$Credits.visible = false
	$Content.visible = true
