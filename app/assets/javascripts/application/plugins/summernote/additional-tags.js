(function ($) {
    'use strict';

    window.summernoteManager = window.summernoteManager || {};

    var TagUtils = {
        findClosestTag: function (node, tagName) {
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
            $tag.contents().unwrap();
        },

        wrapSelectionWithTag: function (context, tagName) {
            var sel = window.getSelection(),
                range,
                frag,
                node,
                newRange;
            if (!sel.rangeCount) {
                return;
            }

            range = sel.getRangeAt(0);
            frag = range.extractContents();
            node = document.createElement(tagName);

            if (!frag.textContent) {
                node.innerHTML = '&#8203;'; // caractère invisible pour curseur accessible
            } else {
                node.appendChild(frag);
            }

            range.insertNode(node);

            // Positionner le curseur à l’intérieur de la nouvelle balise
            newRange = document.createRange();
            newRange.setStart(node, 0);
            newRange.collapse(true);

            sel.removeAllRanges();
            sel.addRange(newRange);
            context.invoke('editor.focus');

            // Important : notifier Summernote du changement
            context.invoke('editor.afterCommand');
        },

        isSelectionInsideTag: function (tagName) {
            var sel = window.getSelection(),
                range,
                startTag,
                endTag;
            if (!sel.rangeCount) {
                return false;
            }

            range = sel.getRangeAt(0);
            startTag = this.findClosestTag(range.startContainer, tagName);
            endTag = this.findClosestTag(range.endContainer, tagName);

            return startTag && startTag === endTag;
        },

        removeTagAroundSelection: function (context, tagName) {
            var sel = window.getSelection(),
                range,
                tagNode;
            if (!sel.rangeCount) {
                return;
            }

            range = sel.getRangeAt(0);
            tagNode = this.findClosestTag(range.startContainer, tagName);

            if (tagNode) {
                this.unwrapTag($(tagNode));
                // Important : notifier Summernote du changement
                context.invoke('editor.afterCommand');
            }
        },

        toggleTag: function (context, tagName) {
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
        return function () {
            var sel = window.getSelection(),
                isActive = false,
                $btn,
                range;

            if (sel.rangeCount) {
                range = sel.getRangeAt(0);
                isActive = !!TagUtils.findClosestTag(range.startContainer, tagName);
            }

            $btn = context.layoutInfo.toolbar.find('.note-btn-' + tagName);
            $btn.toggleClass('active', isActive);
        };
    }

    function attachEditorEvents(context, tagName, updateButtonState) {
        var events = ['keyup', 'mouseup', 'change', 'nodechange'],
            i,
            $editable = context.layoutInfo.editable;

        for (i = 0; i < events.length; i++) {
            context.invoke('events.on', events[i], updateButtonState);
        }

        $editable.on('mouseup keyup', function () {
            if (document.activeElement === $editable[0]) {
                updateButtonState();
            }
        });
    }

    function createButton(context, tagName, options) {
        var ui = $.summernote.ui,
            updateButtonState = createUpdateButtonState(context, tagName),
            button = ui.button({
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
