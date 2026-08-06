# Charge toutes les catégories d'une université en une seule requête et remonte
# la chaîne de parents en mémoire, pour afficher un objet categorizable groupé
# par taxonomie sans le N+1 de la récursion `descendants_and_self`.
module Osuny
  module Category
    class Optimizer
      def initialize(about)
        @about = about
      end

      # { taxonomie => [catégories de about rattachées à cette taxonomie] },
      # ordonné, limité aux taxonomies qui ont au moins une catégorie utilisée.
      #
      # Exemple : { #<Taxonomy "Pays"> => [#<Category "France">, #<Category "Italie">] }
      def groups_by_taxonomy
        @groups_by_taxonomy ||= taxonomies.each_with_object({}) do |taxonomy, hash|
          used = about_categories_by_root[taxonomy]
          hash[taxonomy] = used if used.present?
        end
      end

      # Catégories de about qui sont elles-mêmes racines et non-taxonomies.
      #
      # Exemple : [#<Category "Actualité">, #<Category "Événement">]
      def free_categories
        @free_categories ||= about_categories.select { |c| c.parent_id.nil? && !c.is_taxonomy }
      end

      protected

      def about_categories
        @about_categories ||= @about.categories.includes(:localizations).to_a
      end

      def categories_by_id
        @categories_by_id ||= categories_class.where(university: university)
                                              .includes(:localizations)
                                              .index_by(&:id)
      end

      def categories_class
        @categories_class ||= @about.categories.klass
      end

      def university
        @university ||= @about.university
      end

      def taxonomies
        @taxonomies ||= categories_by_id.values
                                        .select { |c| c.parent_id.nil? && c.is_taxonomy }
                                        .sort_by(&:position)
      end

      def about_categories_by_root
        @about_categories_by_root ||= about_categories.group_by { |c| root_of(c) }
      end

      def root_of(category)
        current = category
        current = categories_by_id[current.parent_id] while current && current.parent_id
        current
      end
    end
  end
end
