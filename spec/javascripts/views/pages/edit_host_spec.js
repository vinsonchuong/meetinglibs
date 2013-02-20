describe('MeetingLibs.View.Page.EditHost', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.EditHost({eventId: '1', id: '1'});
  });

  afterEach(function() {
    subject.remove();
  });

  itShouldBehaveLike('a page', function() {
    return {
      subject: subject
    };
  });

  it('should fetch the hosts from the server', function() {
    expect({method: 'GET', url: '/events/1/hosts'}).toHaveBeenRequested();
  });

  describe('when the server responds', function() {
    beforeEach(function() {
      server.respondTo('GET', '/events/1/hosts', [
        {id: 1, first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com', token: '111'},
        {id: 2, first_name: 'Jane', last_name: 'Doe', email: 'janedoe@example.com', token: '222'},
      ]);
    });

    it('should have a cancel link', function() {
      expect(subject.$('a.cancel')).toHaveAttr('href', '/#events/1/hosts');
    });

    it('should populate the fields with the current values', function() {
      expect(subject.$('.first_name').val()).toEqual('John');
      expect(subject.$('.last_name').val()).toEqual('Doe');
      expect(subject.$('.email').val()).toEqual('johndoe@example.com');
      expect(subject.$('.cas_user').val()).toEqual('');
      expect(subject.$('.token').val()).toEqual('111');
    });

    describe('when submitting the form with valid input', function() {
      beforeEach(function() {
        subject.$('.email').val('new@example.com');
        subject.$('.submit').click();
      });

      it('should update the host on the server', function() {
        expect({method: 'PUT', url: '/events/1/hosts/1'}).toHaveBeenRequestedWith({
          id: 1,
          first_name: 'John', last_name: 'Doe', email: 'new@example.com',
          cas_user: '', token: '111'
        });
      });

      describe('when the server responds', function() {
        beforeEach(function() {
          server.respondTo('PUT', '/events/1/hosts/1');
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
