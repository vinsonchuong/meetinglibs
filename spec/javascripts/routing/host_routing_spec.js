describe('Host Routes', function() {
  beforeEach(function() {
    new MeetingLibs.Router();
  });

  describe('/events/1/hosts', function() {
    it('should pass the event id to the page', function() {
      spyOn(MeetingLibs.View.Page, 'Hosts');
      Backbone.history.loadUrl('events/1/hosts');
      expect(MeetingLibs.View.Page.Hosts).toHaveBeenCalledWith({eventId: '1'});
    });

    it('should render the hosts page', function() {
      Backbone.history.loadUrl('events/1/hosts');
      expect($('.page_content')).toHaveClass('hosts');
    });

    describe('when navigating to the new hosts page', function() {
      beforeEach(function() {
        Backbone.history.loadUrl('events/1/hosts');
        Backbone.history.loadUrl('events/1/hosts/new');
      });

      it('should remove the host page', function() {
        expect($('.page_content')).not.toHaveClass('hosts');
      });
    })
  });

  describe('/events/1/hosts/new', function() {
    it('should pass the event id to the page', function() {
      spyOn(MeetingLibs.View.Page, 'NewHost');
      Backbone.history.loadUrl('events/1/hosts/new');
      expect(MeetingLibs.View.Page.NewHost).toHaveBeenCalledWith({eventId: '1'});
    });

    it('should render the new host page', function() {
      Backbone.history.loadUrl('events/1/hosts/new');
      expect($('.page_content')).toHaveClass('new_host');
    });
  });

  describe('/events/1/hosts/1', function() {
    it('should pass the event id to the page', function() {
      spyOn(MeetingLibs.View.Page, 'EditHost');
      Backbone.history.loadUrl('events/1/hosts/2');
      expect(MeetingLibs.View.Page.EditHost).toHaveBeenCalledWith({eventId: '1', id: '2'});
    });

    it('should render the edit host page', function() {
      Backbone.history.loadUrl('events/1/hosts/2');
      expect($('.page_content')).toHaveClass('edit_host');
    });
  });
});
