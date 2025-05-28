(function ($) {
    'use strict';

    window.summernoteManager = window.summernoteManager || {};

    var TagUtils = {
        findClosestTag: function (node, tagName) {
            'use strict';
            var currentNode = node;
            tagName = tagName.toLowerCase();
            while (currentNode && currentNode.nodeType !== 9) { // 9 = DOCUMENT_NODE
                if (currentNode.nodeType === 1 && currentNode.tagName.toLowerCase() === tagName) {
                    return currentNode;
                }
                currentNode = currentNode.parentNode;
            }
            return null;
        },

        unwrapTag: function ($tag) {
            'use strict';
            $tag.contents().unwrap();
        },

        wrapSelectionWithTag: function (context, tagName) {
            'use strict';
            var sel = window.getSelection();
            if (!sel.rangeCount) {
                return;
            }

            var range = sel.getRangeAt(0);
            var frag = range.extractContents();
            var node = document.createElement(tagName);

            if (!frag.textContent) {
                node.innerHTML = '&#8203;'; // caractère invisible pour curseur accessible
            } else {
                node.appendChild(frag);
            }

            range.insertNode(node);

            // Positionner le curseur à l’intérieur de la nouvelle balise
            var newRange = document.createRange();
            newRange.setStart(node, 0);
            newRange.collapse(true);

            sel.removeAllRanges();
            sel.addRange(newRange);
            context.invoke('editor.focus');

            // Important : notifier Summernote du changement
            context.invoke('editor.afterCommand');
        },

        isSelectionInsideTag: function (tagName) {
            'use strict';
            var sel = window.getSelection();
            if (!sel.rangeCount) {
                return false;
            }

            var range = sel.getRangeAt(0);
            var startTag = this.findClosestTag(range.startContainer, tagName);
            var endTag = this.findClosestTag(range.endContainer, tagName);

            return startTag && startTag === endTag;
        },

        removeTagAroundSelection: function (context, tagName) {
            'use strict';
            var sel = window.getSelection();
            if (!sel.rangeCount) {
                return;
            }

            var range = sel.getRangeAt(0);
            var tagNode = this.findClosestTag(range.startContainer, tagName);

            if (tagNode) {
                this.unwrapTag($(tagNode));
                // Important : notifier Summernote du changement
                context.invoke('editor.afterCommand');
            }
        },

        toggleTag: function (context, tagName) {
            'use strict';
            var sel = window.getSelection();
            if (!sel.rangeCount) {
                return;
            }

            if (this.isSelectionInsideTag(tagName)) {
                this.removeTagAroundSelection(context, tagName);
            } else {
                this.wrapSelectionWithTag(context, tagName);
            }
        }
    };

    function createUpdateButtonState(context, tagName) {
        'use strict';
        return function () {
            'use strict';
            var sel = window.getSelection();
            var isActive = false;
            var $btn;

            if (sel.rangeCount) {
                var range = sel.getRangeAt(0);
                isActive = !!TagUtils.findClosestTag(range.startContainer, tagName);
            }

            $btn = context.layoutInfo.toolbar.find('.note-btn-' + tagName);
            $btn.toggleClass('active', isActive);
        };
    }

    function attachEditorEvents(context, tagName, updateButtonState) {
        'use strict';
        var events = ['keyup', 'mouseup', 'change', 'nodechange'];
        var i;
        var $editable = context.layoutInfo.editable;

        for (i = 0; i < events.length; i++) {
            context.invoke('events.on', events[i], updateButtonState);
        }

        $editable.on('mouseup keyup', function () {
            'use strict';
            if (document.activeElement === $editable[0]) {
                updateButtonState();
            }
        });
    }

    function createButton(context, tagName, options) {
        'use strict';
        var ui = $.summernote.ui;
        var updateButtonState = createUpdateButtonState(context, tagName);

        var button = ui.button({
            contents: options.iconHtml,
            tooltip: options.tooltip,
            className: 'note-btn-' + tagName,
            click: function () {
                'use strict';
                TagUtils.toggleTag(context, tagName);
                updateButtonState();
            }
        });

        attachEditorEvents(context, tagName, updateButtonState);
        updateButtonState();

        return button.render();
    }

    window.summernoteManager.createTagToggleButton = function (tagName, options) {
        'use strict';
        return function (context) {
            'use strict';
            return createButton(context, tagName, options);
        };
    };

    window.summernoteManager.qButton = window.summernoteManager.createTagToggleButton('q', {
        iconHtml: '<i class="fas fa-quote-left"></i>',
        tooltip: 'Citation courte'
    });

    window.summernoteManager.noteButton = window.summernoteManager.createTagToggleButton('note', {
        iconHtml: '<i class="fas fa-note-sticky"></i>',
        tooltip: 'Note (beta)'
    });

})(jQuery);
