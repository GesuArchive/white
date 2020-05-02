from gtts import gTTS
from io import BytesIO
from subprocess import Popen, PIPE
from urllib.parse import unquote_plus
import sys

path = sys.argv[0]
name = sys.argv[1]
msg = sys.argv[2]
lang = sys.argv[3]

path = path[:-11] #removes tts_args.py

msg = unquote_plus(msg, 'utf-8')

mp3_fp = BytesIO()

tts = gTTS(msg, lang=lang)
tts.write_to_fp(mp3_fp)

savepath = str(path)+"/lines/"+str(name)+'.ogg'

cmd_com = ['ffmpeg',
           '-i', 'pipe:0',
           '-vn',
           '-ar', '44100',
           '-ac', '2',
           '-b:a', '64k',
           '-f', 'ogg',
           '-y',
           savepath]

process = Popen(cmd_com, stdin=PIPE)
process.communicate(input=mp3_fp.getvalue())
process.wait()

sys.stdout.write(savepath)
