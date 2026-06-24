/*global $ */
// Affiche la cible d'un rôle et n'y propose que les options du bon type.
// Le type attendu est porté par l'option de rôle sélectionnée
// (data-scope-type, vide = rôle global) ; chaque option de cible porte aussi
// son type. Aucun mapping en dur : tout vient du HTML rendu.
window.osuny.userRoles = {
    init: function () {
        'use strict';
        var rows,
            i;
        if (!document.body.matches('.users-edit, .users-new, .users-update, .users-create')) {
            return;
        }
        rows = document.querySelectorAll('[data-user-role]');
        for (i = 0; i < rows.length; i += 1) {
            this.refreshRow(rows[i]);
        }
        this.initEvents();
    },

    initEvents: function () {
        'use strict';
        document.addEventListener('change', this.onChangeRole.bind(this));
        $('#user_roles').on('cocoon:after-insert', this.onAfterInsert.bind(this));
    },

    onChangeRole: function (event) {
        'use strict';
        var roleSelect = event.target.closest('[data-user-role-role]');
        if (roleSelect !== null) {
            this.refreshRow(roleSelect.closest('[data-user-role]'));
        }
    },

    onAfterInsert: function (event, row) {
        'use strict';
        this.refreshRow(row[0]);
    },

    refreshRow: function (row) {
        'use strict';
        var roleSelect = row.querySelector('[data-user-role-role]'),
            roleOption = roleSelect && roleSelect.options[roleSelect.selectedIndex],
            type = roleOption && roleOption.getAttribute('data-scope-type'),
            container = row.querySelector('[data-user-role-scope-container]'),
            scope = row.querySelector('[data-user-role-scope]');

        if (!type) {
            container.classList.add('d-none');
            return;
        }
        container.classList.remove('d-none');
        this.filterScopeOptions(scope, type);
    },

    // N'affiche que les cibles du bon type et, si la cible courante n'est pas
    // du bon type, sélectionne la première valide.
    filterScopeOptions: function (scope, type) {
        'use strict';
        var options = scope.options,
            firstMatch = null,
            selected = scope.options[scope.selectedIndex],
            matches,
            i;

        for (i = 0; i < options.length; i += 1) {
            matches = options[i].getAttribute('data-scope-type') === type;
            options[i].hidden = !matches;
            options[i].disabled = !matches;
            if (matches && firstMatch === null) {
                firstMatch = options[i].value;
            }
        }

        if (!selected || selected.getAttribute('data-scope-type') !== type) {
            scope.value = firstMatch;
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.userRoles.init();
});
