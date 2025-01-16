extends Resource
class_name card_images

@export var deck: Array[card_type]

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