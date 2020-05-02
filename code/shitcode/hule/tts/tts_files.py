from gtts import gTTS
import sys
import subprocess
from urllib.parse import unquote_plus

path = sys.argv[0]

path = path[:-6]

file = open(str(path)+"/voiceq.txt")

params = list()

for line in file:
    line = line.rstrip('\n')
    x = line.split("=", 1)
    params.append(x[1])

file.close()

msg = params[0]
name = params[1]
lng = params[2]

msg = unquote_plus(msg, 'cp1251')

tts = gTTS(msg, lang=lng)
tts.save(str(path)+"/conv/"+str(name)+".mp3")

subprocess.run("ffmpeg -i "+str(path)+"/conv/"+str(name)+".mp3 -vn -ar 44100 -ac 2 -b:a 64k "+str(path)+"/lines/"+str(name)+".ogg -y", shell=True)

