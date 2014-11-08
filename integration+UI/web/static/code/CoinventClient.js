
/**
* @param server {string?} The url for the server
*/
function CoinventClient(server) {
	/** The url for the server -- always ends with a '/'.
	*/
	this.server = server || '/';
	if (this.server.charAt(this.server.length-1)!='/') this.server += '/';
	this.baseEngine = 'default';
	this.blendEngine = 'default';
}

/** common basis for posts */
CoinventClient.prototype.postBlendDiagram = function(op, engine, blendDiagram) {
	assertMatch(op,String, engine,String, blendDiagram,BlendDiagram);
	var data = {
			lang: blendDiagram.format,
			input1: this.val(blendDiagram.input1),
			input2: this.val(blendDiagram.input2),
			base: this.val(blendDiagram.base),
			base_input1: blendDiagram.base_input1,
			base_input2: blendDiagram.base_input2
			//cursor: {?url} For requesting follow-on results.
		};
	return $.ajax({
		url: this.server+op+'/'+engine,
		type:'POST',
		data: data
	});
};

/**
 * Given 2 Concepts, compute a common base Concept
 * @param blendDiagram {BlendDiagram}
 */
CoinventClient.prototype.base = function(blendDiagram) {
	return this.postBlendDiagram('base', this.baseEngine, blendDiagram);
};


/**
 * Given 2 Concepts and a base, compute a blend Concept
 * @param blendDiagram {BlendDiagram}
 */
CoinventClient.prototype.blend = function(blendDiagram) {
	return this.postBlendDiagram('blend', this.blendEngine, blendDiagram);
};


/**
 * @param pathToFile e.g. "winterstein/mytheory.dol"
 */
CoinventClient.prototype.file_load = function(pathToFile) {
	return $.ajax({
		url: this.server+'file/'+pathToFile
	});
}
/**
 * @param pathToFile e.g. "winterstein/mytheory.dol"
 */
CoinventClient.prototype.file_save = function(pathToFile, text) {
	return $.ajax({
		url: this.server+'file/'+pathToFile+"?action=save",
		type:'POST',
		data: text
	});
}

function isURL(u) {
	if ( ! u || ! match(u, String)) return false;
	if (u.match(/\s/)) return false;
	// TODO better -- use a regex
	if (u.substring(0,4)==='http') return true;
	if (u.substring(0,1)==='/') return true;
	return false;
}

/** @returns value to send in an API request -- prefers url if set */
CoinventClient.prototype.val = function(concept) {
	if ( ! concept) return null;
	// is it a url?
	if (isURL(concept)) {
		return concept;
	}
	return concept.url || concept.text;
}


function BlendDiagram() {
	this.format = 'owl';
	/** {Concept} */
	this.base = new Concept();
	/** {Concept} */
	this.blend = new Concept();
	/** {Concept} */
	this.input1 = new Concept();
	/** {Concept} */
	this.input2 = new Concept();

	/** {object} */
	this.base_input1={};
	this.base_input2={};
	this.input1_blend={};
	this.input2_blend={};
//	If weakenings are used, then these Concepts are names weakinput1, weakinput2, and weakbase, 
}

function Concept(text) {
	this.format = 'owl';
	this.text = text;
	/** {string} */
	this.url = null;
}


/**
 * @returns string[] The (relative names) of the symbols used
 */
Concept.prototype.symbols = function() {
	// TODO
	return ['sun','planet'];
};


// helpful error logging
$(document).ajaxError(function( event, jqxhr, settings, thrownError ) {
	console.warn("ajax", settings.url, jqxhr.statusText);
});

// NB: Mappings are just json maps
