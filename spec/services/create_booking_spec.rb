describe CreateBooking do
  before do
    @user = create(:user)
    @coach = create(:coach)
    @params = { coach_id: @coach.id,
                start_at: Time.zone.parse("9:00AM") + 1.day,
                end_at: Time.zone.parse("10:00AM") + 1.day }
  end

  context "when booking available" do
    it "should be created" do
      create(:availability,
             coach: @coach,
             duration: 60,
             auto_confirmation: true)

      expect do
        CreateBooking.new(user: @user, params: @params).call
      end.to change(Booking, :count).by(1)
    end

    it "should be created with confirmation" do
      create(:availability,
             coach: @coach,
             duration: 60,
             auto_confirmation: true)
      booking = CreateBooking.new(user: @user, params: @params).call

      expect(booking.confirmed_at).to be_truthy
    end

    it "should be created without confirmation" do
      create(:availability,
             coach: @coach,
             duration: 60,
             auto_confirmation: false)
      booking = CreateBooking.new(user: @user, params: @params).call

      expect(booking.confirmed_at).to be_falsey
    end
  end

  context "when booking unavailable" do
    it "shouldn't be created" do
      create(:availability,
             coach: @coach,
             maximum_of_participants: 0)

      expect do
        CreateBooking.new(user: @user, params: @params).call
      end.to change(Booking, :count).by(0)
    end
  end
end
