(function($) {
  window.summernoteManager = window.summernoteManager || {};

  const TagUtils = {
    findClosestTag(node, tagName) {
      tagName = tagName.toLowerCase();
      while (node && node.nodeType !== 9) {
        if (node.nodeType === 1 && node.tagName.toLowerCase() === tagName) return node;
        node = node.parentNode;
      }
      return null;
    },
    unwrapTag($tag) { $tag.contents().unwrap(); },
    wrapSelectionWithTag(context, tagName) {
      const sel = window.getSelection();
      if (!sel.rangeCount) return;
      const range = sel.getRangeAt(0);
      const frag = range.extractContents();
      const node = document.createElement(tagName);
      node.appendChild(frag);
      range.insertNode(node);
      range.setStartAfter(node);
      range.collapse(true);
      sel.removeAllRanges();
      sel.addRange(range);
      context.invoke('editor.focus');
    },
    isSelectionInsideTag(tagName) {
      const sel = window.getSelection();
      if (!sel.rangeCount) return false;
      const range = sel.getRangeAt(0);
      const startTag = this.findClosestTag(range.startContainer, tagName);
      const endTag = this.findClosestTag(range.endContainer, tagName);
      return startTag && startTag === endTag;
    },
    removeTagAroundSelection(tagName) {
      const sel = window.getSelection();
      if (!sel.rangeCount) return;
      const range = sel.getRangeAt(0);
      const tagNode = this.findClosestTag(range.startContainer, tagName);
      if (tagNode) this.unwrapTag($(tagNode));
    },
    toggleTag(context, tagName) {
      const sel = window.getSelection();
      if (!sel.rangeCount) return;
      if (this.isSelectionInsideTag(tagName)) this.removeTagAroundSelection(tagName);
      else {
        const text = context.invoke('editor.getSelectedText');
        if (!text) return;
        this.wrapSelectionWithTag(context, tagName);
      }
    }
  };

  function createUpdateButtonState(context, tagName) {
    return function() {
      const sel = window.getSelection();
      let isActive = false;
      if (sel.rangeCount) {
        const range = sel.getRangeAt(0);
        isActive = !!TagUtils.findClosestTag(range.startContainer, tagName);
      }
      const $btn = context.layoutInfo.toolbar.find(`.note-btn-${tagName}`);
      $btn.toggleClass('active', isActive);
    };
  }

  window.summernoteManager.createTagToggleButton = function(tagName, options = {}) {
    const iconHtml = options.iconHtml || `<i class="fas fa-${tagName}"></i>`;
    const tooltip = options.tooltip || `Toggle ${tagName}`;

    return function(context) {
      const ui = $.summernote.ui;
      const $editable = context.layoutInfo.editable;
      const updateButtonState = createUpdateButtonState(context, tagName);

      const button = ui.button({
        contents: iconHtml,
        tooltip,
        className: `note-btn-${tagName}`,
        click() {
          TagUtils.toggleTag(context, tagName);
          updateButtonState();
        }
      });

      ['keyup', 'mouseup', 'change', 'nodechange'].forEach(evt =>
        context.invoke('events.on', evt, updateButtonState)
      );

      function onSelectionChange() {
        if (document.activeElement === $editable[0]) updateButtonState();
      }
      $editable.on('mouseup keyup', onSelectionChange);
      updateButtonState();

      return button.render();
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
