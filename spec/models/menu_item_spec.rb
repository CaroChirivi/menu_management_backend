# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe MenuItem, type: :model do
  let(:menu_item) { create(:menu_item) }

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
    context '#name' do
      it 'is required' do
        menu_item.name = nil
        menu_item.valid?
        expect(menu_item.errors[:name].size).to eq(1)
      end

      it 'is unique' do
        another_menu_item = FactoryBot.build(:menu_item, name: menu_item.name)
        another_menu_item.valid?
        expect(another_menu_item.errors['name'].size).to eq(1)
      end

      it 'maximum length' do
        menu_item.name = Faker::Lorem.characters(110)
        menu_item.valid?
        expect(menu_item.errors[:name].size).to eq(1)
      end
    end
  end

  describe 'when update an existing menu_item' do
    describe 'with valid attributes' do
      it 'should succeeds with no side effects' do
        name = Faker::Food.unique.dish
        menu_item.update(name: name)
        expect(MenuItem.find_by_name(name)).to eq(menu_item)
      end
    end

    describe 'with invalid attributes' do
      context '#name' do
        it 'is empty' do
          menu_item.update(name: nil)
          menu_item.valid?
          expect(menu_item.errors[:name].size).to eq(1)
        end

        it 'return error if the name already exists' do
          another_menu_item = FactoryBot.create(:menu_item)
          menu_item.update(name: another_menu_item.name)
          menu_item.valid?
          expect(menu_item.errors[:name].size).to eq(1)
        end

        it 'exceed maximum length' do
          menu_item.update(name: Faker::Lorem.characters(110))
          menu_item.valid?
          expect(menu_item.errors[:name].size).to eq(1)
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

  describe 'when have menu_item_prices' do
    it 'return the referenced menu_item_prices' do
      menu = FactoryBot.create(:menu)
      another_menu = FactoryBot.create(:menu)
      FactoryBot.create(:menu_item_price, menu: menu, menu_item: menu_item)
      FactoryBot.create(:menu_item_price, menu: another_menu, menu_item: menu_item)
      expect(menu_item.menu_item_price.size).to eq(2)
    end
  end
end
