# Prépare les données du graphique des tâches en attente (page admin/dashboard#tasks_count) :
# plages temporelles sélectionnables, filtrage + agrégation, et unité de l'axe temporel.
class TasksCountChart

  # Plages temporelles sélectionnables sur le graphique.
  RANGES = {
    '1h'  => 1.hour,
    '3h'  => 3.hours,
    '12h' => 12.hours,
    '1d'  => 1.day,
    '3d'  => 3.days,
    '15d' => 15.days,
    '30d' => 30.days,
    '90d' => 90.days
  }.freeze

  DEFAULT_RANGE = '1d'

  attr_reader :range

  def initialize(range)
    @range = RANGES.key?(range) ? range : DEFAULT_RANGE
  end

  def ranges
    RANGES.keys
  end

  # Historique sur la plage choisie, agrégé par tranche de 10 minutes (max de la tranche, pour
  # conserver les pics) afin d'alléger le rendu du graphique.
  def data
    @data ||= TasksCount.where(created_at: duration.ago..)
                        .order(:created_at)
                        .pluck(:created_at, :tasks_pending)
                        .group_by { |created_at, _| created_at.change(min: created_at.min / 10 * 10) }
                        .transform_values { |rows| rows.map(&:last).max }
  end

  # Unité de l'axe temporel selon la plage choisie. On la fixe explicitement car chartkick
  # écrase nos displayFormats localisés tant que scales.x.time.unit n'est pas défini
  def time_unit
    days = duration / 1.day.to_f
    case
    when days > 60  then 'month' # 90 j
    when days > 5   then 'day'   # 15 j, 30 j
    when days > 0.2 then 'hour'  # 12 h, 1 j, 3 j
    else                 'minute' # 1 h, 3 h
    end
  end

  private

  def duration
    RANGES[@range]
  end

end
