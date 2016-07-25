class SlotPresenter
  delegate :name, :address, to: :location
  attr_accessor :location

  def initialize(location)
    @location = location
  end

  def slots
    @slots ||= @location.slots
  end

  def slots?
    slots.any?
  end

  def slots_count
    slots.count
  end

  def slots_distribution
    return @slots_distribution unless @slots_distribution.nil? || @slots_distribution.empty?
    @slots_distribution = []
    slot_rows = slots_count / 5
    slot_rows.times do
      @slots_distribution << []
    end
    @slots_distribution
  end

  def build_slot_rows
    ctrl = slots.size
    idx = 0
    idx2 = 0
    if slots_distribution.size > 1
      while idx < (slots_distribution.size - 1) do
        while idx2 < ctrl do
          break if slots[idx2].nil?
          slots_distribution[idx][idx2] = slots[idx2]
          idx2 += 1
        end
        idx2 += 1
        ctrl = idx2 + 5
        idx += 1
      end
    else
      0.upto(slots.size - 1) do
        slots_distribution[0][idx2] << slot[idx2]
        idx2 += 1
      end
    end
  end
end
