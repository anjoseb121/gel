class FormularioController < ApplicationController
  def index
    @formulario = Formulario.new(params)
    #redirect_to "/tramites-y-servicios", flash: {formulas: @formulario.prueba}
  end
end