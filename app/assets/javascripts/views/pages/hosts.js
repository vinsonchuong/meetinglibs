//= require views/page
//= require templates/pages/hosts
//= require views/dialogs/confirmation
//= require collections/host
MeetingLibs.View.Page.Hosts = MeetingLibs.View.Page.extend({
  className: 'view page hosts',
  templateName: 'pages/hosts',

  events: {
    'click .actions .delete': 'deleteHost'
  },

  initialize: function(options) {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.eventId = options.eventId;

    this.model = new MeetingLibs.Collection.Host([], {eventId: this.eventId});
    this.listenTo(this.model, 'reset change destroy', this.render);
    this.model.fetch();
  },

  context: function() {
    return {
      hosts: this.model.toJSON(),
      eventId: this.eventId
    };
  },

  deleteHost: function(e) {
    e.preventDefault();
    var id = this.$(e.currentTarget).parents('.host').data('id');
    var host = this.model.get(id);

    var dialog = new MeetingLibs.View.Dialog.Confirmation({
      message: 'You are removing ' + host.get('first_name') + ' ' + host.get('last_name') +
               ' from this event. Survey answers and scheduled meetings for' +
               ' this host will all be permanently deleted. Do you want to' +
               ' continue?',
      action: 'Remove Host'
    });
    this.listenTo(dialog, 'confirm', function() {
      this.stopListening(dialog, 'confirm');
      host.destroy({wait: true});
    });
  }
});
