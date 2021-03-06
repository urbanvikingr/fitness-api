require "spec_helper"

describe PaymentPlan, type: :request do
  context "when authenticated" do
    before do
      coach = create(:coach)
      login(coach)
      @payment_plan = create_list(:payment_plan,
                                  2,
                                  user: coach).first
    end

    describe "GET #index" do
      before do
        get("/api/payment_plans.json")
      end

      it "should respond with an array of 2 PaymentPlans" do
        expect(json.count).to eq 2
      end

      it "should respond with status 200" do
        expect(response.status).to eq 200
      end
    end

    describe "GET #show" do
      before do
        get("/api/payment_plans/#{@payment_plan.id}.json")
      end

      it "should respond with 1 PaymentPlan" do
        expect(json["name"]).to eq(@payment_plan.name)
      end

      it "should respond with status 200" do
        expect(response.status).to eq 200
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        before do
          @payment_plan_attributes = attributes_for(:payment_plan)

          post(
            "/api/payment_plans.json",
            { payment_plan: @payment_plan_attributes })
        end

        it "should respond with created PaymentPlan" do
          expect(json["name"]).to eq @payment_plan_attributes[:name]
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
          payment_plan_attributes =
            attributes_for(:payment_plan, name: nil)

          post(
            "/api/payment_plans.json",
            { payment_plan: payment_plan_attributes })
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
            "/api/payment_plans/#{@payment_plan.id}.json",
            { payment_plan: { name: @name }})
        end

        it "should respond with updated PaymentPlan" do
          expect(json["name"]).to eq(@name)
        end

        it "should respond with status 200" do
          expect(response.status).to eq 200
        end
      end

      context "with invalid attributes" do
        before do
          name = "EXCEEDS MAX LENGTH" * 100

          patch(
            "/api/payment_plans/#{@payment_plan.id}.json",
            { payment_plan: { name: name }})
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
        delete("/api/payment_plans/#{@payment_plan.id}.json")
      end

      it "should respond with status 204" do
        expect(response.status).to eq 204
      end
    end
  end

  context "when unauthenticated" do
    before do
      get "/api/payment_plans.json"
    end

    it "should respond with status 401" do
      expect(response.status).to eq 401
    end
  end
end
