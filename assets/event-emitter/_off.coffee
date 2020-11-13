###*
 * Off methods
###

###* Remove eventName listeners ###
__eventEmitter_RemoveEventQ= (arr, fxRm)->
	i= 0
	len= arr.length
	while i < len
		if fxRm arr, i
			arr.splice i, 3
			len= arr.length
		else
			i+= 3
	return
__eventEmitter_RemoveEvent= (obj, eventName, listener)->
	throw 'Illegal eventName' if eventName in ['', '.'] # security reasons
	# get group
	if typeof eventName is 'string'
		if ~(idx= eventName.indexOf '.')
			group= (eventName.substr idx+1) or undefined
			eventName= eventName.substr 0, idx
		eventName= eventName.toLowerCase() if obj._eventNameIgnoreCase
	# Fx remover
	if group
		if listener
			fxRm= (q, i)-> q[i] is listener and q[i+1] is group
		else
			fxRm= (q, i)-> q[i+1] is group
	else if listener
		fxRm= (q, i)-> q[i] is listener
	# Remove
	queue= obj[EVENT_QUEUE]
	if eventName
		if fxRm
			if queueQ= queue.get(eventName)
				__eventEmitter_RemoveEventQ queueQ, fxRm
				queue.delete eventName unless queueQ.length
		else
			queue.delete eventName
	else if fxRm
		queue.forEach (queueQ, k)->
			__eventEmitter_RemoveEventQ queueQ, fxRm
			queue.delete k unless queueQ.length
			return
	else
		queue.clear()
	return
