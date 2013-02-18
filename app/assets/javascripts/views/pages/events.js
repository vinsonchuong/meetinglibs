//= require views/page
//= require templates/pages/events
//= require views/dialogs/confirmation
//= require collections/event
MeetingLibs.View.Page.Events = MeetingLibs.View.Page.extend({
  className: 'view page events',
  templateName: 'pages/events',

  events: {
    'click .actions .archive': 'archiveEvent'
  },

  initialize: function() {
    this.setElement(Backbone.$('.page_content'));

    this.model = new MeetingLibs.Collection.Event();
    this.listenTo(this.model, 'reset change', this.render);
    this.model.fetch();
  },

  setElement: function() {
    MeetingLibs.View.Page.prototype.setElement.apply(this, arguments);
    this.$elClone = this.$el.clone();
    this.$el.addClass(this.className);
  },

  render: function() {
    this.$el.html(JST['templates/' + this.templateName](this.context()));
    return this;
  },

  context: function() {
    return {
      events: this.model.toJSON()
    };
  },

  archiveEvent: function(e) {
    e.preventDefault();
    var eventId = this.$(e.currentTarget).parents('.event').data('id');
    var event = this.model.get(eventId);

    var dialog = new MeetingLibs.View.Dialog.Confirmation({
      message: 'You are archiving ' + event.get('name') + '. Once an event' +
               ' is archived, only administrators will be able to view it.' +
               ' Do you want to continue?',
      action: 'Archive Event'
    });
    this.listenTo(dialog, 'confirm', function() {
      this.stopListening(dialog, 'confirm');
      event.save({archived: true}, {wait: true});
    });
  },

  remove: function() {
    this.$el.replaceWith(this.$elClone);
    MeetingLibs.View.Page.prototype.remove.apply(this, arguments);
  }
});
