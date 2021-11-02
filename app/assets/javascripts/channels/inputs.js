App.Inputs = App.cable.subscriptions.create(
  'InputsChannel',
  {
    received: function(data) {
      console.log("test");
      //document.getElementById('input-alert').innerHTML = "<div class='alert alert-warning' role='alert'>This is a warning alert—check it out!</div>";
      //setTimeout(function(){ document.getElementById('input-alert').innerHTML = ""; }, 5000);
    },
  },
);