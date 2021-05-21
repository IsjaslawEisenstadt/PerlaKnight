extends GameState
class_name PauseMenu

var popup_open: bool = false

func _ready() -> void:
	if OS.has_feature("HTML5"):
		$Content/VBox/ButtonCenter/ButtonVBox/ExitButton.visible = false

func _state_enter(previous_state: State, params: Dictionary = {}) -> void:
	$AnimationPlayer.play("blur")
	$AnimationPlayer.advance(0)
	._state_enter(previous_state, params)

func _state_process(delta: float) -> void:
	._state_process(delta)
	# ui_cancel for Gamepad B presses
	if can_press() && (Input.is_action_just_pressed("pause") || Input.is_action_just_pressed("ui_cancel")):
		close()

func blur_finished(_animation_name: String) -> void:
	state_machine._pop_state()

func can_press() -> bool:
	return !popup_open && is_active() && !$AnimationPlayer.is_playing()

func close() -> void:
	$AnimationPlayer.connect("animation_finished", self, "blur_finished", [], CONNECT_ONESHOT)
	$AnimationPlayer.play_backwards("blur")

func on_continue_pressed() -> void:
	if can_press():
		close()

func on_new_game_pressed() -> void:
	if can_press():
		popup_open = true
		$NewGamePopup.open()
		var confirmed: bool = yield($NewGamePopup, "popup_closed")
		if confirmed:
			# kind of hacky but should be fine
			$".."/MainMenu.start_game()
			
		Input.action_release("pause")
		Input.action_release("ui_cancel")
		popup_open = false

func on_exit_pressed() -> void:
	if can_press():
		popup_open = true
		$ExitPopup.open()
		var confirmed: bool = yield($ExitPopup, "popup_closed")
		if confirmed:
			get_tree().quit()
			
		Input.action_release("pause")
		Input.action_release("ui_cancel")
		popup_open = false
