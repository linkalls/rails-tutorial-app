class ApplicationController < ActionController::Base
  include SessionsHelper # どのコントローラからでもログイン関連のメソッドを呼び出せるように

  # def hello
  #   render html: 'hello, world!'
  # end
end
