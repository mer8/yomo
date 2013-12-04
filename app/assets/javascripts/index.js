$(document).ready(function(){
  // Swipe left to show analytics card
  $(".card").swipe({
    swipeLeft:function(event) {
  	    event.preventDefault();
        $.ajax('/sessions/anaInfo',{
          type: 'POST',
          data: {"channelID":$(this).closest(".card").data("channel")},
          context: this,
          success: function(data){
            console.log(data);

            $(this).css("display", "none");
            var anaId = $('#ana' + $(this).attr("id").substring(3,999))
            anaId.html("<h2> Total Views: <span class='totalViews'>"+data[2][0]+ "</span></h2>" +"<h2> Average View Duration: <span class='averageViewDuration'>"+data[2][1] + "</span></h2>" + "<h2> Average View %: <span class='averageViewPercentage'>"+data[2][2].toFixed(2) + "% </span></h2>"+ "<h2> Facebook: <span class='facebookViews'>"+data[0] + "</span></h2>"+"<h2> Twitter: <span class='twitterViews'>"+data[1] + "</span></h2>");
            $('#ana' + $(this).attr("id").substring(3,999)).css("display", "block"); 
          }
        });
      }

  });
  // Jquery to swipe left and show the email form
  $(".analytics").swipe({
    swipeLeft:function(event) {
        event.preventDefault();
        $(this).css("display", "none");
        $('#eml' + $(this).attr("id").substring(3,999) + " #message_body").html(
          "Just wanted to update you on "+ $('#vid' + $(this).attr("id").substring(3,999) + " .videoTitle").text() + "\n\nPlease see below for the most current stats on the video:\n\nTotal Views: " + $('#ana' + $(this).attr("id").substring(3,999) + ' .totalViews').text() +"\nAverage View Duration: "+$('#ana' + $(this).attr("id").substring(3,999) + ' .averageViewDuration').text() +"\nAverage View Percentage: "+$('#ana' + $(this).attr("id").substring(3,999) + ' .averageViewPercentage').text() +"\nTraffic from Facebook: "+$('#ana' + $(this).attr("id").substring(3,999) + ' .facebookViews').text() +"\nTraffic from Twitter: "+$('#ana' + $(this).attr("id").substring(3,999) + ' .twitterViews').text()
          )
        $('#eml' + $(this).attr("id").substring(3,999)).css("display", "block");
    },
    // Jquery to swipe right from the analytics card and get back to the cover card
    swipeRight:function() {
        console.log("Entered into: Jquery to swipe right from the analytics card and get back to the cover card")
        $(this).css("display", "none");
        $('#vid' + $(this).attr("id").substring(3,999)).css("display", "block"); 
    }
  });
  // Jquery to swipe right from the email form to cover card
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

