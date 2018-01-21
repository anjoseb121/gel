class FormularioController < ApplicationController
  def index
    @formulario = Formulario.new(params[:data]) if params[:data].present?
    puts "----------"
    puts "#{@formulario} --- enfermera"
    redirect_to "/tramites-y-servicios", flash: {formulas: @formulario}
  end
end