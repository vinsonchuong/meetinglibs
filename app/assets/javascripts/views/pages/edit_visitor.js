//= require views/page
//= require templates/pages/edit_visitor
//= require collections/visitor
MeetingLibs.View.Page.EditVisitor = MeetingLibs.View.Page.extend({
  className: 'view page edit_visitor',
  templateName: 'pages/edit_visitor',

  events: {
    'click .submit': 'updateVisitor'
  },

  initialize: function(options) {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);

    this.eventId = options.eventId;
    this.id = options.id;

    this.model = new MeetingLibs.Collection.Visitor([], {eventId: this.eventId});
    this.listenTo(this.model, 'reset', this.render);
    this.listenTo(this.model, 'change', this.navigateToVisitors);
    this.model.fetch();
  },

  context: function() {
    return {
      visitor: this.model.get(this.id).toJSON(),
      eventId: this.eventId
    };
  },

  updateVisitor: function(e) {
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

  navigateToVisitors: function() {
    this.remove();
    this.navigate('events/' + this.eventId + '/visitors');
  }
});
