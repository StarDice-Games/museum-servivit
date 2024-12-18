extends Node2D

@onready var label: Label = $Label
@export var item : ItemData
@export var dialog : Array[DialogText]

func _ready() -> void:
	EventSystem.trigger_changed.connect(trigger_update)
	if TriggersSystem.check_trigger("guardian_locker_open", true):
		$Interactable/CollisionShape2D.disabled = false

func trigger_update(key, value):	
	if key == "guardian_locker_open" and value == true:
		$Interactable/CollisionShape2D.disabled = false

func _on_interactable_player_enter() -> void:
	label.show()


func _on_interactable_player_exit() -> void:
	label.hide()


func _on_interactable_interacted() -> void:
	if visible:
		InventorySystem.pick_up(item)
		DialogueSystem.start_dialog(dialog)
		TriggersSystem.update_trigger("key_picked", true)
		queue_free()
