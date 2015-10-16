
class Simulator do
	@delay = 1

	def initilize(speed)
		@delay = 1 / speed
	end

	def run(n)
		@run_length = n
		n.times do |i|
			@run_percent = i/@run_length
			tick i
			sleep @delay
		end
	end

	def tick(n)
		@accel = Math.sin(n)
	end

end

while true do


	sleep 1
end
