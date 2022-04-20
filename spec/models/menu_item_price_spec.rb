# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenuItemPrice, type: :model do
  let(:menu_item_price) { create(:menu_item_price) }

  describe 'when create successfully a new MenuItemPrice' do
    it 'should be an instance of MenuItemPrice' do
      expect(menu_item_price).to be_an MenuItemPrice
    end

    it 'should be persisted' do
      expect(menu_item_price).to be_persisted
    end

    it 'should be valid with valid attributes' do
      expect(menu_item_price).to be_valid
    end
  end

  describe 'when validate attributes' do
    context '#menu' do
      it 'is required' do
        menu_item_price.menu = nil
        menu_item_price.valid?
        expect(menu_item_price.errors[:menu].size).to eq(1)
      end

      it 'is an instance of Menu' do
        expect(menu_item_price.menu).to be_an Menu
      end
    end

    context '#menu_item' do
      it 'is required' do
        menu_item_price.menu_item = nil
        menu_item_price.valid?
        expect(menu_item_price.errors[:menu_item].size).to eq(1)
      end

      it 'is an instance of MenuItem' do
        expect(menu_item_price.menu_item).to be_an MenuItem
      end
    end

    context '#price' do
      it 'is required' do
        menu_item_price.price = nil
        menu_item_price.valid?
        expect(menu_item_price.errors[:price]).to include("can't be blank")
      end

      it 'is a number' do
        menu_item_price.price = Faker::Name.name
        menu_item_price.valid?
        expect(menu_item_price.errors[:price].size).to eq(1)
      end

      it 'is greater than 0' do
        menu_item_price.price = 0
        menu_item_price.valid?
        expect(menu_item_price.errors[:price].size).to eq(1)
      end

      it 'is less than 10000' do
        menu_item_price.price = Faker::Number.number(5)
        menu_item_price.valid?
        expect(menu_item_price.errors[:price].size).to eq(1)
      end
    end

    context '#description' do
      it 'maximum length' do
        menu_item_price.description = Faker::Lorem.characters(510)
        menu_item_price.valid?
        expect(menu_item_price.errors[:description].size).to eq(1)
      end
    end
  end

  describe 'when update an existing menu_item_price' do
    describe 'with valid attributes' do
      it 'should succeeds with no side effects' do
        menu = FactoryBot.build(:menu)
        menu_item = FactoryBot.build(:menu_item)
        price = Faker::Commerce.price
        description = Faker::Food.description
        menu_item_price.update(menu: menu, menu_item: menu_item, price: price, description: description)
        expect(menu_item_price).to be_valid
      end
    end

    describe 'with invalid attributes' do
      context '#menu' do
        it 'is empty' do
          menu_item_price.update(menu: nil)
          menu_item_price.valid?
          expect(menu_item_price.errors[:menu].size).to eq(1)
        end
      end

      context '#menu_item' do
        it 'is empty' do
          menu_item_price.update(menu_item: nil)
          menu_item_price.valid?
          expect(menu_item_price.errors[:menu_item].size).to eq(1)
        end
      end

      context '#price' do
        it 'is empty' do
          menu_item_price.update(price: nil)
          menu_item_price.valid?
          expect(menu_item_price.errors[:price]).to include("can't be blank")
        end

        it 'is not a number' do
          menu_item_price.update(price: Faker::Name.name)
          menu_item_price.valid?
          expect(menu_item_price.errors[:price].size).to eq(1)
        end

        it 'is not greater than 0' do
          menu_item_price.update(price: 0)
          menu_item_price.valid?
          expect(menu_item_price.errors[:price].size).to eq(1)
        end

        it 'is not less than 10000' do
          menu_item_price.update(price: Faker::Number.number(5))
          menu_item_price.valid?
          expect(menu_item_price.errors[:price].size).to eq(1)
        end
      end

      context '#description' do
        it 'exceed maximum length' do
          menu_item_price.update(description: Faker::Lorem.characters(510))
          menu_item_price.valid?
          expect(menu_item_price.errors[:description].size).to eq(1)
        end
      end
    end
  end

  describe 'when read an existing menu_item_price' do
    it 'should check a menu_item_price can be readed' do
      id = menu_item_price.id
      expect(MenuItemPrice.find(id)).to eq(menu_item_price)
    end
  end

  describe 'when destroy an existing menu_item_price' do
    it 'should check a menu_item_price is deleted' do
      id = menu_item_price.id
      menu_item_price.destroy
      expect(MenuItemPrice.where(id: id).size).to eq(0)
    end
  end

  describe 'when belongs to a menu' do
    it 'return the referenced menu' do
      menu = Menu.find(menu_item_price.menu_id)
      expect(menu).to be_valid
    end
  end

  describe 'when belongs to a menu_item' do
    it 'return the referenced menu_item' do
      menu_item = MenuItem.find(menu_item_price.menu_item_id)
      expect(menu_item).to be_valid
    end
  end
end
