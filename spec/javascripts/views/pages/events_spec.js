describe('MeetingLibs.View.Page.Events', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.Events();
  });

  afterEach(function() {
    subject.remove();
  });

  it('should render to its container', function() {
    expect(subject.$el).toBe('body .page_content');
  });

  it('should add its class names to its container', function() {
    expect(subject.$el).toHaveClass('view');
    expect(subject.$el).toHaveClass('page');
    expect(subject.$el).toHaveClass('events');
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
      expect(pageContent).not.toHaveClass('events');
      expect(pageContent).toBeEmpty();
    });
  });

  it('should fetch the events from the server', function() {
    expect({method: 'GET', url: '/events'}).toHaveBeenRequested();
  });

  describe('when the server responds', function() {
    beforeEach(function() {
      server.respondTo('GET', '/events', [
        {id: 1, name: 'Event 1', archived: true},
        {id: 2, name: 'Event 2'},
        {id: 3, name: 'Event 3'}
      ]);
    });

    it('should show a list of events', function() {
      expect(subject.$('.event_list .event:eq(0) .name')).toHaveText('Event 1');
      expect(subject.$('.event_list .event:eq(1) .name')).toHaveText('Event 2');
      expect(subject.$('.event_list .event:eq(2) .name')).toHaveText('Event 3');
    });

    it('should distinguish the archived events', function() {
      expect(subject.$('.event_list .event:eq(0)')).toHaveClass('archived');
      expect(subject.$('.event_list .event:eq(1)')).not.toHaveClass('archived');
      expect(subject.$('.event_list .event:eq(2)')).not.toHaveClass('archived');
    });

    describe('for normal users', function() {
      beforeEach(function() {
        session.administrator = false;
        subject.render();
      });

      it('should not allow archiving events', function() {
        expect(subject.$('.event_list .event .archive')).not.toExist();
      });

      it('should not allow deleting events', function() {
        expect(subject.$('.event_list .event .delete')).not.toExist();
      });
    });

    describe('when archiving an event', function() {
      beforeEach(function() {
        subject.$('.event_list .event:eq(1) .archive').click();
      });

      it('should show a confirmation dialog', function() {
        expect($('.confirmation .message')).toHaveText(
          'You are archiving Event 2. Once an event is archived, only' +
          ' administrators will be able to view it. Do you want to' +
          ' continue?'
        )
      });

      describe('when confirming', function() {
        beforeEach(function() {
          $('.confirmation :contains("Archive Event")').click();
        });

        it('should save the event to the server', function() {
          expect({method: 'PUT', url: '/events/2'}).toHaveBeenRequestedWith({id: 2, name: 'Event 2', archived: true});
        });

        describe('when the server responds', function() {
          beforeEach(function() {
            server.respondTo('PUT', '/events/2');
          });

          it('should indicate the event is archived', function() {
            expect(subject.$('.event_list .event:eq(1)')).toHaveClass('archived');
          });
        });
      });

      describe('when cancelling', function() {
        beforeEach(function() {
          $('.confirmation :contains("Cancel")').click();
        });

        it('should not archive the event', function() {
          expect(subject.$('.event_list .event:eq(1)')).not.toHaveClass('archived');
        });
      });
    });

    describe('when deleting an event', function() {
      beforeEach(function() {
        subject.$('.event_list .event:eq(0) .delete').click();
      });

      it('should show a confirmation dialog', function() {
        expect($('.confirmation .message')).toHaveText(
          'You are deleting Event 1. Survey answers, meeting schedules, and' +
          ' comments for this event will all be permanently deleted. Do you' +
          ' want to continue?'
        )
      });

      describe('when confirming', function() {
        beforeEach(function() {
          $('.confirmation :contains("Delete Event")').click();
        });

        it('should delete the event from the server', function() {
          expect({method: 'DELETE', url: '/events/1'}).toHaveBeenRequested();
        });

        describe('when the server responds', function() {
          beforeEach(function() {
            server.respondTo('DELETE', '/events/1');
          });

          it('should remove the event', function() {
            expect(subject.$('.event_list .event .name:contains("Event 1")')).not.toExist();
          });
        });
      });

      describe('when cancelling', function() {
        beforeEach(function() {
          $('.confirmation :contains("Cancel")').click();
        });

        it('should not delete the event', function() {
          expect(subject.$('.event_list .event .name:contains("Event 1")')).toExist();
        });
      });
    });
  });
});
