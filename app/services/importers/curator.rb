module Importers
  class Curator
    attr_reader :website, :user, :language, :url, :post, :l10n

    def initialize(website, user, language, url)
      @website = website
      @user = user
      @language = language
      @url = url
      unless slug_already_exists?
        create_post!
        create_localization!
        create_chapter!
        attach_image!
      end
    rescue
    end

    def already_imported?
      slug_already_exists?
    end

    def valid?
      @post&.valid? && @l10n&.valid? && @chapter&.valid?
    end

    protected

    def create_post!
      @post = website.posts.create(
        university: website.university,
        author: @user.person
      )
    end

    def create_localization!
      @l10n = @post.localizations.create(
        language_id: @language.id,
        title: page.title,
        slug: page.title.parameterize,
        published_at: Time.now
      )
    end

    def create_chapter!
      @chapter = @l10n.blocks.create(
        university: website.university,
        template_kind: :chapter,
        published: true,
        position: 0
      )
      text = Importers::Cleaner.clean_html("#{page.text}<p><a href=\"#{@url}\" target=\"_blank\">Source</a></p>")
      data = @chapter.data.deep_dup
      data['text'] = text
      @chapter.data = data
      @chapter.save
    end

    def attach_image!
      return if page.image.blank?
      ActiveStorage::Utils.attach_from_url(@l10n.featured_image, page.image)
    rescue
      puts "Attach image failed"
    end

    def slug
      @slug ||= page.title.parameterize
    end

    def slug_already_exists?
      Communication::Website::Post::Localization.where(
        website: website,
        language: language,
        slug: slug
      )
    end

    def page
      @page ||= Curation::Page.new(@url)
    end
  end
end