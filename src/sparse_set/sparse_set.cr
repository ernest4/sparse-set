class SparseSetItem
  # TODO:...
end

class SparseSet
  def initialize
    @dense_list = [] of SparseSetItem
    # @sparse_list = [] of UInt32
    @sparse_hash = {} of Uint32 => UInt32
    @element_count = 0 # No elements initially
  end

  def get(id : UInt32) : SparseSetItem | Nil
    dense_list_index = @sparse_hash[id]

    return nil if @element_count <= dense_list_index
    return nil if @dense_list[dense_list_index].try &.id != id

    @dense_list[dense_list_index]
  end

  def add(item : SparseSetItem)
    item_id = item.id
    return unless get(item_id).nil?

    @dense_list[@element_count] = item
    @sparse_hash[item_id] = @element_count
    @element_count += 1
  end

  def remove(item : SparseSetItem | UInt32): UInt32 | Nil
    item_id = item.is_a?(SparseSetItem) ? SparseSetItem.id : item

    return nil if get(item_id).nil?

    dense_list_Index = @sparse_hash[item_id]

    const lastItem = @dense_list[@element_count - 1] # Take an element from end
    @dense_list[dense_list_Index] = lastItem # Overwrite.
    @sparse_hash[lastItem.id] = dense_list_Index # Overwrite.

    @element_count -= 1

    return item_id
  end

  def clear
    @element_count = 0
  end

  def size
    @element_count
  end

  def stream(&block)
    @dense_list.each { |dense_list_item| block.call(dense_list_item) }
  end
end
