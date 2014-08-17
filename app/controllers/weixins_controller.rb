#encoding: UTF-8
require 'digest/sha1'
class WeixinsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	before_filter :check_weixin_legality

	def show
		render :text => params[:echostr]
	end

	def create
		if params[:xml][:MsgType] == "text"
			respond_to do |format|
				format.xml { render "echo"}
			end
		end
	end  

    # 1. 将token、timestamp、nonce三个参数进行字典序排序
	# 2. 将三个参数字符串拼接成一个字符串进行sha1加密
	# 3. 开发者获得加密后的字符串可与signature对比，标识该请求来源于微信
	private
	def check_weixin_legality
		array = [Settings.token, params[:timestamp], params[:nonce]].sort
		render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
	end
end
