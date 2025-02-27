require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    it 'resets the tribunal case in the session' do
      expect(subject).to receive(:reset_tribunal_case_session)
      get :index
    end

    it 'assigns the expected link sections' do
      get :index

      name, time, link = assigns[:link_sections][0]
      expect(name).to eq(:appeal)
      expect(time).to eq(30)
      expect(link).to eq('/appeal')

      name, time, link = assigns[:link_sections][1]
      expect(name).to eq(:close)
      expect(time).to eq(15)
      expect(link).to eq('/closure')

      name, time, link = assigns[:link_sections][2]
      expect(name).to eq(:home_login)
      expect(time).to eq(0)
      expect(link).to eq('/users/login')

      name, time, link = assigns[:link_sections][3]
      expect(name).to eq(:guidance)
      expect(time).to eq(0)
      expect(link).to eq('/guidance')
    end

    context 'when user is logged in' do
      let(:user) { instance_double(User) }

      before do
        sign_in(user)
      end

      it 'the link to login points to the cases portfolio' do
        get :index

        name, time, link = assigns[:link_sections][2]
        expect(name).to eq(:home_login)
        expect(time).to eq(0)
        expect(link).to eq('/users/cases')
      end
    end
  end

  describe '#guidance' do
    it 'renders the expected page' do
      get :guidance
      expect(response).to render_template(:guidance)
    end
  end

  describe '#contact' do
    it 'renders the expected page' do
      get :contact
      expect(response).to render_template(:contact)
    end
  end

  describe '#cookies' do
    it 'renders the expected page' do
      get :cookies
      expect(response).to render_template(:cookies)
    end

    it 'sets for cookie_setting form object' do
      get :cookies
      expect(assigns(:form_object)).to be_a(Cookie::SettingForm)
    end
  end

  describe '#update' do
    let(:referer) { 'http://local.net/page' }

    before do
      request.env['HTTP_REFERER'] = referer
    end

    Cookie::SettingForm.choices.each do |selection|
      it "saves cookie preferences #{selection}" do
        expect(Cookie::SettingForm).to receive(:new)
                                       .with(hash_including(cookie_setting: selection))
                                       .and_return(Cookie::SettingForm.new)
        put :update, params: { cookie_setting_form: { cookie_setting: selection} }
      end
    end

    it 'sets notification flag' do
      put :update, params: { cookie_setting_form: { cookie_setting: 'yes'} }
      expect(flash[:cookie_notification]).to be_present
    end

    it 'redirects to cookies page' do
      put :update, params: { cookie_setting_form: { cookie_setting: 'yes'} }
      expect(response).to redirect_to(referer)
    end
  end

  describe '#terms' do
    it 'renders the expected page' do
      get :terms
      expect(response).to render_template(:terms)
    end
  end

  describe '#privacy' do
    it 'renders the expected page' do
      get :privacy
      expect(response).to render_template(:privacy)
    end
  end

  describe '#accessibility' do
    it 'renders the expected page' do
      get :accessibility
      expect(response).to render_template(:accessibility)
    end
  end
end
