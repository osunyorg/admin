module Communication::Website::WithAbouts
  extend ActiveSupport::Concern

  included do
    belongs_to  :about,
                polymorphic: true,
                optional: true

    def self.about_types
      [
        nil,
        Education::School.name,
        Research::Laboratory.name,
        Research::Journal.name
      ]
    end

  end

  def about_school?
    about_type == 'Education::School'
  end

  def about_journal?
    about_type == 'Research::Journal'
  end

  def about_laboratory?
    about_type == 'Research::Laboratory'
  end
  
end
