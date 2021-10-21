//= require activestorage
//= require jquery3
//= require jquery_ujs
//= require notyf/notyf.min
//= require simple_form_password_with_hints
//= require simple_form_bs5_file_input
//= require cropperjs/dist/cropper
//= require jquery-cropper/dist/jquery-cropper
//= require appstack/app
//= require gdpr/cookie_consent
//= require trix
//= require sortablejs/Sortable
//= require_tree ./admin

// Nested demo
var nestedSortables = [].slice.call(document.querySelectorAll('.nested-sortable'));

// Loop through each nested sortable element
for (var i = 0; i < nestedSortables.length; i++) {
	new Sortable(nestedSortables[i], {
		group: 'nested',
		animation: 150,
		fallbackOnBody: true,
		swapThreshold: 0.65
	});
}
