module ProjectHelper
  def steps
    ['info', 'story', 'owner', 'final']
  end
  def next_step_of(step)
    index = steps.index(step) + 1
    steps[index]
  end
end
