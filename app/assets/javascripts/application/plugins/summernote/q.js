(function($) {
  window.summernoteManager = window.summernoteManager || {};

  function findClosestQ(node) {
    while (node && node.nodeType !== 9) {
      if (node.nodeType === 1 && node.tagName.toLowerCase() === 'q') {
        return node;
      }
      node = node.parentNode;
    }
    return null;
  }

  function unwrapQ($q) {
    $q.contents().unwrap();
  }

  function wrapSelectionWithQ(context) {
    var selection = window.getSelection();
    if (!selection.rangeCount) return;
    var range = selection.getRangeAt(0);

    var frag = range.extractContents();
    var qNode = document.createElement('q');
    qNode.appendChild(frag);

    range.insertNode(qNode);

    range.setStartAfter(qNode);
    range.collapse(true);

    selection.removeAllRanges();
    selection.addRange(range);

    context.invoke('editor.focus');
  }

  function insertEmptyQ(context) {
    var selection = window.getSelection();
    if (!selection.rangeCount) return;
    var range = selection.getRangeAt(0);

    var qNode = document.createElement('q');
    var zwsp = document.createTextNode('\u200B');
    qNode.appendChild(zwsp);

    range.insertNode(qNode);

    range.setStart(zwsp, 0);
    range.setEnd(zwsp, 0);

    selection.removeAllRanges();
    selection.addRange(range);

    context.invoke('editor.focus');
  }

  function isSelectionInsideQ() {
    var selection = window.getSelection();
    if (!selection.rangeCount) return false;
    var range = selection.getRangeAt(0);
    var startQ = findClosestQ(range.startContainer);
    var endQ = findClosestQ(range.endContainer);

    return startQ && startQ === endQ;
  }

  function removeQAroundSelection() {
    var selection = window.getSelection();
    if (!selection.rangeCount) return;
    var range = selection.getRangeAt(0);

    var qNode = findClosestQ(range.startContainer);
    if (qNode) {
      unwrapQ($(qNode));
    }
  }

  function toggleQ(context) {
    var selection = window.getSelection();
    if (!selection.rangeCount) return;
    var range = selection.getRangeAt(0);

    if (range.collapsed) {
      if (findClosestQ(range.startContainer)) {
        removeQAroundSelection();
      } else {
        insertEmptyQ(context);
      }
    } else {
      if (isSelectionInsideQ()) {
        removeQAroundSelection();
      } else {
        wrapSelectionWithQ(context);
      }
    }
  }

  function updateButtonState(context) {
    var selection = window.getSelection();
    var isActive = false;

    if (selection.rangeCount) {
      var range = selection.getRangeAt(0);
      var qNode = findClosestQ(range.startContainer);
      isActive = !!qNode;
    }

    var $button = context.layoutInfo.toolbar.find('.note-btn-quote');
    $button.toggleClass('active', isActive);
  }

  window.summernoteManager.qButton = function(context) {
    var ui = $.summernote.ui;
    var $editable = context.layoutInfo.editable;

    var button = ui.button({
      contents: '<i class="fas fa-quote-left"></i>',
      tooltip: 'Citation courte',
      className: 'note-btn-quote',
      click: function() {
        toggleQ(context);
        updateButtonState(context);
      }
    });

    ['keyup', 'mouseup', 'change', 'nodechange'].forEach(function(event) {
      context.invoke('events.on', event, function() {
        updateButtonState(context);
      });
    });

    // Écoute locale sur l'édition (uniquement dans cet éditeur)
    function onSelectionChange() {
      // Vérifie si le focus est bien dans cet éditeur avant update
      if (document.activeElement === $editable[0]) {
        updateButtonState(context);
      }
    }

    $editable.on('mouseup keyup', onSelectionChange);

    // Optionnel : nettoyage si Summernote off, mais pas toujours accessible
    // context.invoke('events.on', 'summernote.destroy', function() {
    //   $editable.off('mouseup keyup', onSelectionChange);
    // });

    // Mise à jour initiale
    updateButtonState(context);

    return button.render();
  };
})(jQuery);
