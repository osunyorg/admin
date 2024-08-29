module Osuny
  class Notes
    attr_reader :index

    def initialize
      @index = 1
    end

    def prepare(text)
      @text = text
      @parts = @text.split('<note>')
      @text_with_notes = ''
      replace_notes! if @parts.any?
      @text_with_notes.html_safe
    end

    protected

    def replace_notes!
      # Take what's before the first, even if it's empty
      @text_with_notes = @parts.shift
      # For each note, replace <note> and </note>
      @parts.each do |part|
        @text_with_notes += build_note(part)
        @index += 1
      end
    end

    # Part peut ressembler à ça :
    # Cf. Shoshana Zuboff, The Age of Surveillance Capitalism. The Fight for a Human Future at the New Frontier of Power, New York, Public Affairs, 2019.</note>. L’appétit de ces entreprises pour les données a aussi fait naître des craintes plus générales quant à leur pouvoir économique et politique. Les développements récents des intelligences artificielles (IA) dites « génératives » n’a fait qu’accentuer ces préoccupations : l’accès à des bases de données pléthoriques constitue, avec la capacité à déployer de colossales infrastructures de calcul, le fondement de la domination exercée par les <i>Big Tech </i>dans ce champ, vu comme stratégique pour les décennies à venir
    def build_note(part)
      note, text_after_note = part.split('</note>')
      label = I18n.t('notes.label', index: @index)
      html = '<span class="note" role="note">'
      html += "<span class=\"note__call\" role=\"button\" tabindex=\"0\" aria-expanded=\"false\" aria-label=\"#{label}\">#{@index}</span>"
      html += "<span class=\"note__content\" aria-hidden=\"true\" aria-live=\"polite\">#{note}</span>"
      html += "</span>"
      html += text_after_note
      html
    end
  end
end