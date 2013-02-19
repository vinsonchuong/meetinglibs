//= require application
//= require sinon
//= require jasmine-jquery
//= require_self
//= require_tree .

sharedExamples = {};
function itShouldBehaveLike(name, context) {
  sharedExamples[name](context);
}

beforeEach(function() {
  session = {
    administrator: true
  };

  spyOn(humane, 'log');

  spyOn(MeetingLibs.View.prototype, 'navigate').andCallFake(function(route) {
    Backbone.history.loadUrl(route);
  });

  $('<div/>').addClass('page_content').hide().appendTo('body');
  $('<div/>').addClass('dialog_content').hide().appendTo('body');

  server = sinon.fakeServer.create();
  server.stubRequest = function(method, url) {
    var jsonResponse;
    server.respondWith(method, url, function(request) {
      request.respond(200, {}, jsonResponse);
    });
    return {
      andReturn: function(response) {
        jsonResponse = JSON.stringify(response);
      }
    };
  };
  server.respondTo = function(method, url, response) {
    var request = _.where(server.requests, {method: method, url: url})[0];

    if (_.isUndefined(response) || response == '') {
      request.respond(204, {'Content-Type': 'application/json'}, '');
    } else {
      request.respond(200, {'Content-Type': 'application/json'}, JSON.stringify(response));
    }
  };
  this.addMatchers({
    toHaveBeenRequested: function() {
      this.message = _.bind(function() {
        return 'Expected ' + this.actual.method + ' ' + this.actual.url +
                (this.isNot ? ' not' : '') + ' to have been requested';
      }, this);
      return !_.isEmpty(_.where(server.requests, this.actual));
    },

    toHaveBeenRequestedWith: function(json) {
      var request = _.where(server.requests, this.actual)[0];
      this.message = _.bind(function() {
        if (_.isUndefined(request)) {
          return 'Expected ' + this.actual.method + ' ' + this.actual.url +
                 (this.isNot ? ' not' : '') + ' to have been requested';
        } else {
          return 'Expected ' + this.actual.method + ' ' + this.actual.url +
                 (this.isNot ? ' not' : '') +
                 ' to have been requested with ' + JSON.stringify(json) +
                 ', but was requested with ' + request.requestBody;
        }
      }, this)
      return _.isEqual(json, JSON.parse(request.requestBody));
    }
  });

  listener = new (function() {
    _.extend(this, Backbone.Events);
    this.events = [];
    this.listenTo = function(subject) {
      Backbone.Events.listenTo.call(this, subject, 'all', function(eventName) {
        this.events.push({subject: subject, name: eventName, data: _.rest(arguments)});
      });
    };
  })();
  this.addMatchers({
    toHaveTriggered: function(eventName) {
      var event = _.where(listener.events, {subject: this.actual, name: eventName})[0];
      this.message = _.bind(function() {
        return 'Expected ' + eventName + (this.isNot ? ' not' : '') + ' to have been triggered';
      }, this);
      return !_.isUndefined(event);
    }
  });
});

afterEach(function() {
  $('.page_content').remove();
  $('.dialog_content').remove();

  var pendingRequests = _.filter(server.requests, function(request) {
    return request.status == 404;
  });
  if (!_.isEmpty(pendingRequests)) {
    console.warn('Unexpected Requests: ', pendingRequests);
  }
  server.restore();

  listener.stopListening();
});
