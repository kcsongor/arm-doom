from PIL import Image
import struct
import sys
import os
import argparse
def main():
	# Parse arguments
	parser = argparse.ArgumentParser(description='Converts an image to binary')
	parser.add_argument('file', metavar='N', type=str, nargs=1,
	help='Input file')
	parser.add_argument('-o', '--out', help='output .bin file')
	parser.add_argument('-d', '--add-depth', action='store_true')
	# Get file names
	args = parser.parse_args()
	in_path = args.file[0]
	root, ext = os.path.splitext(in_path)
	out_path = args.out if args.out is not None else root + ".bmap"
	# Read image
	image = Image.open(in_path)
	f = open(out_path, 'wb')
	# Write size
	width, height = image.size
	f.write(struct.pack('<HH', width,height))
	# Write data
	if  image.mode != "RGB":
		image.convert("RGB")

	for y in xrange(height):
		for x in xrange(width):
			r, g, b = image.getpixel((x, y))
			assert 0 <= r < 256
			assert 0 <= g < 256
			assert 0 <= b < 256
			#print "old rgb:", hex(r),hex(g), hex(b)
			n_px = ((r & 0xf8) << 8) |( (g & 0xfc) <<3) |(b>>3)
			if n_px == 0:
				n_px = 0b0000100000100001
			#print "new pixel:", hex(n_px)
			f.write(struct.pack('H',n_px ))
	f.flush()
	f.close()
if __name__ == '__main__':
	main()


