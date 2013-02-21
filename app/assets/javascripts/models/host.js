//= require ../model
MeetingLibs.Model.Host = MeetingLibs.Model.extend({
  initialize: function(options) {
    this.urlRoot = '/events/' + options.event_id + '/hosts';
  }
});
