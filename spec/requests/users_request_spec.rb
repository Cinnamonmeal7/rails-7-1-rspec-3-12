require 'rails_helper'

describe UsersController, type: :request do 
  describe 'user access' do
    before :each do
      @user = create(:user)
      post sessions_path, params: { email: @user.email, password: @user.password }
    end

    describe 'GET #index' do
      it "collects users into @users" do
        user = create(:user)
        get users_path
        expect(response.body).to include @user.email
        expect(response.body).to include user.email
      end

      it "renders the :index template" do
        get users_path
        expect(response.status).to eq 200
      end
    end

    it "GET #new denies access" do
      get new_user_path
      expect(response).to redirect_to root_url
    end

    it "POST#create denies access" do
      post users_path, params: { user: attributes_for(:user) }
      expect(response).to redirect_to root_url
    end
  end
end
