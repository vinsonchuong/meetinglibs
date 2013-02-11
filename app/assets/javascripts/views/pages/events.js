//= require ../page
MeetingLibs.View.Page.Events = MeetingLibs.View.Page.extend({
  initialize: function() {
    this.setElement($('body'));
    this.render();
  },

  render: function() {
    this.$el.html(this.template(this.context()));
    return this;
  }
});
