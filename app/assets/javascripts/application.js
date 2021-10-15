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

	$( ".bulb" ).draggable({
	    revert: 'invalid',
	    drag: function(event, ui) {

	    }
	});

	$( ".outfit" ).droppable({
		tolerance: "pointer",
	    accept: ".bulb",
	    drop: function(event, ui) {
	        if (!confirm("Are you sure?")) {
	            ui.draggable.css({
	            top: 0,
	            left: 0
	        	}); 
	    	} else {
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
	        };
	    }
	});
})


var wait;
window.onresize = function() {
	clearTimeout(wait);
	wait = setTimeout(function() {
		$( ".bulb" ).each(function( index ) {
			//$(this).css("left", parseInt($(this).attr('coords').split(",")[0]) / ($(".outfit").width() / 100) + "%");
			//$(this).css("top", parseInt($(this).attr('coords').split(",")[1]) / ($(".outfit").height() / 100) + "%");
			//$(this).attr("coords", $("#" + $(this).attr("class").split(/\s+/)[1]).attr('coords'));
		});
    }, 100);
};