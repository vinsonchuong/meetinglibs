//= require views/page
//= require templates/pages/event
//= require collections/event
MeetingLibs.View.Page.Event = MeetingLibs.View.Page.extend({
  className: 'view page event',
  templateName: 'pages/event',

  events: {
    'click .submit': 'onSubmit'
  },

  initialize: function(options) {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.id = options.id;

    this.eventCollection = new MeetingLibs.Collection.Event();
    this.listenTo(this.eventCollection, 'reset', this.onEventsFetched);
    this.eventCollection.fetch();
  },

  context: function() {
    return {
      title: this.title,
      participant: this.participant ? this.participant.toJSON() : {}
    };
  },

  onEventsFetched: function() {
    this.event = this.eventCollection.get(this.id);
    var hostId = this.event.get('host_id');
    var visitorId = this.event.get('visitor_id');
    if (!hostId && !visitorId) {
      this.title = 'Host Survey';
      this.participant = new MeetingLibs.Model.Host({event_id: this.id});
      this.render();
    } else {
      if (hostId) {
        this.title = 'Host Survey';
        this.participant = new MeetingLibs.Model.Host({event_id: this.id, id: hostId});
      } else {
        this.title = 'Visitor Survey';
        this.participant = new MeetingLibs.Model.Visitor({event_id: this.id, id: visitorId});
      }
      this.participant.fetch();
    }
    this.listenTo(this.participant, 'change', this.render);
  },

  onSubmit: function(e) {
    e.preventDefault();
    var firstName = this.$('.first_name').val();
    var lastName = this.$('.last_name').val();
    var email = this.$('.email').val();
    if (!firstName || !lastName || !email) {
      humane.log('Please provide your name and email address.');
    } else {
      this.stopListening(this.participant, 'change');
      this.listenTo(this.participant, 'change', this.navigateToEvents);
      this.participant.save({
        first_name: firstName,
        last_name: lastName,
        email: email
      }, {wait: true});
    }
  },

  navigateToEvents: function() {
    this.remove();
    this.navigate('');
  }
});
