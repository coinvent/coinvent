
/** Lets use a template to put some content into the page */
$(function() {

	loadTemplates('/static/blendui/blendui-templates.html', function(){		
		
		/*** **/

		$('#conceptEditor1').html(templates.ConceptEditor({name:'input1'}));
		$('#conceptEditor2').html(templates.ConceptEditor({name:'input2'}));


		/*** WIRING **/

		$('.doBlend').on('click',function(e){
			e.preventDefault();
			alert("Do Blend!");
		});
		$('.doBlendNext').on('click',function(e){
			e.preventDefault();
			alert("Do Next Blend!");
		});
		$('.doBlendClose').on('click',function(e){
			e.preventDefault();
			
		});
		
	}); 

});

/** Let's call the server */
$(function() {
	$('#ServerSays').text("Calling server...");

	/** $.get('/cmd/hdtp/hdtp.json?request=start')
	.then(function(a,b) {
		console.log('HelloData',a,b);
		$('#ServerSays').text(a.cargo.output); 
	});*/
});


