extends Resource
class_name RuneResource

enum RuneType {Dash, DoubleJump, WallClimb, Health}

export(RuneType) var rune_type
export var description : String

var texture : Texture
