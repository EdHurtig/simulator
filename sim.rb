require 'unirest'
class Simulator 
	@delay = 1

	def initialize(speed = 1)
		@delay = 1 / speed
	end

	def run(n)
		@run_length = n
		ticks = []
		n.times do |t|
			data = tick t
			push data
			sleep @delay
		end
	end

	def tick(n)
		data = {}
		data[:a] = (2 + Math.cos(n / Math::PI) / (2 * Math::PI ** 2) + \
					(2 * Math.cos((2 * n) / Math::PI) / Math::PI ** 2) / \
				    (2 * Math.sqrt(2 * n + Math.sin(n / Math::PI) / (2 * Math::PI) + \
				    Math.sin((2 * n) / Math::PI) / Math::PI))) # Accel
		data[:v] = Math.sqrt(2 * n + Math.sin(n / Math::PI) / \
					(2 * Math::PI) + Math.sin(2 * n / Math::PI) / Math::PI) # Velocity
		data[:x] = n # Postion x in tube
		data[:y] = Math.sin(n / Math::PI) # Vertical Postion
		data[:z] = Math.sin(n / (2 * Math::PI)) # Horizontal Postion

		return data
	end

	def push(data)
		boday = data.inject("") do |acc, (k, v)|
			acc += "#{k}, pod=0001 value=#{v}\n"
		end

		Unirest.post("http://localhost:8086/write?db=mydb", parameters: boday)
		puts boday
	end
end

Simulator.new.run(500)
