window.osuny.websites.batchSyncThemes = {
    init: function () {
        'use strict';
        this.syncAllBtn = document.querySelector('.js-sync-all-theme-versions');
        this.syncBtns = document.querySelectorAll('.js-sync-theme-version');
        this.syncAllBtn.addEventListener('click', this.syncAll.bind(this));
    },

    syncAll: function (e) {
        'use strict';
        var i;
        e.preventDefault();
        for (i = 0; i < this.syncBtns.length; i += 1) {
            this.syncBtns[i].click();
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        }
    }
}.invoke();

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    if (document.body.classList.contains('websites-manage_versions')) {
        window.osuny.websites.batchSyncThemes.init();
    }
})