class Osuny::Evolution::Song
  PATH = 'app/services/osuny/evolution/songs.yml'

  def self.random
    data.sample
  end

  def self.data
    @@data ||= YAML.load_file(PATH)
  end
end