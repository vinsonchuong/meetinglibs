describe('MeetingLibs.Model.Host', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.Model.Host({event_id: '1', id: '2'});
  });

  it('should have the correct urlRoot', function() {
    expect(subject.urlRoot).toEqual('/events/1/hosts');
  });

  it('should have the correct initial attributes', function() {
    expect(subject.get('event_id')).toEqual('1');
    expect(subject.get('id')).toEqual('2');
  });
});
