/*global $ */
$(function () {
    'use strict';

    // Affiche la cible d'un rôle et n'y propose que les options du bon type.
    // Le type attendu est porté par l'option de rôle sélectionnée
    // (data-scope-type, vide = rôle global) ; chaque option de cible porte aussi
    // son type. Aucun mapping en dur : tout vient du HTML rendu.
    function refreshRow(row) {
        var $row = $(row),
            roleOption = $row.find('[data-user-role-role] option:selected')[0],
            type = roleOption && roleOption.getAttribute('data-scope-type'),
            $container = $row.find('[data-user-role-scope-container]'),
            $scope = $row.find('[data-user-role-scope]');

        if (!type) {
            $container.hide();
            return;
        }
        $container.show();

        var firstMatch = null;
        $scope.find('option').each(function () {
            var matches = this.getAttribute('data-scope-type') === type;
            this.hidden = this.disabled = !matches;
            if (matches && firstMatch === null) {
                firstMatch = this.value;
            }
        });
        // Si la cible courante n'est pas du bon type, prend la première valide.
        var selected = $scope.find('option:selected')[0];
        if (!selected || selected.getAttribute('data-scope-type') !== type) {
            $scope.val(firstMatch);
        }
    }

    if ($('body').is('.users-edit, .users-new, .users-update, .users-create')) {
        $('[data-user-role]').each(function () { refreshRow(this); });
        $(document).on('change', '[data-user-role-role]', function () {
            refreshRow($(this).closest('[data-user-role]'));
        });
        $('#user_roles').on('cocoon:after-insert', function (e, row) { refreshRow(row); });
    }
});
