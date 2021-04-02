require "benchmark"
require "../sparse_set/*"

class TestyItem < SparseSet::Item; end

count = 10_000

items = (1..count).map {|i| TestyItem.new(i) }

sparse_set = SparseSet::SparseSet.new

items.each {|item| sparse_set.add(item) }

hashy = {} of Int32 => SparseSet::Item

items.each {|item| hashy[item.id] = item }

Benchmark.ips do |x|
  x.report("SparseSet iteration of #{items.size} items") do
    sparse_set.stream { |item| item }
  end

  x.report("Array iteration of #{items.size} items") do
    items.each { |item| item }
  end

  x.report("Hash values iteration of #{items.size} items") do
    hashy.values.each { |item| item }
  end

  x.report("While values iteration A of #{items.size} items") do
    i = 0
    while i < count
      items[i]
      i += 1
    end
  end

  x.report("While values iteration B of #{items.size} items") do
    i = -1
    while (i += 1) < count
      items[i]
    end
  end
end

Benchmark.ips do |x|
  x.report("SparseSet get") do
    sparse_set.get(9_999)
  end

  x.report("Array find") do
    items.find { |item| item.id == 9_999 }
  end

  x.report("Hash get") do
    hashy[9_999]
  end
end
