import math
import array
import wave

def wave2mif(file_in, file_out):
    width = 8
    fin = wave.open(file_in)
    samples_array = array.array('B', fin.readframes(fin.getnframes()))
    # Round up to the nearest power of 2 for depth
    depth = int(2**math.ceil(math.log(len(samples_array),2)))
    f = open(file_out, 'w')
    f.write("DEPTH = {0};\nWIDTH = {1};\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n".format(depth, width))
    for addr, content in enumerate(samples_array):
        f.write("{0:05X} : {1:02X};\n".format(addr, content))
        depth -= 1
    f.write("\nEND;")
    f.close()
        
if __name__ == '__main__':
    import sys
    if len(sys.argv) < 2 or len(sys.argv) > 3 or sys.argv[1] in ['-h', '--help']:
        print("Usage: {} INPUT_WAV_FILE [OUT_MIF_FILE]".format(sys.argv[0]))
        print("\nConvert WAV file to MIF file of the same name, or with the name given by OUT_MIF_FILE")
        sys.exit(1)
    file_in = sys.argv[1]
    if len(sys.argv) == 2:
        if file_in.endswith('.wav'):
            file_out = file_in[:-4] + '.mif'
        else:
            file_out = file_in + '.mif'
    else:
        file_out = sys.argv[2]
    print("Will read {} and write to {}".format(file_in, file_out))
    wave2mif(file_in, file_out)
