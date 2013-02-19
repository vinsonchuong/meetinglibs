sharedExamples['a page'] = function(context) {
  var subject;
  beforeEach(function() {
    subject = context().subject;
  })

  it('should render to its container', function() {
    expect(subject.$el).toBe('body .page_content');
  });

  it('should add its class names to its container', function() {
    _.each(subject.className.split(' '), function(name) {
      expect(subject.$el).toHaveClass(name)
    });
  });

  describe('#remove', function() {
    beforeEach(function() {
      subject.remove();
    });

    it('should remove itself from the DOM', function() {
      expect(subject.$el).not.toExist();
    });

    it('should leave its container intact', function() {
      var pageContent = $('body .page_content');
      expect(pageContent).toExist();
      _.each(subject.className.split(' '), function(name) {
        expect(pageContent).not.toHaveClass(name)
      });
      expect(pageContent).toBeEmpty();
    });
  });
};
