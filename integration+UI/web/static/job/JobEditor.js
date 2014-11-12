

function JobEditor() {
	this.client = new CoinventClient();
}


JobEditor.prototype.wireup = function() {
	var editor = this;	
	$('.UI-title').text('Job Manager');

	$('input[name=uname]').change(function() {
		var name = $(this).val();
		$("div.JobList").html("Loading Job-List for "+name+"...");
		editor.actorName = name;
		editor.client.job_list(name)
			.then(function(r){				
				editor.jobs = r.cargo.jobs;
				console.log("editor.jobs", editor.jobs);
				$("div.JobList").html(templates.JobListList(editor.jobs));
			})
			.fail(function(e) {
				console.log(e);
				toastr.error(JSON.stringify(e));
			});
	});

	$('body').on('click', '.OneJobListing a', function() {
		var id = $(this).attr('data-id');
		editor.client.job_details(editor.actorName, id)
			.then(function(r){
				editor.activeJob = r.cargo.job;
				console.log("activeJob", editor.activeJob);
				$("#OneJobEditorWrapper").html(templates.OneJobEditor(editor.activeJob));
			})
			.fail(function(e){
				toastr.error(JSON.stringify(e));
			});
		return false;
	});

	$('body').on('click', 'button.SaveJob', function() {
		var id = $('.OneJobEditor input[name=id]').val();
		var result = $('.OneJobEditor textarea#input-result').val();
		console.log(id, result, this);
		editor.client.job_put(editor.actorName, id, result)
			.then(function(r){
				toastr.info("Saved "+id);
			})
			.fail(function(e){
				toastr.error(JSON.stringify(e));
			});
		return false;
	});
}; /* ./wireup */
