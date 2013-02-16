//= require application
//= require sinon
//= require jasmine-jquery
//= require_self
//= require_tree .

beforeEach(function() {
  $('<div/>').addClass('page_content').hide().appendTo('body');

  server = sinon.fakeServer.create();
  server.stubRequest = function(method, url, response) {
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
});

afterEach(function() {
  var pendingRequests = _.filter(server.requests, function(request) {
    return request.status == 404;
  });
  if (!_.isEmpty(pendingRequests)) {
    console.warn('Unexpected Requests: ', pendingRequests);
  }
  server.restore();

  $('.page_content').remove();
});
