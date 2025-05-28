(function($) {
  window.summernoteManager = window.summernoteManager || {};

  function findClosestNote(node) {
    while (node && node.nodeType !== 9) {
      if (node.nodeType === 1 && node.tagName.toLowerCase() === 'note') {
        return node;
      }
      node = node.parentNode;
    }
    return null;
  }

  function unwrapNote($note) {
    $note.contents().unwrap();
  }

  function wrapSelectionWithNote(context) {
    var selection = window.getSelection();
    if (!selection.rangeCount) return;
    var range = selection.getRangeAt(0);

    var frag = range.extractContents();
    var noteNode = document.createElement('note');
    noteNode.appendChild(frag);

    range.insertNode(noteNode);

    // Place le curseur après le <note>
    range.setStartAfter(noteNode);
    range.collapse(true);

    selection.removeAllRanges();
    selection.addRange(range);

    context.invoke('editor.focus');
  }

  function isSelectionInsideNote() {
    var selection = window.getSelection();
    if (!selection.rangeCount) return false;
    var range = selection.getRangeAt(0);
    var startNote = findClosestNote(range.startContainer);
    var endNote = findClosestNote(range.endContainer);

    return startNote && startNote === endNote;
  }

  function removeNoteAroundSelection() {
    var selection = window.getSelection();
    if (!selection.rangeCount) return;
    var range = selection.getRangeAt(0);

    var noteNode = findClosestNote(range.startContainer);
    if (noteNode) {
      unwrapNote($(noteNode));
    }
  }

  function toggleNote(context) {
    var selection = window.getSelection();
    if (!selection.rangeCount) return;

    if (isSelectionInsideNote()) {
      removeNoteAroundSelection();
    } else {
      var text = context.invoke('editor.getSelectedText');
      if (!text) return; // Rien à entourer
      wrapSelectionWithNote(context);
    }
  }

  function updateButtonState(context) {
    var selection = window.getSelection();
    var isActive = false;

    if (selection.rangeCount) {
      var range = selection.getRangeAt(0);
      var noteNode = findClosestNote(range.startContainer);
      isActive = !!noteNode;
    }

    var $button = context.layoutInfo.toolbar.find('.note-btn-note');
    $button.toggleClass('active', isActive);
  }

  window.summernoteManager.noteButton = function(context) {
    var ui = $.summernote.ui;
    var $editable = context.layoutInfo.editable;

    var button = ui.button({
      contents: '<i class="fas fa-note-sticky"></i>',
      tooltip: 'Note (beta)',
      className: 'note-btn-note',
      click: function() {
        toggleNote(context);
        updateButtonState(context);
      }
    });

    ['keyup', 'mouseup', 'change', 'nodechange'].forEach(function(event) {
      context.invoke('events.on', event, function() {
        updateButtonState(context);
      });
    });

    // Écoute locale sur l'édition (uniquement cet éditeur)
    function onSelectionChange() {
      if (document.activeElement === $editable[0]) {
        updateButtonState(context);
      }
    }

    $editable.on('mouseup keyup', onSelectionChange);

    // Mise à jour initiale
    updateButtonState(context);

    return button.render();
  };
})(jQuery);
