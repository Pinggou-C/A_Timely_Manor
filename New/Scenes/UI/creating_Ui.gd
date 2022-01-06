extends Control


func ready(size, wires, nodes):
	$Corner.position = size
	var nod = nodes
	var wir = wires
	if nod == 0:
		nod = '---'
	elif nod < 10:
		nod = '0' + String(nod)
	else:
		nod = String(nod)
	if wir == 0:
		wir = '---'
	elif wir < 10:
		wir = '0' + String(wir)
	else:
		wir = String(wir)
	$Corner/nodes.text = nod
	$Corner/wires.text = wir

func update_text(wires = null, nodes = null):
	var nod = nodes
	var wir = wires
	if nod != null:
		if nod == 0:
			nod = '---'
		elif nod < 10:
			nod = '0' + String(nod)
		else:
			nod = String(nod)
		$Corner/nodes.text = nod
	if wir != null:
		if wir == 0:
			wir = '---'
		elif wir < 10:
			wir = '0' + String(wir)
		else:
			wir = String(wir)
		$Corner/wires.text = wir

func blink(which):
	if which == "nodes":
		$AnimationPlayer.play('wir')
	if which == "wires":
		$AnimationPlayer.play('nod')
