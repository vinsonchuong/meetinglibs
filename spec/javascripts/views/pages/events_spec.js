describe('MeetingLibs.View.Page.Events', function() {
  var subject;
  beforeEach(function() {
    server.stubRequest('GET', '/events').andReturn([
      {name: 'Event 1'},
      {name: 'Event 2'},
      {name: 'Event 3'}
    ]);
    subject = new MeetingLibs.View.Page.Events();
  });

  afterEach(function() {
    subject.remove();
  });

  describe('when the Events model is fetched', function() {
    beforeEach(function() {
      server.respond();
    });

    it('should show a list of events', function() {
      expect(subject.$('.events_list .event:eq(0)')).toHaveText('Event 1');
      expect(subject.$('.events_list .event:eq(1)')).toHaveText('Event 2');
      expect(subject.$('.events_list .event:eq(2)')).toHaveText('Event 3');
    });
  });
});
