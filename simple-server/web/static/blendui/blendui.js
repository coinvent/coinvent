
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
		$('#conceptEditorAmalCASL').html(templates.ConceptEditor({name:'inputamalcasl', previous:prev}));
		$('#conceptEditorAmalOWL').html(templates.ConceptEditor({name:'inputamalowl', previous:prev}));
		$('.outputLoading').hide();

		/*** WIRING **/

		$('.doBlend').on('click',function(e){
			e.preventDefault();
			var idx = $('#thelist').prop('selectedIndex');
			/*alert($('#thelist').prop('selectedIndex'));*/
			callBackend('hdtp',idx);
		});
		
		$('.doBlendNext').on('click',function(e){
			e.preventDefault();
			var idx = $('#thelist').prop('selectedIndex');
			/*alert($('#thelist').prop('selectedIndex'));*/
			callBackend('next',idx);
		});
		
		$('.doBlendClose').on('click',function(e){
			e.preventDefault();
			callBackend('close');
		});

		$('.doSave').on('click',function(e){
			e.preventDefault();
			callSave();
		});
	}); 

});

function comboInit(thelist)
{
  var idx = thelist.selectedIndex;
  var content = thelist.options[idx].innerHTML;
}

function combo(thelist, theinput)
{
  theinput = document.getElementById(theinput);  
  var idx = thelist.selectedIndex;
  var content = thelist.options[idx].innerHTML;
  if (idx==0)
  {
   $('#HDTPform').attr('style','display:inline-block');
   $('#AmalgamsCASLform').attr('style','display:none');
   $('#AmalgamsOWLform').attr('style','display:none');
  }
  else if (idx ==1)
  {
   $('#HDTPform').attr('style','display:none');
   $('#AmalgamsCASLform').attr('style','display:inline-block');
   $('#AmalgamsOWLform').attr('style','display:none');

  }
  else if (idx == 2)
  {
   $('#HDTPform').attr('style','display:none');
   $('#AmalgamsCASLform').attr('style','display:none');
   $('#AmalgamsOWLform').attr('style','display:inline-block');
  }
  else 
  {
   $('#HDTPform').attr('style','display:inline-block');
   $('#AmalgamsCASLform').attr('style','display:none');
   $('#AmalgamsOWLform').attr('style','display:none');
  }
}


function getInput(name) {
	var $tab = $('#ConceptEditor'+name+' .active');	
	return {name: $tab.find('.form-control[name=name]').val(), 
			text: $tab.find('textarea[name=text]').val(), 
			url: $tab.find('.form-control[name=url]').val()
			};
}

function callSave() {
    var blendname = $('input[name=blendname]').val();
    var blend = $('textarea[name=output]').val();
    $.ajax({
    	method:'POST',
	url: '/cmd/blend',
	data: {
		action:"save",
		blendname: blendname,
		blend: blend
		}
        })
	.then(function(a,b)
	{
		window.location.reload();
	});		
}


function callBackend(action,index) {
	if (index == 0)
	{
	var username = window.username;
	var input1 = getInput('input1');
	var input2 = getInput('input2');
	$('.doBlend').attr('disabled','disabled');
	$('.doBlendNext').attr('disabled','disabled');
	$('.outputLoading').show();
	var pid = $('input[name=pid]').val();
	$.ajax({
		method:'POST',
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
		$('.doBlend').attr('disabled',false);
		$('.doBlendNext').attr('disabled',false);
		var output = "" + a.cargo.input1.text +"\n\n"+ 
			a.cargo.input2.text +"\n\n"+ a.cargo.output;
		$('.outputLoading').hide();
		if (a.cargo.pid) {
		$('input[name=pid]').val(a.cargo.pid);
		}
		pid = $('input[name=pid]').val();
		$.ajax({
			method:'POST',
			url: '/cmd/HETS',
   			data: {
				action: 'full-theories',
				contents:output,
				pid: pid
				}
			})
			.then(function(c,d){
			console.warn(c,d);
			$('textarea[name=output]').removeClass('loading'); 
			$('textarea[name=output]').val(c.cargo.blend);	
			$('iframe[id=svg]').attr("src",c.cargo.svg);
			});
	});
	}
	else if (index == 1)
	{
		var input1 = getInput('inputamalcasl');
		var spname1 = $('input[name=acinput1]').val(); 
 		var spname2 = $('input[name=acinput2]').val(); 
		$('.doBlend').attr('disabled','disabled');
		$('.doBlendNext').attr('disabled','disabled');
		$('.outputLoading').show();
		var pid = $('input[name=pid]').val();
		if (action == 'next') 
		{request = 'next';} else {request = 'start';}
		$.ajax({
      		method: 'POST',
      		url: '/cmd/blend',
      		data: {action:"amalgamscasl",
      				request:request,
      				space_name1:spname1,
      				space_name2:spname2,
      				content:JSON.stringify(input1)}
      			})
		    .then(function(data,ef) {
             console.warn(data,ef);
		    $('textarea[name=output]').removeClass('loading'); 
			$('textarea[name=output]').val(data.cargo.blend);
  			$('textarea[name=pid]').val(data.cargo.id);
			});	
	}
	else if (index == 2)
	{
		var input1 = getInput('inputamalowl');
		var spname1 = $('input[name=aoinput1]').val(); 
 		var spname2 = $('input[name=aoinput2]').val(); 
		$('.doBlend').attr('disabled','disabled');
		$('.doBlendNext').attr('disabled','disabled');
		$('.outputLoading').show();
		var pid = $('input[name=pid]').val();
		if (action == 'next') 
		{request = 'next';} else {request = 'start';}
		$.ajax({
      		method: 'POST',
      		url: '/cmd/blend',
      		data: {action:"amalgamsowl",
      				request:request,
      				space_name1:spname1,
      				space_name2:spname2,
      				content:JSON.stringify(input1)}
      			})
		    .then(function(data,ef) {
             console.warn(data,ef);
		    $('textarea[name=output]').removeClass('loading'); 
			$('textarea[name=output]').val(data.cargo.blend);
  			$('textarea[name=pid]').val(data.cargo.id);
			});	
	}
	else
	{
	}	
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


