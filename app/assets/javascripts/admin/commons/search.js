window.osuny = window.osuny || {};
window.osuny.search = {

    init: function () {
        'use strict';
        this.modal = document.getElementById('searchModal');
        this.field = document.getElementById('searchField');
        this.results = document.getElementById('searchResults');
        this.modal.addEventListener('shown.bs.modal', this.open.bind(this));
        this.field.addEventListener('input', this.update.bind(this));
        this.request = new XMLHttpRequest();
        this.endpoint = this.modal.dataset.endpoint;
    },

    open: function () {
        'use strict';
        this.field.focus();
    },

    update: function () {
        'use strict';
        this.term = this.field.value;
        this.loadResults();
    },

    loadResults: function () {
        'use strict';
        this.query = this.endpoint + '?term=' + this.term;
        this.request.abort();
        this.request.open('GET', this.query, true);
        this.request.addEventListener('load', this.resultsLoaded.bind(this));
        this.request.send();
    },

    resultsLoaded: function () {
        'use strict';
        this.results.innerHTML = this.request.response;
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();

document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.search.init();
});
