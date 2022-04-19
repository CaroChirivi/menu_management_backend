# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Menu, type: :model do
  let(:menu) { create(:menu) }

  describe 'when create successfully a new Menu' do
    it 'should be an instance of Menu' do
      expect(menu).to be_an Menu
    end

    it 'should be persisted' do
      expect(menu).to be_persisted
    end

    it 'should be valid with valid attributes' do
      expect(menu).to be_valid
    end
  end

  describe 'when validate attributes' do
    let(:another_menu) { build(:menu, name: menu.name, restaurant_id: menu.restaurant_id) }

    context '#restaurant' do
      it 'is required' do
        menu.restaurant = nil
        menu.valid?
        expect(menu.errors[:restaurant].size).to eq(1)
      end

      it 'is an instance of Restaurant' do
        expect(menu.restaurant).to be_an Restaurant
      end
    end

    context '#name' do
      it 'is required' do
        menu.name = nil
        menu.valid?
        expect(menu.errors[:name].size).to eq(1)
      end

      it 'is unique' do
        another_menu.valid?
        expect(another_menu.errors['name'].size).to eq(1)
      end

      it 'maximum length' do
        menu.name = Faker::Lorem.characters(110)
        menu.valid?
        expect(menu.errors[:name].size).to eq(1)
      end
    end
  end

  describe 'when update an existing menu' do
    let(:another_menu) { create(:menu, name: Faker::Name.unique.name, restaurant_id: menu.restaurant_id) }

    describe 'with valid attributes' do
      it 'should succeeds with no side effects' do
        name = Faker::Name.unique.name
        menu.update(name: name)
        menu.valid?
        expect(Menu.find_by_name(name)).to eq(menu)
      end
    end

    describe 'with invalid attributes' do
      context '#restaurant' do
        it 'is empty' do
          menu.update(restaurant: nil)
          menu.valid?
          expect(menu.errors[:restaurant].size).to eq(1)
        end
      end

      context '#name' do
        it 'return error if is empty' do
          menu.update(name: nil)
          menu.valid?
          expect(menu.errors[:name].size).to eq(1)
        end

        it 'return error if the name already exists' do
          menu.update(name: another_menu.name)
          menu.valid?
          expect(menu.errors[:name].size).to eq(1)
        end

        it 'return error if exceed maximum length' do
          menu.update(name: Faker::Lorem.characters(110))
          menu.valid?
          expect(menu.errors[:name].size).to eq(1)
        end
      end
    end
  end

  describe 'when read an existing menu' do
    it 'should check a menu can be readed' do
      name = menu.name
      expect(Menu.find_by_name(name)).to eq(menu)
    end
  end

  describe 'when destroy an existing menu' do
    it 'should check a menu is deleted' do
      name = menu.name
      menu.destroy
      expect(Menu.find_by_name(name)).to be_nil
    end
  end

  describe 'when have menu_items' do
    it 'return the referenced menu_items' do
      FactoryBot.create(:menu_item, menu: menu)
      FactoryBot.create(:menu_item, menu: menu)
      expect(menu.menu_items.size).to eq(2)
    end
  end

  describe 'when belongs to a restaurant' do
    it 'return the referenced restaurant' do
      restaurant = Restaurant.find(menu.restaurant_id)
      expect(restaurant).to be_valid
    end
  end
end
