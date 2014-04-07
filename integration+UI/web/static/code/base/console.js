/**
 * Ensures that the global console methods `log`, `warn` & `error` are defined,
 * and provides support for log-tags (supplied by the query parameter 'log' as
 * a '+' separated list. The first argument passed to the log method is taken to
 * be the log-tag.
**/
(function () {
	// Extract value for query parameter 'log'.
	var logTags = window.location.search.match(/[?&]log=([^&#]+)/);
	
	// Is 'nativelog' present as a qiery parameter?
	window.NATIVELOG = window.location.search.match(/[\?&]nativelog/) ? true : false;
	
	// Is 'debug' present as a qiery parameter?
	window.DEBUG = window.location.search.match(/[\?&]debug/) ? true : false;
	
	if (typeof window.console !== 'object') {
		window.console = {};
	}
	
	if (typeof window.console.log !== 'function') {
		if (DEBUG && $) { // In debug, and jQuery is available.
			var console = $('<div id="substitute-console"></div>');
			
			$(function () {
				$(document.body).append(console);
			});
			
			window.console.log = function () {			
				var args = Array.prototype.slice.call(arguments); // Cast Arguments from "object" to Array
				
				for (var i = 0; i < args.length; i++) {
					if (args[i] instanceof Object) {				
						args[i] = JSON.stringify(args[i]);
					}
				}
				
				console.append($("<p>").text(args.join(" ")));
				
				console[0].scrollTop = console[0].scrollHeight;
			};	
		} else {
			window.console.log = function () {};
		}
	}
	
	if (typeof window.console.warn !== 'function') {
		window.console.warn = window.console.log;
	}
	
	if (typeof window.console.error !== 'function') {
		window.console.error = window.console.log;
	}
	
	if (!window.NATIVELOG && logTags) {
		var nativeLog = window.console.log;
		
		window.console.log = createLogTagWrapper(window.console.log);
		
		window.console.warn = createLogTagWrapper(window.console.warn);
		
		window.console.error = createLogTagWrapper(window.console.error);
	}

	/**
	* Alert wrapper. Useful if you need to set a breakpoint here for debugging.
	*/
	if (window.DEBUG) {
		var nativeAlert = window.alert;
		
		window.alert = function (message) {
			if (nativeAlert.call !== undefined) {
				nativeAlert.call(window, message);
			} else {
				nativeAlert(message);
			}
		};
	}
	
	function createLogTagWrapper(nativeLog) {
		return function () {
			var args = Array.prototype.slice.call(arguments); // Cast Arguments from "object" to Array
			
			if (logTags.indexOf(args[0]) === -1) { // Log-tag not in white-list.
				return;
			}
			
			if (typeof nativeLog.apply === 'function') {
				nativeLog.apply(window.console, args);
			} else {
				nativeLog(args.join(" ")); // See previous comment for description.
			}
		};
	}
}());
