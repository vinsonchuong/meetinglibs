describe('MeetingLibs.View.Page.Events', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.Events();
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

  describe('when the server responds', function() {
    beforeEach(function() {
      server.respondTo('GET', '/events', [
        {id: 1, name: 'Event 1', archived: true},
        {id: 2, name: 'Event 2'},
        {id: 3, name: 'Event 3'}
      ]);
    });

    it('should show a "Create Event" link', function() {
      expect(subject.$('a.create')).toHaveAttr('href', '/#events/new');
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

      it('should not allow managing hosts', function() {
        expect(subject.$('.event_list .event .hosts')).not.toExist();
      });

      it('should not allow managing visitors', function() {
        expect(subject.$('.event_list .event .visitors')).not.toExist();
      });

      it('should not allow archiving events', function() {
        expect(subject.$('.event_list .event .archive')).not.toExist();
      });

      it('should not allow deleting events', function() {
        expect(subject.$('.event_list .event .delete')).not.toExist();
      });

      it('should show a link for updating survey answers', function() {
        expect(subject.$('.event_list .event:eq(0) a.survey')).toHaveAttr('href', '/#events/1');
        expect(subject.$('.event_list .event:eq(1) a.survey')).toHaveAttr('href', '/#events/2');
        expect(subject.$('.event_list .event:eq(2) a.survey')).toHaveAttr('href', '/#events/3');
      });
    });

    it('should show a link for managing hosts', function() {
      expect(subject.$('.event_list .event:eq(0) a.hosts')).toHaveAttr('href', '/#events/1/hosts');
      expect(subject.$('.event_list .event:eq(1) a.hosts')).toHaveAttr('href', '/#events/2/hosts');
      expect(subject.$('.event_list .event:eq(2) a.hosts')).toHaveAttr('href', '/#events/3/hosts');
    });

    it('should show a link for managing visitors', function() {
      expect(subject.$('.event_list .event:eq(0) a.visitors')).toHaveAttr('href', '/#events/1/visitors');
      expect(subject.$('.event_list .event:eq(1) a.visitors')).toHaveAttr('href', '/#events/2/visitors');
      expect(subject.$('.event_list .event:eq(2) a.visitors')).toHaveAttr('href', '/#events/3/visitors');
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
