//= require ../model
MeetingLibs.Model.Visitor = MeetingLibs.Model.extend({
  initialize: function(options) {
    this.urlRoot = '/events/' + options.event_id + '/visitors';
  }
});
