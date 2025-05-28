(function($) {
  window.summernoteManager = window.summernoteManager || {};

  var TagUtils = {
    findClosestTag: function(node, tagName) {
      tagName = tagName.toLowerCase();
      while (node && node.nodeType !== 9) {
        if (node.nodeType === 1 && node.tagName.toLowerCase() === tagName) return node;
        node = node.parentNode;
      }
      return null;
    },
    unwrapTag: function($tag) { $tag.contents().unwrap(); },
    wrapSelectionWithTag: function(context, tagName) {
      var sel = window.getSelection();
      if (!sel.rangeCount) return;
      var range = sel.getRangeAt(0);
      var frag = range.extractContents();
      var node = document.createElement(tagName);
      node.appendChild(frag);
      range.insertNode(node);
      range.setStartAfter(node);
      range.collapse(true);
      sel.removeAllRanges();
      sel.addRange(range);
      context.invoke('editor.focus');
    },
    isSelectionInsideTag: function(tagName) {
      var sel = window.getSelection();
      if (!sel.rangeCount) return false;
      var range = sel.getRangeAt(0);
      var startTag = this.findClosestTag(range.startContainer, tagName);
      var endTag = this.findClosestTag(range.endContainer, tagName);
      return startTag && startTag === endTag;
    },
    removeTagAroundSelection: function(tagName) {
      var sel = window.getSelection();
      if (!sel.rangeCount) return;
      var range = sel.getRangeAt(0);
      var tagNode = this.findClosestTag(range.startContainer, tagName);
      if (tagNode) this.unwrapTag($(tagNode));
    },
    toggleTag: function(context, tagName) {
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

  function createUpdateButtonState(context, tagName) {
    return function() {
      var sel = window.getSelection();
      var isActive = false;
      if (sel.rangeCount) {
        var range = sel.getRangeAt(0);
        isActive = !!TagUtils.findClosestTag(range.startContainer, tagName);
      }
      var $btn = context.layoutInfo.toolbar.find('.note-btn-' + tagName);
      $btn.toggleClass('active', isActive);
    };
  }

  window.summernoteManager.createTagToggleButton = function(tagName, options) {
    options = options || {};
    var iconHtml = options.iconHtml || '<i class="fas fa-' + tagName + '"></i>';
    var tooltip = options.tooltip || 'Toggle ' + tagName;

    return function(context) {
      var ui = $.summernote.ui;
      var $editable = context.layoutInfo.editable;
      var updateButtonState = createUpdateButtonState(context, tagName);

      var button = ui.button({
        contents: iconHtml,
        tooltip: tooltip,
        className: 'note-btn-' + tagName,
        click: function() {
          TagUtils.toggleTag(context, tagName);
          updateButtonState();
        }
      });

      var events = ['keyup', 'mouseup', 'change', 'nodechange'];
      for (var i = 0; i < events.length; i++) {
        context.invoke('events.on', events[i], updateButtonState);
      }

      $editable.on('mouseup keyup', function() {
        if (document.activeElement === $editable[0]) updateButtonState();
      });

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
