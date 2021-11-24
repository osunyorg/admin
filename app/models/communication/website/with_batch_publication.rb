module Communication::Website::WithBatchPublication
  extend ActiveSupport::Concern

  included do
    def force_publish!
      publish_authors!
      publish_categories!
      publish_pages!
      publish_posts!
      publish_menus!
      publish_school! if about.is_a?(Education::School)
      publish_journal! if about.is_a?(Research::Journal)
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

    def publish_menus!
      publish_objects(Communication::Website::Menu, menus)
    end

    def publish_school!
      github.publish(path: about.github_path, commit: "[School] Save #{about.to_s}", data: about.to_jekyll)
      publish_shared_objects(Education::Program, about.programs)
      publish_shared_objects(Education::Teacher, about.teachers)
    end

    def publish_journal!
      github.publish(path: about.github_path, commit: "[Journal] Save #{about.to_s}", data: about.to_jekyll)
      publish_shared_objects(Research::Article, about.articles)
      publish_shared_objects(Research::Volume, about.volumes)
    end

    protected

    def publish_objects(model, objects)
      return if objects.empty?
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

    def publish_shared_objects(model, objects)
      return if objects.empty?
      begin
        had_callback = model.__callbacks[:save].find { |c| c.matches?(:after, :publish_to_every_websites) }
        model.skip_callback(:save, :after, :publish_to_every_websites) if had_callback
        return unless github.valid?
        clean_model_name = model.name.demodulize
        objects.each do |object|
          if object.respond_to?(:github_path)
            github_path = object.github_path
          else
            root_folder = "_#{clean_model_name.pluralize.underscore}"
            github_path = "#{root_folder}/#{object.id}.md"
          end
          github.add_to_batch(path: github_path, data: object.to_jekyll)
        end
        github.commit_batch "[#{clean_model_name}] Batch update from import"
      ensure
        model.set_callback(:save, :after, :publish_to_every_websites) if had_callback
      end
    end
  end

end
