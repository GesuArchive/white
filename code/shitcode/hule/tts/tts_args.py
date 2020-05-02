from gtts import gTTS
import sys

path = sys.argv[0]
name = sys.argv[1]
msg = sys.argv[2]
lang = sys.argv[3]

path = path[:-11] #removes tts_args.py

tts = gTTS(msg, lang=lang)
tts.save(str(path)+"lines/"+str(name)+'.ogg')
