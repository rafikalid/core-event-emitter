###*
 * Router
###
<% var Core= false; %>
do->
	"use strict"
	#=_utils.coffee
	#=event-emitter/_main.coffee

	# Export interface
	if module? then module.exports= EventEmitter
	else if window? then window.EventEmitter= EventEmitter
	else
		throw new Error "Unsupported environement"
	return
