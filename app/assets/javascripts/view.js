MeetingLibs.View = Backbone.View.extend({
  navigate: function(path) {
    router.navigate(path, {trigger: true});
  }
});
