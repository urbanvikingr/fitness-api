FactoryGirl.define do
  factory :exercise_description do
    user
    sequence(:name) { |n| "NAME#{n}" }
    sequence(:short_name_for_mobile) { |n| "SHORT NAME FOR MOBILE#{n}" }
    sequence(:description) { |n| "DESCRIPTION#{n}" }
    distance false
    duration false
    load false
    repetition true
    tempo "TEMPO"
    video_url "HTTP://WWW.YOUTUBE.COM"
    unilateral_execution false
    unilateral_loading false
  end
end
