//= require jquery
//= require jquery_ujs
//= require backbone-rails
//= require_self
//= require_tree .

function MeetingLibs(options) {
  _.extend(this, options);
  router = new MeetingLibs.Router();
  Backbone.history.start();
}
