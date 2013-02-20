describe('MeetingLibs.Collection.Visitor', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.Collection.Visitor([], {eventId: '1'});
  });

  it('should have the correct url', function() {
    expect(subject.url).toEqual('/events/1/visitors')
  });
});
