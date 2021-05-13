extends AI
class_name Sequence

# a sequence will be asked if it handles this object
# if it does the sequence will be started on the same object
func _does_handle(object) -> bool:
	return false
