# frozen_string_literal: true

require 'rails_helper'

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
    let(:another_menu) { build(:menu, name: menu.name) }

    it 'should require #name' do
      menu.name = nil
      menu.valid?
      expect(menu.errors[:name].size).to eq(1)
    end

    it 'should verify uniqueness of #name' do
      another_menu.valid?
      expect(another_menu.errors['name'].size).to eq(1)
    end
  end

  describe 'when update an existing menu' do
    let(:another_menu) { create(:menu, name: 'Brunch') }

    context 'with valid attributes' do
      it 'should succeeds with no side effects' do
        name = 'Brunch'
        menu.update(name: name)
        menu.valid?
        expect(Menu.find_by_name(name)).to eq(menu)
      end
    end

    context 'with invalid attributes' do
      it 'should be not valid with an empty #name' do
        menu.update(name: nil)
        menu.valid?
        expect(menu.errors[:name].size).to eq(1)
      end

      it 'should be not valid with an existing #name' do
        menu.update(name: another_menu.name)
        menu.valid?
        expect(menu.errors[:name].size).to eq(1)
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
end
