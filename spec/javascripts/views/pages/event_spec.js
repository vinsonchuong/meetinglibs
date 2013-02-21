describe('MeetingLibs.View.Page.Event', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.Event({id: '1'});
  });

  afterEach(function() {
    subject.remove();
  });

  itShouldBehaveLike('a page', function() {
    return {
      subject: subject
    };
  });

  it('should fetch the events from the server', function() {
    expect({method: 'GET', url: '/events'}).toHaveBeenRequested();
  });

  describe('when the server responds that the user is not yet a participant', function() {
    beforeEach(function() {
      server.respondTo('GET', '/events', [
        {id: 1, name: 'Event 1', archived: false, host_id: null, visitor_id: null},
        {id: 2, name: 'Event 2', archived: true},
        {id: 3, name: 'Event 3', archived: false}
      ]);
    });

    it('should have title "Host Survey"', function() {
      expect(subject.$('h2')).toHaveText('Host Survey');
    });

    describe('when the form is submitted with valid data', function() {
      beforeEach(function() {
        subject.$('.first_name').val('John');
        subject.$('.last_name').val('Doe');
        subject.$('.email').val('john.doe@example.com');
        subject.$('.submit').click();
      });

      it('should save the model to the server', function() {
        expect({method: 'POST', url: '/events/1/hosts'}).toHaveBeenRequestedWith({
          event_id: '1',
          first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com'
        });
      });
    });

    describe('when the the form is submitted wihout a name or email', function() {
      beforeEach(function() {
        subject.$('.first_name').val('John');
        subject.$('.last_name').val('');
        subject.$('.email').val('john.doe@example.com');
        subject.$('.submit').click();
      });

      it('should inform the user that the fields are required', function() {
        expect(humane.log).toHaveBeenCalledWith('Please provide your name and email address.');
      });
    });
  });

  describe('when the server responds that the user is a host', function() {
    beforeEach(function() {
      server.respondTo('GET', '/events', [
        {id: 1, name: 'Event 1', archived: false, host_id: 2, visitor_id: null},
        {id: 2, name: 'Event 2', archived: true},
        {id: 3, name: 'Event 3', archived: false}
      ]);
    });

    it('should fetch the host from the server', function() {
      expect({method: 'GET', url: '/events/1/hosts/2'}).toHaveBeenRequested();
    })

    describe('when the server responds', function() {
      beforeEach(function() {
        server.respondTo('GET', '/events/1/hosts/2', {first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com'});
      });

      it('should have title "Host Survey"', function() {
        expect(subject.$('h2')).toHaveText('Host Survey');
      });

      it('should populate the input fields', function() {
        expect(subject.$('.first_name')).toHaveValue('John');
        expect(subject.$('.last_name')).toHaveValue('Doe');
        expect(subject.$('.email')).toHaveValue('jdoe@example.com');
      });

      describe('when the form is submitted with valid data', function() {
        beforeEach(function() {
          subject.$('.first_name').val('John');
          subject.$('.last_name').val('Doe');
          subject.$('.email').val('john.doe@example.com');
          subject.$('.submit').click();
        });

        it('should save the model to the server', function() {
          expect({method: 'PUT', url: '/events/1/hosts/2'}).toHaveBeenRequestedWith({
            event_id: '1', id: 2,
            first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com'
          });
        });

        describe('when the server responds', function() {
          beforeEach(function() {
            server.respondTo('PUT', '/events/1/hosts/2');
          });

          it('should navigate to the events page', function() {
            var pageContainer = $('.page_content');
            expect(pageContainer).toExist();
            expect(pageContainer).not.toHaveClass('new_event');
            expect(pageContainer).toHaveClass('events');
          });
        });
      });
    });
  });

  describe('when the server responds that the user is a visitor', function() {
    beforeEach(function() {
      server.respondTo('GET', '/events', [
        {id: 1, name: 'Event 1', archived: false, host_id: null, visitor_id: 3},
        {id: 2, name: 'Event 2', archived: true},
        {id: 3, name: 'Event 3', archived: false}
      ]);
    });

    it('should fetch the visitor from the server', function() {
      expect({method: 'GET', url: '/events/1/visitors/3'}).toHaveBeenRequested();
    })

    describe('when the server responds', function() {
      beforeEach(function() {
        server.respondTo('GET', '/events/1/visitors/3', {first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com'});
      });

      it('should have title "Visitor Survey"', function() {
        expect(subject.$('h2')).toHaveText('Visitor Survey');
      });

      it('should populate the input fields', function() {
        expect(subject.$('.first_name')).toHaveValue('John');
        expect(subject.$('.last_name')).toHaveValue('Doe');
        expect(subject.$('.email')).toHaveValue('jdoe@example.com');
      });
    });
  });
});
