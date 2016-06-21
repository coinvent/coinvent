
/** Lets use a template to put some content into the page */
$(function() {

	var fConcepts = $.get('/cmd/blend?action=list-concepts');

	var fTemplates = loadTemplates('/static/blendui/blendui-templates.html');

    var inputs = ["HDTP1", "HDTP2", "AMALCASL", "AMALOWL"];

	console.log("f", fConcepts, fTemplates);

	$.when(fConcepts, fTemplates)
		.then(function() {		
		
		$('#PickConceptsForm').removeClass('loading');
		/*** **/
		var prev = fConcepts.responseJSON.cargo;
		console.log("context=", {name:'input1', previous:prev});
		for (var k = 0;k<inputs.length;k++) {
		

		$('#conceptEditor'+inputs[k]).html(templates.ConceptEditor({name:'input'+inputs[k], previous:prev}));
		//$('#conceptEditorHDTP2').html(templates.ConceptEditor({name:'inputHDTP2', previous:prev}));


		/*Make modal an argument??? */
		//$('#conceptEditorAmalCASL').html(templates.ConceptEditor({name:'inputAMALCASL', previous:prev}));
		//$('#conceptEditorAmalOWL').html(templates.ConceptEditor({name:'inputAMALOWL', previous:prev}));
		}
		$('.outputLoading').hide();

		/*** WIRING **/

		$('.doBlend').on('click',function(e){
			e.preventDefault();
			var idx = $('#thelist').prop('selectedIndex');
			/*alert($('#thelist').prop('selectedIndex'));*/
			 if (idx==0)
			 {
				callBackend('hdtp',idx);
			}
			else if (idx == 1)
				{ callBackend('amalgamscasl',idx)}
			else if (idx==2)
				{ callBackend('amalgamsowl',idx)}
			else {}
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


		for (var j=0;j<inputs.length;j++)
		{
		var tab = $('#ConceptEditor'+'input'+inputs[j]+' .active');
        var tabmodal = tab.find('.modal[name=concepttext]');
        tabmodal.on('show.bs.modal', function (event) {
        	var modal = $(this);
        	var s = modal.prop('id').slice(11);
        	var select = $('#ConceptEditor'+s+' .active').find('.form-control[name=selectname]');
        	var i = select.prop('selectedIndex');
        	var title = prev[i];
        	modal.find('.modal-title').text(title);
        	$('#textarea'+s).val("Balloons");
    	});
    	}	

		// HACK TODO wire up to an onchange and a call to the backend
		//$('#textareainput1').val('TODO display the text for input1');
		//$('#textareainput2').val('TODO display the text for input2');
		
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
    var blend = $('textarea[name=blendtheory]').val();
    $.ajax({
    method: 'POST',
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
	var input1 = getInput('inputHDTP1');
	var input2 = getInput('inputHDTP2');
	$('.doBlend').attr('disabled','disabled');
	$('.doBlendNext').attr('disabled','disabled');
	$('.outputLoading').show();
	var pid = $('input[name=pid]').val();
	$.ajax({
		method: 'POST',
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
		if (a.cargo.output != "")
		{
		var output = "" + a.cargo.input1.text +"\n\n"+ 
			a.cargo.input2.text +"\n\n"+ a.cargo.output;
		$('.outputLoading').show();
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
			$('.outputLoading').hide();
			$('textarea[name=output]').removeClass('loading'); 
			$('textarea[name=output]').val(c.cargo.theory+"\n\n"+c.cargo.blend);	
			$('textarea[name=blendtheory]').val(c.cargo.blend);
			$('iframe[id=svg]').attr("src",c.cargo.svg);
			});
	} else {$('.outputLoading').hide();
			$('textarea[name=output]').removeClass('loading'); 
			$('textarea[name=output]').val("");	
			$('.doBlendNext').attr('disabled','disabled');
		}});
	}
	else if (index == 1)
	{
		var input1 = getInput('inputAMALCASL');
		var spname1 = $('input[name=acinput1]').val(); 
 		var spname2 = $('input[name=acinput2]').val(); 
		$('.doBlend').attr('disabled',false);
		$('.doBlendNext').attr('disabled',false);
		$('.outputLoading').show();
		var pid = $('input[name=pid]').val();
		
		$.ajax({
      		method: 'POST',
      		url: '/cmd/blend',
      		data: {action:action,
      				space_name1:spname1,
      				space_name2:spname2,
      				content:JSON.stringify(input1),
      				pid:pid}
      			})
		    .then(function(data,ef) {
             console.warn(data,ef);
            $('.outputLoading').hide();
		    $('textarea[name=output]').removeClass('loading'); 
			$('textarea[name=output]').val(data.cargo.blend);
  			if (data.cargo.pid) {
				$('input[name=pid]').val(data.cargo.pid);
			}
			});	
	}
	else if (index == 2)
	{  
		var input1 = getInput('inputAMALOWL');
		var spname1 = $('input[name=aoinput1]').val(); 
 		var spname2 = $('input[name=aoinput2]').val(); 
		$('.doBlend').attr('disabled',false);
		$('.doBlendNext').attr('disabled',false);
		$('.outputLoading').show();
		var pid = $('input[name=pid]').val();
		
		$.ajax({
      		method: 'POST',
      		url: '/cmd/blend',
      		data: {action:action,
      				space_name1:spname1,
      				space_name2:spname2,
      				content:JSON.stringify(input1),
      				pid:pid}
      			})
		    .then(function(data,ef) {
			console.warn(data,ef);
			  $('.outputLoading').hide();
		    $('textarea[name=output]').removeClass('loading'); 
			$('textarea[name=output]').val(data.cargo.theory);
			$('textarea[name=blendtheory]').val(data.cargo.blend);
  			if (data.cargo.pid) {
				$('input[name=pid]').val(data.cargo.pid);
			}
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

