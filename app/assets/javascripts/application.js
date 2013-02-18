//= require jquery
//= require jquery_ujs
//= require backbone-rails
//= require_self
//= require_tree .

function MeetingLibs(options) {
  _.extend(this, options);
  new MeetingLibs.Router();
  Backbone.history.start();
}
