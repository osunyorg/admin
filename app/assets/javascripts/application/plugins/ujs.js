/*global $, jQuery */
/* This allow ujs requests to automatically inject nonce */
$(function () {
    'use strict';
    $.ajaxSetup({
        converters: {
            'text script': function (text) {
                jQuery.globalEval(text, { nonce: $('meta[name="csp-nonce"]').attr('content') });
                return text;
            }
        }
    });
});
