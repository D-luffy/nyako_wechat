class Settings < Settingslogic
  source "#{Rails.root}/config/wechat.yml"
  namespace Rails.env
end