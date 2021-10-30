App.Inputs = App.cable.subscriptions.create(
  'InputsChannel',
  {
    received: function(data) {
      document.getElementById('input-' + data['id']).innerHTML = '<div class="alert alert-warning" role="alert">This is a warning alert—check it out!</div>';
      setTimeout(function(){ document.getElementById('input-' + data['id']).innerHTML = ""; }, 3000);
    },
  },
);