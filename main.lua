local f = assert(io.open('file.iso', 'rb'))

local pos = f:seek("end")

assert(type(pos) == 'number', "failed to get the end position")
assert(pos ~= -1, "position is out of 32-bit range")

print("file size in bytes: ", pos)

f:close()