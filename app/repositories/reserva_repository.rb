class ReservaRepository
  def all
    Reserva.all
  end

  def find(id)
    Reserva.find(id)
  end

  def create(attrs)
    Reserva.create!(attrs)
  end

  def destroy(id)
    Reserva.find(id).destroy!
  end

  def existe_sobreposicao?(inicio, fim)
    Reserva.where("(data_inicio < ?) AND (data_fim > ?)", fim, inicio).exists?
  end
end
