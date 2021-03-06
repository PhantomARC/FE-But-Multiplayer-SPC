extends Node

const CAP = { #Stat Caps, SHOULD BE INTEGERS
	"HP" : 120, #Health Stat Maximum
	"MP" : 240, #Mana Stat Maximum
	"TG" : 180, #Toughness Stat Maximum
	"EG" : 60, #Energy Stat Maximum
	"STR" : 80, #Strength Stat Maximum
	"DFS" : 80, #Defense Stat Maximum
	"INT" : 80, #Intellect Stat Maximum
	"RES" : 80, #Resilience Stat Maximum
	"DEX" : 100, #Dexterity Stat Maximum
}
const RED = { #Reduction Decimals as Percentages, SHOULD BE FLOATS
	"TG" : 0.50, #Toughness Damage Reduction Percentage
	"DFS" : 0.80,
	"RES" : 0.80,
	"DEX" : 0.60,
}
const FLOOR = { #Damage Threshold Floors
	"STR" : 1.00, #Strength Upper Damage Floor
	"INT" : 0.75, #Intellect Lower Damage Floor
}
const CEILING = { #Damage Threshold Ceilings
	"STR" : 1.25, #Strength Upper Damage Ceiling
	"INT" : 1.00, #Intellect Lower Damage Ceiling
}
#Anima/Imperium Effect Caps
const HP_REG : float = 0.10; #Health Regeneration, based on Max HP
const MP_REG : float = 0.05; #Mana Regeneration, based on Max MP
const EG_MPX : float = 0.50; #Energy to Damage Multiplier
#Stat Primary Effect Caps
const DEX_DODGE_MAX : float = 0.50; #Dexterity Evasion/Block Ceiling
#Stat Secondary Effect Caps
const STAT_RESIST_MAX : float = 0.25; #Defense/Resilience Status Resist Max
const S_DEX_REG_MAX : float = 0.05; #Dexterity Regeneration, Spirit
const M_DEX_CRT_MAX : float = 0.15; #Dexterity Crit Bonus, Mecha
const B_DEX_TRN_MAX : int = 2; #Dexterity Terrain Bonus, Beasts
const H_DEX_MOV_MAX : int = 2; #Dexterity Movement Bonus, Humans
#Final Caps - Calculated Last!!!
const FINAL_RESIST_MAX : float = 0.50; #Total Resist Chance Cap
const FINAL_DODGE_MAX : float = 0.85; #Evasion/Block Chance Cap

var dRNG = RandomNumberGenerator.new()

#Stat Limits
	#Anima/Imperium Capping
		#Used to limit resources to maximum
func cap_anima(anima:int, animaMax:int, type:String) -> void: #caps Anima/Imperium
	anima = int(clamp(anima, 0, animaMax)) if (animaMax < int(CAP[type])) else cap_stat(anima, type)

	#Any Stat Capping 
		#Used in other calculations
func cap_stat(stat:int, type:String) -> int: #returns valid int (ranges 0 - cap)
	return int(clamp(stat, 0, CAP[type]))


#Battle Functions
	#Natural Health Regen
func calc_healthReg(healthCurrent:int, healthMax:int) -> int: #return new health after Regeneration
	return int(clamp((HP_REG * healthMax) + healthCurrent, healthCurrent, healthMax))

	#Natural Mana Regen
func calc_manaReg(manaCurrent:int, manaMax:int) -> int: #return new mana after Regeneration
	return int(clamp((MP_REG * manaMax) + manaCurrent, manaCurrent, manaMax))

	#Stat damage Reduction
		#used to calculate and return a Percent multiplier for damage
func calc_statRed(stat:int, type:String) -> float: #return damage multiplier from stat
	return 1.00 - (clamp(stat, 0, CAP[type]) * RED[type] / CAP[type])

	#Energy Adaptive Damage Application
func calc_overloadBonus(stat:int, energy:int) -> int:
	return (energy - CAP["EG"] + stat) if (energy > CAP["EG"]) else stat


#DEX and CRIT Functions
	#Dodge chance from DEX
func calc_dodgeChance(dexterity:int) -> float: #return dodge chance
	return (0.00 + cap_stat(dexterity, "DEX") * DEX_DODGE_MAX / CAP["DEX"])

	#Critical Hit Application
func calc_critCheck(critChance:float) -> bool: #return critical hit status
	#dRNG as random number
	dRNG.randomize()
	return (clamp(critChance, 0.00, 1.00) >= dRNG.randf_range(0.00, 1.00))

	#Dodge/Block Application
func calc_dodgeCheck(chance:float) -> bool: #return dodge/block status
	#dRNG as random number against chance; chance as dodge/block chance in float
	dRNG.randomize()
	return (clamp(chance, 0, FINAL_DODGE_MAX) >= dRNG.randf_range(0.00, 1.00))

#Damage Functions
	#Easier Implementation for Pure, Pre-mitigated Damage, CALL
func calc_dmgNorm(a_str:int, a_int:int, a_type:int, a_bonus) -> int:
	calc_dmgPure(calc_dmgRange(a_int, "int"), calc_dmgRange(a_str, "str"), a_type, a_bonus)
	return 1

	#Pure, Pre-mitigated Damage, DO NOT CALL
func calc_dmgPure(dmg_floor:float, dmg_ceiling:float, stat:int, bonus:int) -> int: 
	#return pure damage output
	#dRNG as random number for caps; stat as num; bonus as extra damage
	#dmg_floor from calc_dmgFloor(); dmg_ceiling from calc_dmgCeiling()
	dRNG.randomize()
	return int(dRNG.randf_range(dmg_floor, dmg_ceiling) * (stat + bonus))

	#Flat Damage
func calc_dmgFlat(dmg:int) -> int:
# warning-ignore:integer_division
	return int(dmg / 4)


func calc_dmgRange(stat:int, type:String) -> float: #return damage floor/ceiling
	return (FLOOR[type] + (cap_stat(stat, type) * (CEILING[type] - FLOOR[type]) / CAP[type]))

