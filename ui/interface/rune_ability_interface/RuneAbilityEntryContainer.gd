extends MarginContainer
 
onready var RuneTextureRect := $HBoxContainer/RuneTextureRect
onready var DescriptionRichTextLabel := $HBoxContainer/DescriptionRichTextLabel as RichTextLabel

func init(RuneResource : Resource):
	DescriptionRichTextLabel.text = RuneResource.description
	RuneTextureRect.texture = RuneResource.texture
	
