module Communication::Website::WithBatchPublication
  extend ActiveSupport::Concern

  included do
    def force_publish!
      publish_authors!
      publish_categories!
      publish_pages!
      publish_posts!
    end
    handle_asynchronously :force_publish!, queue: 'default'

    def publish_authors!
      publish_objects(Communication::Website::Author, authors)
    end

    def publish_categories!
      publish_objects(Communication::Website::Category, categories)
    end

    def publish_pages!
      publish_objects_with_blobs(Communication::Website::Page, pages)
    end

    def publish_posts!
      publish_objects_with_blobs(Communication::Website::Post, posts)
    end

    protected

    def publish_objects(model, objects)
      begin
        had_callback = model.__callbacks[:save].find { |c| c.matches?(:after, :publish_to_github) }
        model.skip_callback(:save, :after, :publish_to_github) if had_callback
        return unless github.valid?
        objects.each do |object|
          github.add_to_batch path: object.github_path_generated,
                              previous_path: object.github_path,
                              data: object.to_jekyll
          yield(github, object) if block_given?
        end
        github.commit_batch "[#{model.name.demodulize}] Batch update from import"
      ensure
        model.set_callback(:save, :after, :publish_to_github) if had_callback
      end
    end

    def publish_objects_with_blobs(model, objects)
      publish_objects(model, objects) { |github, object|
        object.active_storage_blobs.each do |blob|
          blob.analyze unless blob.analyzed?
          github_path = "_data/media/#{blob.id[0..1]}/#{blob.id}.yml"
          data = ApplicationController.render(
            template: 'active_storage/blobs/jekyll',
            layout: false,
            assigns: { blob: blob }
          )
          github.add_to_batch(path: github_path, data: data)
        end
      }
    end
  end

end
