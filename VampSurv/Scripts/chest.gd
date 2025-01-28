extends NinePatchRect

@onready var chest = $AnimatedSprite2D
@onready var options = %Options
@onready var rewards = $Rewards
func _ready():
	randomize()
	hide()
	$Open.show()
	$Close.hide()

func open():
	clear_reward()
	chest.play("idle_boss_chest")
	get_tree().paused = true
	show()
	$Open.show()
	$Close.hide()


func _on_open_pressed():
	clear_reward()
	chest.play("open_boss_chest")
	await chest.animation_finished
	set_reward()
	$Open.hide()
	$Close.show()


func _on_close_pressed():
	get_tree().paused = false
	hide()

func set_reward():
	clear_reward()
	var chance = randf()
	var weight = [5.0,2.0,1.0]
	if chance < get_weight_chance(weight, 0):
		upgrade_item(2, 3)
	elif chance < get_weight_chance(weight, 1):
		upgrade_item(1, 4)
	else:
		upgrade_item(0, 5)

func upgrade_item(start, end):
	for index in range(start, end):
		var upgrades = options.get_available_upgrades()

		if upgrades.size() == 0:
			add_gold(index)
		else:
			var selected_upgrade : Item
			selected_upgrade = upgrades.pick_random()
			if selected_upgrade is Weapon and selected_upgrade.max_level_reached():
				rewards.get_child(index).texture = selected_upgrade.evolution.icon
			else:
				rewards.get_child(index).texture = selected_upgrade.icon
			
			rewards.get_child(index).show()
			selected_upgrade.upgrade_item()

func clear_reward():
	for slot in rewards.get_children():
		slot.texture = null
		slot.hide()

func add_gold(index):
	var gold : Gold = load("res://resources/Pickups/Gold.tres")
	gold.player_reference = owner
	rewards.get_child(index).texture = gold.icon
	rewards.get_child(index).show()
	gold.activate() 

func get_weight_chance(weight, index):
	var modified_weight = []
	var sum = 0
	for i in range(weight.size()):
		if i == 0:
			modified_weight.append(weight[i])
			sum += weight[i]
		else:
			modified_weight.append(weight[i] * owner.luck)
			sum += weight[i] * owner.luck
	
	var cumulative = 0
	for i in range(index + 1):
		cumulative += modified_weight[i]
	
	return float(cumulative)/sum
