MeetingLibs.Router = Backbone.Router.extend({
  routes: {
    '': 'events',
    'events/new': 'newEvent'
  },

  events: function() {
    new MeetingLibs.View.Page.Events();
  },

  newEvent: function() {
    new MeetingLibs.View.Page.NewEvent();
  }
});
