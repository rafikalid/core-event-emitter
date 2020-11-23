###*
 * Router
###
<% var Core= false; %>
do->
	"use strict"
	#=include _utils.coffee
	#=include event-emitter/_main.coffee

	# Export interface
	if module? then module.exports= EventEmitter
	else if window? then window.EventEmitter= EventEmitter
	else
		throw new Error "Unsupported environement"
	return
