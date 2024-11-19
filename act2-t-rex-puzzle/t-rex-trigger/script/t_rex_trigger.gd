extends Node2D
@onready var label_text = $StaticBody2D/Label
@onready var t_rex_tooth = $StaticBody2D/TrexTooth
@onready var t_rex_tooth_rope = $StaticBody2D/TrexToothRope
@export var dialog : Array[DialogText]
@export var item : ItemData

var can_pull = false
var has_rope = false

func _ready() -> void:
	has_rope = InventorySystem.check_item(item)
	EventSystem.picked_up_item.connect(picked_rope)
	EventSystem.dropped_item.connect(dropped_rope)
	

func picked_rope(item_id : String):
	if item_id == item.id:
		has_rope = true
		print(item_id)
		
func dropped_rope(item_id : String):
	if item_id == item.id:
		has_rope = false

func _on_interactable_player_enter() -> void:
	label_text.show()

func _on_interactable_player_exit() -> void:
	label_text.hide()

func _on_interactable_interacted() -> void:
	if TriggersSystem.check_trigger("rope_picked", true):
		if not can_pull and has_rope:
			t_rex_tooth.hide()
			t_rex_tooth_rope.show()
			label_text.text = "Pull"
			can_pull = true
			InventorySystem.drop_item(item)
		else:
			can_pull = false
			t_rex_tooth.show()
			t_rex_tooth_rope.hide()
			TriggersSystem.toggle_trigger("pulled_out")
			$Interactable.queue_free()
			label_text.hide()
	else:
		DialogueSystem.start_dialog(dialog)
		