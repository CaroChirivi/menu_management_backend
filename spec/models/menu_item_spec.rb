require 'rails_helper'
require 'faker'

RSpec.describe MenuItem, type: :model do
  let (:menu_item) { create(:menu_item) }

  describe 'when create successfully a new MenuItem' do
    it 'should be an instance of MenuItem' do
      expect(menu_item).to be_an MenuItem
    end

    it 'should be persisted' do
      expect(menu_item).to be_persisted
    end

    it 'should be valid with valid attributes' do
      expect(menu_item).to be_valid
    end
  end

  describe 'when validate attributes' do
    context '#menu' do
      it "is required" do
        menu_item.menu = nil
        menu_item.valid?
        expect(menu_item.errors[:menu].size).to eq(1)
      end

      it "is an instance of Menu" do
        expect(menu_item.menu).to be_an Menu
      end
    end

    context '#name' do
      it 'is required' do
        menu_item.name = nil
        menu_item.valid?
        expect(menu_item.errors[:name].size).to eq(1)
      end

      it 'maximum length' do
        menu_item.name = Faker::Lorem.characters(110)
        menu_item.valid?
        expect(menu_item.errors[:name].size).to eq(1)
      end
    end

    context '#description' do
      it 'is required' do
        menu_item.description = nil
        menu_item.valid?
        expect(menu_item.errors[:description].size).to eq(1)
      end

      it 'maximum length' do
        menu_item.description = Faker::Lorem.characters(510)
        menu_item.valid?
        expect(menu_item.errors[:description].size).to eq(1)
      end
    end

    context '#price' do
      it 'is required' do
        menu_item.price = nil
        menu_item.valid?
        expect(menu_item.errors[:price]).to include("can't be blank")
      end

      it 'is a number' do
        menu_item.price = Faker::Name.name
        menu_item.valid?
        expect(menu_item.errors[:price].size).to eq(1)
      end

      it 'is greater than 0' do
        menu_item.price = 0
        menu_item.valid?
        expect(menu_item.errors[:price].size).to eq(1)
      end

      it 'is less than 10000' do
        menu_item.price = Faker::Number.number(digits = 5)
        menu_item.valid?
        expect(menu_item.errors[:price].size).to eq(1)
      end
    end
  end

  describe 'when update an existing menu_item' do
    describe 'with valid attributes' do
      it 'should succeeds with no side effects' do
        menu = FactoryBot.build(:menu, name: Faker::Lorem.word)
        name = Faker::Food.dish
        description = Faker::Food.description
        price = Faker::Commerce.price
        menu_item.update(menu: menu, name: name, description: description, price: price)
        menu_item.valid?
        expect(MenuItem.find_by_name(name)).to eq(menu_item)
      end
    end

    describe 'with invalid attributes' do
      context '#menu' do
        it 'is empty' do
          menu_item.update(menu: nil)
          menu_item.valid?
          expect(menu_item.errors[:menu].size).to eq(1)
        end
      end

      context '#name' do
        it 'is empty' do
          menu_item.update(name: nil)
          menu_item.valid?
          expect(menu_item.errors[:name].size).to eq(1)
        end

        it 'exceed maximum length' do
          menu_item.update(name: Faker::Lorem.characters(110))
          menu_item.valid?
          expect(menu_item.errors[:name].size).to eq(1)
        end
      end

      context '#description' do
        it 'is empty' do
          menu_item.update(description: nil)
          menu_item.valid?
          expect(menu_item.errors[:description].size).to eq(1)
        end

        it "exceed maximum length" do
          menu_item.update(description: Faker::Lorem.characters(510))
          menu_item.valid?
          expect(menu_item.errors[:description].size).to eq(1)
        end
      end

      context '#price' do
        it 'is empty' do
          menu_item.update(price: nil)
          menu_item.valid?
          expect(menu_item.errors[:price]).to include("can't be blank")
        end

        it 'is not a number' do
          menu_item.update(price: Faker::Name.name)
          menu_item.valid?
          expect(menu_item.errors[:price].size).to eq(1)
        end

        it 'is not greater than 0' do
          menu_item.update(price: 0)
          menu_item.valid?
          expect(menu_item.errors[:price].size).to eq(1)
        end

        it 'is not less than 10000' do
          menu_item.update(price: Faker::Number.number(digits = 5))
          menu_item.valid?
          expect(menu_item.errors[:price].size).to eq(1)
        end
      end
    end
  end

  describe 'when read an existing menu_item' do
    it 'should check a menu_item can be readed' do
      id = menu_item.id
      expect(MenuItem.find(id)).to eq(menu_item)
    end
  end

  describe 'when destroy an existing menu_item' do
    it 'should check a menu_item is deleted' do
      id = menu_item.id
      menu_item.destroy
      expect(MenuItem.find_by_id(id)).to be_nil
    end
  end
end
