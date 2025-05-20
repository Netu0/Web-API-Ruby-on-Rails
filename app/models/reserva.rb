class Reserva < ApplicationRecord
  validates :nome, :data_inicio, :data_fim, presence: true
  validate :data_fim_deve_ser_maior

  def data_fim_deve_ser_maior
    if data_inicio && data_fim && data_fim < data_inicio
      errors.add(:data_fim, "não pode ser anterior à data de início")
    end
  end
end
