require 'date'
class ChemicalInventorySystem
  attr_accessor :current_amount, :recurring_uses
  def initialize(current_amount:, recurring_uses:)
    @current_amount = current_amount
    @recurring_uses = recurring_uses
  end

  def predict_depletion_date
    date = Date.today
    recurring_use_count = self.recurring_uses.count
    tracker = Set.new

    if current_amount == 0
      return false
    end

    while current_amount > 0
      daily_usage = 0

      # if all recurring uses have ended, return false as depletion will never happen
      if tracker.size == recurring_use_count
        return false
      end
      
      self.recurring_uses.each_with_index do |use, index|
        if use.ended?(date)
          tracker.add(index)
          next
        end
        if use.use_on_date?(date)
          daily_usage += use.amount
        end
      end
      break if daily_usage > self.current_amount
      self.current_amount -= daily_usage
      date += 1
    end
    date - 1
  end

end


class RecurringUse
  attr_accessor :amount, :periodicity, :start_date, :end_date
  def initialize(amount:, periodicity:, start_date:, end_date: nil)
    @amount = amount
    @periodicity = periodicity
    @start_date = start_date
    @end_date = end_date
  end

  def periodicity_day
    if weekly?
      return start_date.cwday
    else
      return nil
    end
  end

  def use_on_date?(date)
    if daily?
      return true
    end
    if weekly?
      return date.cwday === periodicity_day
    end
  end

  def daily?
    periodicity == :daily
  end

  def weekly?
    periodicity == :weekly
  end

  def ended?(date)
    end_date && date > end_date
  end
end

