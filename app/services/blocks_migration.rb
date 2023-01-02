require 'communication/block/template/base'
require 'communication/block/template/chapter'

class BlocksMigration

  def self.cleanup
    Communication::Website::Post.find_each do |post|
      next if post.text.blank?
      puts "#{post} (#{post.id}, #{post.university})"
      if post.blocks.none?
        puts "  migrating"
        block = post.blocks.create university: post.university, template_kind: :chapter
        data = block.data
        data['text'] = post.text.to_html
        block.data = data
        block.save
      end
    end
  end
end
