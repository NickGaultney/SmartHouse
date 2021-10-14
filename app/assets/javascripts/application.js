// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require jquery.rwdImageMaps
//= require_tree .

$(document).on('turbolinks:load', function() {
	$('img[usemap]').rwdImageMaps();

	$( ".outfit" ).droppable({
		tolerance: "pointer",
	    accept: ".bulb",
	    drop: function(event, ui) {
    		var left = (ui.draggable.css("left").slice(0, -2) / ($(".outfit").width() / 100)) + "%";
    		var top = (ui.draggable.css("top").slice(0, -2) / ($(".outfit").height() / 100)) + "%";
    		ui.draggable.css("left", left);
    		ui.draggable.css("top", top);

        	$.ajax({
			  url: "/buttons/" + ui.draggable.attr("data-id"),
			  type: "put",
			  data: {
			  	authenticity_token: $('[name="csrf-token"]')[0].content,
			  	button: {
			  		coordinates: left + "," + top
			  	}
			  },
			  success: function(data) {},
			  error: function(data) {}
			})
	    }
	});
})

function getEditButton() {
	return document.getElementById("edit-mode");
}

function toggleEditMode() {
	var button = getEditButton();

	if (button.getAttribute("state") === "false") {
		button.setAttribute("state", "true");
		enableDraggable(".bulb");
	} else {
		button.setAttribute("state", "false");
		disableDraggable(".bulb");
	}
}

function enableDraggable(e) {
	$(e).draggable({
		containment: '.outfit',
	    revert: 'invalid',
	    drag: function(event, ui) {
	    }
	});

	$(e).draggable('enable');

	var button = getEditButton();
	button.classList.remove('btn-success');
	button.classList.add('btn-warning');
	button.innerHTML = "Disable Edit Mode";
}

function disableDraggable(e) {
	$(e).draggable('disable');

	var button = getEditButton();
	button.classList.remove('btn-warning');
	button.classList.add('btn-success');
	button.innerHTML = "Enable Edit Mode";
}