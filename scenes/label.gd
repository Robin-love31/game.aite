extends Label

func _process(delta):
	text = "金币: " + str(Global.coin_count)
