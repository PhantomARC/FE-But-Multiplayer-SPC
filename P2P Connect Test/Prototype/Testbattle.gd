extends Control


onready var BDict = preload("res://Scripts/BattleDictionary.gd").new()
onready var chat = $VCore/HCore/Log/Chat
onready var STR = $VCore/HBOX/VBOX/STRPanel/strBox
onready var INT = $VCore/HBOX/VBOX/INTPanel/intBox
onready var BNS = $VCore/HBOX/VBOX/BNSPanel/bnsBox
onready var CRIT = $VCore/HBOX/VBOX/CRITPanel/critBox
onready var ETG = $VCore/HBOX/VBOX2/ETGPanel/tgBox
onready var DEX = $VCore/HBOX/VBOX3/DEXPanel/dexBox
onready var DFS = $VCore/HBOX/VBOX3/DFSPanel/dfsBox
onready var RES = $VCore/HBOX/VBOX3/RESPanel/resBox
onready var TypeText = $VCore/HBOX/VBOX2/TYPEPanel/typeButton
onready var StyleText = $VCore/HBOX/VBOX2/STYLEPanel/styleButton
onready var ClassText = $VCore/HBOX/VBOX2/ECLASSPanel/classButton

var classes = ["Human","Spirit","Mecha","Beast"]
var styles = ["normal","flat","set"]
var typeCtr = true
var classCtr = 0
var styleCtr = 0


func _ready():
	add_to_group("log")


func relay(msg):
	chat.bbcode_text += msg + " "






#Damage dealt: 
#Attacker: 80 str, 80 int, dealing str damage (80), no bonus, 10% crit base, normal attack
#Defender: 180tg, 80 dfs, "DFS" resist type, 100 dex, Mecha class

#str, int, bonus, crit

#battle(a_str:int, a_int:int, a_power:int, a_bonus:int, a_crit:float, a_method:String,
#e_tg:int, e_resist:int, e_resist_type:String,  e_dex:int, e_classType:String)



func _on_Button_pressed():
	var s = [
		int(STR.get_text()),
		int(INT.get_text()),
		int(BNS.get_text()),
		int(CRIT.get_text()),
		int(ETG.get_text()),
		int(DFS.get_text()),
		int(RES.get_text()),
		int(DEX.get_text()),
	]
	print(BDict.battle(s[0], s[1], int(s[0] if typeCtr else s[1]), int(s[2]),
	int(s[3]), styles[styleCtr], int(s[4]), int(s[5] if typeCtr else s[6]), 
		("DFS" if typeCtr else "RES"), int(s[7]), classes[classCtr]))


func _on_typeButton_pressed():
	print(typeCtr)
	typeCtr = !typeCtr
	TypeText.set_text("STR" if typeCtr else "INT")


func _on_styleButton_pressed():
	styleCtr = (styleCtr + 1) % styles.size()
	StyleText.set_text(styles[styleCtr])


func _on_classButton_pressed():
	classCtr =  (classCtr + 1) % classes.size()
	ClassText.set_text(classes[classCtr])
