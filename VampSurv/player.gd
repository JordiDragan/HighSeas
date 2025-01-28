extends CharacterBody2D

@export var character : Character

var health : float = 100:
	set(value):
		health = max(value, 0)
		%Health.value = value
		if health <= 0:
			get_tree().paused = true
var movement_speed : float = 150
var max_health : float = 100:
	set(value):
		max_health = value
		%Health.max_value = value
var recovery : float = 0:
	set(value):
		recovery = value
		%Recovery.text = "R: " + str(value)
var armor : float = 0:
	set(value):
		armor = value
		%Armor.text = "A: " + str(value)
var might : float = 1.0:
	set(value):
		might = value
		%Might.text = "M: " + str(value)
var area : float = 0
var magnet : float = 0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 50 + value
var growth : float = 1
var luck : float = 1.0

var nearest_enemy
var nearest_enemy_distance : float = 150 + area

var gold : int = 0:
	set(value):
		gold = value
		%Gold.text = "Gold : " + str(value)

var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0
var level : int = 1:
	set(value):
		level = value
		%Level.text = "Lvl " + str(value)
		%Options.show_option()

		if level >= 3:
			%XP.max_value = 20
		elif level >= 7:
			%XP.max_value = 40

var distance_in_pixel : float

func _ready():
	Persistence.gain_bonus_stats(self)
	character = Persistence.character
	set_base_stats(character.base_stats)
	%Options.check_item(character.starting_weapon)

func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation
	else:
		nearest_enemy_distance = 150 + area
		nearest_enemy = null

	var initial_position = position
	velocity = Input.get_vector("left", "right", "up", "down") * movement_speed
	move_and_collide(velocity * delta)
	distance_in_pixel += position.distance_to(initial_position)

	if distance_in_pixel >= 20:
		distance_in_pixel -= 20
		ParticleFx.add_effect("dust", position + Vector2(0, 15))

	check_XP()
	animation(delta)
	health += recovery * delta

func take_damage(amount):
	health -= max(amount * (amount/(amount + armor)), 1)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth

func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1

func _on_magnet_area_entered(area_overlap):
	if area_overlap.has_method("follow"):
		area_overlap.follow(self)

func gain_gold(amount):
	gold += amount

func open_chest():
	$UI/Chest.open()

func animation(_delta):
	if velocity == Vector2.ZERO:
		%AnimationPlayer.play("idle_" + character.animation_name)
	else:
		%AnimationPlayer.play("run_" + character.animation_name)

	if velocity.x < 0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false

func set_base_stats(base_stats : Stats):
	max_health += base_stats.max_health
	recovery += base_stats.recovery
	armor += base_stats.armor
	movement_speed += base_stats.movement_speed
	might += base_stats.might
	area += base_stats.area
	magnet += base_stats.magnet
	growth += base_stats.growth
	luck += base_stats.luck
