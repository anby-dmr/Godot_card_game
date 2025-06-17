extends Node2D

var COLLISION_MASK_CARD = 1

var card_being_dragged
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)
		
# Called on your node whenever an input event occurs. 
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = raycast_check_for_card()
			if card:
				card_being_dragged = card
		else:
			card_being_dragged = null

# Get the card object clicked by mouse
func raycast_check_for_card():
	var state_space = get_world_2d().direct_space_state
	var clickParams = PhysicsPointQueryParameters2D.new()
	clickParams.position = get_global_mouse_position()
	clickParams.collide_with_areas = true
	clickParams.collision_mask = COLLISION_MASK_CARD
	var res = state_space.intersect_point(clickParams)
	if len(res) > 0:
		return res[0].collider.get_parent()
	return null
