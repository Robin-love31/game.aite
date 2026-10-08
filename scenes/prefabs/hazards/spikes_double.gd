extends Area2D

@export var damage: int = 1

# 获取 Timer 节点
@onready var timer = $Timer

# 用一个变量记录当前是“出现”还是“消失”状态
var is_active: bool = true

func _ready():
	# 连接 Timer 的 timeout 信号
	timer.timeout.connect(_on_timer_timeout)
	# 连接碰撞信号
	body_entered.connect(_on_body_entered)

func _on_timer_timeout():
	# 状态翻转（出现变消失，消失变出现）
	is_active = not is_active
	
	if is_active:
		# 出现：显示图片，开启碰撞
		show() # 显示自身（包括 Sprite2D 和 CollisionShape2D）
		# 如果你想让 Area2D 能检测到玩家，需要把监测开启
		monitoring = true
		# 如果你想让碰撞形状生效，需要开启
		$DetectionArea.disabled = false
	else:
		# 消失：隐藏图片，关闭碰撞
		hide() # 隐藏自身
		# 关闭检测，防止玩家在“消失”时碰到空气扣血
		monitoring = false
		$DetectionArea.disabled = true

func _on_body_entered(body):
	# 只有在激活状态（出现）时，才扣血
	if is_active and body.is_in_group("player"):
		body.take_damage(damage)
