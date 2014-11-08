
SJTest.run({name:'CoinventClientTests',

	SmokeTest: function() {
		return "Welcome to Coinvent";
	},

	/** Check a file exists */
	fileLoadTest: function(test) {
		var cc = new CoinventClient();
		var f = cc.file_load('test/mermaid.dol')
			.then(function(r){
				console.log(r, test);
				assert(r);
				test.setStatus("pass");
				return r;								
		});
		test.setStatus("waiting");
		return f;
	},
	
	/** Compute a common base for 2 concepts */
	baseTest: function(test) {
		var concept1 = "/file/test/fish.dol";
		var concept2 = "/file/test/human.dol";
		var bd = new BlendDiagram();
		bd.input1 = concept1;
		bd.input2 = concept2;
		var cc = new CoinventClient();
		var f = cc.base(bd)
			.then(function(r){
				console.log(r);
				assert(r);
				test.setStatus("pass");
		}).fail(function(r) {
			console.log(r);
			test.setStatus("fail");
			test.details = r.statusText;
		});
		test.setStatus("waiting");
		return f;
	},

	/** Compute a blend from 2 concepts */
	blendTest: function(test) {
		var concept1 = "/file/test/fish.dol";
		var concept2 = "/file/test/human.dol";
		var bd = new BlendDiagram();
		bd.input1 = concept1;
		bd.input2 = concept2;
		var cc = new CoinventClient();
		
		var f = cc.blend(bd)
			.then(function(r){
				console.log(r);
				assert(r);
				window.blendResponse = r;
				var blend = new BlendDiagram(r.cargo);
				assert(blend.input1);
				assert(blend.input2);
				assert(blend.blend);
				assert(blend.blend.text);
				window.blend = blend;
				test.setStatus("pass");
		}).fail(function(r) {
			console.log(r);
			test.setStatus("fail");
			test.details = r.statusText;
		});
		test.setStatus("waiting");
		return f;
	}

});
