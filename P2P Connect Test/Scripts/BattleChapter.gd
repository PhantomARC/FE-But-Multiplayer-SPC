extends Node

#Health Cap = 50; Mana Cap = 120; Energy Cap = 30; Toughness Cap = 100;

var tAnima
var sStats
var tStats
const hpCap : int = 100;
const mpCap : int = 200;
const eCap : int = 50;
const tCap : int = 150;
const tDRed : float = 0.50;


func battle(source, target):
	tAnima = get_anima(target);
	sStats = get_stats(source,"ATK");
	tStats = get_stats(target,"DFS");
	if tAnima[0] == "health" or tAnima[0] == "mana":
		return (sStats)
	if tAnima[0] == "toughness":
		return (sStats * tough_mpx(150))


func get_anima(unit):
	return (["health",100])


func get_stats(unit, type) -> int:
	if unit == 1:
		return (120)
	if unit == 2:
		return (60)
	return (0)


func tough_mpx(amt) -> float:
	var toughCtr = (amt if (amt < tCap) else tCap)
	return (toughCtr * tDRed / tCap)
