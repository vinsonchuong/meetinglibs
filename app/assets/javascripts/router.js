MeetingLibs.Router = Backbone.Router.extend({
  routes: {
    '': 'events',
    'events/new': 'newEvent',

    'events/:event_id/hosts': 'hosts',
    'events/:event_id/hosts/new': 'newHost',
    'events/:event_id/hosts/:id': 'editHost',

    'events/:event_id/visitors': 'visitors',
    'events/:event_id/visitors/new': 'newVisitor',
    'events/:event_id/visitors/:id': 'editVisitor'
  },

  events: function() {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.Events();
  },

  newEvent: function() {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.NewEvent();
  },

  hosts: function(eventId) {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.Hosts({eventId: eventId});
  },

  newHost: function(eventId) {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.NewHost({eventId: eventId});
  },

  editHost: function(eventId, id) {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.EditHost({eventId: eventId, id: id});
  },

  visitors: function(eventId) {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.Visitors({eventId: eventId});
  },

  newVisitor: function(eventId) {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.NewVisitor({eventId: eventId});
  },

  editVisitor: function(eventId, id) {
    if (this.page) {
      this.page.remove();
    }
    this.page = new MeetingLibs.View.Page.EditVisitor({eventId: eventId, id: id});
  }
});
