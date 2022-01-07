extends Control

var error
var info1
var info2
var inout = false

func text(onof, volt=0, amp=0, resistance=0, watt=0, type="none", flowing= 'false', errors = "~"):
	inout(onof)
	if onof == true:
		info1= "Volts: " + String(volt)+"\nAmps: " + String(amp) + "\nWatts: " + String(watt) + "\nResistance: " + String(resistance)
		info2 = "Type: " + type+ "\n\nFlowing: " + flowing
		error = "Errors: "
		if errors.size() >0:
			for i in errors:
				if i != null:
					error += i + "\n"
		$Pda/error.text = error
		$Pda/info.text = info1
		$Pda/info2.text = info2
	else:
		info1= "Volts: ~\nAmps: ~\nWatts: ~\nResistance: ~" 
		info2 = "Type: ~\n\nFlowing: ~" 
		error = "Errors: ~"

		$Pda/error.text = error
		$Pda/info.text = info1
		$Pda/info2.text = info2
func inout(which):
	if which == true && inout == false:
		$AnimationPlayer.play("in")
		inout = true
	if which == false && inout == true:
		$AnimationPlayer.play("New Anim")
		inout = false
