class FormularioController < ApplicationController
  def index
    @formulario = Formulario.new(params)
    redirect_to request.env['HTTP_REFERER'], flash: {response_data: @formulario.attr_response}
  end
end