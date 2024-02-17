extends Control

@onready var descriptionBox = $Description
@onready var nameBox = $Name
@onready var iconBox = $Icon

func _ready():
	visible = false

func display(nname, description, icon):
	visible = true
	descriptionBox.text = description
	nameBox.text = nname
	iconBox.texture = icon

func undisplay():
	visible = false
	descriptionBox.text = "Description Box"
	nameBox.text = "Name"
	iconBox.texture = null
