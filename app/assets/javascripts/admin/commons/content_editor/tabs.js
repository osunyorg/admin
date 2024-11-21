window.osuny.contentEditor.tabs = {
    init: function () {
        'use strict';
        this.container = document.querySelector('.js-content-editor');
        this.tabs = document.querySelectorAll('[data-bs-toggle="tab"]');
        this.modeWriteContainer = this.container.querySelector('#mode-write-container');
        this.modeWritePane = this.container.querySelector('#mode-write');
        this.modeWriteSource = this.modeWritePane.getAttribute('data-source');
        this.modeStructureContainer = this.container.querySelector('#mode-structure-container');
        this.modeStructurePane = this.container.querySelector('#mode-structure');
        this.modeStructureSource = this.modeStructurePane.getAttribute('data-source');
        this.target = this.modeWriteContainer;
        this.source = this.modeWriteSource;
        this.initTabsHook();
    },

    initTabsHook: function () {
        'use strict';
        var i,
            tab;
        for (i = 0; i < this.tabs.length; i += 1) {
            tab = this.tabs[i];
            tab.addEventListener('shown.bs.tab', this.tabChanged.bind(this));
        }
    },

    tabChanged: function (event) {
        'use strict';
        if (event.target.id === 'mode-write-tab') {
            this.loadWrite();
        } else {
            this.loadStructure();
        }
    },

    loadWrite: function () {
        'use strict';
        this.target = this.modeWriteContainer;
        this.source = this.modeWriteSource;
        this.loadCurrentTab();
    },

    loadStructure: function () {
        'use strict';
        this.target = this.modeStructureContainer;
        this.source = this.modeStructureSource;
        this.loadCurrentTab();
    },

    loadCurrentTab: function () {
        'use strict';
        if (!this.target) {
            return;
        }

        this.target.innerHTML = '';
        this.xhr = new XMLHttpRequest();
        this.xhr.open('GET', this.source, true);
        this.xhr.onreadystatechange = this.tabLoaded.bind(this);
        this.xhr.send();
    },

    reload: function () {
        'use strict';
        this.loadCurrentTab();
    },

    tabLoaded: function () {
        'use strict';
        if (this.xhr.readyState === XMLHttpRequest.DONE) {
            if (this.xhr.status === 200) {
                this.target.innerHTML = this.xhr.responseText;
                window.osuny.contentEditor.sort.init();
                window.osuny.contentEditor.offcanvas.initButtons();
            }
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this),
            reload: this.reload.bind(this)
        };
    }
}.invoke();
