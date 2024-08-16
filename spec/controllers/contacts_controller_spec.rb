describe 'GET #show' do
  it "assigns the requested contact to @contact" do
    contact = create(:contact)
    get :show, params: {id: contact}
    except(assigns(:contact)).to eq contact
  end

  it "renders the :show template" do
    contact = create(:contact)
    get :show, params: {id: contact}
    except(response).to render_template :show
  end
end

describe 'GET # index' do
  context 'with params[:letter]' do
    it "popluates an array of contacts starting with the letter" do
      smith = create(:contact, lastname: 'Smith')
      jones = create(:contact, lastname: 'Jones')
      get :index, params: {letter: 'S'}
      except(assigns(:contact)).to match_array([smith])
    end

    it " renders the :index template" do
      get :index, params: {letter: 'S'}
      except(response).to render_template :index
    end
  end

context 'without params[:letter]' do
  it "populates an array of all contacts" do 
    smith = create(:contact, lastname: 'Smith')
    jones = create(:contact, lastname: 'Jones')
    get :index
    except(assigns(:contacts)).to match_array([smith, jones])
  end

  it "renders the :index template" do
    get :index
    except(response).to render_template :index
  end
end

describe 'GET #new' do
  it "assigns a new contact to @contact" do
    get :new
    except(assigns(:contact)).to be_a_new(Contact)
  end

  it "renders the :new template" do
    get :new
    except(response).to render_template :new
  end
end

describe 'GET #edit' do
  it "assings the requested contact to @contact" do
    contact = create(:contact)
    get :edit, params: {id: contact}
    except(assigns(:contact)).to eq contact
  end

  it "renders the :edit template" do
    contact = create(:contact)
    get :edit, params: { id: contact}
    except(response).to render_template :edit
  end
end

describe "POST #create" do
  before :each do
    @phones = [
      attributes_for(:phone),
      attributes_for(:phone),
      attributes_for(:phone)
    ]
  end

  context "with valid attributes" do
    it "saves the new contact in the database" do
      except{
        post :create, contact: attributes_for(:contact,
          phones_attributes: @phones)
      }.to change(Contact, :count).by(1)
    end

    it "redirects to contacts#show" do
    post :create, contact:attributes_for(:contact,
      phones_attributes: @phones
    )
    except(response).to redirect_to contact_path(assigns[:contact])
  end
end

# 無効な属性の場合
context "with invalid attributes" do
  # データベースに新しい連絡先を保存しないこと
  it "does not save the new contact in the database" do
    expect{
      post :create,
        contact: attributes_for(:invalid_contact)
    }.not_to change(Contact, :count)
  en
  # :newテンプレートを再表示すること
  it "re-renders the :new template" do
    post :create,
      contact: attributes_for(:invalid_contact)
    expect(response).to render_template :new
  end
end
end

describe 'PATCH #update' do
  before :each do
    @contact = create(:contact,
      firstname: 'Lawrence',
      lastname: 'Smith')
  end

  # 有効な属性の場合
  context "valid attributes" do
    # 要求された@contactを取得すること
    it "locates the requested @contact" do
      patch :update, id: @contact, contact: attributes_for(:contact)
      expect(assigns(:contact)).to eq(@contact)
    end

    # @contactの属性を変更すること
    it "changes @contact's attributes" do
      patch :update, id: @contact,
            contact: attributes_for(:contact,
              firstname: 'Larry',
              lastname: 'Smith')
          @contact.reload
          expect(@contact.firstname).to eq('Larry')
          expect(@contact.lastname).to eq('Smith')
        end
  
        # 更新した連絡先のページへリダイレクトすること
        it "redirects to the updated contact" do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(response).to redirect_to @contact
        end
      end
    # 無効な属性の場合
    context "with invalid attributes" do
      # 連絡先の属性を変更しないこと
      it "does not change the contact's attributes" do
        patch :update, id: @contact,
          contact: attributes_for(:contact,
             firstname: "Larry", lastname: nil)
         @contact.reload
         expect(@contact.firstname).not_to eq("Larry")
         expect(@contact.lastname).to eq("Smith")
       end
       # editテンプレートを再表示すること
       it "re-renders the :edit template" do
         patch :update, id: @contact,
           contact: attributes_for(:invalid_contact)
         expect(response).to render_template :edit
       end
      end
    end