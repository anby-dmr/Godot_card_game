extends Node2D

func animate_card_position(card: Node2D, pos: Vector2, duration: float = 0.2):
	# tween is an an animation technique 
	# where you specify keyframes 
	# and the computer interpolates the frames that appear between them. 
	
	var tween = card.get_node("Tween") if card.has_node("Tween") else card.create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "position", pos, duration)
