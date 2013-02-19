//= require views/page
//= require templates/pages/events
//= require views/dialogs/confirmation
//= require collections/event
MeetingLibs.View.Page.Events = MeetingLibs.View.Page.extend({
  className: 'view page events',
  templateName: 'pages/events',

  events: {
    'click .actions .archive': 'archiveEvent',
    'click .actions .delete': 'deleteEvent'
  },

  initialize: function() {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.model = new MeetingLibs.Collection.Event();
    this.listenTo(this.model, 'reset change destroy', this.render);
    this.model.fetch();
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

  deleteEvent: function(e) {
    e.preventDefault();
    var eventId = this.$(e.currentTarget).parents('.event').data('id');
    var event = this.model.get(eventId);

    var dialog = new MeetingLibs.View.Dialog.Confirmation({
      message: 'You are deleting ' + event.get('name') + '. Survey answers,' +
               ' meeting schedules, and comments for this event will all be' +
               ' permanently deleted. Do you want to continue?',
      action: 'Delete Event'
    });
    this.listenTo(dialog, 'confirm', function() {
      this.stopListening(dialog, 'confirm');
      event.destroy({wait: true});
    });
  }
});
