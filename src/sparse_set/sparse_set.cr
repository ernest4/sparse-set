require "iterator"

module SparseSet
  class SparseSet
    def initialize
      @dense_list = [] of Item
      @sparse_hash = {} of Int32 => Int32
      @element_count = 0
    end
  
    def get(id : Int32) : Item | Nil
      dense_list_index = @sparse_hash[id]?
  
      return nil if dense_list_index.nil?
      return nil if @element_count <= dense_list_index
      return nil if @dense_list[dense_list_index].try &.id != id
  
      @dense_list[dense_list_index]
    end
  
    def add(item : Item)
      item_id = item.id
      return unless get(item_id).nil?
  
      if @dense_list.size == @element_count
        @dense_list.push(item) # grow max array size
      else 
        @dense_list[@element_count] = item # re-use existing array space
      end
  
      @sparse_hash[item_id] = @element_count
      @element_count += 1
    end
  
    def remove(item : Item | Int32): Int32 | Nil
      item_id = item.is_a?(Item) ? item.id : item
  
      return nil if get(item_id).nil?
  
      dense_list_index = @sparse_hash[item_id]
  
      last_item = @dense_list[@element_count - 1] # take an element from end
      @dense_list[dense_list_index] = last_item # overwrite
      @sparse_hash[last_item.id] = dense_list_index # overwrite
  
      @element_count -= 1
  
      return item_id
    end
  
    def clear
      @element_count = 0
    end
  
    def size
      @element_count
    end
  
    def stream
      i = -1
      while (i += 1) < @element_count
        yield @dense_list[i]
      end
    end
  end
end
