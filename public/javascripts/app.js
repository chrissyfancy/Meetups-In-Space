$('#event_form').on("submit", function(event) {
  event.preventDefault();

  var newMeetup = $('#event_name').val();
  var newLocation = $('#location').val();
  var newDescription = $('#description').val();

  if(newMeetup === "" || newDescription === "" || newLocation === ""){
    alert("Please fill out all required fields.");
  } else {
    var request = $.ajax({
      method: "POST",
      data: {
      event_name: newMeetup,
      location: newLocation,
      description: newDescription
    },
    url: "/meetups/new"
  });

  request.done(function(responseData) {
    alert("Form Successfully Submitted!");
    console.log(responseData);
    });
  }
});
