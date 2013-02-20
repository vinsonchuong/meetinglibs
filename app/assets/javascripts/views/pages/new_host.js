//= require views/page
//= require templates/pages/new_host
//= require collections/host
MeetingLibs.View.Page.NewHost = MeetingLibs.View.Page.extend({
  className: 'view page new_host',
  templateName: 'pages/new_host',

  events: {
    'click .submit': 'createHost'
  },

  initialize: function(options) {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.eventId = options.eventId;

    this.model = new MeetingLibs.Collection.Host([], {eventId: this.eventId});
    this.listenTo(this.model, 'add', this.navigateToHosts);
    this.render();
  },

  context: function() {
    return {
      eventId: this.eventId
    };
  },

  createHost: function(e) {
    e.preventDefault();
    var firstName = this.$('.first_name').val();
    var lastName = this.$('.last_name').val();
    var email = this.$('.email').val();
    if (!firstName || !lastName) {
      humane.log('Please fill in the first and last name fields.');
    } else if (!email) {
      humane.log('Please fill in the email field.');
    } else {
      this.model.create({
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
