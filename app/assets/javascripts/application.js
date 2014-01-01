// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .

function ready()
 {
     // MAKE SURE YOUR SELECTOR MATCHES SOMETHING IN YOUR HTML!!!
     $('a.ajax').each(function() {
         $(this).qtip({
            content: {
                text: function(event, api) {
                    $.ajax({
                        url: api.elements.target.attr('href') // Use href attribute as URL
                    })
                    .then(function(content) {
                        // Set the tooltip content upon successful retrieval
                        api.set('content.text', YamlDumper.dump(content, 1).replace(/\n/g, '<br />'));
                    }, function(xhr, status, error) {
                        // Upon failure... set the tooltip content to error
                        api.set('content.text', xhr.responseText);
                    });
        
                    return 'Laden ...'; // Set some initial text
                }
            },
            position: {
                viewport: $(window)
            },
            style: 'qtip-wiki'
         });
     });
 }
 $(document).ready(ready);
 $(document).on('page:load', ready);