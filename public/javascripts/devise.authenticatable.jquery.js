// = require "facebox"

var devise = (function($) {

  $.facebox.settings.loadingImage = '/javascripts/facebox/loading.gif';
  $.facebox.settings.closeImage = '/javascripts/facebox/closelabel.gif';

  $(document).ready(function() {
    devise.ajaxifyLink('a[rel*=devise]');
    devise.ajaxifyForm('form[rel*=devise]');

    $('a.devise.sign_in_link.dialog').click(function() {
      var scope = devise.scopeByElementClass(this);
      devise.renderSignInForm(scope);
      return false;
    });
  });

  $().ajaxError(function(event, xhr, options, error) {
    var data = devise.unserialize(options.data);
    switch(xhr.status) {
      case 401:
        devise.renderSignInForm(data.scope);
        break;
      case 406:
        devise.renderFormError(xhr, data);
        break;
    }
  });

  return {

    formSpinner: $('<img class="spinner" src="' + $.facebox.settings.loadingImage + '" width="20" height="20" />'),

    afterSignIn: function(data) {
      $.getScript('/devise/after_sign_in.js');
      devise.setFlash('success', data);

      if (!devise.$clickBack && !devise.$submitBack) $(document).trigger('close.facebox');
      if (devise.$clickBack) devise.$clickBack.click();
      if (devise.$submitBack) devise.$submitBack.submit();

      devise.$clickBack = devise.$submitBack = null;
    },

    // Source: http://stackoverflow.com/questions/1131630/javascript-jquery-param-inverse-function
    unserialize: function(query) {
      var params = query.split('&');
      var params_hash = {};

      for (var i = 0; i < params.length; i++) {
        var param = params[i].split('=');
        param[0] = decodeURIComponent(param[0]);
        param[1] = decodeURIComponent(param[1]);

        if (typeof params_hash[param[0]] === 'undefined') {
          params_hash[param[0]] = param[1];
        } else if (typeof params_hash[param[0]] === 'string') {
          params_hash[param[0]] = [params_hash[param[0]], param[1]];
        } else {
          params_hash[param[0]].push(param[1]);
        }
      }
      return params_hash;
    },

    scopeByElementClass: function(element) {
      var self = $(element)
      var classes = self.attr('class').split(' ');
      return ((classes.length > 2) ? classes[2] : null);
    },

    spinner: function(self, show) {
      var formSubmitButton = self.find('input[type=submit]');

      if (show) {
        formSubmitButton.after(devise.formSpinner);
        formSubmitButton.attr('disabled', 'disabled');
      } else {
        devise.formSpinner.remove();
        formSubmitButton.removeAttr('disabled');
      };
    },

    setFlash: function(kind, message) {
      var kind_id = '#flash_' + kind;
      var flash = $(kind_id);
      if (flash.length == 0) {
        $('<div id="' + kind_id.replace('#', '') + '"></div>').appendTo('#flash');
      }
      $(kind_id).text(message);
    },

    // TODO: Make more agnostic, e.g. should re-render entire form?
    renderFormError: function(xhr, data) {
      $('#errorExplanation').remove();
      $('#facebox form').prepend(xhr.responseText);
      
      // Alt. solution: Re-render form:
      // $.get('/devise/sign_in/' + data.scope,
      //       null,
      //       function(data) {
      //         $.facebox(data);
      //         //devise.ajaxifyForm('#facebox form.sign_in', afterSignIn);
      //       },
      //       'html');
    },

    renderSignInForm: function(scope) {
      $.facebox(function() {
        $.get('/devise/sign_in/' + scope,
              null,
              function(data) {
                $.facebox(data);
                devise.ajaxifyForm('#facebox form.sign_in', devise.afterSignIn);
              },
              'html');
      });
    },

    ajaxifyLink: function(link, options) {
      if (typeof(options) === 'function') options = {success: options}

      $(link).click(function() {
        var self = $(this);
        var defaults = {
            url: self.attr('href'),
            type: 'GET',
            dataType: 'html',
            success: function(data) {
                $.facebox(data);
              },
            error: function(xhr) {
                if (xhr.status == 401) devise.$clickBack = self;
              }
          };

        var settings = $.extend(defaults, options);
        $.facebox(function() {
            $.ajax(settings);
          });

        return false;
      });
    },

    ajaxifyForm: function(form, options) {
      form = $(form);
      if (form.length == 0) return;
      if (typeof(options) === 'function') options = {success: options};
      var scope = devise.scopeByElementClass(form);

      $(form).submit(function() {
        var self = $(this);
        var defaults = {
          type: 'POST',
          url: self.attr('action'),
          data: self.serialize() + '&scope=' + scope, /* probably not a best practice... */
          dataType: 'html',
          beforeSend: function() {
              devise.spinner(self, true);
            },
          complete: function() {
              devise.spinner(self, false);
            },
          success: function(data) {
              $.facebox(data);
            },
          error: function(xhr) {
              if (xhr.status == 401) devise.$submitBack = self;
            }
        };

        var settings = $.extend(defaults, options);
        $.ajax(settings);

        return false;
      });
    }

  }
})(jQuery);
