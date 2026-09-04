class Osuny::Evolution::Song
  PATH = 'app/services/osuny/evolution/songs.yml'

  def self.random
    YAML.load_file(PATH).sample
  end
end