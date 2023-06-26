window.osuny.contentEditor.Element = function Element (container) {
    'use strict';
    this.container = container;
    this.kind = this.container.dataset.kind;
    this.id = this.container.dataset.id;
    this.childrenList = this.container.querySelector('.js-content-editor-sortable-container');
};


window.osuny.contentEditor.Element.prototype.getChildrenIds = function () {
    'use strict';
    var children = [],
        child,
        i;
    if (this.childrenList === null) {
        return children;
    }
    for (i = 0; i < this.childrenList.children.length; i += 1) {
        child = this.childrenList.children[i];
        children.push(child.dataset.id);
    }
    return children;
};
