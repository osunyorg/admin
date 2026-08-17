class Migrations::Organizations
  def self.migrate
    puts 'Identifying organizations to merge'
    University.find_each do |university|
      locations = university.locations
      schools = university.schools
      laboratories = university.laboratories
      next if schools.none? && laboratories.none? && locations.none?
      puts university
      puts '--- locations'
      locations.each do |location|
        puts "#{location.original_localization} — #{location.id}"
      end
      puts '--- schools'
      schools.each do |school|
        puts "#{school.original_localization} — #{school.id}"
      end
      puts '--- laboratories'
      laboratories.each do |laboratory|
        puts "#{laboratory.original_localization} — #{laboratory.id}"
      end
    end
  end
end