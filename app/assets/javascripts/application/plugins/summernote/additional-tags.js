(function ($) {
    'use strict';

    window.summernoteManager = window.summernoteManager || {};

    var TagUtils = {
        findClosestTag: function (node, tagName) {
            'use strict';
            var currentNode = node;
            tagName = tagName.toLowerCase();
            while (currentNode && currentNode.nodeType !== 9) {
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
            var range, frag, node;
            if (!sel.rangeCount) return;

            range = sel.getRangeAt(0);
            frag = range.extractContents();
            node = document.createElement(tagName);
            node.appendChild(frag);
            range.insertNode(node);

            range.setStartAfter(node);
            range.collapse(true);
            sel.removeAllRanges();
            sel.addRange(range);
            context.invoke('editor.focus');
        },

        isSelectionInsideTag: function (tagName) {
            'use strict';
            var sel = window.getSelection();
            var range, startTag, endTag;
            if (!sel.rangeCount) return false;

            range = sel.getRangeAt(0);
            startTag = this.findClosestTag(range.startContainer, tagName);
            endTag = this.findClosestTag(range.endContainer, tagName);
            return startTag && startTag === endTag;
        },

        removeTagAroundSelection: function (tagName) {
            'use strict';
            var sel = window.getSelection();
            var range, tagNode;
            if (!sel.rangeCount) return;

            range = sel.getRangeAt(0);
            tagNode = this.findClosestTag(range.startContainer, tagName);
            if (tagNode) {
                this.unwrapTag($(tagNode));
            }
        },

        toggleTag: function (context, tagName) {
            'use strict';
            var sel = window.getSelection();
            if (!sel.rangeCount) return;

            if (this.isSelectionInsideTag(tagName)) {
                this.removeTagAroundSelection(tagName);
            } else {
                var text = context.invoke('editor.getSelectedText');
                if (!text) return;
                this.wrapSelectionWithTag(context, tagName);
            }
        }
    };

    function createUpdateButtonState (context, tagName) {
        'use strict';
        var sel, range, isActive, $btn;
        return function () {
            'use strict';
            sel = window.getSelection();
            isActive = false;

            if (sel.rangeCount) {
                range = sel.getRangeAt(0);
                isActive = !!TagUtils.findClosestTag(range.startContainer, tagName);
            }

            $btn = context.layoutInfo.toolbar.find('.note-btn-' + tagName);
            $btn.toggleClass('active', isActive);
        };
    }

    function attachEditorEvents (context, tagName, updateButtonState) {
        'use strict';
        var events = ['keyup', 'mouseup', 'change', 'nodechange'];
        var i, $editable = context.layoutInfo.editable;

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

    function createButton (context, tagName, options) {
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
