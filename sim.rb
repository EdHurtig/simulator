require 'unirest'
class Simulator
	def initialize(speed = 1)
		@delay = 1 / speed
		@template = {
			a: 0.0,
			v: 0.0,
			x: 0.0,
			y: 0.0,
			z: 0.0
		}
		@data = []
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
		data = @template

		# Come up with complete BS for datapoints
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
			acc += "#{k},pod=0001 value=#{v} #{timestamp}\n"
		end

		puts boday
		resp = Unirest.post("http://stage-influxdb-1c:8086/write?db=metrics", parameters: boday)
		puts "#{resp.code} #{resp.body}"
		if resp.code == 204
			save data
		end
	end

	def timestamp
		require 'time'
		DateTime.now.strftime('%s%9N')
		#DateTime.now.rfc3339(9)
	end

	def save(data)
		@data << data
	end

	def get(index)
		if @data[index]
			return @data[index]
		else
			return @template
		end
	end
end

Simulator.new.run(500)
