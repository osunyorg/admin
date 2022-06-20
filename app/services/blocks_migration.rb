class BlocksMigration

  def self.cleanup
    clean_cta
    clean_chapter
    clean_definitions
    clean_gallery
    clean_image
    clean_posts
    clean_pages
  end

  private

  def self.clean_cta
    Communication::Block.where(template_kind: 'call_to_action').each do |block|
      data = block['data']
      if data && data['url'].present?
        elements = []
        if data['url'].present?
          elements << { title: data['button'], url: data['url'], target_blank: data['target_blank']}
        end
        if data['url_secondary'].present?
          elements << { title: data['button_secondary'], url: data['url_secondary'], target_blank: data['target_blank_secondary']}
        end
        if data['url_tertiary'].present?
          elements << { title: data['button_tertiary'], url: data['url_tertiary'], target_blank: data['target_blank_tertiary']}
        end
        data['elements'] = elements
        data['alt'] = data['image_alt']
        data['credit'] = data['image_credit']
        block['data'] = data

        block.save
      end
    end
  end

  def self.clean_chapter
    Communication::Block.where(template_kind: 'chapter').each do |block|
      data = block['data']
      if data && (data['image_alt'].present? || data['image_credit'].present?)
        data['alt'] = data['image_alt']
        data['credit'] = data['image_credit']
        block['data'] = data
        block.save
      end
    end
  end

  def self.clean_definitions
    Communication::Block.where(template_kind: 'definitions').each do |block|
      data = block['data']
      if data && data['elements'].any? && data['elements'].first.has_key?('text')
        elements = []
        data['elements'].each do |elmt|
          elements << { title: elmt['title'], description: elmt['text'] }
        end
        data['elements'] = elements
        block['data'] = data
        block.save
      end
    end
  end

  def self.clean_gallery
    Communication::Block.where(template_kind: 'gallery').each do |block|
      data = block['data']
      if data && data['elements'].any? && data['elements'].first.has_key?('file')
        elements = []
        data['elements'].each do |elmt|
          elements << { alt: elmt['alt'], text: elmt['text'], credit: elmt['credit'], image: elmt['file'] }
        end
        data['elements'] = elements
        block['data'] = data
        block.save
      end
    end
  end

  def self.clean_image
    Communication::Block.where(template_kind: 'image').each do |block|
      data = block['data']
      if data && (data['image_alt'].present? || data['image_credit'].present?)
        data['alt'] = data['image_alt']
        data['credit'] = data['image_credit']
        block['data'] = data
        block.save
      end
    end
  end

  def self.clean_posts
    Communication::Block.where(template_kind: 'posts').each do |block|
      data = block['data']
      if data && data['kind'].present?
        data['mode'] = data['kind']
        block['data'] = data
        block.save
      end
    end
  end

  def self.clean_pages
    Communication::Block.where(template_kind: 'pages').each do |block|
      data = block['data']
      if data && data['kind'].present?
        data['mode'] = data['kind']
        block['data'] = data
        block.save
      end
    end
  end

end
