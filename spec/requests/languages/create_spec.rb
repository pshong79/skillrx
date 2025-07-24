require "rails_helper"

describe "Languages", type: :request do
  describe "POST /languages" do
    let(:user) { create(:user, :admin) }
    let(:language_params) { { name: "french" } }

    before { sign_in(user) }

    it "creates a Language" do
      post languages_url, params: { language: language_params }

      expect(response).to redirect_to(languages_path)
      expect(Language.last.name).to eq("french")
      expect(Language.last.file_storage_prefix).to eq("FR_")
    end

    it "displays a success message" do
      post languages_url, params: { language: language_params }

      expect(flash[:notice]).to eq("Language was successfully created.")
    end
  end
end
