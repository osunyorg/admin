// Data and methods for the inner Vue app that drives a single block's edit form.
// Extracted verbatim from the (now-removed) inline script in blocks/edit.html.erb.
// The form markup still comes from the server: this runtime just powers the
// v-model bindings already present in the 31 template partials + 35 component
// partials. It relies on the admin page globals: $, window.SUMMERNOTE_CONFIGS,
// window.summernoteManager, window.codemirrorManager, CodeMirror,
// ActiveStorage (for direct uploads, loaded via admin.js), document.initLanguageTool.

// Inlined from the old app/assets/javascripts/vue/direct-upload-controller.js,
// which used to hang off window.Vue (populated by vue.global.prod.js loaded via
// `javascript_include_tag 'vue'` inside blocks/edit.html.erb before this branch).
// That global Vue build is gone — Vue 3 is bundled into vue-apps.js via esbuild —
// so we keep the DirectUpload wrapper local here instead.
function DirectUploadController(input, file, url) {
  this.input = input;
  this.file = file;
  this.url = url;
  this.directUpload = new window.ActiveStorage.DirectUpload(this.file, this.url, this);
  this.dispatch('initialize');
}

DirectUploadController.prototype.start = function start(callback) {
  this.directUpload.create((error, blob) => {
    this.dispatch('end');
    if (error) {
      // eslint-disable-next-line no-console
      console.error(error);
    } else {
      callback(blob);
    }
  });
};

DirectUploadController.prototype.uploadRequestDidProgress = function uploadRequestDidProgress(event) {
  const progress = (event.loaded / event.total) * 100;
  if (progress) {
    this.dispatch('progress', { progress });
  }
};

DirectUploadController.prototype.dispatch = function dispatch(name, detail) {
  const eventName = `direct-upload:${name}`;
  const eventDetail = detail || {};
  eventDetail.file = this.file;
  eventDetail.id = this.directUpload.id;
  const event = document.createEvent('Event');
  event.initEvent(eventName, true, true);
  event.detail = eventDetail;

  // Temporarily un-disable the input so the bubbling event reaches the
  // document-level progress listeners installed by
  // ensureDirectUploadProgressListeners(), then restore its disabled state.
  const { disabled } = this.input;
  this.input.disabled = false;
  this.input.dispatchEvent(event);
  this.input.disabled = disabled;

  return event;
};

DirectUploadController.prototype.directUploadWillStoreFileWithXHR = function directUploadWillStoreFileWithXHR(xhr) {
  xhr.upload.addEventListener('progress', this.uploadRequestDidProgress.bind(this));
};

export function editorFormData(payload) {
  return {
    directUpload: {
      url: payload.directUploadUrl,
      blobUrlTemplate: payload.blobUrlTemplate,
    },
    data: payload.data,
    defaultElement: payload.defaultElement,
  };
}

