class ApplicationMailer < ActionMailer::Base
  default from: '送り主の名称(オーナーなど)　<from@example.com>'
  layout 'mailer'
end
