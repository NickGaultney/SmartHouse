function getColor(state) {
  if (state) {
    return "#FFA500";
  } else {
    return "#000000";
  }
}

App.Buttons = App.cable.subscriptions.create(
  'ButtonsChannel',
  {
    received: function(data) {
      document.getElementById('button-' + data['id']).setAttribute("fill", getColor(data['state']));
      //document.getElementById('input-alert').innerHTML = "<div class='alert alert-warning' role='alert'>This is a warning alert—check it out!</div>";
      //setTimeout(function(){ document.getElementById('input-alert').innerHTML = ""; }, 5000);
    },
  },
);