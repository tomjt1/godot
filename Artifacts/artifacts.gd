extends Node2D
#Artifact Controller

@onready var goldTunic = $A_GoldTunic
@onready var freshHoney = $A_FreshHoney
@onready var slipnSlide = $A_SlipNSlide
@onready var daredevil = $A_Daredevil

func _on_hurtbox_area_entered(_area):
	if goldTunic.artifactEnabled && PlayerStats.money >= 1:
		goldTunic.effect()
	elif goldTunic.artifactEnabled && PlayerStats.money <= 0: #if no more money, disable
		goldTunic.toggle()

func _on_a_gold_tunic_artifact_enabled():
	PlayerStats.defense += goldTunic.defense
func _on_a_gold_tunic_artifact_disabled():
	PlayerStats.defense -= goldTunic.defense

func _on_a_slip_n_slide_artifact_enabled():
	PlayerStats.friction += -0.75
func _on_a_slip_n_slide_artifact_disabled():
	PlayerStats.friction += 0.75

func _on_a_fresh_honey_artifact_enabled():
	freshHoney.timer.start()
