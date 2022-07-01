import sys
import os
import hashlib
import shutil

input_text = sys.argv[1]
input_speaker = sys.argv[2]

hash_name = hashlib.md5(input_text.encode()).hexdigest()

combined_path = "./cache/" + input_speaker + "/" + hash_name + ".wav"

if os.path.isfile(combined_path):
    shutil.copy(combined_path, sys.argv[3])
    sys.exit(0)

import torch

device = torch.device('cpu')
torch.set_num_threads(16)
# speakers = ['aidar', 'baya', 'kseniya', 'xenia', 'eugene']

local_file = 'v3_1_ru.pt'

if not os.path.isfile(local_file):
    torch.hub.download_url_to_file('https://models.silero.ai/models/tts/ru/v3_1_ru.pt', local_file)

model = torch.package.PackageImporter(local_file).load_pickle("tts_models", "model")
model.to(device)

sample_rate = 24000

model.save_wav(text = input_text, speaker = input_speaker, sample_rate = sample_rate)

shutil.move("test.wav", combined_path)
shutil.copy(combined_path, sys.argv[3])
