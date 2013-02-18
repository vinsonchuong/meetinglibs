describe('MeetingLibs.View.Dialog.Confirmation', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Dialog.Confirmation({
      message: 'Do you want to continue?',
      action: 'Continue'
    });
    listener.listenTo(subject);
  });

  afterEach(function() {
    subject.remove();
  });

  it('should render to its container', function() {
    expect(subject.$el).toBe('body .dialog_content');
  });

  it('should add its class names to its container', function() {
    expect(subject.$el).toHaveClass('view');
    expect(subject.$el).toHaveClass('dialog');
    expect(subject.$el).toHaveClass('confirmation');
  });

  describe('#remove', function() {
    beforeEach(function() {
      subject.remove();
    });

    it('should remove itself from the DOM', function() {
      expect(subject.$el).not.toExist();
    });

    it('should leave its container intact', function() {
      var pageContent = $('body .dialog_content');
      expect(pageContent).toExist();
      expect(pageContent).not.toHaveClass('confirmation');
      expect(pageContent).toBeEmpty();
    });
  });

  it('should display a title', function() {
    expect(subject.$('.title')).toHaveText('Confirmation');
  });

  it('should display the message', function() {
    expect(subject.$('.message')).toHaveText('Do you want to continue?');
  });

  describe('when confirming', function() {
    beforeEach(function() {
      subject.$(':contains("Continue")').click();
    });

    it('should trigger a "confirm" event', function() {
      expect(subject).toHaveTriggered('confirm');
    });

    it('should remove itself', function() {
      expect($('.dialog_content')).toBeEmpty();
    });
  });

  describe('when cancelling', function() {
    beforeEach(function() {
      subject.$(':contains("Cancel")').click();
    });

    it('should trigger a "cancel" event', function() {
      expect(subject).toHaveTriggered('cancel');
    });

    it('should remove itself', function() {
      expect($('.dialog_content')).toBeEmpty();
    });
  });
});
