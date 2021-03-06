describe Scheduler::Schedule do
  before do
    availability = create(:availability,
                          start_at: Time.zone.now,
                          end_at: 1.week.from_now)
    @schedule = Scheduler::Schedule.new(availability: availability).to_hash
  end

  it "should include date" do
    date = 1.day.from_now.to_date

    expect(@schedule.keys).to include(date)
  end

  it "shouldn't include date" do
    date = 1.day.ago.to_date

    expect(@schedule.keys).not_to include(date)
  end
end
