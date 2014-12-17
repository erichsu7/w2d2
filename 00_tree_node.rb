class PolyTreeNode

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def parent=(new_parent)
    old_parent = @parent
    old_parent.children.delete(self) if old_parent
    @parent = new_parent

    unless @parent.nil? || new_parent.children.include?(self)
      new_parent.children << self
    end
  end

  def add_child(child_node)
    child_node.parent=(self)
  end

  def remove_child(child_node)
    child_node.parent = nil
    raise "That is not your child!" if !@children.include?(child_node)
  end

  def dfs(target_value)

    if @value == target_value
      return self
    else
      @children.each do |child|
        dfs_on_child = child.dfs(target_value)
        return dfs_on_child if dfs_on_child
      end
    end

   nil
  end

  def bfs(target_value)
    queue = [self]

    until queue.empty?
      first_node = queue.shift

      return first_node if first_node.value == target_value
      queue += first_node.children
    end
  end

  def trace_path_back(root_node)
    #self = target_node
    queue = [self]
    path = [self]

    until queue.empty?
      current_node = queue.shift
      unless current_node.parent.nil?
        path << current_node.parent
        queue << current_node.parent
      end

    end
    path.reverse
  end

end
  #   until path.last.value != root_node.value
  #     path << parent.trace_path_back(root_node)
  #
  #   path.reverse


  # def trace_path_back(node)
  #   current_node = self
  #   results = []
  #   until current_node == node
  #     p current_node.value
  #     results << current_node.value
  #     current_node = current_node.parent
  #   end
  #   results << current_node.parent.value
  # end
