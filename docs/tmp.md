# Sauvegarde

## Sauvegarde de Person

    # AsIndirectObject
    after_save  :connect_to_websites
    after_touch :connect_to_websites 

        # WithDependencies
        after_save :clean_websites_if_necessary

    # Categorizable
    after_save :touch_after_categories_change, if: :saved_only_changed_categories?
    
    # Searchable
    after_save :save_search_data


## Sauvegarde de Person::Localization

    # AsLocalization
        
        # AsIndirectObject
        after_save  :connect_to_websites
        after_touch :connect_to_websites 

            # WithDependencies (via AsIndirectObject)
            after_save :clean_websites_if_necessary

    # HasGitFiles
    after_save  :generate_git_files
    after_touch :generate_git_files

    # Permalinkable
        # Sluggable
        before_validation :set_slug

    # Sanitizable
    before_validation :sanitize_fields



## Ordre idéal
1. Créer les connexions manquantes
-> là il a une liste de websites à jour
Pour chaque website
1. Identifier (dépendances récursives et références) les objets et générer leurs git_files
Pour les sites déconnectés
1. Mark_for_destruction les git_files
1. Clean le website pour enlever les traces inutiles

