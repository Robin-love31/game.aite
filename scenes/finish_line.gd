extends Area2D

# 设置通关需要的金币数
@export var required_coins: int = 11

# 在编辑器里连线 UI 节点
@export var result_label: Label
@export var restart_button: Button

# 防止玩家反复触发
var has_finished: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	restart_button.pressed.connect(_on_restart_pressed)

func _on_body_entered(body):
	if has_finished or not body.is_in_group("player"):
		return
	has_finished = true
	
	# ? 正确：直接去问全局单例 Global，因为它才是真正记录金币的地方
	var current_coins = Global.coin_count 
	
	# 打印出来确认一下
	print("终点检测：玩家当前有 ", current_coins, " 个金币，需要 ", required_coins, " 个")
	
	if current_coins >= required_coins:
		# 完美通关判断（如果你有蓝钻变量，也是从 Global 里读）
		if Global.has_blue_gem:
			result_label.text = " 完美通关！ "
		else:
			result_label.text = " 普通通关！ "
	else:
		result_label.text = " 金币不足！需要 " + str(required_coins) + " 个金币。"
	
	var result_layer = get_tree().current_scene.get_node("ResultLayer") # 路径根据实际修改
	if result_layer:
		result_layer.show()


func _on_restart_pressed():

	Global.coin_count = 0
	# Global.has_blue_gem = false # 如果有蓝钻变量，也重置
	# 重新加载当前关卡
	get_tree().reload_current_scene()
