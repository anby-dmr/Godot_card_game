extends Node2D

var COLLISION_MASK_CARD = 1

var card_being_dragged
var screen_size
var is_hovering_on_card

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	is_hovering_on_card = false

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
				start_drag(card)
		else:
			finish_drag(card_being_dragged)

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	
func finish_drag(card):
	card.scale = Vector2(1.05, 1.05)
	card_being_dragged = null

func connect_card_signals(card):
	card.connect("hovered", on_hovered_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_hovered_card(card):
	if !is_hovering_on_card:
		highlight_card(card, true)
		is_hovering_on_card = true

func on_hovered_off_card(card):
	# This is not correct.
	# This slot func will still be triggered when move from one card to another
	# But before is_hovering_on_card = false, 
	# the on_hovered_card will be called first (signal emits only once here),
	# which cause bug.
	#if is_hovering_on_card:
		#highlight_card(card, false)
		#is_hovering_on_card = false
		
	if card_being_dragged != null:
		return
		
	highlight_card(card, false)
	var new_card_hovered = raycast_check_for_card()
	if new_card_hovered:
		highlight_card(new_card_hovered, true)
	else:
		is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

# Get the card object hovered by mouse (the atop one)
# Clicked check is in _input() method.
func raycast_check_for_card():
	var state_space = get_world_2d().direct_space_state
	var clickParams = PhysicsPointQueryParameters2D.new()
	clickParams.position = get_global_mouse_position()
	clickParams.collide_with_areas = true
	clickParams.collision_mask = COLLISION_MASK_CARD
	var res = state_space.intersect_point(clickParams)
	if len(res) > 0:
		return find_atop_card(res)
	return null

func find_atop_card(cards):
	var atop_card = cards[0].collider.get_parent()
	var atop_card_z = atop_card.z_index
	
	for res in cards:
		var card = res.collider.get_parent()
		if card.z_index > atop_card_z:
			atop_card = card
			atop_card_z = card.z_index
		
	return atop_card
