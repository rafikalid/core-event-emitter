###*
 * On methods
###
__eventEmitter_on= (obj, eventName, listener, isOnce)->
	throw 'EventName could not be empty' unless eventName?
	throw "Listener expected function" unless typeof listener is 'function'
	if typeof eventName is 'string'
		eventName= eventName.trim().split /\s+/
		__eventEmitter_on2 obj, ev, listener, isOnce for ev in eventName
	else if _isArray eventName
		__eventEmitter_on obj, ev, listener, isOnce for ev in eventName
	else
		__eventEmitter_on2 obj, eventName, listener, isOnce
	return

__eventEmitter_on2= (obj, eventName, listener, isOnce)->
	queue= obj[EVENT_QUEUE]?= new Map()
	# Group
	if typeof eventName is 'string'
		if ~(idx= eventName.indexOf '.')
			group= (eventName.substr idx+1) or undefined
			eventName= eventName.substr 0, idx
			throw 'EventName could not be empty' unless eventName
		eventName= eventName.toLowerCase() if obj._eventNameIgnoreCase
	# add
	if eventQ= queue.get eventName
		eventQ.push listener, group, isOnce
	else
		eventQ= [listener, group, isOnce]
		queue.set eventName, eventQ
	return

###* RUN LISTENERS ###
__eventEmitter_runListener= (listener, obj, eventName, data)->
	try
		p= listener.call obj, data
		if p instanceof Promise
			if eventName is 'error'
				p.catch Core.fatalError.bind Core, 'listener-error'
			else
				p.catch obj.emit.bind obj, 'error'
	catch error
		if eventName is 'error'
			Core.fatalError 'listener-error', error
		else
			obj.emit 'error', error
	return