export const editorFormMethods = {
  onMultipleFileImageChange(event, key) {
    const files = event.target.files || event.dataTransfer.files;
    if (!files.length) return;
    let index = 0;
    for (let i = 0; i < files.length; i += 1) {
      index = this.data.elements.length;
      this.data.elements.push(JSON.parse(JSON.stringify(this.defaultElement)));
      this.uploadFile(event.target, files[i], this.data.elements[index], key);
    }
  },

  onFileImageChange(event, object, key) {
    const files = event.target.files || event.dataTransfer.files;
    if (!files.length) return;
    this.uploadFile(event.target, files[0], object, key);
  },

  uploadFile(input, file, object, key) {
    const size = Math.round(file.size / 1024 / 1024);
    let sizeLimit = window.osunyConfig?.defaultImageMaxSize || (10 * 1024 * 1024);
    if (input.hasAttribute('data-size-limit')) {
      sizeLimit = parseInt(input.getAttribute('data-size-limit'), 10);
    }
    const sizeLimitMo = Math.round(sizeLimit / 1024 / 1024);
    if (file.size > sizeLimit) {
      alert(`File is too big (${size} Mo > ${sizeLimitMo} Mo)`);
      return;
    }
    const controller = new DirectUploadController(input, file, this.directUpload.url);
    controller.start((blob) => {
      object[key] = {
        id: blob.id,
        signed_id: blob.signed_id,
        filename: blob.filename,
      };
    });
  },

  deleteElement(element) {
    const index = this.data.elements.indexOf(element);
    this.data.elements.splice(index, 1);
    setTimeout(() => this.refreshSummernotes(), 500);
  },

  getFileUrl(signed_id, filename) {
    return this.directUpload.blobUrlTemplate
      .replace(':signed_id', signed_id)
      .replace(':filename', filename);
  },

  getImageUrl(data) {
    const parts = data.filename.split('.');
    const extension = parts[parts.length - 1];
    return this.getFileUrl(data.signed_id, `image_1024x.${extension}`);
  },

  handleSummernotes() {
    const $elements = window.$('.summernote-vue:not(.is-initialized)');
    $elements.each((index) => {
      const el = $elements.get(index);
      el.classList.add('is-initialized');
      this.initSummernote(el);
    });
  },

  refreshSummernotes() {
    const summernotes = document.getElementsByClassName('summernote-vue');
    for (const textarea of summernotes) {
      textarea.classList.remove('is-initialized');
      window.$(textarea).summernote('destroy');
    }
    this.handleSummernotes();
  },

  handleCodemirrors() {
    const $elements = window.$('.codemirror-vue');
    $elements.each((index) => {
      this.initCodemirror($elements.get(index));
    });
  },

  initSummernote(element) {
    const $ = window.$;
    const config = element.getAttribute('data-summernote-config') || 'default';
    const onChange = (content) => {
      element.value = content;
      element.dispatchEvent(new Event('input'));
    };
    const onFocus = function () {
      $(this).parent().children('.note-editor').removeClass('note-editor--defocusing');
      $(this).parent().children('.note-editor').addClass('note-editor--focus');
    };
    const onBlur = function () {
      const editor = $(this).parent().children('.note-editor');
      editor.addClass('note-editor--defocusing');
      setTimeout(() => {
        const defocusing = editor.hasClass('note-editor--defocusing');
        const codeview = editor.hasClass('codeview');
        if (defocusing && !codeview) editor.removeClass('note-editor--focus');
      }, 1000);
    };
    const onCursor = function (event) {
      const node = event.target.nodeName;
      const $editor = $(this).parent().children('.note-editor');
      const $btn = $editor.find('.note-btn-note');
      if (node === 'NOTE') $btn.addClass('active');
      else $btn.removeClass('active');
    };

    $(element).summernote({
      lang: element.getAttribute('data-summernote-locale') || undefined,
      toolbar: window.SUMMERNOTE_CONFIGS[config].toolbar,
      followingToolbar: true,
      disableDragAndDrop: true,
      codemirror: window.codemirrorManager.defaultConfig(),
      buttons: {
        q: window.summernoteManager.qButton,
        note: window.summernoteManager.noteButton,
      },
      callbacks: {
        onPaste: window.SUMMERNOTE_CONFIGS[config].callbacks.onPaste,
        onChange,
        onChangeCodeview: onChange,
        onBlur,
        onFocus,
        onMousedown: onCursor,
        onKeydown: onCursor,
      },
    });
  },

  initCodemirror(element) {
    const config = window.codemirrorManager.defaultConfig();
    const mode = element.getAttribute('data-codemirror-mode');
    config.mode = mode;
    const editor = window.CodeMirror.fromTextArea(element, config);
    editor.on('change', (instance) => {
      element.value = instance.getValue();
      element.dispatchEvent(new Event('input'));
    });
  },
};

// One-time global listeners for ActiveStorage progress bars.
// Safe to call multiple times — idempotent via a flag.
export function ensureDirectUploadProgressListeners() {
  if (window.__osunyDirectUploadListenersReady) return;
  window.__osunyDirectUploadListenersReady = true;

  window.addEventListener('direct-upload:initialize', (event) => {
    event.target.insertAdjacentHTML(
      'afterend',
      '<progress value="0" max="100" style="width: 100%;"></progress>'
    );
  });
  window.addEventListener('direct-upload:progress', (event) => {
    const bar = event.target.parentNode.querySelector('progress');
    if (bar) bar.value = event.detail.progress;
  });
  window.addEventListener('direct-upload:end', (event) => {
    const bar = event.target.parentNode.querySelector('progress');
    if (bar) bar.parentNode.removeChild(bar);
  });
}
