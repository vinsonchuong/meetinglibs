MeetingLibs.Collection.Host = MeetingLibs.Collection.extend({
  initialize: function(models, options) {
    this.url = '/events/' + options.eventId + '/hosts';
  },
});
