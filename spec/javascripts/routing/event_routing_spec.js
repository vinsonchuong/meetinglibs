describe('Event Routes', function() {
  beforeEach(function() {
    new MeetingLibs.Router();
  });

  describe('/', function() {
    beforeEach(function() {
      Backbone.history.loadUrl('');
    });

    it('should render the events page', function() {
      expect($('.page_content')).toHaveClass('events');
    });
  });

  describe('/events/new', function() {
    beforeEach(function() {
      Backbone.history.loadUrl('events/new');
    });

    it('should render the new events page', function() {
      expect($('.page_content')).toHaveClass('new_event');
    });
  });
});
