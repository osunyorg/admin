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
        @url = 'http://creativecommons.org/publicdomain/zero/1.0/'
      end
    end
    @url
  end

end