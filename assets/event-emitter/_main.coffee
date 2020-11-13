###*
 * Event emitter
###
EVENT_QUEUE= Symbol 'Event Queue'
#=include _on.coffee
#=include _off.coffee
class EventEmitter
	constructor: ->
		@[EVENT_QUEUE]= new Map()
		@_eventNameIgnoreCase= yes # do escape event name case
		return

	###*
	 * Convert plain objects ito event emitters
	###
	@applyTo: (plainObj)->
		throw new Error "::applyTo>> target object is null" unless plainObj?
		plainObj[EVENT_QUEUE]= new Map()
		plainObj._eventNameIgnoreCase= yes
		_defineProperties plainObj, _getOwnPropertyDescriptors @prototype
		return plainObj

	###*
	 * ADD EVENT
	 * @param {String, Array[String]} eventName - name of the event, could be grouped by '.'
	 * @param {function} listener - The listener
	###
	on: (eventName, listener)->
		try
			throw "Illegal arguments" unless arguments.length
			__eventEmitter_on this, eventName, listener, no
		catch error
			error= new Error "::on>> #{error}" if typeof error is 'string'
			throw error
		return this # chain
	###* ONCE ###
	once: (eventName, listener)->
		try
			throw "Illegal arguments" unless arguments.length
			__eventEmitter_on this, eventName, listener, yes
		catch error
			error= new Error "::once>> #{error}" if typeof error is 'string'
			throw error
		return this # chain

	###*
	 * REMOVE EVENT
	 * @example
	 *		::off()							Clear all events
	 *		::off('eventName')				Clear "eventName" listeners
	 *		::off(listener)					Remove listener from all events
	 *		::off('eventName', listener)	Remove listener from 'eventName'
	###
	off: (eventName, listener)->
		try
			return this unless @[EVENT_QUEUE]
			switch arguments.length
				when 0
					# Clear all events
					@[EVENT_QUEUE].clear()
				when 1
					if typeof eventName is 'string'
						eventName= eventName.trim().split(/\s+/)
						__eventEmitter_RemoveEvent this, ev, null for ev in eventName
					if typeof eventName is 'function'
						__eventEmitter_RemoveEvent this, null, eventName
					else if _isArray eventName
						@off ev for ev in eventName
					else if eventName?
						__eventEmitter_RemoveEvent this, eventName, null
					else
						throw "Event name could not be null"
				when 2
					if _isArray eventName
						@off ev, listener for ev in eventName
					else if eventName?
						throw 'Listener expected function' unless typeof listener is 'function'
						__eventEmitter_RemoveEvent this, eventName, listener
					else
						throw "Event name could not be null"
				else
					throw 'Illegal arguments'
			return this # chain
		catch error
			error= new Error "::off>> #{error}" if typeof error is 'string'
			throw error

	###* Emit event ###
	emit: (eventName, data)->
		try
			return unless queue= @[EVENT_QUEUE]
			# Check event name
			eventName= eventName.toLowerCase() if typeof eventName is 'string' and @_eventNameIgnoreCase
			# If event found
			if q= queue.get eventName
				len= q.length
				i= 0
				while i < len
					listener= q[i]
					# remove if is once
					if q[i+2]
						q.splice i, 3
						len= q.length
					else
						i+= 3
					# Exec
					setTimeout __eventEmitter_runListener(listener, this, eventName, data), 0
			# Check why event not found
			else
				if typeof eventName is 'string'
					throw "Event name contains space or dot: [#{eventName}]" if /[\s.]/.test eventName
				@catchUnknownEvent eventName, data
		catch error
			error= new Error "::emit>> #{error}" if typeof error is 'string'
			throw error
		this # chain
	###* when unknown event emitted ###
	catchUnknownEvent: (eventName)->
		Core.error "Uncaught error event", data arguments if eventName is 'error'
		return
	###* List all event names ###
	listEventNames: ->
		@[EVENT_QUEUE]?= new Map()
		return @[EVENT_QUEUE].keys()

	###* List all event names ###
	listListeners: (eventName)->
		result= []
		if queue= @[EVENT_QUEUE]
			# Check event name
			if typeof eventName is 'string'
				if ~(idx= eventName.indexOf '.')
					group= (eventName.substr idx+1) or undefined
					eventName= eventName.substr 0, idx
				eventName= eventName.toLowerCase() if @_eventNameIgnoreCase
			# Get event listeners
			if eventName and (q= queue.get eventName)
				if group
					result.push listener for listener, i in q by 3 when q[i+1] is group
				else
					result.push listener for listener in q by 3
			else if group
				queue.forEach (q)->
					result.push listener for listener, i in q by 3 when q[i+1] is group
					return
			else
				queue.forEach (q)->
					result.push listener for listener in q by 3
					return
		return result

	###* hasEvent ###
	hasEvent: (eventName)->
		return no unless queue= @[EVENT_QUEUE]
		eventName= eventName.toLowerCase() if typeof eventName is 'string' and @_eventNameIgnoreCase
		return yes if queue.has eventName
		throw "Event name contains space or dot: [#{eventName}]" if typeof eventName is 'string' and /[\s.]/.test eventName
		return no

	###* hasListener ###
	hasListener: (eventName, listener)->
		try
			return no unless queue= @[EVENT_QUEUE]
			# Check args
			switch arguments.length
				when 1
					listener= eventName
					throw "Listener expected function" unless typeof listener is 'function'
					`for(el of queue){ /*`
					for el of queue
						`*/`
						q= el[1]
						return yes for lstner, i in q by 3 when lstner is listener
						return no
				when 2
					throw "Listener expected function" unless typeof listener is 'function'
					eventName= eventName.toLowerCase() if typeof eventName is 'string' and @_eventNameIgnoreCase
					if eventQ= queue.get eventName
						return yes for lstner in eventQ by 3 when lstner is listener
						return no
					else if typeof eventName is 'string' and /[\s.]/.test eventName
						throw "Event name contains space or dot: [#{eventName}]"
					else
						return no
				else
					throw "Illegal arguments"
		catch error
			error= new Error "::hasListener>> #{error}" if typeof error is 'string'
			throw error
