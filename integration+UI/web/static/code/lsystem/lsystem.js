/* An L-System growing grammar in JavaScript file: lsystem.js author: Daniel Winterstein 
 * Depends on: jquery, easeljs, (winterwell's) Array.js
 * */

function LSystem(canvasId) {
	this.canvasId = canvasId;	
}

function LRule(lhs, rhs) {
	this.lhs = lhs;
	this.rhs = rhs;
	assertMatch(lhs, string, rhs, "string|function");
	/** {LRule[]} */
	this.rules = [];
}

function LSentence(root) {
	assertMatch(root,string);
	this.nonTerminals = [root];
	this.symbols = [root];
	this.root = root;
}

LSystem.prototype.run = function(root) {
	this.stage = new createjs.Stage(this.canvasId);

	for(var ti=0; ti<nonTerminals.length; ti++) {
		var before = nonTerminals[ti];
		for(var ri=0; ri<this.rules.length; ri++) {
			var rule = this.rules[ri];			
			if (rule.lhs !== before) continue;
			var after = rule.apply(before);
			// TODO splice after in place of before in symbols			
			this.nonTerminals.removeValue(before);
			this.nonTerminals.append(after);
			console.log("L", before, after, this.symbols, this.nonTerminals);
		}
	}
	
	this.stage.addChild(new createjs.Shape())
			.setTransform(100,100)
			.graphics.f("red").dc(0,0,50);
	
	this.stage.update();
};