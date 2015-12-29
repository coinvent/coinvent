
/** Lets use a template to put some content into the page */
$(function() {

	loadTemplates('/static/blendui/blendui-templates.html', function(){		
		
		/*** **/

		$('#conceptEditor1').html(templates.ConceptEditor({name:'input1'}));
		$('#conceptEditor2').html(templates.ConceptEditor({name:'input2'}));


		/*** WIRING **/

		$('.doBlend').on('click',function(e){
			e.preventDefault();
			callBackend('hdtp');
		});
		
		$('.doBlendNext').on('click',function(e){
			e.preventDefault();
			callBackend('next');
		});
		
		$('.doBlendClose').on('click',function(e){
			e.preventDefault();
			callBackend('close');
		});
		
	}); 

});

function getInput(name) {
	return "TODO "+name;
}

function callBackend(action) {
	var input1 = getInput('input1');
	var input2 = getInput('input1');
	var pid = $('input[name=pid]').val();
	$.ajax({
		url: '/cmd/blend',
		data: {
			action:action,
			input1:input1,
			input2:input2,
			pid:pid
		}
	})
	.then(function(a,b){
		console.warn(a,b);
	});
}

/** Let's call the server */
$(function() {
	$('#ServerSays').text("Calling server...");

	/** $.get('/cmd/hdtp/hdtp.json?request=start')
	.then(function(a,b) {
		console.log('HelloData',a,b);
		$('#ServerSays').text(a.cargo.output); 
	});*/
});


