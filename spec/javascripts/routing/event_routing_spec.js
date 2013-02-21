describe('Event Routes', function() {
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

  describe('/events/1', function() {
    beforeEach(function() {
      Backbone.history.loadUrl('events/1');
    });

    it('should render the event page', function() {
      expect($('.page_content')).toHaveClass('event');
    });
  });
});
