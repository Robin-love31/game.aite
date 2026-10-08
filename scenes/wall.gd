extends StaticBody2D

func disappear():
	# 隐藏自己（虽然它本来就没图片，但养成好习惯）
	hide() 
	# 关闭碰撞！这样玩家就能走过去了
	$CollisionShape2D.disabled = true
	print("隐形墙壁已关闭！")
