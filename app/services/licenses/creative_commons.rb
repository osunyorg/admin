class Licenses::CreativeCommons
  attr_reader :attribution, :commercial_use, :derivatives, :sharing

  def self.create_from_block(block)
    new block.template.creative_commons_attribution,
        block.template.creative_commons_commercial_use,
        block.template.creative_commons_derivatives,
        block.template.creative_commons_sharing
  end
  
  def initialize(attribution, commercial_use, derivatives, sharing)
    @attribution = attribution
    @commercial_use = commercial_use
    @derivatives = derivatives
    @sharing = sharing
  end

  def badge
    unless @badge
      @badge = 'cc-zero'
      if attribution == 'true'
        @badge = 'by'
        @badge += '-nc' if commercial_use == 'false'
        if derivatives == 'false'
          @badge += '-nd'
        elsif sharing == 'false'
          @badge += '-sa'
        end
      end
    end
    @badge
  end

end