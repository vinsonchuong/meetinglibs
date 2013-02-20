describe('MeetingLibs.Collection.Host', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.Collection.Host([], {eventId: '1'});
  });

  it('should have the correct url', function() {
    expect(subject.url).toEqual('/events/1/hosts')
  });
});
