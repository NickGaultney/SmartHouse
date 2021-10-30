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
      document.getElementById('switch-' + data['id']).setAttribute("fill", getColor(data['state']));
    },
  },
);