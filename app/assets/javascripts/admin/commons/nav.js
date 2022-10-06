var autoCollapseSidebar = function () {
    'use strict';
    var sidebar = document.querySelector('#sidebar[data-auto-collapsed]');
    if (sidebar && window.innerWidth >= 992) {
        sidebar.classList.add('collapsed');
        sidebar.removeAttribute('data-auto-collapsed');
    }
};

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    autoCollapseSidebar();
});
