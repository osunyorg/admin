module Importers
  class Base
    def self.execute(import)
      new(import)
    end

    def initialize(import)
      @import = import
      @university = import.university
      @errors = []
      analyze_xlsx
      manage_errors
      save
    end

    protected

    def xlsx
      return @xlsx if defined?(@xlsx)
      @xlsx = Roo::Spreadsheet.open(@import.file.url, extension: :xlsx)
      begin @xlsx.info
        # ensure we can access basic infos on the excel file. If not the file was incorrect
      rescue
        add_error("Unable to analyse the xlsx file", 0)
        @xlsx = nil
      end
    end

    def analyze_xlsx
      xlsx.each.with_index do |hash, index|
        next if index == 0 # Column labels
        analyze_hash(hash, index)
      end if xlsx
    end

    def analyze_hash(hash, index)
      raise NotImplementedError
    end

    def add_error(error, line)
      @errors << { line: line, error: error }
    end

    def manage_errors
      if @errors.count > 0
        @import.status = :finished_with_errors
        @import.processing_errors = @errors
      else
        @import.status = :finished
      end
    end

    def save
      @import.number_of_lines = xlsx.nil? ? 0 : xlsx.count - 1
      @import.save
    end
  end

end
