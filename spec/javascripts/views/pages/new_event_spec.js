describe('MeetingLibs.View.Page.NewEvent', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.NewEvent();
  });

  afterEach(function() {
    subject.remove();
  });

  itShouldBehaveLike('a page', function() {
    return {
      subject: subject
    };
  });

  describe('when submitting the form', function() {
    beforeEach(function() {
      subject.$('.name').val('New Event');
      subject.$('.submit').click();
    });

    it('should create the event on the server', function() {
      expect({method: 'POST', url: '/events'}).toHaveBeenRequestedWith({name: 'New Event', archived: false});
    });

    describe('when the server responds', function() {
      beforeEach(function() {
        server.respondTo('POST', '/events', {id: 1, name: 'New Event', archived: false});
      });

      it('should navigate to the events page', function() {
        var pageContainer = $('.page_content');
        expect(pageContainer).toExist();
        expect(pageContainer).not.toHaveClass('new_event');
        expect(pageContainer).toHaveClass('events');
      });
    });
  });

  it('should have a cancel link', function() {
    expect(subject.$('a.cancel')).toHaveAttr('href', '/#');
  });
});
