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

  def identifier
    @identifier ||= attribution ? identifier_with_attribution
                                : 'cc-zero'
  end

  def url
    @url ||= attribution  ? "https://creativecommons.org/licenses/#{identifier}/4.0/"
                          : 'https://creativecommons.org/publicdomain/zero/1.0/'
  end

  def label
    @label ||= attribution  ? 'CC0 1.0 Universal'
                            : label_with_attribution
  end

  def to_s
    "#{label}"
  end

  def icons
    @icons = ['cc']
    if !attribution
      @icons << 'zero'
    else
      @icons << 'by'
      @icons << 'nc' if !commercial_use
      @icons << 'nd' if !derivatives
      @icons << 'sa' if derivatives && !sharing
    end
    @icons
  end

  protected

  def identifier_with_attribution
    identifier = 'by'
    identifier += '-nc' if !commercial_use
    identifier += '-nd' if !derivatives
    identifier += '-sa' if derivatives && !sharing
    identifier
  end

  def label_with_attribution
    label = 'CC BY'
    label += '-NC' if !commercial_use
    label += '-ND' if !derivatives
    label += '-SA' if derivatives && !sharing
    label += ' 4.0'
    label
  end

end