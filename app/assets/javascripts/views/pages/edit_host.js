//= require views/page
//= require templates/pages/edit_host
//= require collections/host
MeetingLibs.View.Page.EditHost = MeetingLibs.View.Page.extend({
  className: 'view page edit_host',
  templateName: 'pages/edit_host',

  events: {
    'click .submit': 'updateHost'
  },

  initialize: function(options) {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.eventId = options.eventId;
    this.id = options.id;

    this.model = new MeetingLibs.Collection.Host([], {eventId: this.eventId});
    this.listenTo(this.model, 'reset', this.render);
    this.listenTo(this.model, 'change', this.navigateToHosts);
    this.model.fetch();
  },

  context: function() {
    return {
      host: this.model.get(this.id).toJSON(),
      eventId: this.eventId
    };
  },

  updateHost: function(e) {
    e.preventDefault();
    var firstName = this.$('.first_name').val();
    var lastName = this.$('.last_name').val();
    var email = this.$('.email').val();
    if (!firstName || !lastName) {
      humane.log('Please fill in the first and last name fields.');
    } else if (!email) {
      humane.log('Please fill in the email field.');
    } else {
      this.model.get(this.id).save({
        first_name: firstName,
        last_name: lastName,
        email: email,
        cas_user: this.$('.cas_user').val(),
        token: this.$('.token').val()
      }, {wait: true});
    }
  },

  navigateToHosts: function() {
    this.remove();
    this.navigate('events/' + this.eventId + '/hosts');
  }
});
