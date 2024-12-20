require 'rspec'
require_relative './chemical.rb'

RSpec.describe ChemicalInventorySystem do
  it 'predicts depletion for a single daily use' do
    uses = [
      RecurringUse.new(amount: 10, periodicity: :daily, start_date: Date.today)
    ]
    sys = ChemicalInventorySystem.new(current_amount: 100, recurring_uses: uses)
    expect(sys.predict_depletion_date).to eq(Date.today + 9)
  end

  it 'predicts depletion for multiple uses' do
    uses = [
      RecurringUse.new(amount: 10, periodicity: :daily, start_date: Date.today),
      RecurringUse.new(amount: 20, periodicity: :weekly, start_date: Date.today) # Weekly
    ]
    sys = ChemicalInventorySystem.new(current_amount: 180, recurring_uses: uses)
    expect(sys.predict_depletion_date).to eq(Date.today + 13)
  end

  it 'returns false if the chemical will not be depleted because of end dates' do
    uses = [
      RecurringUse.new(amount: 10, periodicity: :daily, start_date: Date.today, end_date: Date.today + 5)
    ]
    sys = ChemicalInventorySystem.new(current_amount: 100, recurring_uses: uses)
    expect(sys.predict_depletion_date).to eq(false)
  end

  it "handles multiple uses with end dates mixed in" do
    uses = [
      RecurringUse.new(amount: 10, periodicity: :daily, start_date: Date.today, end_date: Date.today + 5),
      RecurringUse.new(amount: 10, periodicity: :daily, start_date: Date.today)
    ]
    sys = ChemicalInventorySystem.new(current_amount: 150, recurring_uses: uses)
    expect(sys.predict_depletion_date).to eq(Date.today + 8)
  end

  

  it 'returns false if no depletion happens' do
    uses = [
      RecurringUse.new(amount: 10, periodicity: :daily, start_date: Date.today)
    ]
    system = ChemicalInventorySystem.new(current_amount: 0, recurring_uses: uses)
    expect(system.predict_depletion_date).to eq(false)
  end
end