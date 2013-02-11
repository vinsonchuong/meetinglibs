//= require jquery
//= require jquery_ujs
//= require backbone-rails
//= require_self
//= require_tree .

MeetingLibs = {
  initialize: function() {
    new MeetingLibs.Router();
    Backbone.history.start();
  }
};
