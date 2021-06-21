extends State
class_name Sequence

var host
var input_controller

# a sequence will be asked if it handles this object
# if it does the sequence will be started on the same object
func _does_handle(_object) -> bool:
	return false
