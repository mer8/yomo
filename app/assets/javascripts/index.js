$(document).ready(function(){
  // Swipe left to show analytics card
  $(".card").swipe({
    swipeLeft:function() {
	  event.preventDefault();
      $.post('/sessions/anaInfo', {channelID:$(this).closest(".card").data("channel")}, function(){
        $.get('/sessions/anaInfo', function(data) {
			   console.log(data);
 		    });
      });
  	}
  });
  // Jquery to swipe left and show the email form
  $(".card").swipe({
    swipeLeft:function() {
      $(this).css("display", "none");
      $('#eml' + $(this).attr("id").substring(3,999)).css("display", "block");
    }
  });
  // Jquery to swipe right and get back to the card with analytics data
  $(".swiperight").swipe({
    swipeRight:function() {
      $(this).css("display", "none");
      $('#vid' + $(this).attr("id").substring(3,999)).css("display", "block"); 
    }
  });
  // Jquery that flips the card back to analytics data on send of email
  $(".send_button").on('click', function(){
    $('#vid' + $(this).attr("id").substring(4,999)).css("display", "block");
    $('#eml' + $(this).attr("id").substring(4,999)).css("display", "none")
  });
  // Jquery to implement search
  $('#searchBox').bind('keydown keypress keyup change', function() {
      var search = this.value;
      var $li= $(".card").hide();
      $li.filter(function() {
          return $(this).text().indexOf(search) >= 0;
      }).show();
  });

});


