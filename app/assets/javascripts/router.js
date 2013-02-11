MeetingLibs.Router = Backbone.Router.extend({
  routes: {
    '': 'events'
  },

  events: function() {
    new MeetingLibs.View.Page.Events();
  }
});
