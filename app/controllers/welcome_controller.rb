#encoding: UTF-8
require 'digest/sha1'
class WelcomeController < ApplicationController
	wechat_responder appid: Settings.appid, secret: Settings.secret, token: Settings.token, access_token: Settings.access_token
	def index
	end

	#   1. 将token、timestamp、nonce三个参数进行字典序排序
	# 2. 将三个参数字符串拼接成一个字符串进行sha1加密
	# 3. 开发者获得加密后的字符串可与signature对比，标识该请求来源于微信
	def check_signature
		token = Settings.token
		timestamp = params[:timestamp]
		nonce = params[:nonce]
		join = [token,timestamp,nonce].sort().join("")
		tmp_str = Digest::SHA1.hexdigest(join)
		echostr = "hello"
		echostr = params[:echostr] if tmp_str == params[:signature]
		respond_to do |format|
			format.json { render json: echostr}
		end
	end
end
