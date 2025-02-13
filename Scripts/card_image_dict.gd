extends Resource
class_name card_images

@export var deck: Array[card_type]
var card_texture_spritesheet: Texture2D
var card_type_resource = preload("res://Scripts/card_type_res.gd")
var card_size = Vector2(48,64)
var deck_creator: Array[card_type]

func create_deck(sprite_sheet: Texture2D):
	card_texture_spritesheet = sprite_sheet
	deck_creator = []
	for suit in range(4):
		for card in range(13):
			var new_card = card_type_resource.new() as card_type
			new_card.card_suit = card_type.suit.values()[suit]
			new_card.card_number = card + 1
			var card_texture = AtlasTexture.new()
			card_texture.atlas = card_texture_spritesheet
			card_texture.region.size = card_size
			card_texture.region.position = Vector2(64*card, 80*suit)
			new_card.card_texture = card_texture
			deck_creator.append(new_card)
	deck = deck_creator
		

func random_card():
	var num = randi() % 10 +1
	var suit = card_type.suit.values()[randi()%card_type.suit.size()]
	var output: card_type
	for x in deck:
		if x.card_number == num && x.card_suit == suit:
			output = x.duplicate()
	if output == null:
		print("NO CARD FOUND FOR "+str(num)+" of "+str(suit))
	return output

func random_boss():
	var num = 10+ randi()%3+1
	var suit = card_type.suit.values()[randi()%card_type.suit.size()]
	var output: card_type
	for x in deck:
		if x.card_number == num && x.card_suit == suit:
			output = x.duplicate()
	return output

func specific_card(cardNum: int, targetSuit: int = 0):
	var num = cardNum
	var suit = card_type.suit.values()[randi()%card_type.suit.size()] if targetSuit == 0 else card_type.suit.values()[targetSuit]
	var output: card_type
	for x in deck:
		if x.card_number == num && x.card_suit == suit:
			output = x.duplicate()
	return output