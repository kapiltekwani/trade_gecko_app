class AuthenticationsController < ApplicationController

  def auth
    request.env['omniauth.auth']
  end

  def create
    omniauth = auth
    authentication = Authentication.where(provider: omniauth['provider'], uid: omniauth['uid']).first
    if authentication
      if authentication.user.blank?
        user = create_new_omniauth_user(omniauth)
        authentication.user = user
        authentication.save!
      end
      user = authentication.user
      flash[:notice] = "Signed Successfully"
      sign_in(user)
    else
      authentication = Authentication.create(provider: omniauth['provider'], uid: omniauth['uid'], token: omniauth[:credentials][:token], secret: omniauth[:credentials][:secret])
      user = create_new_omniauth_user(omniauth)
      if user 
        authentication.user = user
        authentication.save!
      end
    end
    redirect_to root_url
  end

  def create_new_omniauth_user(omniauth)
    user = User.new
    p omniauth['info']
    user = user.apply_omniauth(omniauth)
    if user.save(:validate => false)
      return user
    else
      nil
    end
  end

  def failure 
    flash[:error] = params[:message]
    redirect_to root_url
  end
end
