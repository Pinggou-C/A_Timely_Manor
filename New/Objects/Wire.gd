extends RigidBody

var conns = []
var poscon = false
var negcon = false
var flowable = false
var flowing = false

func _ready():
	pass # Replace with function body.

func check(body):
	var good = true
	if conns.size > 0:
		for i in conns:
			if i != body:
				var g = i.check(self)
				if g == false:
					good = false
	

func positive_connect(body):
	poscon = body
	conns.append(body)
	if negcon != null:
		var pos = poscon.check()
		var neg = negcon.check()
		if pos == true && neg == true:
			flowable == true


func positive_disconnect(body):
	poscon = null
	conns.remove(conns.find(body))
	if flowable == true:
		flowable = false
	if flowing == true:
		flowing = false

func negative_connect(body):
	negcon =  body
	conns.append(body)
	if poscon != null:
		var pos = poscon.check()
		var neg = negcon.check()
		if pos == true && neg == true:
			flowable == true


func negative_disconnect(body):
	negcon = null
	conns.remove(conns.find(body))
	if flowable == true:
		flowable = false
	if flowing == true:
		flowing = false