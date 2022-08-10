class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso de Ruby on rails - [cookie]"#armazenado no Browser
    session[:curso] = "Curso de Ruby on rails - [session]"# armazenado no servidor
    
    @curso = "Rails"
  end
 
  
  end
