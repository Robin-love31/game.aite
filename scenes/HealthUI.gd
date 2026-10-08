extends HBoxContainer

func _process(delta):
	# 1. 自动在场景里寻找玩家
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return # 如果还没找到玩家，就什么都不做
		
	var player = players[0]
	var current_hp = player.hp
	
	# 2. 获取容器里所有的心
	var hearts = get_children() # 获取所有的子节点（也就是你的心）
	
	# 3. 根据血量，更新每一颗心
	for i in range(hearts.size()):
		var heart = hearts[i]
		# 如果这颗心的编号小于当前血量，就是红心
		if i < current_hp:
			heart.set_full()
		else:
			# 否则，变成灰心
			heart.set_empty()
