
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
		data[:a] = (2 + Math.cos[n / Math.PI] / (2 * Math.PI^2) + \
					(2 * Math.cos[(2 * n) / Math.PI]) / Math.PI^2) / \
				   (2 * Math.sqrt[2 * n + Math.sin[n / Math.PI] / (2 * Math.PI) + \
				    Math.sin[(2 * n) / Math.PI] / Math.PI]) # Accel
		data[:v] = Math.sqrt(2*n + Math.sin(n / Math.PI) / \
					(2 * Math.PI) + Math.sin(2 * n / Math.PI) / Math.PI) # Velocity
		data[:x] = n # Postion x in tube
		data[:y] = Math.sin(n / Math.PI) # Vertical Postion
		data[:z] = Math.sin(n / (2 * Math.PI)) # Horizontal Postion

		return data
	end

end

Simulator.new.run(500)
