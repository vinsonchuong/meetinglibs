//= require views/dialog
//= require templates/dialogs/confirmation
MeetingLibs.View.Dialog.Confirmation = MeetingLibs.View.Dialog.extend({
  className: 'view dialog confirmation',
  templateName: 'dialogs/confirmation',

  events: {
    'click .confirm': 'confirm',
    'click .cancel': 'cancel',
  },

  initialize: function(options) {
    this.setElement($('.dialog_content'));

    this.message = options.message;
    this.action = options.action;
    this.render();
  },

  setElement: function() {
    MeetingLibs.View.Dialog.prototype.setElement.apply(this, arguments);
    this.$elClone = this.$el.clone();
    this.$el.addClass(this.className);
  },

  render: function() {
    this.$el.html(JST['templates/' + this.templateName](this.context()));
    return this;
  },

  context: function() {
    return {
      message: this.message,
      action: this.action
    };
  },

  confirm: function(e) {
    e.preventDefault();
    this.trigger('confirm');
    this.remove();
  },

  cancel: function(e) {
    e.preventDefault();
    this.trigger('cancel');
    this.remove();
  },

  remove: function() {
    this.$el.replaceWith(this.$elClone);
    MeetingLibs.View.Dialog.prototype.remove.apply(this, arguments);
  }
});
