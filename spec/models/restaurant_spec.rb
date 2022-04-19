# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:restaurant) { create(:restaurant) }

  describe 'when create successfully a new Restaurant' do
    it 'should be an instance of Restaurant' do
      expect(restaurant).to be_an Restaurant
    end

    it 'should be persisted' do
      expect(restaurant).to be_persisted
    end

    it 'should be valid with valid attributes' do
      expect(restaurant).to be_valid
    end
  end

  describe 'when validate attributes' do
    let(:another_restaurant) { build(:restaurant, name: restaurant.name) }

    context '#name' do
      it 'is required' do
        restaurant.name = nil
        restaurant.valid?
        expect(restaurant.errors[:name].size).to eq(1)
      end

      it 'is unique' do
        another_restaurant.valid?
        expect(another_restaurant.errors['name'].size).to eq(1)
      end

      it 'maximum length' do
        restaurant.name = Faker::Lorem.characters(110)
        restaurant.valid?
        expect(restaurant.errors[:name].size).to eq(1)
      end
    end
  end

  describe 'when update an existing restaurant' do
    let(:another_restaurant) { create(:restaurant, name: Faker::Restaurant.unique.name) }

    describe 'with valid attributes' do
      it 'should succeeds with no side effects' do
        name = Faker::Restaurant.unique.name
        restaurant.update(name: name)
        restaurant.valid?
        expect(Restaurant.find_by_name(name)).to eq(restaurant)
      end
    end

    describe 'with invalid attributes' do
      context '#name' do
        it 'return error if is empty' do
          restaurant.update(name: nil)
          restaurant.valid?
          expect(restaurant.errors[:name].size).to eq(1)
        end

        it 'return error if the name already exists' do
          restaurant.update(name: another_restaurant.name)
          restaurant.valid?
          expect(restaurant.errors[:name].size).to eq(1)
        end

        it 'return error if exceed maximum length' do
          restaurant.update(name: Faker::Lorem.characters(110))
          restaurant.valid?
          expect(restaurant.errors[:name].size).to eq(1)
        end
      end
    end
  end

  describe 'when read an existing restaurant' do
    it 'should check a restaurant can be readed' do
      name = restaurant.name
      expect(Restaurant.find_by_name(name)).to eq(restaurant)
    end
  end

  describe 'when destroy an existing restaurant' do
    it 'should check a restaurant is deleted' do
      name = restaurant.name
      restaurant.destroy
      expect(Restaurant.find_by_name(name)).to be_nil
    end
  end

  describe 'when have menus' do
    it 'return the referenced menus' do
      FactoryBot.create(:menu, restaurant: restaurant)
      FactoryBot.create(:menu, restaurant: restaurant)
      expect(restaurant.menu.size).to eq(2)
    end
  end
end
