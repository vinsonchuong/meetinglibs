describe('MeetingLibs.View.Page.Visitors', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.Visitors({eventId: '1'});
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
        {id: 1, first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'},
        {id: 2, first_name: 'Jane', last_name: 'Doe', email: 'janedoe@example.com'},
      ]);
    });

    it('should show a create visitor link', function() {
      expect(subject.$('a.create')).toHaveAttr('href', '/#events/1/visitors/new');
    });

    it('should show a table of visitors', function() {
      expect(subject.$('.visitor_list .visitor:eq(0) .name')).toHaveText('John Doe');
      expect(subject.$('.visitor_list .visitor:eq(1) .name')).toHaveText('Jane Doe');
    });

    it('should show an edit link for each visitor', function() {
      expect(subject.$('.visitor_list .visitor:eq(0) a.edit')).toHaveAttr('href', '/#events/1/visitors/1');
      expect(subject.$('.visitor_list .visitor:eq(1) a.edit')).toHaveAttr('href', '/#events/1/visitors/2');
    });

    describe('when deleting a visitor', function() {
      beforeEach(function() {
        subject.$('.visitor_list .visitor:eq(0) .delete').click();
      });

      it('should show a confirmation dialog', function() {
        expect($('.confirmation .message')).toHaveText(
          'You are removing John Doe from this event. Survey answers and' +
          ' scheduled meetings for this visitor will all be permanently'  +
          ' deleted. Do you want to continue?'
        )
      });

      describe('when confirming', function() {
        beforeEach(function() {
          $('.confirmation :contains("Remove Visitor")').click();
        });

        it('should delete the visitor from the server', function() {
          expect({method: 'DELETE', url: '/events/1/visitors/1'}).toHaveBeenRequested();
        });

        describe('when the server responds', function() {
          beforeEach(function() {
            server.respondTo('DELETE', '/events/1/visitors/1');
          });

          it('should remove the visitor', function() {
            expect(subject.$('.visitor_list .visitor .name:contains("John Doe")')).not.toExist();
          });
        });
      });

      describe('when cancelling', function() {
        beforeEach(function() {
          $('.confirmation :contains("Cancel")').click();
        });

        it('should not delete the visitor', function() {
          expect(subject.$('.visitor_list .visitor .name:contains("John Doe")')).toExist();
        });
      });
    });
  });
});
