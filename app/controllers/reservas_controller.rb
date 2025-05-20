class ReservasController < ApplicationController
  def initialize
    super
    @service = ReservaService.new(ReservaRepository.new)
  end

  def index
    render json: @service.listar
  end

  def show
    render json: @service.buscar(params[:id])
  end

  def create
    reserva = @service.criar(reserva_params)
    render json: reserva, status: :created
  end

  def destroy
    @service.remover(params[:id])
    head :no_content
  end

  private

  def reserva_params
    params.require(:reserva).permit(:nome, :data_inicio, :data_fim)
  end
end
