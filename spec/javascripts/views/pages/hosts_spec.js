describe('MeetingLibs.View.Page.Hosts', function() {
  var subject;
  beforeEach(function() {
    subject = new MeetingLibs.View.Page.Hosts({eventId: '1'});
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
        {id: 1, first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'},
        {id: 2, first_name: 'Jane', last_name: 'Doe', email: 'janedoe@example.com'},
      ]);
    });

    it('should show a create host link', function() {
      expect(subject.$('a.create')).toHaveAttr('href', '/#events/1/hosts/new');
    });

    it('should show a table of hosts', function() {
      expect(subject.$('.host_list .host:eq(0) .name')).toHaveText('John Doe');
      expect(subject.$('.host_list .host:eq(1) .name')).toHaveText('Jane Doe');
    });

    it('should show an edit link for each host', function() {
      expect(subject.$('.host_list .host:eq(0) a.edit')).toHaveAttr('href', '/#events/1/hosts/1');
      expect(subject.$('.host_list .host:eq(1) a.edit')).toHaveAttr('href', '/#events/1/hosts/2');
    });

    describe('when deleting a host', function() {
      beforeEach(function() {
        subject.$('.host_list .host:eq(0) .delete').click();
      });

      it('should show a confirmation dialog', function() {
        expect($('.confirmation .message')).toHaveText(
          'You are removing John Doe from this event. Survey answers and' +
          ' scheduled meetings for this host will all be permanently'  +
          ' deleted. Do you want to continue?'
        )
      });

      describe('when confirming', function() {
        beforeEach(function() {
          $('.confirmation :contains("Remove Host")').click();
        });

        it('should delete the host from the server', function() {
          expect({method: 'DELETE', url: '/events/1/hosts/1'}).toHaveBeenRequested();
        });

        describe('when the server responds', function() {
          beforeEach(function() {
            server.respondTo('DELETE', '/events/1/hosts/1');
          });

          it('should remove the host', function() {
            expect(subject.$('.host_list .host .name:contains("John Doe")')).not.toExist();
          });
        });
      });

      describe('when cancelling', function() {
        beforeEach(function() {
          $('.confirmation :contains("Cancel")').click();
        });

        it('should not delete the host', function() {
          expect(subject.$('.host_list .host .name:contains("John Doe")')).toExist();
        });
      });
    });
  });
});
