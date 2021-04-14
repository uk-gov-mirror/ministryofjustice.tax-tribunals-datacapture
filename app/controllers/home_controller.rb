class HomeController < ApplicationController
  def index
    reset_tribunal_case_session
    @link_sections = link_sections
  end

  def contact
  end

  def cookies
    @form_object = Cookie::YesNoForm.new(
      request: request
    )
  end

  def terms
  end

  def privacy
  end

  def accessibility
  end

  def guidance
  end

  def update
    Cookie::YesNoForm.new(
      cookie_setting: cookie_setting,
      response: response
    ).save
    flash[:cookie_notification] = true
    redirect_to :cookies
  end

  private

  def cookie_setting
    params[:cookie_yes_no_form]
      .permit(:cookie_setting)
      .to_h
      .fetch(:cookie_setting)
  end

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  # Use '0' minutes to hide the time to complete paragraph
  def link_sections
    [
      [:appeal, 30, appeal_path],
      [:close, 15, closure_path],
      [:home_login, 0, helpers.login_or_portfolio_path],
      [:guidance, 0, guidance_path]
    ]
  end
end
