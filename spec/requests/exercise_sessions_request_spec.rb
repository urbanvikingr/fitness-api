require "spec_helper"

describe ExerciseSession, type: :request do
  before do
    @coach = create(:coach)
    @exercise_plan = create(:exercise_plan,
                            user: @coach)
    @exercise_session = create_list(:exercise_session,
                                    2,
                                    exercise_plan: @exercise_plan,
                                    user: @coach).first
  end

  context "when authenticated" do
    before do
      login(@coach)
    end

    describe "GET #show" do
      before do
        get("/api/exercise_sessions/#{@exercise_session.id}.json")
      end

      it "should respond with 1 ExerciseSession" do
        expect(json["name"]).to eq(@exercise_session.name)
      end

      it "should respond with status 200" do
        expect(response.status).to eq(200)
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        before do
          @exercise_session_attributes =
            attributes_for(:exercise_session,
                           exercise_plan_id: @exercise_plan.id)
          post(
            "/api/exercise_sessions.json",
            { exercise_session: @exercise_session_attributes })
        end

        it "should respond with created ExerciseSession" do
          expect(json["name"]).to eq @exercise_session_attributes[:name]
        end

        it "should respond with new id" do
          expect(json.keys).to include("id")
        end

        it "should respond with status 201" do
          expect(response.status).to eq 201
        end
      end

      context "with invalid attributes" do
        before do
          exercise_session_attributes =
            attributes_for(:exercise_session,
                           name: nil,
                           exercise_plan_id: @exercise_plan.id)
          post(
            "/api/exercise_sessions.json",
            { exercise_session: exercise_session_attributes })
        end

        it "should respond with errors" do
          expect(json.keys).to include("errors")
        end

        it "should respond with status 422" do
          expect(response.status).to eq 422
        end
      end
    end

    describe "PATCH #update" do
      context "with valid attributes" do
        before do
          @name = "NAME#{rand(1000)}"

          patch(
            "/api/exercise_sessions/#{@exercise_session.id}.json",
            { exercise_session: { name: @name }})
        end

        it "should respond with updated ExerciseSession" do
          expect(json["name"]).to eq @name
        end

        it "should respond with status 200" do
          expect(response.status).to eq 200
        end
      end

      context "with invalid attributes" do
        before do
          name = "EXCEEDS MAX LENGTH" * 100

          patch(
            "/api/exercise_sessions/#{@exercise_session.id}.json",
            { exercise_session: { name: name }})
        end

        it "should respond with errors" do
          expect(json.keys).to include("errors")
        end

        it "should respond with status 422" do
          expect(response.status).to eq 422
        end
      end
    end

    describe "DELETE #destroy" do
      before do
        delete("/api/exercise_sessions/#{@exercise_session.id}.json")
      end

      it "should respond with status 204" do
        expect(response.status).to eq 204
      end
    end
  end

  context "when unauthenticated" do
    before do
      get "/api/exercise_sessions/#{@exercise_session.id}.json"
    end

    it "should respond with status 401" do
      expect(response.status).to eq 401
    end
  end
end
