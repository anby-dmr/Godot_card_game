extends Node2D

const INIT_HAND_COUNT = 8
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_WIDTH = 200
const HAND_Y_POSITION = 890
const TWEEN_SPEED = 0.4

var player_hand = []
var center_screen_x

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(INIT_HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "card"
		add_to_hand(new_card)

func add_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_position()
	else:
		animate_card_position(card, card.starting_position)
		
func remove_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position()
	
func update_hand_position():
	for i in range(player_hand.size()):
		# Set the card position based on the index
		var new_position = Vector2(calculate_hand_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_position(card, new_position)
	
func calculate_hand_position(index):
	# This is a bit tricky
	# The requirements: no matter how many cards in on hand,
	# we always want them to distribute uniformly in the middle.
	# Note that card postion_x refer to the center_x of the card.

	var total_width = player_hand.size() * CARD_WIDTH
	var x_offset = center_screen_x - total_width / 2 + index * CARD_WIDTH + CARD_WIDTH / 2
	return x_offset

func animate_card_position(card, pos):
	CardUtils.animate_card_position(card, pos, TWEEN_SPEED)
