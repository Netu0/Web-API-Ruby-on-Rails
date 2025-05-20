class CreateReservas < ActiveRecord::Migration[8.0]
  def change
    create_table :reservas do |t|
      t.string :nome
      t.datetime :data_inicio
      t.datetime :data_fim

      t.timestamps
    end
  end
end
