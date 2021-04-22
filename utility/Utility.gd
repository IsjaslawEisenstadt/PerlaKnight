extends Node

"""
Various utility functions
"""

func _ready():
	randomize()

# returns a random integer in the given range, since godot lacks a built-in function for this
func randi_range(from: int, to: int) -> int:
	return (randi() % ((abs(to - from) as int) + 1)) + (min(from, to) as int)
