class Migrations::Organizations
  def self.migrate
    University.find_each do |university|
      locations = university.locations
      schools = university.schools
      laboratories = university.laboratories
      next if schools.none? && laboratories.none? && locations.none?
      puts university
      puts '--- locations'
      locations.each do |location|
        puts location.original_localization
      end
      puts '--- schools'
      schools.each do |school|
        puts school.original_localization
      end
      puts '--- laboratories'
      laboratories.each do |laboratory|
        puts laboratory.original_localization
      end
    end
  end
end