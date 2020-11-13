# core-event-emitter
Advanced and fast event emitter for node, browser &amp; others

# Enable events on your objects

## By extending this class
This is the preffered
```javascript
// If you use "core-ui", use "Core.EventEmitter"
class MyClass extends EventEmitter {
	constructor(){
		super();
	}
}
```

## By calling EventEmitter.applyTo
```javascript
EventEmitter.applyTo(MyClass.prototype);
```

## Or if you need it on one object only or as static methods on a class
```javascript
// Apply event service to myObject
EventEmitter.applyTo(myObject);

// Apply event service as static methods to MyClass
EventEmitter.applyTo(MyClass);
```

# Add listener to an event
```javascript
// Add simple event listener
myObj.on('eventName', function myListener(data){ /* Logic */ });

// Event name could be of any type: string, number, symbol, object, function, ...
myObj.on(27, function myListener(data){ /* Logic */ });

// Add listener to multiple events: Just add a blank space between event names
myObj.on('event1 event2 ... eventN', function myListener(data){ /* Logic */ });
// Or use Array
myObj.on(['event1', 'event2', ... ,'eventN'], function myListener(data){ /* Logic */ });

// Add under a group
myObj.on('eventName.myGroup', function myListener(data){ /* Logic */ });
```

# Add listener to be run only once and then autoremoved
Just use `once` method instead of `on`.

# remove listeners
```javascript
// Clear all event listeners
myObj.off();

// Remove all listeners of an event
myObj.off('eventName');
myObj.off('event1 event2'); // multiple events are supported by "off" method
myObj.off(['event1', 'event2']); // multiple events are supported by "off" method

// Remove all listeners of an event under a group
myObj.off('eventName.groupName');

// Remove all listeners of all events under a group
myObj.off('.groupName');

// Remove specific listener from all events
myObj.off(listener);

// Remove listener on an event
myObj.off('eventName', listener);

// Remove listener on an event under a group
myObj.off('eventName.groupName', listener);

// Remove listener on all events under a group
myObj.off('.groupName', listener);
```

# Trigger event listeners
```javascript
// We recommend to use a plain object as your event data
// But it could be of any type
myObj.emit('eventName', {eventData});
```

# Catch unknown event
If no listener is added to an event, you still can catch it by overriding the method `catchUnknownEvent`
```javascript
class MyClass extends EventEmitter {
	catchUnknownEvent(eventName, eventData){
		// Your logic
	}
}
```

# Other methods

## Check if an event is set and has listeners
```javascript
var isEventSet= myObject.hasEvent('eventName');
```

## Check if has a listener
```javascript
// Check if a listener is found on some event
var hasListener= myObject.hasListener(listener);

// Check if a listener is found on specific event
var hasListener= myObject.hasListener('eventName', listener);
```

## List all events
```javascript
var eventList= myObject.listEventNames();
```

## List all listeners
```javascript
// List all listeners
var listeners= myObject.listListeners();

// List listeners on an event
var listeners= myObject.listListeners('eventName');

// List listeners on an event under a group
var listeners= myObject.listListeners('eventName.groupName');

// List listeners on all event under a group
var listeners= myObject.listListeners('.groupName');
```
