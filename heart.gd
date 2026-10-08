extends Control # 如果你的根节点是 Node2D，就把这里改成 Node2D

@onready var grey_heart = $GreyHeart # 确保这里路径指向你的灰心子节点

# 默认是红色（满血）状态：灰心隐藏
func _ready():
	grey_heart.visible = false

# 变成空心（掉血）
func set_empty():
	grey_heart.visible = true

# 变成红心（回血/重置）
func set_full():
	grey_heart.visible = false
