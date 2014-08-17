#encoding: UTF-8
require 'digest/sha1'
class WechatsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality
  def show
    render :text => params[:echostr]
  end

  def create
    if params[:xml][:MsgType] == "text"
      render "echo", :formats => :xml
    end
  end  

  private
  def check_weixin_legality
    array = [Settings.token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end