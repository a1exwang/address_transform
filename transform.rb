open("out.txt", "r") do |f|
	@memory = f.read.split
end

#puts @memory

@cr3 = 544
@addr = ARGV.count == 1 ? ARGV[0].to_i(16) : 0x6c74

pde_index = (@addr & 0x7c00) >> 10
pte_index = (@addr & 0x3e0) >> 5
offset = @addr & 0x1f

pde = @memory[@cr3 + pde_index].to_i(16)
if pde < 0x80
	puts 'invalid pde'
	exit
end

ptep = (pde - 0x80) << 5
pte = @memory[ptep + pte_index].to_i(16)
if pte < 0x80
	puts 'invalid pte'
	exit
end

start = (pte - 0x80) << 5
addr = start + offset
content = @memory[addr]
puts addr: addr, content: content