$(document).ready(function() {
  $('.new_comment_button').on("click", function(){
    $(this).hide();
    var commentForm = $(this).siblings('form');
    commentForm.show();
  });

  $(".new_comment_form").on("submit", function(event) {
    
    event.preventDefault();

    var form = $(this);
    var url = form.attr("action");
    var method = form.attr("method");
    var data = form.serialize();

    if (form.find('comment_text').html === ""){
      // $('#comment_text').before('<span class="error">Please either
      //   make a comment, or do not click the button</span>');
      return false
    }
    else {

      var request = $.ajax({url: url, method: method, data: data});

      request.done(function(comment) {
        console.log(comment);
        console.log(comment.body);

        var new_comment = `<p>${comment.body}</p>
                <hr>`;

        $(".comment-list").append(new_comment);
        $(".comment-form").hide();
        $('.new_comment_button').show();
      })
    };
  });
})
