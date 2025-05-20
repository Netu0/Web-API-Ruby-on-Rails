class ReservaService
  def initialize(repository)
    @repository = repository
  end

  def listar
    @repository.all
  end

  def buscar(id)
    @repository.find(id)
  end

  def criar(params)
    data_inicio = params[:data_inicio]
    data_fim = params[:data_fim]

    raise "Data de fim não pode ser anterior à de início" if data_fim < data_inicio

    if @repository.existe_sobreposicao?(data_inicio, data_fim)
      raise "Já existe uma reserva nesse intervalo"
    end

    @repository.create(params)
  end

  def remover(id)
    @repository.destroy(id)
  end
end
