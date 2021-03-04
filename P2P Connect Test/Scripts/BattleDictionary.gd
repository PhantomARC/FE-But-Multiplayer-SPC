extends Node

#Anima/Imperium Caps
const hpCap : int = 120; #Health Maximum
const mpCap : int = 240; #Mana Maximum
const eCap : int = 60; #Energy Maximum
const tCap : int = 180; #Toughness Maximum
#Anima/Imperium Effect Caps
const tDRed : float = 0.50; #Toughness Damage Reduction Percentage
const hReg : float = 0.10; #Health MaxHP based Regeneration
const mReg : float = 0.05; #Mana/All MaxStat Regeneration
const eDam : float = 0.50; #Energy to Damage Conversion
#Stat Caps
const strCap : int = 80; #Strength Maximum
const dfsCap : int = 80; #Defense Maximum
const intCap : int = 80; #Intellect Maximum
const resCap : int = 80; #Resilience Maximum
const dexCap : int = 100; #Dexterity Maximum
#Stat Effect Caps
const iBLow : float = 0.75; #Intellect Lower Damage Floor
const sBLow : float = 1.00; #Strength Upper Damage Floor
const sBDam : float = 1.25; #Strength Upper Damage Ceiling
const dSRed : float = 0.25; #Defense Resist Ceiling
const iBDam : float = 1.00; #Intellect Lower Damage Ceiling
const rSRed : float = 0.25; #Resilience Resist Ceiling
const dRoll : float = 0.50; #Dexterity Evasion/Block Ceiling
#Pure Effect Caps
const SRedCap : float = 0.50; #Total Resist Chance Cap
const blockRed : float = 0.60; #Block Damage Percent
const dRollCap : float = 0.85; #Evasion/Block Chance Cap


var dRNG = RandomNumberGenerator.new()


func calc_tDRed(toughness:int) -> float: #return damage multiplier from toughness
	return (1.00 - (clamp(toughness, 0, tCap) * tDRed / tCap))


func calc_nReg(mpx:float, res:int, mres:int, oload:bool) -> int: 
	#return new resource amount after Regeneration
	#mpx as hReg or mReg; oload as true/false (for energy)
	#res as resource current amount; mres as resource character maximum
	return int((mpx * mres) + res) if oload else int(clamp((mpx * mres) + res, res, mres))


func calc_dRoll(dodge:int) -> float: #return dodge chance
	return (0.00 + clamp(dodge, 0, dexCap) * dRoll / dexCap)


func calc_dodged(dch:float) -> bool: #return dodge/block status
	#dRNG as random number against dch; dch as dodge chance in float
	dRNG.randomize()
	return (clamp(dch,0,dRollCap) >= dRNG.randf_range(0.00, 1.00))


func calc_dmg(loCap:float, hiCap:float, stat:int, bonus:int) -> int: #return pure damage output
	#dRNG as random number for caps; stat as num; bonus as extra pre-dmg
	#loCap as int boost; hiCap as str boost
	dRNG.randomize()
	return int(dRNG.randf_range(loCap, hiCap) * (stat + bonus))


func calc_iBDam(intellect:int) -> float: #return loCap int boost
	return (iBLow + (clamp(intellect, 0, intCap) * (iBDam - iBLow) / intCap))


func calc_sBDam(strength:int) -> float: #return hiCap str boost
	return (sBLow + (clamp(strength, 0, strCap) * (sBDam - sBLow) / strCap))


