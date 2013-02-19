//= require views/page
//= require templates/pages/new_event
//= require collections/event
MeetingLibs.View.Page.NewEvent = MeetingLibs.View.Page.extend({
  className: 'view page new_event',
  templateName: 'pages/new_event',

  events: {
    'click .submit': 'createEvent'
  },

  initialize: function() {
    MeetingLibs.View.Page.prototype.initialize.apply(this, arguments);
    this.model = new MeetingLibs.Collection.Event();
    this.listenTo(this.model, 'add', this.navigateToEvents);
    this.render();
  },

  createEvent: function(e) {
    e.preventDefault();
    var name = this.$('.name').val();
    if (name) {
      this.model.create({name: this.$('.name').val(), archived: false}, {wait: true});
    } else {
      humane.log('Please fill in the name field.');
    }
  },

  navigateToEvents: function() {
    this.remove();
    this.navigate('');
  }
});
