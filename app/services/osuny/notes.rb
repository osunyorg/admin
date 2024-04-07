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
        # Cf. Shoshana Zuboff, The Age of Surveillance Capitalism. The Fight for a Human Future at the New Frontier of Power, New York, Public Affairs, 2019.</note>. L’appétit de ces entreprises pour les données a aussi fait naître des craintes plus générales quant à leur pouvoir économique et politique. Les développements récents des intelligences artificielles (IA) dites « génératives » n’a fait qu’accentuer ces préoccupations : l’accès à des bases de données pléthoriques constitue, avec la capacité à déployer de colossales infrastructures de calcul, le fondement de la domination exercée par les <i>Big Tech </i>dans ce champ, vu comme stratégique pour les décennies à venir
        note, text_after_note = part.split('</note>')
        @text_with_notes += '<span class="note">'
        @text_with_notes += "<span class=\"note__call\">#{@index}</span>"
        @text_with_notes += "<span class=\"note__content\">#{note}</span>"
        @text_with_notes += "</span>"
        @text_with_notes += text_after_note
        @index += 1
      end
    end
  end
end