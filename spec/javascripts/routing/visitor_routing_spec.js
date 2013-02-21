describe('Visitor Routes', function() {
  describe('/events/1/visitors', function() {
    it('should pass the event id to the page', function() {
      spyOn(MeetingLibs.View.Page, 'Visitors');
      Backbone.history.loadUrl('events/1/visitors');
      expect(MeetingLibs.View.Page.Visitors).toHaveBeenCalledWith({eventId: '1'});
    });

    it('should render the visitors page', function() {
      Backbone.history.loadUrl('events/1/visitors');
      expect($('.page_content')).toHaveClass('visitors');
    });
  });

  describe('/events/1/visitors/new', function() {
    it('should pass the event id to the page', function() {
      spyOn(MeetingLibs.View.Page, 'NewVisitor');
      Backbone.history.loadUrl('events/1/visitors/new');
      expect(MeetingLibs.View.Page.NewVisitor).toHaveBeenCalledWith({eventId: '1'});
    });

    it('should render the new visitor page', function() {
      Backbone.history.loadUrl('events/1/visitors/new');
      expect($('.page_content')).toHaveClass('new_visitor');
    });
  });

  describe('/events/1/visitors/1', function() {
    it('should pass the event id to the page', function() {
      spyOn(MeetingLibs.View.Page, 'EditVisitor');
      Backbone.history.loadUrl('events/1/visitors/2');
      expect(MeetingLibs.View.Page.EditVisitor).toHaveBeenCalledWith({eventId: '1', id: '2'});
    });

    it('should render the edit visitor page', function() {
      Backbone.history.loadUrl('events/1/visitors/2');
      expect($('.page_content')).toHaveClass('edit_visitor');
    });
  });
});
