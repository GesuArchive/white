import sys
import os
import hashlib
import shutil
import re

def has_cyrillic(text):
    return bool(re.search('[а-яА-Я]', text))

input_text = sys.argv[1]

if has_cyrillic(input_text) == False:
    sys.exit(0)

input_speaker = sys.argv[2]

hash_name = hashlib.md5(input_text.lower().encode()).hexdigest()

combined_path = "./cache/" + input_speaker + "/" + hash_name + ".wav"

if os.path.isfile(combined_path):
    shutil.copy(combined_path, sys.argv[3])
    sys.exit(0)

from torch import set_num_threads, hub, device, package

device = device('cpu')
set_num_threads(16)
# speakers = ['aidar', 'baya', 'kseniya', 'xenia', 'eugene']

local_file = 'v3_1_ru.pt'

if not os.path.isfile(local_file):
    hub.download_url_to_file('https://models.silero.ai/models/tts/ru/v3_1_ru.pt', local_file)

model = package.PackageImporter(local_file).load_pickle("tts_models", "model")
model.to(device)

sample_rate = 24000

model.save_wav(text = input_text, speaker = input_speaker, sample_rate = sample_rate)

shutil.move("test.wav", combined_path)
shutil.copy(combined_path, sys.argv[3])
