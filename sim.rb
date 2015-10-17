require 'unirest'
class Simulator
	def initialize(speed = 1)
		@delay = 1.0 / speed
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
		t = 1
		while t != n
			data = tick t
			push data
			sleep @delay
			t += 1
		end
	end

	def tick(n)
		data = @template

		# Don't let increased tick speed crunch data together
		n = n * @delay

		# Come up with complete BS for datapoints
		data[:a] = (-1.1 * Math.sin(n) - 1) / (Math.sin(n) + 1.1)**2
		data[:v] = Math.cos(n) / (1.1 + Math.sin(n)) + 2.5
		data[:x] = 2.5*n + Math.log(10*Math.sin(n) + 11)

		# Basically make it look like small vibrations
		data[:y] = Math.sin(300*n)/800 # Vertical Postion
		data[:z] = Math.sin(100*n)/500 # Horizontal Postion

		return data
	end

	def push(data)
		body = data.inject("") do |acc, (k, v)|
			acc += "#{k},pod=0001 value=#{v} #{timestamp}\n"
		end

		puts body
		resp = Unirest.post("http://influxdb.northeastern.me:8086/write?db=metrics", parameters: body)
		if resp.code == 204
			puts "OK"
			save data
		else
			puts "ERROR: #{resp.code} #{resp.body}"
		end
	end

	def timestamp
		require 'time'
		DateTime.now.strftime('%s%9N')
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

Simulator.new(10).run(-1)
