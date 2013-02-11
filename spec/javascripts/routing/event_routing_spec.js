describe('Event Routes', function() {
  beforeEach(function() {
    new MeetingLibs.Router();
  });

  describe('/', function() {
    beforeEach(function() {
      spyOn(MeetingLibs.View.Page, 'Events');
      Backbone.history.loadUrl('');
    });

    it('should render the events page', function() {
      expect(MeetingLibs.View.Page.Events).toHaveBeenCalled();
    });
  });
});
