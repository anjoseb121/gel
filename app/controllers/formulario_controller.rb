class FormularioController < ApplicationController
  def index
    @formulario = Formulario.new(params)
  end
end