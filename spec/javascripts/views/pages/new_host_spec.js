describe('MeetingLibs.View.Page.NewHost', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.NewHost({eventId: '1'});
  });

  afterEach(function() {
    subject.remove();
  });

  itShouldBehaveLike('a page', function() {
    return {
      subject: subject
    };
  });

  it('should have a cancel link', function() {
    expect(subject.$('a.cancel')).toHaveAttr('href', '/#events/1/hosts');
  });

  describe('when submitting the form with valid input', function() {
    beforeEach(function() {
      subject.$('.first_name').val('John');
      subject.$('.last_name').val('Doe');
      subject.$('.email').val('jdoe@example.com');
      subject.$('.cas_user').val('111');
      subject.$('.submit').click();
    });

    it('should create the host on the server', function() {
      expect({method: 'POST', url: '/events/1/hosts'}).toHaveBeenRequestedWith({
        first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com',
        cas_user: '111', token: ''
      });
    });

    describe('when the server responds', function() {
      beforeEach(function() {
        server.respondTo('POST', '/events/1/hosts', {
          id: 1,
          first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com',
          cas_user: '111', token: ''
        });
      });

      it('should navigate to the hosts page', function() {
        var pageContainer = $('.page_content');
        expect(pageContainer).toExist();
        expect(pageContainer).not.toHaveClass('new_host');
        expect(pageContainer).toHaveClass('hosts');
      });
    });
  });

  describe('when submitting the form with a blank first name or last name', function() {
    beforeEach(function() {
      subject.$('.first_name').val('');
      subject.$('.last_name').val('');
      subject.$('.email').val('jdoe@example.com');
      subject.$('.cas_user').val('111');
      subject.$('.submit').click();
    });

    it('should inform the user that the first name is required', function() {
      expect(humane.log).toHaveBeenCalledWith('Please fill in the first and last name fields.');
    });
  });

  describe('when submitting the form with a blank email', function() {
    beforeEach(function() {
      subject.$('.first_name').val('John');
      subject.$('.last_name').val('Doe');
      subject.$('.email').val('');
      subject.$('.cas_user').val('111');
      subject.$('.submit').click();
    });

    it('should inform the user that the email is required', function() {
      expect(humane.log).toHaveBeenCalledWith('Please fill in the email field.');
    });
  });
});
