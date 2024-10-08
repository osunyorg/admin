window.osuny.contentEditor.offcanvas = {
    init: function () {
        'use strict';
        this.editor = document.getElementById('offcanvasEditor');
        this.editorBootstrap = new bootstrap.Offcanvas(this.editor);
        this.iframe = document.getElementById('offcanvasEditorIframe');
        this.editButtons = document.querySelectorAll('.js-content-editor__element__edit');
        this.addBlockButton = document.querySelector('.js-content-editor__add-block');
        this.initButtons();
    },

    initButtons: function () {
        'use strict';
        var i,
            button;
        for (i = 0; i < this.editButtons.length; i += 1) {
            button = this.editButtons[i];
            button.addEventListener('click', this.onEditButtonClick.bind(this));
        }
        this.addBlockButton.addEventListener('click', this.onAddBlockButtonClick.bind(this));
    },

    onEditButtonClick: function (event) {
        'use strict';
        event.preventDefault();
        window.open(event.target.href, 'editor');
        this.editorBootstrap.show();
    },

    onAddBlockButtonClick: function (event) {
        'use strict';
        event.preventDefault();
        window.open(event.target.href, 'editor');
        this.editorBootstrap.show();
    },

    onBlockSave: function (blockIdentifier, blockPath) {
        'use strict';
        var snippet = document.querySelector('#snippet-' + blockIdentifier);
        if (snippet === null) {
            this.addNewSnippet();
        } else {
            this.updateExistingSnippet(snippet, blockPath);
        }
    },

    addNewSnippet: function () {
        this.editorBootstrap.hide();
        window.osuny.contentEditor.tabs.reload();
    },

    updateExistingSnippet: function (snippet, blockPath) {
        'use strict';
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.status == 200) {
                snippet.innerHTML = request.responseText;
            }
        };
        request.open("GET", blockPath);
        request.send();
        this.editorBootstrap.hide();
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this),
            onBlockSave: this.onBlockSave.bind(this)
        };
    }
}.invoke();