require "./spec_helper"

class TestyItem < SparseSet::Item; end

Spectator.describe SparseSet::SparseSet do
  let(:item) { TestyItem.new(123) }
  let(:item2)  { TestyItem.new(456) }
  let(:item3)  { TestyItem.new(789) }

  subject { described_class.new }

  describe "#add" do
    context "when item doesn't already exist" do
      it "adds the item" do
        subject.add(item)
        expect(subject.get(item.id)).to be item
      end

      it "increases sparse set size" do
        expect { subject.add(item) }.to change { subject.size }.from(0).to(1)
        expect { subject.add(item2) }.to change { subject.size }.from(1).to(2)
      end
    end

    context "when item already exists" do
      before_each { subject.add(item) }

      it "return and does not replaces item" do
        subject.add(item)
        expect(subject.get(item.id)).to be item
      end

      it "does not increase sparse set size" do
        expect { subject.add(item) }.not_to change { subject.size }
      end
    end
  end

  describe "#get" do
    before_each { subject.add(item) }

    context "when sparse set has the item" do
      it "returns the item" do
        expect(subject.get(item.id)).to be item
        expect(subject.get(item.id).try &.id).to eq item.id
      end
    end

    context "when sparse set does not have the item" do
      context "when item never existed" do
        it "returns nil" do
          expect(subject.get(item2.id)).to eq nil
        end
      end

      context "when items was added" do
        context "when items was removed" do
          before_each { subject.remove(item) }

          it "returns nil" do
            expect(subject.get(item.id)).to eq nil
          end
        end

        context "when all items were cleared" do
          before_each { subject.clear }

          it "returns nil" do
            expect(subject.get(item.id)).to eq nil
          end
        end
      end
    end
  end

  describe "#remove" do
    context "when sparse set has the item" do
      before_each { subject.add(item) }

      it "returns removed item's id" do
        expect(subject.remove(item)).to eq item.id
      end

      it "allows you to remove item by id" do
        expect(subject.remove(item.id)).to eq item.id
      end

      it "reduces sparse set's size" do
        expect { subject.remove(item) }.to change { subject.size }.from(1).to(0)
      end
    end

    context "when sparse set does not have the item" do
      context "when item never existed" do
        it "returns nil" do
          expect(subject.remove(item2.id)).to eq nil
        end
      end

      context "when items was added" do
        context "when items was removed" do
          before_each { subject.remove(item) }

          it "returns nil" do
            expect(subject.remove(item.id)).to eq nil
          end

          context "when removing item with same id (before it was even added)" do
            it "returns nil" do 
              expect(subject.remove(TestyItem.new(item.id))).to eq nil
            end
          end
        end

        context "when all items were cleared" do
          before_each { subject.clear }

          it "returns nil" do
            expect(subject.remove(item.id)).to eq nil
          end
        end
      end
    end
  end

  describe "#clear" do
    before_each do
      subject.add(item)
      subject.add(item2)
      subject.clear
    end

    it "sets the size to 0" do
      expect(subject.size).to eq 0
    end

    it "makes existing components inaccessible" do 
      expect(subject.get(item.id)).to eq nil
      expect(subject.get(item2.id)).to eq nil
    end
  end

  describe "#size" do
    before_each do 
      subject.add(item)
      subject.add(item2)
    end
 
    it "returns the number of items in the set" do
      expect(subject.size).to eq 2

      subject.add(item3)
      expect(subject.size).to eq 3

      subject.remove(item)
      expect(subject.size).to eq 2

      subject.remove(item2)
      expect(subject.size).to eq 1

      subject.remove(item3)
      expect(subject.size).to eq 0
    end
  end
 
  describe "#stream" do
    before_each do 
      subject.add(item)
      subject.add(item2)
    end

    it "streams all the items" do
      items = [] of SparseSet::Item
      subject.stream { |sparse_set_item| items.push(sparse_set_item) }
      expect(items).to eq [item, item2]

      subject.add(item3)

      items = [] of SparseSet::Item
      subject.stream { |sparse_set_item| items.push(sparse_set_item) }
      expect(items).to eq [item, item2, item3]

      subject.remove(item)
      subject.remove(item3)

      items = [] of SparseSet::Item
      subject.stream { |sparse_set_item| items.push(sparse_set_item) }
      expect(items).to eq [item2]
    end
  end
end
