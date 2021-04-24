extends GameState
class_name MainMenu

onready var PlayState := get_node(play_state_path) as GameState
onready var Transition := get_node(transition_path) as Transition

export var play_state_path: NodePath = "../PlayState"
export var transition_path: NodePath = "../Transition"

func _on_NewGameButton_pressed() -> void:
	Transition.start("fade_out")
	yield(Transition, "transition_finished")
	state_machine._pop_push(PlayState)

func _on_ExitButton_pressed() -> void:
	get_tree().quit()
