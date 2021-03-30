# sparse-set

A [sparse set](https://programmingpraxis.com/2012/03/09/sparse-sets/) implementation in Crystal.

Goal of sparse set is to trade memory for performance. The aim of the implementation is to provide
the following Big O performance:

|   get   |   insert	|   remove	|   iterate   |	  clear   |
|---------|-----------|-----------|-------------|-----------|
|   O(1)	|   O(1)	  |   O(1)	  |   O(n)	    |   O(1)    |

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     sparse-set:
       github: ernest4/sparse-set
   ```

2. Run `shards install`

## Usage

```crystal
require "sparse-set"

# create a sparse set
sparse_set = SparseSet::SparseSet.new

# create some item data container classes that inherit from SparseSet::Item

class MyItem1 < SparseSet::Item
  # some data here
end

class MyItem2 < SparseSet::Item
  # some data here
end

# instantiate your items. NOTE: every item needs some unique Int32 id!
my_item_1_a = MyItem1.new(1)
my_item_1_b = MyItem1.new(2)
my_item_2 = MyItem2.new(3)

# add items to sparse set
sparse_set.add(my_item_1_a)
sparse_set.add(my_item_1_b)
sparse_set.add(my_item_2)

# remove items from sparse set
sparse_set.remove(my_item_1_b) # by item
sparse_set.remove(2) # by item id

# get item by id from sparse set
sparse_set.get(3)

# get sparse set size
sparse_set.size

# iterate through the sparse set items
sparse_set.stream { |sparse_set_item| puts sparse_set_item }
```

## Contributing

1. Fork it (<https://github.com/your-github-user/sparse-set/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Ernestas Monkevicius](https://github.com/your-github-user) - creator and maintainer
