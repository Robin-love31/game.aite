extends CharacterBody2D

@export_category("移动参数")
@export var double_press_interval := 0.3
@export var move_speed: float = 75.0
@export var acceleration: float = 600.0
@export var deceleration: float = 800.0
@export var jump_velocity: float = -190.0
@export var custom_gravity: float = 800.0
@export_category("冲刺参数")
@export var dash_speed: float = 200.0       # 冲刺时的速度
@export var dash_duration: float = 0.2      # 冲刺持续时间（秒）
@export var dash_cooldown: float = 0.5      # 冲刺冷却时间（秒）
@onready var health_ui = get_node("Level/PrefabInstances/Signs/CanvasLayer/HBoxContainer") # 路径根据你的实际情况修改
@onready var game_over_ui = get_node("Level/PrefabInstances/Signs/CanvasLayer/CanvasLayer")
var is_dashing: bool = false                # 是否正在冲刺
var dash_time_left: float = 0.0             # 冲刺剩余时间
var dash_cooldown_left: float = 0.0         # 冷却剩余时间
var dash_direction: float = 1.0             # 冲刺方向（1为右，-1为左）
func _ready():
	# 游戏一运行，就暂停整个场景
	get_tree().paused = true

var coin_count: int = 0
var has_blue_gem: bool = false # 记录是否拿到了蓝钻
@onready var sprite: Sprite2D = $Sprite2D


var last_space_press_time := -1000


func _physics_process(delta: float) -> void:

	if dash_cooldown_left > 0:
		dash_cooldown_left -= delta

	# 2. 处理冲刺状态（如果正在冲刺，就倒计时）
	if is_dashing:
		dash_time_left -= delta
		# 冲刺时间结束，恢复普通状态
		if dash_time_left <= 0:
			is_dashing = false
			
	# 3. 检测冲刺输入 (假设你的输入动作叫 "dash"，稍后在项目设置里绑定右键)
	if Input.is_action_just_pressed("dash") and dash_cooldown_left <= 0 and not is_dashing:
		start_dash()
	if is_invincible:
		invincible_timer -= delta
		if invincible_timer <= 0:
			is_invincible = false
		
	# ... 你原本的重力、跳跃、移动逻辑 ...

	handle_jump()
	
	
	handle_horizontal_movement(delta)
	update_sprite_direction()
	
	if not is_on_floor():
		velocity.y += custom_gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumpCount-1 >0:
		velocity.y = jump_velocity
		jumpCount -=1
		
	if is_on_floor():
		jumpCount =2
	move_and_slide()

func start_dash():
	is_dashing = true
	dash_time_left = dash_duration
	dash_cooldown_left = dash_cooldown
	
	# 判断冲刺方向：如果当前有按左右键，就按当前方向冲；如果没有按，就按面朝方向冲
	var input_dir = Input.get_axis("move_left", "move_right")
	if input_dir != 0:
		dash_direction = sign(input_dir) # 获取 -1 或 1
	else:
		# 如果没按方向，就根据精灵图的翻转来判断面朝方向
		dash_direction = -1.0 if sprite.flip_h else 1.0
		
func handle_horizontal_movement(delta: float) -> void:
	# 如果正在冲刺，忽略普通输入，直接设置冲刺速度
	if is_dashing:
		velocity.x = dash_direction * dash_speed
		return # 直接返回，不执行下面的代码
		
	# --- 下面是原本的普通移动逻辑 ---
	var direction := Input.get_axis("move_left", "move_right")
	var target_speed := direction * move_speed

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
var jumpCount = 3
var hp: int = 3 
var is_invincible: bool = false
var invincible_timer: float = 0.0

func take_damage(amount: int):
	if is_invincible:
		return
		
	hp -= amount
	if hp <= 0:
		hp = 0
	
		var ui_nodes = get_tree().get_nodes_in_group("game_over")
		if ui_nodes.size() > 0:
			ui_nodes[0].show() # 显示找到的那个 GameOverScreen

		
		set_physics_process(false)
		return
	is_invincible = true
	invincible_timer = 1.0 

# 在 _physics_process(delta) 里的最上面，加上无敌时间倒计时
	
			
	# ... 下面是你原本的重力、移动、跳跃代码 ...

func update_sprite_direction() -> void:
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fly") and !event.is_echo():
		handle_space_pressed()
	
func handle_space_pressed() -> void:
	var current_time := Time.get_ticks_msec()
	var elapsed_time := current_time - last_space_press_time

	
