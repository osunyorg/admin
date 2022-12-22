# Mise à jour de l'algorithme de génération de clés

## Préambule

Avant Rails 7, le générateur de clés `ActiveSupport::KeyGenerator` utilisait l'algorithme SHA1 pour chiffrer des messages. Ce générateur est utilisé dans de multiples cas :
- Les cookies chiffrés (*encrypted cookies*)
- Les attributs chiffrés (*encrypted attributes*) (*Non utilisé par Osuny*)
- Les IDs signés des objets, notamment les blobs d'ActiveStorage
- Les ETags et les clés de cache

A partir de Rails 7, le générateur de clés utilise SHA256 comme algorithme par défaut, ce qui casse les messages listés précédemment. Pas de vrai problème pour les cookies, les Etags et les clés de cache. Cependant, chaque ID signé de blobs créé avec SHA1 est désormais invalide. Ce qui pose problème dans les blocs qui stockent cet ID signé dans le data JSON ou encore dans l'attribut `direct_url` des fichiers médias des sites web créés avec Osuny.

Pour les fichiers médias, une mise à jour des sites web va actualiser sans problème. Cependant, il faut un script pour mettre à jour les IDs signés dans les data JSON des blocs.

## Classe du *rotator*

### Définition

```ruby
class ActiveStorageKeyConverter
  def self.convert(legacy_signed_id)
    # Try to find blob with the un-modified legacy_signed_id
    blob = ActiveStorage::Blob.find_signed!(legacy_signed_id)
    legacy_signed_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    #
    key_generator = ActiveSupport::KeyGenerator.new(
      Rails.application.secrets.secret_key_base,
      iterations: 1000,
      hash_digest_class: OpenSSL::Digest::SHA1
    )
    key_generator = ActiveSupport::CachingKeyGenerator.new(key_generator)
    secret = key_generator.generate_key("ActiveStorage")
    verifier = ActiveSupport::MessageVerifier.new(secret)

    ActiveStorage::Blob.find_by_id(verifier.verify(legacy_signed_id, purpose: :blob_id)).try(:signed_id)
  end
end
```

### Utilisation

```ruby
ActiveStorageKeyConverter.convert legacy_signed_id
```

## Script pour les blocs

```ruby

def crawl(enumerable)
  case enumerable
  when Array
    enumerable.each do |item|
      crawl(item) if [Array, Hash].include?(item.class)
    end
  when Hash
    enumerable.keys.each do |key|
      if key == "signed_id"
        # Convert value
        enumerable[key] = ActiveStorageKeyConverter.convert(enumerable[key]) if key == "signed_id"
      elsif [Array, Hash].include?(enumerable[key].class)
        crawl(enumerable[key])
      end
    end
  end
end

Communication::Block.all.find_each { |block|
  crawl(block.data)
  block.save
}
```

## Sources

https://www.bigbinary.com/blog/how-we-upgraded-from-rails-6-to-rails-7
