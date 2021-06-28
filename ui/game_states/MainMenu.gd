extends GameState
class_name MainMenu

onready var LoadingScreen := $".."/LoadingScreen
onready var Transition := $".."/Transition
onready var PlayState := $"../.."/PlayState

onready var ContinueButton := $Margin/VBox/ButtonCenter/ButtonVBox/ContinueButton
onready var ExitButton := $Margin/VBox/ButtonCenter/ButtonVBox/ExitButton

func _ready() -> void:
	if OS.has_feature("HTML5"):
		ExitButton.visible = false

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	._state_enter(previous_state, params)

	if PlayState.has_save_data():
		ContinueButton.visible = true
		ContinueButton.grab_focus()
	else:
		ContinueButton.visible = false

func start_game(enter_play_mode: int = PlayState.EnterPlayMode.NEW_GAME) -> void:
	Transition.start("fade")
	yield(Transition, "transition_finished")
	state_machine._pop_push(PlayState, {"enter_play_mode": enter_play_mode})

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
