
class Simulator do
	@delay = 1

	def initilize(speed)
		@delay = 1 / speed
	end

	def run(n)
		@run_length = n
		ticks = []
		n.times do |i|
			@run_percent = i/@run_length
			ticks << tick i
			sleep @delay
		end
	end

	def tick(n)
		data = {}
		data[:a] = ... # Accel
		data[:v] = ... # Velocity
		data[:x] = ... # Postion x in tube
		data[:y] = ... # Vertical Postion
		data[:z] = ... # Horizontal Postion

		return data
	end

end

Simulator.new.run(500)
