module User::WithRoles
  extend ActiveSupport::Concern

  # Encodage partagé par User (colonne `role`, cache du rôle le plus élevé) et
  # par User::Role (source de vérité, scopée). Les entiers sont figés : ils sont
  # stockés en base et utilisés par la migration de backfill.
  ROLES = {
    visitor: 0,
    contributor: 4,
    author: 5,
    teacher: 10,
    program_manager: 12,
    website_manager: 15,
    alumni_manager: 18,
    admin: 20,
    server_admin: 30
  }.freeze

  # Rôles qui se rattachent à une ou plusieurs cibles (sites / formations).
  # Les autres (visitor, teacher, admin, server_admin) sont globaux.
  SCOPED_ROLES = {
    'contributor'     => 'Communication::Website',
    'author'          => 'Communication::Website',
    'website_manager' => 'Communication::Website',
    'program_manager' => 'Education::Program'
  }.freeze

  included do
    attr_accessor :modified_by, :just_autopromoted

    # `role` reste une colonne : c'est un cache dénormalisé du rôle le plus élevé
    # détenu, qui pilote la hiérarchie (managed_roles, menu, auto-promotion, sync,
    # ciblage des messages…). La source de vérité des droits est `roles`.
    #
    # TODO(roles-cache): arbitrage d'équipe — garder ou supprimer ce cache ?
    # Le cache `role` évite de réécrire tout l'existant (prédicats d'enum
    # `server_admin?`/`visitor?`…, scopes SQL `where(role:)`, menu) mais impose
    # une synchronisation cache <-> `roles` (cf. les TODO(roles-cache) ci-dessous :
    # refresh_cached_role!, bootstrap_role_assignment, set_default_role, et les
    # callbacks de User::Role). Le supprimer = tout dériver de `roles`, au prix de
    # ~10-15 points d'appel à réécrire (extranet, sync, emergency_message, menu,
    # vues). À trancher ensemble.
    enum :role, ROLES

    has_many :roles,
             class_name: 'User::Role',
             dependent: :destroy,
             inverse_of: :user
    accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true

    # TODO(roles-cache): requête sur la colonne cache ; sans cache -> jointure sur `roles`.
    scope :for_role, -> (role, language = nil) { where(role: role) }

    before_validation :set_default_role, on: :create
    validate :assigned_roles_within_modifier_scope
    after_create :bootstrap_role_assignment
    after_create :set_university_autopromote_option, if: :just_autopromoted

    def self.roles_with_access_to_global_menu
      roles.keys - ['contributor', 'author', 'website_manager']
    end

    # Rôles effectifs (distincts), ordonnés du moins au plus privilégié.
    # L'ordre est volontaire : Ability fusionne les abilities dans cet ordre pour
    # que les règles du rôle le plus puissant soient déclarées en dernier et
    # l'emportent (CanCanCan évalue de la dernière règle définie à la première).
    def ability_roles
      roles.map(&:role).uniq.sort_by { |name| self.class.roles[name] }
    end

    # Détient ce rôle (sur n'importe quelle cible) ?
    def has_role?(name)
      roles.any? { |user_role| user_role.role == name.to_s }
    end

    # Cibles (records) attachées à un rôle donné.
    def scopes_for(role_name)
      roles.select { |user_role| user_role.role == role_name.to_s }
           .filter_map(&:scope)
    end

    # Crée (idempotente) et retourne une attribution de rôle. Le cache `role` est
    # rafraîchi par le callback after_save de User::Role.
    def grant_role!(role_name, scope: nil)
      roles.find_or_create_by!(
        role: role_name,
        scope_type: scope&.class&.base_class&.name,
        scope_id: scope&.id
      )
    end

    # TODO(roles-cache): toute cette méthode disparaît si on supprime le cache.
    # Recalcule la colonne cache `role` à partir des roles. Les entiers de
    # l'enum sont ordonnés par privilège croissant, donc MAX(role) = rôle le plus
    # élevé détenu (ou visitor si aucun).
    def refresh_cached_role!
      return unless persisted?
      new_value = roles.maximum(:role) || self.class.roles['visitor']
      update_column(:role, new_value) if read_attribute(:role) != new_value
    end

    # TODO(roles-cache): s'appuie sur la colonne cache `role` ; sans cache, calculer
    # le niveau le plus élevé depuis `roles`.
    def managed_roles
      User.roles.map do |role_name, role_id|
        next if role_id > User.roles[role]
        role_name
      end.compact
    end

    def managed_websites
      if has_role?('server_admin')
        Communication::Website.all
      elsif has_role?('admin')
        Communication::Website.where(university_id: university_id)
      elsif has_role?('website_manager')
        Communication::Website.where(id: scopes_for('website_manager').map(&:id))
      else
        Communication::Website.none
      end
    end

    def can_display_global_menu?
      (ability_roles & User.roles_with_access_to_global_menu).any?
    end

    protected

    # Empêche d'attribuer un rôle au-dessus de ce que le modificateur gère.
    def assigned_roles_within_modifier_scope
      return unless modified_by
      assigned = roles.reject(&:marked_for_destruction?).map(&:role).uniq
      forbidden = assigned - modified_by.managed_roles
      errors.add(:base, 'cannot assign a role above your own') if forbidden.any?
    end

    # TODO(roles-cache): pont cache -> `roles`. Sans cache, créer directement la
    # ligne `roles` par défaut (le concept de "matérialiser le cache" disparaît).
    # À la création, si aucune attribution n'a été fournie (création hors
    # formulaire : tout premier utilisateur, premier de l'université, seeds…),
    # on matérialise le rôle calculé par set_default_role en user_role.
    def bootstrap_role_assignment
      return if roles.any?
      return if visitor?
      grant_role!(role)
    end

    # TODO(roles-cache): écrit le cache `role` (puis bootstrap_role_assignment le
    # matérialise). Sans cache, cette règle d'auto-promotion créerait directement
    # la ligne `roles` adéquate.
    def set_default_role
      return if server_admin?
      if User.all.empty?
        self.role = :server_admin
      elsif !university.admin_already_auto_promoted? && university.users.not_server_admin.empty?
        self.role = :admin
        self.just_autopromoted = true
      end
    end

    def set_university_autopromote_option
      university.update(admin_already_auto_promoted: true)
    end

  end
end
