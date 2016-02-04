
/** Lets use a template to put some content into the page */
$(function() {

	var fConcepts = $.get('/cmd/blend?action=list-concepts');

	var fTemplates = loadTemplates('/static/blendui/blendui-templates.html');

	console.log("f", fConcepts, fTemplates);

	$.when(fConcepts, fTemplates)
		.then(function() {		
		
		$('#PickConceptsForm').removeClass('loading');
		/*** **/
		var prev = fConcepts.responseJSON.cargo;
		console.log("context=", {name:'input1', previous:prev});
		$('#conceptEditor1').html(templates.ConceptEditor({name:'input1', previous:prev}));
		$('#conceptEditor2').html(templates.ConceptEditor({name:'input2', previous:prev}));
		$('.outputLoading').hide();

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
	var $tab = $('#ConceptEditor'+name+' .active');	
	return {name: $tab.find('.form-control[name=name]').val(), 
			text: $tab.find('textarea[name=text]').val(), 
			url: $tab.find('.form-control[name=url]').val()
			};
}

function callBackend(action) {
	var username = window.username;
	var input1 = getInput('input1');
	var input2 = getInput('input2');
	$('.doBlend').attr('disabled','disabled');
	$('.doBlendNext').attr('disabled','disabled');
	$('.outputLoading').show();
	var pid = $('input[name=pid]').val();
	$.ajax({
		url: '/cmd/blend',
		data: {
			username:username,
			action:action,
			input1: JSON.stringify(input1),
			input2: JSON.stringify(input2),
			pid:pid
		}
	})
	.then(function(a,b){
		console.warn(a,b);
		var output = ""+a.cargo.output;
		$('textarea[name=output]').val(output);
		if (a.cargo.pid) {
			$('input[name=pid]').val(a.cargo.pid);
		}
		if ( ! output) {
			// Fail :(
			alert("Sadly this blend failed.");
		}
	})
	.fail(function(e){
		console.warn(e);
		alert("Sadly the server request failed.");
	})
	.always(function(){
		$('.doBlend').attr('disabled',false);
		$('.doBlendNext').attr('disabled',false);
		$('.doBlendclose').attr('disabled',false);		
		$('.outputLoading').hide();
		$('textarea[name=output]').removeClass('loading');
	});
} // ./callBackend()

/** Let's call the server */
$(function() {
	$('#ServerSays').text("Calling server...");

	/** $.get('/cmd/hdtp/hdtp.json?request=start')
	.then(function(a,b) {
		console.log('HelloData',a,b);
		$('#ServerSays').text(a.cargo.output); 
	});*/
});


