class Licenses::CreativeCommons
  attr_reader :attribution, :commercial_use, :derivatives, :sharing

  def self.create_from_block(block)
    new block.template.creative_commons_attribution,
        block.template.creative_commons_commercial_use,
        block.template.creative_commons_derivatives,
        block.template.creative_commons_sharing
  end
  
  def initialize(attribution, commercial_use, derivatives, sharing)
    @attribution = attribution == 'true'
    @commercial_use = commercial_use == 'true'
    @derivatives = derivatives == 'true'
    @sharing = sharing == 'true'
  end

  def badge
    unless @badge
      @badge = 'cc-zero'
      if attribution
        @badge = 'by'
        @badge += '-nc' unless commercial_use
        if !derivatives
          @badge += '-nd'
        elsif !sharing
          @badge += '-sa'
        end
      end
    end
    @badge
  end

  def url
    unless @url
      if attribution
        @url = 'https://creativecommons.org/licenses/by'
        @url += '-nc' unless commercial_use
        @url += '-nd' unless derivatives
        if derivatives && !sharing
          @url += '-sa'
        end
        @url += '/4.0/'
      else
        @url = 'https://creativecommons.org/publicdomain/zero/1.0/'
      end
    end
    @url
  end

  def short_name
    unless @short_name
      if attribution
        @short_name = 'CC BY'
        @short_name += '-NC' if !commercial_use
        @short_name += '-ND' if !derivatives
        @short_name += '-SA' if derivatives && !sharing
        @short_name += ' 4.0'
      else
        @short_name = 'CC0 1.0 Universal'
      end
    end
    @short_name
  end

  def long_name
    unless @long_name
      if attribution
        @long_name = 'Attribution'
        @long_name += '-NonCommercial' if !commercial_use
        @long_name += '-NoDerivatives' if !derivatives
        @long_name += '-ShareAlike' if derivatives && !sharing
        @long_name += ' 4.0 International'
      else
        @long_name = 'CC0 1.0 Universal'
      end
    end
    @long_name
  end

  def name
    short_name
  end

  def to_s
    "#{name}"
  end

  def icons
    ['cc']
  end

end