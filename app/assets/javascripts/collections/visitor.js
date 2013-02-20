MeetingLibs.Collection.Visitor = MeetingLibs.Collection.extend({
  initialize: function(models, options) {
    this.url = '/events/' + options.eventId + '/visitors';
  }
});
