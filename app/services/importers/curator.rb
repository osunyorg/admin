module Importers
  class Curator
    attr_reader :website, :user, :language, :url, :university, :post, :l10n, :chapter

    def initialize(website, user, language, url)
      @website = website
      @user = user
      @language = language
      @url = url
      @university = website.university
      unless slug_already_exists?
        create_post!
        set_post_author!
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
      # if nothing exists valid? is "nil" and not "false"
      (post&.valid? && l10n&.valid? && chapter&.valid?) == true
    end

    protected

    def create_post!
      @post = website.posts.create(
        university: university
      )
    end

    def set_post_author!
      post.authors << user.person if user.person.present?
    end

    def create_localization!
      @l10n = post.localizations.create(
        language_id: @language.id,
        title: curated_page.title,
        slug: curated_page.title.parameterize,
        published_at: Time.now
      )
    end

    def create_chapter!
      @chapter = l10n.blocks.create(
        university: website.university,
        template_kind: :chapter,
        published: true,
        position: 0
      )
      text = Importers::Cleaner.clean_html("#{curated_page.text}<p><a href=\"#{url}\" target=\"_blank\">Source</a></p>")
      data = chapter.data.deep_dup
      data['text'] = text
      chapter.data = data
      chapter.save
    end

    def attach_image!
      return if curated_page.image.blank?
      media = Communication::Media.find_or_create_from_url(curated_page.image, university_id: l10n.university_id, origin: :curator)
      l10n.set_featured_media!(id: media.id, language: language)
    rescue
      puts "Attach image failed"
    end

    def slug
      @slug ||= curated_page.title.parameterize
    end

    def slug_already_exists?
      Communication::Website::Post::Localization.where(
        website: website,
        language: language,
        slug: slug
      ).any?
    end

    def curated_page
      @curated_page ||= Curation::Page.new(url)
    end
  end
end