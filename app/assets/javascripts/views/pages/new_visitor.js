//= require views/page
//= require templates/pages/new_visitor
//= require collections/visitor
MeetingLibs.View.Page.NewVisitor = MeetingLibs.View.Page.extend({
  className: 'view page new_visitor',
  templateName: 'pages/new_visitor',

  events: {
    'click .submit': 'createVisitor'
  },

  initialize: function(options) {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.eventId = options.eventId;

    this.model = new MeetingLibs.Collection.Visitor([], {eventId: this.eventId});
    this.listenTo(this.model, 'add', this.navigateToVisitors);
    this.render();
  },

  context: function() {
    return {
      eventId: this.eventId
    };
  },

  createVisitor: function(e) {
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

  navigateToVisitors: function() {
    this.remove();
    this.navigate('events/' + this.eventId + '/visitors');
  }
});
