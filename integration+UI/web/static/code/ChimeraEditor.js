
var BD;

var animals = [
	{name:'Meerkat', img:'/static/img/animals/AN01047C.jpg'},
	{name:'Elephant', img:'/static/img/animals/AN01001C.jpg'},
	{name:'Zebra', img:'/static/img/animals/AN01003C.jpg'},
	{name:'Rhino', img:'/static/img/animals/AN01007C.jpg'},
	{name:'Hippo', img:'/static/img/animals/AN01009C.jpg'}
];

function ChimeraEditor() {
	this.setModel(new BlendDiagram());
	this.client = new CoinventClient();
	this.client.engines.blend = 'chimera';
	this.client.engines.base = 'chimera';
}

ChimeraEditor.prototype.setModel = function(bd) {
	if ( ! match(bd, BlendDiagram)) {
		bd = new BlendDiagram(bd);
	}
	this.model = bd;
	BD = this.model;
};

ChimeraEditor.prototype.wireup = function() {
	var editor = this;	
	$('.UI-title').text('Chimera Blender');

	$('#BlendButton').click(function() {
		// Set the model
		var activeA = $('#ChimeraTheoryEditor-A div.active[data-animal]');
		var animalA = activeA.attr('data-animal');
		editor.model.input1 = '/animals/'+animalA;
		var activeB = $('#ChimeraTheoryEditor-B div.active[data-animal]');
		var animalB = activeB.attr('data-animal');
		editor.model.input2 = '/animals/'+animalB;
		// blend
		editor.client.blend(editor.model)
			.then(function(r){
				var bsrc = $('#ChimeraTheoryEditor-B div.active img').attr('src');
				var asrc = $('#ChimeraTheoryEditor-A div.active img').attr('src');
				toastr.info("Blended!");
				console.log(r.cargo);			
				$('.chimera-img .animal-head').css('background-image', "url('"+asrc+"')");	
				$('.chimera-img .animal-body').css('background-image', "url('"+bsrc+"')");	
			})
			.fail(function(e){
				toastr.warning(e);
			});
	});
}; /* ./wireup */
