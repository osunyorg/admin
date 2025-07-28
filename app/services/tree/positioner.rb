class Tree::Positioner
  attr_reader :university, :klass, :website
  attr_accessor :position

  def initialize(university, klass, website: nil)
    @university = university
    @klass = klass
    @website = website
  end

  def execute
    position = 1
    update_position_in_tree(root_objects)
  end

  protected

  def root_objects
    unless @root_objects
      @root_objects = klass.where(university: university).root.ordered
      @root_objects = @root_objects.where(website: website) if website
    end
    @root_objects
  end

  def update_position_in_tree(list)
    list.each do |object|
      object.update_column :position_in_tree, position
      position += 1
      if object.children.any?
        update_position_in_tree(object.children.ordered)
      end
    end
  end
end
