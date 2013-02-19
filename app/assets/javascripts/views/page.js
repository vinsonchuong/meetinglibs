//= require ../view
MeetingLibs.View.Page = MeetingLibs.View.extend({
  className: 'view page',

  initialize: function() {
    this.setElement(Backbone.$('.page_content'));
  },

  setElement: function() {
    MeetingLibs.View.prototype.setElement.apply(this, arguments);
    this.$elClone = this.$el.clone();
    this.$el.addClass(this.className);
  },

  render: function() {
    this.$el.html(JST['templates/' + this.templateName](this.context()));
    return this;
  },

  context: function() {
    return {};
  },

  remove: function() {
    this.$el.replaceWith(this.$elClone);
    MeetingLibs.View.prototype.remove.apply(this, arguments);
  }
});
