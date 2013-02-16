//= require views/page
//= require templates/pages/events
MeetingLibs.View.Page.Events = MeetingLibs.View.Page.extend({
  className: 'view page events',
  templateName: 'pages/events',
  container: '.page_content',

  initialize: function() {
    this.model = new MeetingLibs.Collection.Event();
    this.listenTo(this.model, 'reset change', this.render);
    this.model.fetch();
  },

  render: function() {
    this.setElement($(this.container));
    this.$el.html(JST['templates/' + this.templateName](this.context()));
    return this;
  },

  context: function() {
    return {
      events: this.model.toJSON()
    };
  }
});
