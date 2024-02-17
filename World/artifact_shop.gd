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

const GoldTunic = preload("res://World/Items/d_gold_tunic.tscn")
const FreshHoney = preload("res://World/Items/d_FreshHoney.tscn")
const SlipNSlide = preload("res://World/Items/d_SlipNSlide.tscn")
const Daredevil = preload("res://World/Items/d_Daredevil.tscn")

enum {
	NONE,
	GOLD_TUNIC,
	SLIPNSLIDE,
	HONEY,
	DAREDEVIL
}
#common x5, uncommon x4, rare x3, super x2, ultra x1
var itemList = [NONE, NONE, NONE]
var leftItemName = NONE
var middleItemName = NONE
var rightItemName = NONE
var rightAllow = false
var middleAllow = false
var leftAllow = false
var player = null


func _ready():
	itemList.append_array([GOLD_TUNIC,GOLD_TUNIC,GOLD_TUNIC,GOLD_TUNIC])
	itemList.append_array([SLIPNSLIDE,SLIPNSLIDE,SLIPNSLIDE,SLIPNSLIDE,SLIPNSLIDE])
	itemList.append_array([HONEY, HONEY, HONEY])
	itemList.append_array([DAREDEVIL,DAREDEVIL,DAREDEVIL,DAREDEVIL])
	#itemList.append_array([])
	#print(itemList)
	setup()

func get_price(item):
	return get_item(item).price

func get_item(item):
	return item.get_child(0, false)


func match_item(item):
	match item:
		GOLD_TUNIC:
			return GoldTunic.instantiate()
		HONEY:
			return FreshHoney.instantiate()
		SLIPNSLIDE:
			return SlipNSlide.instantiate()
		DAREDEVIL:
			return Daredevil.instantiate()
		NONE:
			return null


#when body is entered and sprite is visible, popup price and allow purchase
func _on_area_left_body_entered(body):
	if get_item(itemLeft).visibleSprite:
		#print(get_price(itemLeft))
		leftAllow = true
		labelLeft.visible = true
		player = body
		tooltipUI.display(get_item(itemLeft).artifactName, get_item(itemLeft).text, get_item(itemLeft).sprite2D)

func _on_area_middle_body_entered(body):
	if get_item(itemMiddle).visibleSprite:
		#print(get_price(itemMiddle))
		middleAllow = true
		labelMiddle.visible = true
		player = body
		tooltipUI.display(get_item(itemMiddle).artifactName, get_item(itemMiddle).text, get_item(itemMiddle).sprite2D)

func _on_area_right_body_entered(body):
	if get_item(itemRight).visibleSprite:
		#print(get_price(itemRight))
		rightAllow = true
		labelRight.visible = true
		player = body
		tooltipUI.display(get_item(itemRight).artifactName, get_item(itemRight).text, get_item(itemRight).sprite2D)

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
	if PlayerStats.money >= get_price(itemMiddle) && middleAllow && get_item(itemMiddle).visibleSprite && !get_item(itemMiddle).get_enabled_status(player):
		PlayerStats.money = PlayerStats.money - get_price(itemMiddle) #subtract money
		get_item(itemMiddle).purchase(player)
		get_item(itemMiddle).sprite_visibility_toggle() #set sprite to invisible
		labelMiddle.visible = false
		purchaseSE.play()

func _on_area_left_area_entered(_area):
	if PlayerStats.money >= get_price(itemLeft) && leftAllow && get_item(itemLeft).visibleSprite && !get_item(itemLeft).get_enabled_status(player):
		PlayerStats.money = PlayerStats.money - get_price(itemLeft)
		get_item(itemLeft).purchase(player)
		get_item(itemLeft).sprite_visibility_toggle() #set sprite to invisible
		labelLeft.visible = false
		purchaseSE.play()

func _on_area_right_area_entered(_area):
	if PlayerStats.money >= get_price(itemRight) && rightAllow && get_item(itemRight).visibleSprite && !get_item(itemRight).get_enabled_status(player):
		PlayerStats.money = PlayerStats.money - get_price(itemRight)
		get_item(itemRight).purchase(player)
		get_item(itemRight).sprite_visibility_toggle() #set sprite to invisible
		labelRight.visible = false
		purchaseSE.play()

#randomize items and setup child nodes, if NONE: disable collision
func setup():
	leftItemName = DAREDEVIL#itemList[randi_range(0,itemList.size() -1)]
	if leftItemName != NONE:
		itemLeft.add_child(match_item(leftItemName))
		labelLeft.text = str(get_price(itemLeft))
		get_item(itemLeft).sprite_visibility_toggle()
	else:
		areaLeft.monitoring = false
	middleItemName = itemList[randi_range(0,itemList.size() -1)]
	if middleItemName != NONE:
		itemMiddle.add_child(match_item(middleItemName))
		labelMiddle.text = str(get_price(itemMiddle))
		get_item(itemMiddle).sprite_visibility_toggle()
	else:
		areaMiddle.monitoring = false
	rightItemName = itemList[randi_range(0,itemList.size() -1)]
	if rightItemName != NONE:
		itemRight.add_child(match_item(rightItemName))
		labelRight.text = str(get_price(itemRight))
		get_item(itemRight).sprite_visibility_toggle()
	else:
		areaRight.monitoring = false
