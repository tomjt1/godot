extends Node2D

@onready var areaLeft = $Areas/AreaLeft
@onready var areaMiddle = $Areas/AreaMiddle
@onready var areaRight = $Areas/AreaRight
@onready var itemLeft = $Items/ItemLeft
@onready var itemMiddle = $Items/ItemMiddle
@onready var itemRight = $Items/ItemRight
@onready var labelLeft = $Labels/LabelLeft
@onready var labelMiddle = $Labels/LabelMiddle
@onready var labelRight = $Labels/LabelRight
@onready var purchaseSE = $Purchase
@onready var tooltipUI = $CanvasLayer/TooltipUI

const Potion = preload("res://World/Items/potion.tscn")
const Sword = preload("res://World/Items/swordItem.tscn")
const ExtraHeart = preload("res://World/Items/extraHeart.tscn")
const SpeedUpgrade = preload("res://World/Items/speedUpgrade.tscn")
const Key = preload("res://World/Items/keyItem.tscn")

enum {
	POTION,
	KEY,
	SWORD,
	HEART,
	SPEED,
	NONE
}

var itemList = [NONE, KEY, POTION, SWORD, HEART, SPEED]
var middleList = [NONE, KEY, KEY, POTION, POTION, POTION]
var leftItemName = NONE
var middleItemName = NONE
var rightItemName = NONE
var rightAllow = false
var middleAllow = false
var leftAllow = false


func _ready():
	setup()

func get_price(item):
	return get_item(item).price

func get_item(item):
	return item.get_child(0, false)


func match_item(item):
	match item:
		POTION:
			return Potion.instantiate()
		KEY:
			return Key.instantiate()
		SWORD:
			return Sword.instantiate()
		HEART:
			return ExtraHeart.instantiate()
		SPEED:
			return SpeedUpgrade.instantiate()
		NONE:
			return null


#when body is entered and sprite is visible, popup price and allow purchase
func _on_area_left_body_entered(_body):
	if get_item(itemLeft).visibleSprite:
		#print(get_price(itemLeft))
		leftAllow = true
		labelLeft.visible = true
		tooltipUI.display(get_item(itemLeft).itemName, get_item(itemLeft).text, get_item(itemLeft).sprite2D)

func _on_area_middle_body_entered(_body):
	if get_item(itemMiddle).visibleSprite:
		#print(get_price(itemMiddle))
		middleAllow = true
		labelMiddle.visible = true
		tooltipUI.display(get_item(itemMiddle).itemName, get_item(itemMiddle).text, get_item(itemMiddle).sprite2D)

func _on_area_right_body_entered(_body):
	if get_item(itemRight).visibleSprite:
		#print(get_price(itemRight))
		rightAllow = true
		labelRight.visible = true
		tooltipUI.display(get_item(itemRight).itemName, get_item(itemRight).text, get_item(itemRight).sprite2D)


#when body is exited, erase popup and disallow purchase
func _on_area_right_body_exited(_body):
	rightAllow = false
	labelRight.visible = false
	tooltipUI.undisplay()

func _on_area_middle_body_exited(_body):
	middleAllow = false
	labelMiddle.visible = false
	tooltipUI.undisplay()

func _on_area_left_body_exited(_body):
	leftAllow = false
	labelLeft.visible = false
	tooltipUI.undisplay()

#when area is entered by sword, purchase if allowed and have money and sprite is visible
func _on_area_middle_area_entered(_area):
	if PlayerStats.money >= get_price(itemMiddle) && middleAllow && get_item(itemMiddle).visibleSprite:
		#print("purchase!") #purchase
		#play purchase SE
		PlayerStats.money = PlayerStats.money - get_price(itemMiddle) #subtract money
		get_item(itemMiddle).effect() #activate item effect
		purchaseSE.play()
		get_item(itemMiddle).visibleSprite = false #set sprite to invisible
		labelMiddle.visible = false

func _on_area_left_area_entered(_area):
	if PlayerStats.money >= get_price(itemLeft) && leftAllow && get_item(itemLeft).visibleSprite:
		#print("purchase!") #purchase
		#play purchase SE
		PlayerStats.money = PlayerStats.money - get_price(itemLeft)
		get_item(itemLeft).effect() #activate item effect
		get_item(itemLeft).visibleSprite = false #set sprite to invisible
		labelLeft.visible = false
		purchaseSE.play()

func _on_area_right_area_entered(_area):
	if PlayerStats.money >= get_price(itemRight) && rightAllow && get_item(itemRight).visibleSprite:
		#print("purchase!") #purchase
		#play purchase SE
		PlayerStats.money = PlayerStats.money - get_price(itemRight)
		get_item(itemRight).effect() #activate item effect
		get_item(itemRight).visibleSprite = false #set sprite to invisible
		labelRight.visible = false
		purchaseSE.play()

#randomize items and setup child nodes, if NONE: disable collision
func setup():
	leftItemName = itemList[randi_range(0,itemList.size() -1)]
	if leftItemName != NONE:
		itemLeft.add_child(match_item(leftItemName))
		labelLeft.text = str(get_price(itemLeft))
	else:
		areaLeft.monitoring = false
	middleItemName = middleList[randi_range(0,middleList.size() -1)]
	if middleItemName != NONE:
		itemMiddle.add_child(match_item(middleItemName))
		labelMiddle.text = str(get_price(itemMiddle))
	else:
		areaMiddle.monitoring = false
	rightItemName = itemList[randi_range(0,itemList.size() -1)]
	if rightItemName != NONE:
		itemRight.add_child(match_item(rightItemName))
		labelRight.text = str(get_price(itemRight))
	else:
		areaRight.monitoring = false
