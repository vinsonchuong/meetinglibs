describe('MeetingLibs.View.Page.EditVisitor', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.EditVisitor({eventId: '1', id: '1'});
  });

  afterEach(function() {
    subject.remove();
  });

  itShouldBehaveLike('a page', function() {
    return {
      subject: subject
    };
  });

  it('should fetch the visitors from the server', function() {
    expect({method: 'GET', url: '/events/1/visitors'}).toHaveBeenRequested();
  });

  describe('when the server responds', function() {
    beforeEach(function() {
      server.respondTo('GET', '/events/1/visitors', [
        {id: 1, first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com', cas_user: '111'},
        {id: 2, first_name: 'Jane', last_name: 'Doe', email: 'janedoe@example.com', cas_user: '222'},
      ]);
    });

    it('should have a cancel link', function() {
      expect(subject.$('a.cancel')).toHaveAttr('href', '/#events/1/visitors');
    });

    it('should populate the fields with the current values', function() {
      expect(subject.$('.first_name').val()).toEqual('John');
      expect(subject.$('.last_name').val()).toEqual('Doe');
      expect(subject.$('.email').val()).toEqual('johndoe@example.com');
      expect(subject.$('.cas_user').val()).toEqual('111');
      expect(subject.$('.token').val()).toEqual('');
    });

    describe('when submitting the form with valid input', function() {
      beforeEach(function() {
        subject.$('.email').val('new@example.com');
        subject.$('.submit').click();
      });

      it('should update the visitor on the server', function() {
        expect({method: 'PUT', url: '/events/1/visitors/1'}).toHaveBeenRequestedWith({
          id: 1,
          first_name: 'John', last_name: 'Doe', email: 'new@example.com',
          cas_user: '111', token: ''
        });
      });

      describe('when the server responds', function() {
        beforeEach(function() {
          server.respondTo('PUT', '/events/1/visitors/1');
        });

        it('should navigate to the visitors page', function() {
          var pageContainer = $('.page_content');
          expect(pageContainer).toExist();
          expect(pageContainer).not.toHaveClass('new_visitor');
          expect(pageContainer).toHaveClass('visitors');
        });
      });
    });

    describe('when submitting the form with a blank first name or last name', function() {
      beforeEach(function() {
        subject.$('.first_name').val('');
        subject.$('.last_name').val('');
        subject.$('.submit').click();
      });

      it('should inform the user that the first name is required', function() {
        expect(humane.log).toHaveBeenCalledWith('Please fill in the first and last name fields.');
      });
    });

    describe('when submitting the form with a blank email', function() {
      beforeEach(function() {
        subject.$('.email').val('');
        subject.$('.submit').click();
      });

      it('should inform the user that the email is required', function() {
        expect(humane.log).toHaveBeenCalledWith('Please fill in the email field.');
      });
    });
  });
});
