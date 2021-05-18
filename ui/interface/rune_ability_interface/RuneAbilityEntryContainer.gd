extends MarginContainer
 

onready var RuneTextureRect := $HBoxContainer/RuneTextureRect as TextureRect
onready var DescriptionRichTextLabel := $HBoxContainer/MarginContainer/DescriptionRichTextLabel as RichTextLabel

func init(RuneResource : Resource):
	DescriptionRichTextLabel.text = RuneResource.description
	RuneTextureRect.texture = RuneResource.texture
	
