//= require views/page
//= require templates/pages/visitors
//= require views/dialogs/confirmation
//= require collections/visitor
MeetingLibs.View.Page.Visitors = MeetingLibs.View.Page.extend({
  className: 'view page visitors',
  templateName: 'pages/visitors',

  events: {
    'click .actions .delete': 'deleteVisitor'
  },

  initialize: function(options) {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.eventId = options.eventId;

    this.model = new MeetingLibs.Collection.Visitor([], {eventId: this.eventId});
    this.listenTo(this.model, 'reset change destroy', this.render);
    this.model.fetch();
  },

  context: function() {
    return {
      visitors: this.model.toJSON(),
      eventId: this.eventId
    };
  },

  deleteVisitor: function(e) {
    e.preventDefault();
    var id = this.$(e.currentTarget).parents('.visitor').data('id');
    var visitor = this.model.get(id);

    var dialog = new MeetingLibs.View.Dialog.Confirmation({
      message: 'You are removing ' + visitor.get('first_name') + ' ' + visitor.get('last_name') +
               ' from this event. Survey answers and scheduled meetings for' +
               ' this visitor will all be permanently deleted. Do you want to' +
               ' continue?',
      action: 'Remove Visitor'
    });
    this.listenTo(dialog, 'confirm', function() {
      this.stopListening(dialog, 'confirm');
      visitor.destroy({wait: true});
    });
  }
});
