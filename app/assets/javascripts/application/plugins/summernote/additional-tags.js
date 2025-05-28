(function($) {
  window.summernoteManager = window.summernoteManager || {};

  // Utilitaires génériques pour balises personnalisées
  const TagUtils = {
    findClosestTag(node, tagName) {
      tagName = tagName.toLowerCase();
      while (node && node.nodeType !== 9) {
        if (node.nodeType === 1 && node.tagName.toLowerCase() === tagName) {
          return node;
        }
        node = node.parentNode;
      }
      return null;
    },

    unwrapTag($tag) {
      $tag.contents().unwrap();
    },

    wrapSelectionWithTag(context, tagName) {
      const selection = window.getSelection();
      if (!selection.rangeCount) return;
      const range = selection.getRangeAt(0);

      const frag = range.extractContents();
      const tagNode = document.createElement(tagName);
      tagNode.appendChild(frag);

      range.insertNode(tagNode);

      // Place cursor after inserted tag
      range.setStartAfter(tagNode);
      range.collapse(true);

      selection.removeAllRanges();
      selection.addRange(range);

      context.invoke('editor.focus');
    },

    isSelectionInsideTag(tagName) {
      const selection = window.getSelection();
      if (!selection.rangeCount) return false;
      const range = selection.getRangeAt(0);
      const startTag = this.findClosestTag(range.startContainer, tagName);
      const endTag = this.findClosestTag(range.endContainer, tagName);
      return startTag && startTag === endTag;
    },

    removeTagAroundSelection(tagName) {
      const selection = window.getSelection();
      if (!selection.rangeCount) return;
      const range = selection.getRangeAt(0);
      const tagNode = this.findClosestTag(range.startContainer, tagName);
      if (tagNode) {
        this.unwrapTag($(tagNode));
      }
    },

    toggleTag(context, tagName) {
      const selection = window.getSelection();
      if (!selection.rangeCount) return;

      if (this.isSelectionInsideTag(tagName)) {
        this.removeTagAroundSelection(tagName);
      } else {
        const text = context.invoke('editor.getSelectedText');
        if (!text) return;
        this.wrapSelectionWithTag(context, tagName);
      }
    }
  };

  // Factory pour créer un bouton Summernote qui toggle une balise custom
  window.summernoteManager.createTagToggleButton = function(tagName, options) {
    options = options || {};
    const iconHtml = options.iconHtml || `<i class="fas fa-${tagName}"></i>`;
    const tooltip = options.tooltip || `Toggle ${tagName}`;

    return function(context) {
      const ui = $.summernote.ui;
      const $editable = context.layoutInfo.editable;

      function updateButtonState() {
        const selection = window.getSelection();
        let isActive = false;
        if (selection.rangeCount) {
          const range = selection.getRangeAt(0);
          const tagNode = TagUtils.findClosestTag(range.startContainer, tagName);
          isActive = !!tagNode;
        }
        const $button = context.layoutInfo.toolbar.find(`.note-btn-${tagName}`);
        $button.toggleClass('active', isActive);
      }

      const button = ui.button({
        contents: iconHtml,
        tooltip: tooltip,
        className: `note-btn-${tagName}`,
        click: function() {
          TagUtils.toggleTag(context, tagName);
          updateButtonState();
        }
      });

      ['keyup', 'mouseup', 'change', 'nodechange'].forEach(event => {
        context.invoke('events.on', event, updateButtonState);
      });

      function onSelectionChange() {
        if (document.activeElement === $editable[0]) {
          updateButtonState();
        }
      }

      $editable.on('mouseup keyup', onSelectionChange);

      updateButtonState();

      return button.render();
    };
  };

  // Plugins spécifiques basés sur la factory

  window.summernoteManager.qButton = window.summernoteManager.createTagToggleButton('q', {
    iconHtml: '<i class="fas fa-quote-left"></i>',
    tooltip: 'Citation courte'
  });

  window.summernoteManager.noteButton = window.summernoteManager.createTagToggleButton('note', {
    iconHtml: '<i class="fas fa-note-sticky"></i>',
    tooltip: 'Note'
  });

})(jQuery);
