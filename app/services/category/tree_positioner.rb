class Category::TreePositioner
  attr_reader :university, :klass, :website

  def initialize(university, klass, website: nil)
    @university = university
    @klass = klass
    @website = website
  end

  def execute
    update_position_in_tree(root_objects)
  end

  protected

  def root_objects
    unless @root_objects
      @root_objects = @klass.where(university: university).root.ordered
      @root_objects = @root_objects.where(website: website) if website
    end
    @root_objects
  end

  def update_position_in_tree(list, current_position = 1)
    list.each do |object|
      object.update_column :position_in_tree, current_position
      current_position += 1
      if object.children.any?
        child_objects = object.children.ordered
        current_position = update_position_in_tree(child_objects, current_position)
      end
    end
    current_position
  end
end